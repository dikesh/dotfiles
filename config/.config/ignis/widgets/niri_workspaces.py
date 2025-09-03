from typing import Any

from ignis import widgets
from ignis.services.niri import NiriService
from ignis.utils import get_monitor
from ignis.variable import Variable

# Type Alias
DictStrAny = dict[str, Any]

# Constants
WS_EMPTY_ICON = "archlinux-logo"
WS_MAX_COUNT = 5
WS_WINDOWS_MAX_COUNT = 5

# Niri service
niri = NiriService.get_default()


def _focus_workspace(ws_num: int):
    """Focus Workspace"""
    niri.switch_to_workspace(ws_num)


def _cycle_windows(ws_num: int, is_up: bool):
    """Cycle Windows"""
    _focus_workspace(ws_num)
    niri.send_command({"Action": {f"FocusColumn{'Right' if is_up else 'Left'}": {}}})


def _is_ws_visible(ws_li: list[DictStrAny], ws_num: int):
    """Is Workspace Visible or not"""
    return len(ws_li) > ws_num or (len(ws_li) >= ws_num and ws_li[ws_num - 1]["is_active"])


def _get_ws_classes(ws_li: list[DictStrAny], ws_num: int):
    """Get classes"""
    classes = ["hl-workspace"]

    if len(ws_li) >= ws_num and (
        ws_li[ws_num - 1]["is_active"] and ws_li[ws_num - 1]["is_focused"]
    ):
        classes.append("hl-workspace-active")

    return classes


def _is_window_visible(ws_li: list[DictStrAny], ws_num: int, window_num: int):
    """Is Window Visible"""
    if is_visible := _is_ws_visible(ws_li, ws_num):
        ws_info = ws_li[ws_num - 1]
        is_visible = len(ws_info["app_id_li"]) >= window_num or (
            len(ws_info["app_id_li"]) == 0 and ws_info["is_active"] and window_num == 1
        )

    return is_visible


def _get_window_icon(ws_li: list[DictStrAny], ws_num: int, window_num: int):
    """Get Window Icon"""
    # Get Workspace Info
    if (ws_info := next((ws for ws in ws_li if ws["idx"] == ws_num), None)) is None:
        return WS_EMPTY_ICON

    # Check windows length
    ws_windows = ws_info["app_id_li"]
    if len(ws_windows) < window_num:
        return WS_EMPTY_ICON

    # Get Icon name
    icon_name = ws_windows[window_num - 1].lower()
    if icon_name == "kitty":
        icon_name = "kitty-custom"
    elif icon_name == "dev.zed.zed":
        icon_name = "zed"

    return icon_name


def niri_workspaces(monitor_id: int = 0):
    """Niri Workspaces Widget"""
    # Get connector name
    monitor: str = get_monitor(monitor_id).get_connector()  # type: ignore

    # Workspace List
    var_ws_li = Variable(value=[])

    def _update_ws_li(niri_service, _):
        """Update workspace list"""
        var_ws_li.value = [  # type: ignore
            {
                "idx": ws.idx,
                "is_active": ws.is_active,
                "is_focused": ws.is_focused,
                "app_id_li": [
                    win.app_id for win in niri_service.windows if win.workspace_id == ws.id
                ],
            }
            for ws in niri_service.workspaces
            if ws.output == monitor
        ]

    # Listen to change
    niri.connect("notify::workspaces", _update_ws_li)
    niri.connect("notify::active-window", _update_ws_li)

    def _niri_window(ws_num: int, window_num: int):
        """Window Widget"""

        return widgets.Box(
            visible=var_ws_li.bind(
                "value",
                transform=lambda ws_li: _is_window_visible(ws_li, ws_num, window_num),
            ),
            child=[
                widgets.Icon(
                    image=var_ws_li.bind(
                        "value",
                        transform=lambda ws_li: _get_window_icon(ws_li, ws_num, window_num),
                    ),
                )
            ],
        )

    def _niri_workspace(ws_num: int):
        """Workspace Widget"""

        # Button widget
        return widgets.Revealer(
            visible=var_ws_li.bind(
                "value",
                transform=lambda ws_li: _is_ws_visible(ws_li, ws_num),
            ),
            reveal_child=var_ws_li.bind(
                "value",
                transform=lambda ws_li: _is_ws_visible(ws_li, ws_num),
            ),
            css_classes=var_ws_li.bind(
                "value", transform=lambda ws_li: _get_ws_classes(ws_li, ws_num)
            ),
            transition_type="slide_right",
            transition_duration=250,
            child=widgets.EventBox(
                spacing=8,
                child=[
                    _niri_window(ws_num, win_num) for win_num in range(1, WS_WINDOWS_MAX_COUNT + 1)
                ],
                tooltip_text="Right click to switch to next workspace",
                on_click=lambda _: _focus_workspace(ws_num),
                on_right_click=lambda _: _focus_workspace(ws_num + 1),
                on_scroll_up=lambda _: _cycle_windows(ws_num, True),
                on_scroll_down=lambda _: _cycle_windows(ws_num, False),
            ),
        )

    return widgets.Box(
        css_classes=["bar-section"],
        spacing=4,
        child=[_niri_workspace(ws_num) for ws_num in range(1, WS_MAX_COUNT + 1)],
    )
