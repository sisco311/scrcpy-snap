# Snap Packaging for scrcpy

**This is a snap for scrcpy**, *"Display and control your Android device"*. It works on Ubuntu, Fedora, Debian, and other major Linux distributions.

![Screenshot of the Snapped Application](https://github.com/Genymobile/scrcpy/blob/master/assets/screenshot-debian-600.jpg "Screenshot of the Snapped Application")

## Installation

([Don't have snapd installed?](https://snapcraft.io/docs/core/install))

### The Graphical Way

[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/scrcpy)

### From the Terminal

    sudo snap install scrcpy

## Usage

    scrcpy

### You can also use the builtin adb tool

    scrcpy.adb [options]

For example:

    scrcpy.adb devices
    scrcpy.adb kill-server

### For audio playback the alsa plug is needed

    sudo snap connect scrcpy:alsa

### In order to use the v4l2loopback feature the camera plug must be connected

    sudo snap connect scrcpy:camera

### For physical keyboard simulation you need to connect the raw-usb plug

    sudo snap connect scrcpy:raw-usb

### To uninstall the scrcpy snap

    sudo snap remove scrcpy

## XDG Desktop Entry

The snap comes with an XDG desktop entry that can be called from your desktop environment's application menu. If you would like to customize the command line flags that are called by the desktop environment, copy the `/var/lib/snapd/desktop/applications/scrcpy_scrcpy.desktop` desktop entry file to `~/.local/share/applications/`(manually create the directory if it isn't existed yet) and edit the `Exec` key's value to your liking. For example:

    Exec=env BAMF_DESKTOP_FILE_HINT=/var/lib/snapd/desktop/applications/scrcpy_scrcpy.desktop /snap/bin/scrcpy

could become:

    Exec=env BAMF_DESKTOP_FILE_HINT=/var/lib/snapd/desktop/applications/scrcpy_scrcpy.desktop /snap/bin/scrcpy -w

to enable the `--stay-awake` flag on scrcpy. See all flags by running `scrcpy --help`.
