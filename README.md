MMBNLC Resolution Unlock mod
==================================

This is a mod for Mega Man Battle Network Legacy Collection Vol. 1 & 2 which
unlocks all resolution options regardless of your actual display resolution and
whether you're playing on Steam Deck or not.

Why would you need this? There are a few reasons:

 1. When playing on Steam Deck, the game is always locked to 1366x768 even if
    you're playing on the official dock.

 2. When combined with Greiga Master's Sharper Pixels mod, based on your desired
    screen layout, running the game in a different resolution can yield a better
    image quality.

MMBNLC internally renders the game at 4x GBA resolution (240x160 -> 960x640)
using either xBR x4 (if you have the Filter option on) or nearest-neighbor x4
(if you have the Filter option off).

This 960x640 canvas is then scaled based on the display resolution and your
Screen Layout setting, using point scaling (essentially linear scaling).

|           | Small   | Medium  | Large   | Largest |
|-----------|---------|---------|---------|---------|
| 1366x768  | x0.711  | x0.889  | x1.067  | x1.2    |
| 1600x900  | x0.833  | x1.042  | x1.25   | x1.406  |
| 1920x1080 | x1      | x1.25   | x1.5    | x1.6875 |
| 2560x1440 | x1.333  | x1.667  | x2      | x2.25   |
| 3840x2160 | x2      | x2.5    | x3      | x3.375  |

With linear scaling, the only way to get clean pixels is with a x1 scaling, so
effectively you can only do it by running the game at 1920x1080 + Small.

However, if you use Greiga Master's Sharper Pixels mod, it changes this linear
scaling to a nearest-neighbor scaling. As a result, since the base canvas was
GBA resolution x4, any scaling in the above table which is a multiple of 0.25
will result in clean pixels.

Note that if your in-game resolution does not match your actual display
resolution, your display will also perform a scaling step on the image the game
outputs. Generally if the game resolution is higher than the display resolution,
this shouldn't really reduce image quality - unless that scaling is nearest-
neighbor, in which case you will end up with uneven pixel sizes and shimmering.


Steam Deck settings
-------------------

On Steam Deck, as of SteamOS 3.5.5, there is a new Scaling Mode option which
allows you to zoom and stretch games that don't natively run at 1280x800. You
can use this to get a clean 1200x800 image which is exactly 5x GBA resolution.

The downside is that the Legacy Collection menus will be slightly cut off on the
sides, though they should still be perfectly usable. Also, you may have to turn
off Scaling Mode briefly in case you want to change any of your mods in
chaudloader.

Here are the settings you should use:

 *  Enable Greiga Master's Sharper Pixels mod
 *  Enable this Resolution Unlock mod
 *  Set in-game Display Mode to Windowed
 *  Set in-game Resolution to 2560x1440
 *  Set SteamOS Scaling Mode to Fill
 *  Set SteamOS Scaling Filter to anything other than Nearest


Features
--------

 *  Unhides resolution options higher than your display's resolution.
 *  Unhides all display options when playing on Steam Deck.


Installing
----------

Windows PC and Steam Deck

 1. Download and install chaudloader:
    https://github.com/RockmanEXEZone/chaudloader/releases
    Version 0.11.0 or newer is required.

 2. Launch Steam in Desktop Mode. Right-click the game in Steam, then click
    Properties → Local Files → Browse to open the game's install folder. Then
    open the "exe" folder, where you'll find MMBN_LC1.exe or MMBN_LC2.exe.

 3. Copy the ResolutionUnlock folder to the "mods" folder.

 4. Launch the game as normal.


Version History
---------------

Ver. 1.0.0 - 19 November 2023

 *  Initial version.


Building
--------

Building is supported on Windows 10 & 11. First install the following
prerequisites:

 *  Rust

Then, run one of the following commands:

 *  make - Builds the mod files compatible with chaudloader.
 *  make clean - Removes all temporary files and build outputs.
 *  make install - Installs the previously built mod files into the mods folder for chaudloader.
 *  make uninstall - Removes the installed mod files from the mods folder for chaudloader.
