import asyncio
import math

from ignis import widgets
from ignis.services.audio import AudioService
from ignis.services.bluetooth import BluetoothService
from ignis.services.network import NetworkService, Wifi
from ignis.services.system_tray import SystemTrayItem, SystemTrayService
from ignis.services.upower import UPowerService
from ignis.utils import exec_sh_async
from ignis.variable import Variable

# Services
audio = AudioService.get_default()
bt_service = BluetoothService.get_default()
system_tray = SystemTrayService.get_default()
upower = UPowerService.get_default()
network = NetworkService.get_default()


async def toggle_bluetooth_power():
    """Toggle Bluetooth power on/off"""
    cmd = f"bluetoothctl power {'off' if bt_service.powered else 'on'}"
    await exec_sh_async(cmd)


def bluetooth_widget():
    """Bluetooth Widget"""
    # Variable to watch
    total_devices = Variable(0)

    def _update_total_devices():
        """Update variable"""
        total_devices.value = len(bt_service.connected_devices)  # type: ignore

    # Signals to notify
    bt_service.connect("device_added", lambda _, _devices: _update_total_devices())
    bt_service.connect("notify::connected-devices", lambda _, _devices: _update_total_devices())

    # Command to run
    cmd = "./scripts/bluetooth.sh"

    return widgets.Button(
        css_classes=["bar-section", "bluetooth"],
        child=widgets.Box(
            spacing=8,
            child=total_devices.bind(
                "value",
                transform=lambda total: [
                    widgets.Box(
                        visible=total > 0,
                        child=[
                            widgets.Box(
                                spacing=8,
                                child=[
                                    widgets.Icon(image=f"{device.icon_name}-symbolic"),
                                    widgets.Label(label=device.alias),
                                ],
                            )
                            for device in bt_service.connected_devices
                        ],
                    ),
                    widgets.Icon(
                        image=bt_service.bind(
                            "powered",
                            transform=lambda is_on: "bluetooth-active-symbolic"
                            if is_on
                            else "bluetooth-disabled-symbolic",
                        )
                    ),
                ],
            ),
        ),
        on_click=lambda _: asyncio.create_task(exec_sh_async(cmd)),
        on_right_click=lambda _: asyncio.create_task(toggle_bluetooth_power()),
    )


def volume_widget():
    """Volume Widget"""
    return widgets.EventBox(
        css_classes=["bar-section", "volume"],
        child=[
            widgets.Box(
                spacing=8,
                child=[
                    widgets.Icon(image=audio.speaker.bind("icon_name")),  # type: ignore
                    widgets.Label(
                        label=audio.speaker.bind("volume", lambda value: f"{value}%")  # type: ignore
                    ),
                ],
            )
        ],
        on_click=lambda _: asyncio.create_task(
            exec_sh_async("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
        ),
        on_scroll_up=lambda _: asyncio.create_task(
            exec_sh_async("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
        ),
        on_scroll_down=lambda _: asyncio.create_task(
            exec_sh_async("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
        ),
    )


def wifi_widget():
    """Wifi Widget"""
    # Wifi
    wifi: Wifi = network.wifi

    # Wifi Info variable
    wifi_info = Variable({"ssid": "", "icon_name": ""})

    def _update_wifi_info(_x, _y):
        ssid = next((device.ap.ssid for device in wifi.devices if device.is_connected), "")
        wifi_info.value = {"icon_name": wifi.icon_name, "ssid": ssid or ""}  # type: ignore

    wifi.connect("notify::is-connected", _update_wifi_info)

    return widgets.Box(
        css_classes=["bar-section", "battery"],
        spacing=8,
        child=[
            widgets.Icon(
                image=wifi_info.bind("value", transform=lambda value: value["icon_name"])
            ),
            widgets.Label(label=wifi_info.bind("value", transform=lambda value: value["ssid"])),
        ],
    )


def battery_level():
    """Battery Level Widget"""
    return widgets.Box(
        spacing=8,
        child=upower.bind(
            "batteries",
            transform=lambda batteries: [
                widgets.Box(
                    css_classes=["bar-section", "battery"],
                    spacing=4,
                    child=[
                        widgets.Icon(image=battery.bind("icon_name")),
                        widgets.Label(
                            label=battery.bind(
                                "percent",
                                transform=lambda percent: f"{math.floor(percent)}%",
                            )
                        ),
                    ],
                )
                for battery in batteries
            ],
        ),
    )


def tray_item(item: SystemTrayItem) -> widgets.Button:
    """Tray Item Widget"""
    # Menu
    menu = item.menu.copy() if item.menu else None

    return widgets.Button(
        child=widgets.Box(child=[widgets.Icon(image=item.bind("icon"), pixel_size=16), menu]),
        setup=lambda self: item.connect("removed", lambda _: self.unparent()),
        tooltip_text=item.bind("tooltip"),
        on_click=lambda _: asyncio.create_task(item.activate_async()),
        on_right_click=lambda _: menu.popup() if menu else None,
        css_classes=["traymenu"],
    )


def tray():
    """System Tray Widget"""
    return widgets.Box(
        css_classes=["bar-section", "systray"],
        spacing=8,
        visible=system_tray.bind("items", transform=lambda items: len(items) > 0),
        setup=lambda self: system_tray.connect(
            "added", lambda _, item: self.append(tray_item(item))
        ),
    )


def power_menu():
    """Power Menu Widget"""
    cmd = "~/.config/rofi/powermenu/type-5/powermenu.sh"
    return widgets.Button(
        css_classes=["bar-section", "power"],
        child=widgets.Icon(image="system-shutdown-symbolic"),
        on_click=lambda _: asyncio.create_task(exec_sh_async(cmd)),
    )


def bar_right():
    """Bar Right"""
    return widgets.Box(
        halign="end",
        spacing=8,
        child=[
            bluetooth_widget(),
            volume_widget(),
            wifi_widget(),
            battery_level(),
            tray(),
            power_menu(),
        ],
    )
