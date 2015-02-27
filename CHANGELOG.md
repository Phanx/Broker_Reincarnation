### Version 6.1.0.56

* Updated for WoW 6.1

### Version 6.0.3.55

* **Renamed to Broker: Reincarnation.** The Reincarnation ability has not required ankhs or any other reagents in quite some time, and the addon's feature-set has diminished accordingly; this new name more accurately reflects its current purpose and functionality.
* Version numbers now indicate the number of releases, rather than SVN revisions.

### Version 6.0.2.140

* Updated for WoW 6.0

### Version 5.4.1.133

* Updated for WoW 5.4

### Version 5.3.0.130

* Updated for WoW 5.3
* Fixed an issue causing the Broker text not to start updating after reincarnating

### Version 5.2.0.130

* Fixed an issue causing the right-click menu options to be unclickable
* Fixed a localization issue causing the ready notification message to appear as the Broker text

### Version 5.2.0.128

* Updated for WoW 5.2

### Version 5.0.4.124

* Updated for WoW 5.0.4
* Removed the standalone display frame. User who desire a "movable block" style display should install Fortress or StatBlocks.
* Added tracking for the total number of Reincarnation uses.
* Added a right-click options menu.
* Updated translations.

### Version 5.0.1.111-beta

* Added missing beta tag to the TOC version.
* Added ptBR localization. I'm not even close to fluent in Portuguese, so the translations are probably pretty rough. Feel free to [make corrections](http://wow.curseforge.com/addons/ankhcooldowntimer/localization/ptBR/)!
* Minor updates to most other localizations to better match the current English text.

### Version 5.0.1.108

* Some minor adjustments to the frame size and icon placement/clipping

### Version 5.0.1.103

* Updated for Mists of Pandaria beta
* Removed all ankh reminder and restock features, since ankhs are no longer reagents for Reincarnation
* Changed the addon's icon from an ankh to the Reincarnation spell icon

### Version 4.2.0.94

* Updated for WoW 4.2

### Version 4.1.0.93

* Updated for WoW 4.1
* Added Simplified Chinese translations from kztit
* Added Traditional Chinese translations from wowuicn on CurseForge
* Removed support for WoW 3.2 since China has updated now

### Version 4.0.6.87

* Fixed dragging the monitor window at scales other than 100%
* Added options to change the monitor window’s background and border colors
* Added Russian translations
* Updated German, French, and Spanish translations

### Version 4.0.1.62

* Fixed detection for Glyph of Renewed Life in WoW 4.0
* Moved ready notifiaction from RaidWarningFrame to UIErrorsFrame

### Version 3.3.5.56

* Added compatibility for WoW 4.0 (Cataclysm beta servers)

### Version 3.3.5.54

* Fixed a typo in a debugging statement that could trigger an error on login under some circumstances

### Version 3.3.5.53

* Fixed support for Glyph of Renewed Life

### Version 3.3.5.52

* Restored compatibility with Chinese WoW clients, which are still running WoW 3.2
* Updated for changes in configuration widgets

### Version 3.3.3.48-beta

* Fixed an error that incorrectly unregistered the event for detecting Reincarnation use
* Fixed an error that caused the standalone monitor window to remain draggable while locked
* Fixed an error that caused the tooltip to sometimes stick in the visible state after dragging the window
* Added a workaround for a Blizzard bug introduced in WoW build 11723 that caused the About sub-panel to appear above the main AnkhUp panel in the options window

### Version 3.3.3.43-beta

* Forgot to turn of debug output for the last release

### Version 3.3.3.42-beta

* Fixed an error that prevented some clients from detecting when Reincarnation was used
* Fixed an error that prevented the cooldown timer from updating if Reincarnation was on cooldown at login
* Fixed an error that prevented some settings changes from being saved
* Fixed an error that wiped settings for the monitor window after dragging it
* Fixed an error that occurred when (re)assigning talents

### Version 3.3.3.40

* Minor changes to display format
* Merged DataBroker feed and standalone display into core, among other code simplifications
* Added WoWI-ID to the TOC for the MMOUI Minion

### Version 3.3.2.36-beta

* Update embedded libraries

### Version 3.3.0.32-alpha

* Update for new Reincarnation cooldown duration in WoW 3.3

### Version 3.3.0.31-beta

* Added deDE translations from Gyffes on CurseForge
* Added esES and esMX translations

### Version 3.2.2.27-beta

* Fixed buy function for non-English locales
* Fixed Russian translation for ankh item name

### Version 3.2.2.26-beta

* Added German localization from Gyffes on CurseForge

### Version 3.2.0.24-beta

* Added library references back to TOC (oops)

### Version 3.2.0.23-beta

* Added support for Glyph of Renewed Life to hide ankh information
* Added support for localizing the date format used by the "Last Reincarnation" display
* Fixed leaked global variable "db"

### Version 3.1.1.17-beta

* Fixed packaging issues

### Version 3.1.1.14-beta

* Fixed Reincarnation detection for shamans with Glyph of Renewed Life
* Fixed various minor bugs
* Removed "/aup" slash command

### Version 3.1.0.0-beta

* This is a full rewrite of Ankh Cooldown Timer. It is more efficient, more flexible, more featureful, and more user-friendly.
* Configuration is no longer available via the command line, but instead is available in the standard Interface Options panel.
* A DataBroker plugin is now integrated into the addon. It's compatible with Titan Panel, FuBar (with Broker2FuBar), and all DataBroker displays.
* An alert when Reincarnation becomes ready has been added.

### Version 2.4.3.2

* Fixed tooltip

### Version 2.4.3.1

* Added ruRU translations

### Version 20400.1

* Removed FuBar and Titan Panel plugins; they are now downloadable separately
* Updated localizations
* Updated readme file
* Updated version number

### Version 20100-r01

* Reupload to fix Curse giving you the wrong file (I hope)
* NEW: FuBar plugin support
* NEW: automatic ankh restocking
* CHANGED: more reliable low ankh reminder
* CHANGED: new look for the GUI window
* KNOWN BUG: The very first time you log in with this addon you will get a low ankh warning telling you you have 0 ankhs, regardless of how many you actually have. You will not see this on subsequent logins.

### 3.0.0 Beta 11

* Improved low ankh reminder
* Ankh auto purchase
* New GUI look
* FuBar plugin

### Version 2.0.1

* Added partial German translations (thanks Dleh on ui.wow!) - Fixed bug causing all users to get English translations

### Version 2.0.0

* Full rewrite.

### Version 1.8.2

* Bugfix.

### Version 1.8.1

* Fixed a bug with Titan Panel support.
* Expanded localization.
 * I need help translating for German and French!
 * I also need help localizing for zhCH, zhTW, and koKR locales.
* Removed ankh tooltips for now, as they don't work in WoW 2.0 as-is.

### Version 1.8.0

* Full support for WoW 2.0
* Improvements to Titan Panel support.
 * The icon can now be hidden.
 * Titan plugin code separated from main addon. If you do not need or want the Titan plugin, you can delete the "TitanAnkhCooldownTimer.xml" line in AnkhCooldownTimer.toc
* Removed support All In One Inventory
 * AIOI hasn't been upated in 8 months and probably won't be made 2.0 compliant, and was hideously inefficient anyway.
 * Use Bagnon or OneBag instead - both are actively supported by their authors, are 2.0 compliant, and much more efficient.

### Version 1.7.2-BETA

* Preliminary support for WoW 2.0

### Version 1.7.1

* Added Spanish localization (thanks osilvay)

### Version 1.7.0

* Changed cooldown routine to use Blizzard's new timer.

### Version 1.6.3

* Added support for Totem of Rebirth relic.
* Fixed incorrect cooldown being shown on initial load.

----------

Versions older than 1.6.3 were published by Starforce, the original author of Ankh Cooldown Timer.

### Version 1.5.0

* Updated for 1.11
* Fixed bug with cooldown resetting when zoning
* Added "/act ready" slash command

### Version 1.4.1

* Improved reincarnation for the frenchies is now fixed. Problem was with the translation so blame Zulbukh ;). He was the one who noticed and reported it too though, great thanks to my baguette eating friend!

### Version 1.4.0

* Cooldown in the ankhs tooltip is now possible.
* Works for normal bags aswell as with AllInOneInventory
* Fixed german support. The improved reincarnation abilty was bugged for the germans. Thanks to fukz for pointing this out and for suggesting a fix!
* Updated .toc version to 1700 as it works perfect with the latest patch Note that the toggle argument changed (used to toggle the gui box) to togglegui. New argument added: toggletooltip

### Version 1.3.2

* Fixed the frensh support :P

### Version 1.3.1

* Added french support (thanks to Zulbukh)

### Version 1.3.0

* Added an ankh-icon to the Titan Bar
* Added menu for the Titan Bar

### Version 1.2.0

* Really fixed the improved reincarnation bug. I had to re-spec so now i know it's ok. (pls send me gold)
* Might be some more minor thing, can't remember.

### Version 1.1.0

* Fixed improved reincarnation bug. Should work now. Thanks to nrankin on ui.worldofwar.net for pointing this out and finding the improved reincarnation bug. I'm not a resto shaman so i trust him that he solved it. (it was a spelling error on a variable)
* Fixed the problem with the GUI box showing after re-log even though it was turned off

### Version 1.0.0

* First version
