"""Show the current tab's pane count as a native Kitty window logo."""

from functools import lru_cache
from math import ceil, hypot

from kitty.fast_data_types import add_timer, cell_size_for_window, draw_single_line_of_text, png_from_32bit_rgba_data

_shown = {}
_update_pending = False


@lru_cache(maxsize=32)
def _badge(os_window_id, count, cell_size):
    label = str(count)
    cell_width, cell_height = cell_size
    pixels, width = draw_single_line_of_text(
        os_window_id, label, 0xFFFFFFFF, 0xFF000000,
        max(64, 2 * cell_width * len(label)), max_width=True,
    )
    height = len(pixels) // (4 * width)
    radius = max(19, hypot(width, height) / 2 + 3)
    size = 2 * (ceil(radius) + 8)
    image_height = size + 10  # Extra transparent padding below the ring.
    center = (size - 1) / 2
    rgba = bytearray(b'\xd4\xe0\xee\x00' * (size * image_height))
    for y in range(size):
        for x in range(size):
            edge = 2.25 - abs(hypot(x - center, y - center) - radius)
            rgba[4 * (y * size + x) + 3] = round(144 * max(0, min(1, edge)))

    # Thicken the antialiased digit strokes with a half-opacity pixel fringe.
    left, top = (size - width) // 2, (size - height) // 2
    for y in range(height):
        for x in range(width):
            coverage = pixels[4 * (y * width + x)]
            if coverage:
                idx = 4 * ((top + y) * size + left + x) + 3
                alpha = 224 * coverage // 255
                rgba[idx] = max(rgba[idx], alpha)
                for neighbor in (idx - 4, idx + 4, idx - 4 * size, idx + 4 * size):
                    rgba[neighbor] = max(rgba[neighbor], alpha // 2)

    # Kitty uses this virtual path as the cache key; no PNG file is written.
    path = f'/kitty-pane-count/{os_window_id}-{count}-{cell_width}x{cell_height}.png'
    return path, png_from_32bit_rgba_data(bytes(rgba), size, image_height)


def _update_badges(boss):
    global _shown, _update_pending
    _update_pending = False
    desired = {}
    for manager in boss.all_tab_managers:
        tab = manager.active_tab
        if tab is None or (count := tab.num_window_groups) < 2:
            continue
        if (window := tab.windows.active_group_main) is not None:
            os_window_id = window.os_window_id
            desired[window.id] = (os_window_id, count, cell_size_for_window(os_window_id))

    for window_id in _shown.keys() - desired.keys():
        if (window := boss.window_id_map.get(window_id)) is not None:
            window.set_logo('')
    for window_id, key in desired.items():
        if _shown.get(window_id) != key:
            path, png = _badge(*key)
            boss.window_id_map[window_id].set_logo(path, position='bottom-right', png_data=png)
    _shown = desired


def on_tab_bar_dirty(boss, _window, _data):
    # This notification fires even when the tab bar is not shown. Defer to
    # coalesce changes and read the final pane membership and focus state.
    global _update_pending
    if not _update_pending:
        _update_pending = True
        add_timer(lambda _: _update_badges(boss), 0, False)
