import asyncio

from ignis import widgets
from ignis.utils import exec_sh_async
from ignis.variable import Variable

from widgets.niri_workspaces import niri_workspaces
from widgets.resources import system_resources
from widgets.screenrec import screen_rec


def applications():
    """Applications Widget"""
    cmd = "~/.config/rofi/launchers/type-3/launcher.sh"
    return widgets.Button(
        css_classes=["bar-section", "apps"],
        tooltip_text="Open Applications",
        child=widgets.Label(label="󰀻"),
        on_click=lambda _: asyncio.create_task(exec_sh_async(cmd)),
    )


def color_picker():
    """Color Picker"""
    # Command to run
    cmd = "./scripts/color_picker.nu"
    return widgets.Button(
        css_classes=["bar-section", "apps"],
        child=widgets.Label(label=""),
        on_click=lambda _: asyncio.create_task(exec_sh_async(cmd)),
    )


def tools():
    """Tools"""
    # Flag for revealer
    show_tools = Variable(False)

    def _toggle_show_tools():
        show_tools.value = not show_tools.value  # type: ignore

    return widgets.Box(
        spacing=show_tools.bind("value", lambda flag: 8 if flag else 0),
        child=[
            widgets.Button(
                on_click=lambda _: _toggle_show_tools(),
                css_classes=["bar-section", "apps"],
                child=widgets.Label(label=""),
            ),
            widgets.Revealer(
                reveal_child=show_tools.bind("value"),
                transition_duration=500,
                transition_type="swing_right",
                child=widgets.Box(
                    spacing=8,
                    child=[
                        screen_rec(),
                        color_picker(),
                    ],
                ),
            ),
        ],
    )


def bar_left(monitor_id: int = 0):
    """Bar Left"""
    return widgets.Box(
        spacing=8,
        child=[
            system_resources(),
            applications(),
            tools(),
            niri_workspaces(monitor_id),
        ],
    )
