from ignis import widgets
from ignis.window_manager import WindowManager

from constants import NS_IGNIS_CALENDAR

# Get window manager
window_manager = WindowManager.get_default()


def calendar() -> widgets.Window:
    """Main Bar Widget"""
    return widgets.Window(
        namespace=NS_IGNIS_CALENDAR,
        anchor=["left", "right", "top", "bottom"],
        exclusivity="ignore",
        kb_mode="exclusive",
        popup=True,
        visible=False,
        child=widgets.Overlay(
            child=widgets.Button(
                vexpand=True,
                hexpand=True,
                can_focus=False,
                on_click=lambda _: window_manager.close_window(NS_IGNIS_CALENDAR),
            ),
            overlays=[
                widgets.Calendar(
                    css_classes=["calendar-container"],
                    height_request=500,
                    width_request=500,
                    halign="center",
                    valign="center",
                ),
            ],
        ),
    )
