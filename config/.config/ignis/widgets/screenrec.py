import asyncio
from datetime import datetime as dt
from datetime import timezone

from ignis import widgets
from ignis.utils import exec_sh_async
from ignis.variable import Variable

# Variables
filename = Variable("")
is_recording = Variable(False)


async def start_recording():
    """Start Recording"""
    # Start recording
    now = dt.now(timezone.utc).strftime("%Y%m%d%H%M%S")
    filename.value = f"~/Videos/screenrec-{now}.mp4"  # type: ignore
    is_recording.value = True  # type: ignore

    cmd = f'wl-screenrec -g "$(slurp)" -f {filename.value}'
    try:
        res = await exec_sh_async(cmd)
        if res.returncode != 0:
            is_recording.value = False  # type: ignore
    except:  # noqa: E722
        is_recording.value = False  # type: ignore


async def stop_recording():
    """Stop Recording"""
    # Kill process and Update flag
    await exec_sh_async("pkill wl-screenrec")
    is_recording.value = False  # type: ignore

    # Send notification
    await exec_sh_async(f"notify-send 'Screen Recorder ..' 'Filename: {filename.value}'")


async def toggle_recording():
    """Toggle Recording"""
    if is_recording.value:
        await stop_recording()
    else:
        await start_recording()


def screen_rec():
    """Screen Recording Widget"""
    # Constants
    icon_recording_on = "record-desktop-indicator-recording"
    icon_recording_off = "record-desktop-indicator"

    # Record button
    return widgets.Button(
        css_classes=["bar-section"],
        child=widgets.Icon(
            image=is_recording.bind(
                "value",
                transform=lambda flag: icon_recording_on if flag else icon_recording_off,
            )
        ),
        on_click=lambda _: asyncio.create_task(toggle_recording()),
    )
