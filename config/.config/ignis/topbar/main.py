from ignis.css_manager import CssInfoPath, CssManager
from ignis.icon_manager import IconManager
from ignis.utils import get_n_monitors, sass_compile

from widgets.bar import bar

# Add CSS and Icons
CssManager.get_default().apply_css(
    CssInfoPath(
        name="main",
        path="./assets/style.scss",
        compiler_function=lambda path: sass_compile(path=path),
    )
)
IconManager.get_default().add_icons("./assets")

# Init bar for each monitor
for i in range(get_n_monitors()):
    bar(i)
