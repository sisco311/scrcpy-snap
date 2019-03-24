# Unofficial Snap Packaging for scrcpy
2
<!--
3
        Use the Staticaly service for easy access to in-repo pictures:
4
        https://www.staticaly.com/
5
-->
6
​
7
**This is the unofficial snap for scrcpy**, *"Display and control your Android device"*. It works on Ubuntu, Fedora, Debian, and other major Linux distributions.
8
​
9
<!-- Uncomment and modify this when you are provided a build status badge
10
[![Build Status Badge of the `my-awesome-app` Snap](https://build.snapcraft.io/badge/_repo_owner_id_/_repo_name_id_.svg "Build Status of the `my-awesome-app` snap")](https://build.snapcraft.io/user/_repo_owner_id_/_repo_name_id_)
11
-->
12
​
13
![Screenshot of the Snapped Application](https://github.com/Genymobile/scrcpy/blob/master/assets/screenshot-debian-600.jpg "Screenshot of the Snapped Application")
14
​
15
​
16
Published for <img src="http://anything.codes/slack-emoji-for-techies/emoji/tux.png" align="top" width="24" /> with 💝 by Snapcrafters
17
​
18
## Installation
19
([Don't have snapd installed?](https://snapcraft.io/docs/core/install))
20
​
21
### In a Terminal
22
    # Install the snap #
23
    sudo snap install --channel=edge scrcpy
24
    
25
    # Connect the snap to essential security confinement interfaces #
26
    ## core snap is needed ##
27
    sudo snap install core
28
    ## for adb support ##
29
    sudo snap connect scrcpy:adb-support :adb-support
30
​
31
    # Launch the application #
32
    scrcpy
33
    
34
    # If you need to use the builtin adb tool #
35
    scrcpy.adb [options]
36
​
37
### The Graphical Way
38
[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/scrcpy)
39
-->
40
​
41
<!-- Uncomment when you have test results
42
## What is Working
43
* [A list of functionallities that are verified working]
44
​
45
## What is NOT Working...yet 
46
Check out the [issue tracker](https://github.com/_repo_owner_id_/_repo_name_id_/issues) for known issues.
47
-->
48
​
49
<!-- Uncomment when you have initialized the URLs
50
## Support
51
* Report issues regarding using this snap to the issue tracker:  
52
  <https://github.com/_repo_owner_id_/_repo_name_id_/issues>
53
* You may also post on the Snapcraft Forum, under the `snap` topic category:  
54
  <https://forum.snapcraft.io/c/snap>
55
-->
56
​
57
​
58
[![Snap Status](https://build.snapcraft.io/badge/sisco311/scrcpy-snap.svg)](https://build.snapcraft.io/user/sisco311/scrcpy-snap)
