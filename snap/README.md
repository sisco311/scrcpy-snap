# Unofficial Snap Packaging for scrcpy
<!--
	Use the Staticaly service for easy access to in-repo pictures:
	https://www.staticaly.com/
-->

**This is the unofficial snap for scrcpy**, *"Display and control your Android device"*. It works on Ubuntu, Fedora, Debian, and other major Linux distributions.

<!-- Uncomment and modify this when you are provided a build status badge
[![Build Status Badge of the `my-awesome-app` Snap](https://build.snapcraft.io/badge/_repo_owner_id_/_repo_name_id_.svg "Build Status of the `my-awesome-app` snap")](https://build.snapcraft.io/user/_repo_owner_id_/_repo_name_id_)
-->

![Screenshot of the Snapped Application](https://github.com/Genymobile/scrcpy/blob/master/assets/screenshot-debian-600.jpg "Screenshot of the Snapped Application")


Published for <img src="http://anything.codes/slack-emoji-for-techies/emoji/tux.png" align="top" width="24" /> with 💝 by Snapcrafters

## Installation
([Don't have snapd installed?](https://snapcraft.io/docs/core/install))

### In a Terminal
    # Install the snap #
    sudo snap install --channel=edge --devmode scrcpy
    
    # Connect the snap to essential security confinement interfaces #
    ## for adb support ##
    sudo snap connect scrcpy:adb-support

    # Launch the application #
    scrcpy
    
    # If you need to use the builtin adb tool #
    scrcpy.adb [options]

### The Graphical Way
[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/scrcpy)
-->

<!-- Uncomment when you have test results
## What is Working
* [A list of functionallities that are verified working]

## What is NOT Working...yet 
Check out the [issue tracker](https://github.com/_repo_owner_id_/_repo_name_id_/issues) for known issues.
-->

<!-- Uncomment when you have initialized the URLs
## Support
* Report issues regarding using this snap to the issue tracker:  
  <https://github.com/_repo_owner_id_/_repo_name_id_/issues>
* You may also post on the Snapcraft Forum, under the `snap` topic category:  
  <https://forum.snapcraft.io/c/snap>
-->


[![Snap Status](https://build.snapcraft.io/badge/sisco311/scrcpy-snap.svg)](https://build.snapcraft.io/user/sisco311/scrcpy-snap)
