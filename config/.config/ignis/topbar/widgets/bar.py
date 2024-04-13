from ignis import widgets

from widgets.bar_center import bar_center
from widgets.bar_left import bar_left
from widgets.bar_right import bar_right


def bar(monitor_id: int = 0) -> widgets.Window:
    """Main Bar Widget"""
    return widgets.Window(
        css_classes=["bar"],
        namespace=f"ignis_bar_{monitor_id}",
        monitor=monitor_id,
        anchor=["left", "top", "right"],
        exclusivity="exclusive",
        child=widgets.CenterBox(
            css_classes=["bar-container"],
            start_widget=bar_left(monitor_id),
            center_widget=bar_center(),
            end_widget=bar_right(),
        ),
    )
