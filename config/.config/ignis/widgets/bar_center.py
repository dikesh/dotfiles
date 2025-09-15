from datetime import datetime as dt
from datetime import timezone

from ignis import widgets
from ignis.utils import Poll
from ignis.variable import Variable
from ignis.window_manager import WindowManager

from constants import NS_IGNIS_CALENDAR

# Get window manager
window_manager = WindowManager.get_default()


def bar_center():
    """Bar Center"""
    # Variable to indicate to show UTC time or now
    show_utc = Variable(value=False)

    def toggle_show_utc():
        show_utc.value = not show_utc.value  # type: ignore

    return widgets.Box(
        css_classes=["bar-section", "clock"],
        spacing=8,
        child=[
            widgets.Box(
                spacing=8,
                tooltip_text="Click to toggle between UTC and Local Timezone",
                child=[
                    widgets.Icon(image="preferences-system-time-symbolic"),
                    widgets.Button(
                        child=widgets.Label(
                            label=Poll(
                                50,
                                lambda _: dt.now(
                                    timezone.utc if show_utc.value else None
                                ).strftime("%T"),
                            ).bind("output")
                        ),
                        on_click=lambda _: toggle_show_utc(),
                    ),
                ],
            ),
            widgets.Box(
                spacing=8,
                tooltip_text="Click to open calendar",
                child=[
                    widgets.Icon(image="x-office-calendar-symbolic"),
                    widgets.Button(
                        child=widgets.Label(
                            label=Poll(
                                50,
                                lambda _: dt.now(
                                    timezone.utc if show_utc.value else None
                                ).strftime("%a %d %b %Y"),
                            ).bind("output")
                        ),
                        on_click=lambda _: window_manager.open_window(NS_IGNIS_CALENDAR),
                    ),
                ],
            ),
        ],
    )
