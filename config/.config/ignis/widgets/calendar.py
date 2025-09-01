from ignis import widgets


def calendar() -> widgets.Window:
    """Main Bar Widget"""
    return widgets.Window(
        namespace="ignis_calendar",
        exclusivity="ignore",
        kb_mode="exclusive",
        popup=True,
        visible=False,
        child=widgets.Box(
            css_classes=["calendar-container"],
            height_request=500,
            width_request=500,
            child=[widgets.Calendar(hexpand=True, vexpand=True)],
        ),
    )
