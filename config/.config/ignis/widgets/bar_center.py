from datetime import datetime as dt
from datetime import timezone

from ignis import widgets
from ignis.utils import Poll
from ignis.variable import Variable

# Date time format
FORMAT = "%H:%M:%S %a %d %b %Y"


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
            widgets.Icon(image="preferences-system-time-symbolic"),
            widgets.Button(
                child=widgets.Label(
                    label=Poll(
                        50,
                        lambda _: dt.now(timezone.utc if show_utc.value else None).strftime(
                            FORMAT
                        ),
                    ).bind("output")
                ),
                on_click=lambda _: toggle_show_utc(),
            ),
        ],
    )
