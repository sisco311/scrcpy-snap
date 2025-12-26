# Snap packaging for scrcpy

**This is a snap for scrcpy**, *"Display and control your Android device"*. It works on Ubuntu, Fedora, Debian, and other major Linux distributions.

![Screenshot of the snapped application](https://github.com/Genymobile/scrcpy/blob/master/assets/screenshot-debian-600.jpg "Screenshot of the snapped application")

## Installation

([Don't have snapd installed?](https://snapcraft.io/docs/core/install))

### The graphical way

[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/scrcpy)

### From the terminal

    sudo snap install scrcpy

## Usage

### Launching the application

Once installed, you should be able to locate the following application entries in your desktop environment's application menu:

* scrcpy  
  Run scrcpy directly.
* scrcpy (console)  
  Run scrcpy from a terminal window, which allows you to see any output or error messages.  Use this option if the regular scrcpy entry does not work.

You can launch the application by running the following command in the terminal:

    scrcpy

If you have multiple installations of scrcpy, you might need to run the following command instead to ensure you're using the snapped version:

    snap run scrcpy

### Interacting with the builtin adb server

This snap uses a builtin adb server/client to communicate with your Android device. If you need to interact with the adb server launched by the snap, you should use the `scrcpy.adb` command to do so:

    scrcpy.adb [options]

For example, to list the devices available to the snap, you can run the following command:

    scrcpy.adb devices

Using other adb installations (e.g., the one provided by your distribution) to interact with the adb server launched by the snap is _not_ supported and may lead to unexpected behaviors, refer to [Consider adding more documentation about when and how to use scrcpy.adb · Issue #21 · sisco311/scrcpy-snap](https://github.com/sisco311/scrcpy-snap/issues/21) for more information.

If you need to shutdown the adb server launched by the snap (e.g. to run another adb server or to allow the snap to be updated), you can do so by running:

    scrcpy.adb kill-server

### For audio playback the alsa plug is needed

    sudo snap connect scrcpy:alsa

### In order to use the v4l2loopback feature the camera plug must be connected

    sudo snap connect scrcpy:camera

### For physical keyboard simulation you need to connect the raw-usb plug

    sudo snap connect scrcpy:raw-usb

### In order to use the gamepad simulation feature the joystick plug must be connected

    sudo snap connect scrcpy:joystick

### To uninstall the scrcpy snap

    sudo snap remove scrcpy

## XDG Desktop Entry

The snap comes with an XDG desktop entry that can be called from your desktop environment's application menu. If you would like to customize the command line flags that are called by the desktop environment, copy the `/var/lib/snapd/desktop/applications/scrcpy_scrcpy.desktop` desktop entry file to `~/.local/share/applications/`(manually create the directory if it isn't existed yet) and edit the `Exec` key's value to your liking. For example:

    Exec=env BAMF_DESKTOP_FILE_HINT=/var/lib/snapd/desktop/applications/scrcpy_scrcpy.desktop /snap/bin/scrcpy

could become:

    Exec=env BAMF_DESKTOP_FILE_HINT=/var/lib/snapd/desktop/applications/scrcpy_scrcpy.desktop /snap/bin/scrcpy -w

to enable the `--stay-awake` flag on scrcpy. See all flags by running `scrcpy --help`.
