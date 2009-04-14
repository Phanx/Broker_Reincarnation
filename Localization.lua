--[[--------------------------------------------------------------------
	AnkhUp: a shaman Reincarnation monitor
	by Phanx <addons@phanx.net>
	http://www.wowinterface.com/downloads/info6330-AnkhUp.html
	Copyright (c) 2005-2009 Alyssa S. Kinley, a.k.a. Phanx
	See included README for license terms and additional information.
----------------------------------------------------------------------]]

local locale = GetLocale()
if locale == "enUS" or locale == "enGB" then return end

AnkhUpStrings = {}
local L = AnkhUpStrings

------------------------------------------------------------------------
--	deDE translations contributed by NAME
--	Last updated YYYY-MM-DD
------------------------------------------------------------------------

if locale == "deDE" then
	L["Ankh"] = "Ankh"

	L["Ankhs"] = "Ankhs"
	L["Ready in..."] = "Ready in..."
	L["Reincarnation is..."] = "Reincarnation is..."
	L["Ready"] = "Ready"
	L["Cooldown"] = "Cooldown"
	L["Last Reincarnated"] = "Last Reincarnated"

	L["You only have %d ankhs left. Don't forget to restock!"] = "You only have %d ankhs left. Don't forget to restock!"
	L["Buying %d ankhs."] = "Buying %d ankhs."
	L["Reincarnation ready!"] = "Reincarnation ready!"

	L["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."
	L["Low ankh warning"] = "Low ankh warning"
	L["Show a warning dialog when you have fewer than this number of ankhs in your inventory. Set to 0 to disable warnings."] = "Show a warning dialog when you have fewer than this number of ankhs in your inventory. Set to 0 to disable warnings."
	L["Restock ankhs"] = "Restock ankhs"
	L["Restock ankhs up to this number when interacting with reagent vendors. Set to 0 to disable restocking."] = "Restock ankhs up to this number when interacting with reagent vendors. Set to 0 to disable restocking."
	L["Notify when buying"] = "Notify when buying"
	L["Enable notification in the chat frame when restocking ankhs."] = "Enable notification in the chat frame when restocking ankhs."
	L["Notify when ready"] = "Notify when ready"
	L["Enable notification in the raid warning frame when Reincarnation becomes ready."] = "Enable notification in the raid warning frame when Reincarnation becomes ready."
	L["Show monitor"] = "Show monitor"
	L["Show a small, movable monitor window for your Reincarnation cooldown."] = "Show a small, movable monitor window for your Reincarnation cooldown."
	L["Monitor scale"] = "Monitor scale"
	L["Adjust the size of the monitor window."] = "Adjust the size of the monitor window."
return end

------------------------------------------------------------------------
--	esES translations contributed by NAME
--	Last updated YYYY-MM-DD
------------------------------------------------------------------------

if locale == "esES" then
	L["Ankh"] = "Ankh"

	L["Ankhs"] = "Ankhs"
	L["Ready in..."] = "Ready in..."
	L["Reincarnation is..."] = "Reincarnation is..."
	L["Ready"] = "Ready"
	L["Cooldown"] = "Cooldown"
	L["Last Reincarnated"] = "Last Reincarnated"

	L["You only have %d ankhs left. Don't forget to restock!"] = "You only have %d ankhs left. Don't forget to restock!"
	L["Buying %d ankhs."] = "Buying %d ankhs."
	L["Reincarnation ready!"] = "Reincarnation ready!"

	L["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."
	L["Low ankh warning"] = "Low ankh warning"
	L["Show a warning dialog when you have fewer than this number of ankhs in your inventory. Set to 0 to disable warnings."] = "Show a warning dialog when you have fewer than this number of ankhs in your inventory. Set to 0 to disable warnings."
	L["Restock ankhs"] = "Restock ankhs"
	L["Restock ankhs up to this number when interacting with reagent vendors. Set to 0 to disable restocking."] = "Restock ankhs up to this number when interacting with reagent vendors. Set to 0 to disable restocking."
	L["Notify when buying"] = "Notify when buying"
	L["Enable notification in the chat frame when restocking ankhs."] = "Enable notification in the chat frame when restocking ankhs."
	L["Notify when ready"] = "Notify when ready"
	L["Enable notification in the raid warning frame when Reincarnation becomes ready."] = "Enable notification in the raid warning frame when Reincarnation becomes ready."
	L["Show monitor"] = "Show monitor"
	L["Show a small, movable monitor window for your Reincarnation cooldown."] = "Show a small, movable monitor window for your Reincarnation cooldown."
	L["Monitor scale"] = "Monitor scale"
	L["Adjust the size of the monitor window."] = "Adjust the size of the monitor window."
return end

------------------------------------------------------------------------
--	esMX translations contributed by NAME
--	Last updated YYYY-MM-DD
------------------------------------------------------------------------

if locale == "esMX" then
	L["Ankh"] = "Ankh"

	L["Ankhs"] = "Ankhs"
	L["Ready in..."] = "Ready in..."
	L["Reincarnation is..."] = "Reincarnation is..."
	L["Ready"] = "Ready"
	L["Cooldown"] = "Cooldown"
	L["Last Reincarnated"] = "Last Reincarnated"

	L["You only have %d ankhs left. Don't forget to restock!"] = "You only have %d ankhs left. Don't forget to restock!"
	L["Buying %d ankhs."] = "Buying %d ankhs."
	L["Reincarnation ready!"] = "Reincarnation ready!"

	L["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."
	L["Low ankh warning"] = "Low ankh warning"
	L["Show a warning dialog when you have fewer than this number of ankhs in your inventory. Set to 0 to disable warnings."] = "Show a warning dialog when you have fewer than this number of ankhs in your inventory. Set to 0 to disable warnings."
	L["Restock ankhs"] = "Restock ankhs"
	L["Restock ankhs up to this number when interacting with reagent vendors. Set to 0 to disable restocking."] = "Restock ankhs up to this number when interacting with reagent vendors. Set to 0 to disable restocking."
	L["Notify when buying"] = "Notify when buying"
	L["Enable notification in the chat frame when restocking ankhs."] = "Enable notification in the chat frame when restocking ankhs."
	L["Notify when ready"] = "Notify when ready"
	L["Enable notification in the raid warning frame when Reincarnation becomes ready."] = "Enable notification in the raid warning frame when Reincarnation becomes ready."
	L["Show monitor"] = "Show monitor"
	L["Show a small, movable monitor window for your Reincarnation cooldown."] = "Show a small, movable monitor window for your Reincarnation cooldown."
	L["Monitor scale"] = "Monitor scale"
	L["Adjust the size of the monitor window."] = "Adjust the size of the monitor window."
return end

------------------------------------------------------------------------
--	frFR translations contributed by NAME
--	Last updated YYYY-MM-DD
------------------------------------------------------------------------

if locale == "frFR" then
	L["Ankh"] = "Ankh"

	L["Ankhs"] = "Ankhs"
	L["Ready in..."] = "Ready in..."
	L["Reincarnation is..."] = "Reincarnation is..."
	L["Ready"] = "Ready"
	L["Cooldown"] = "Cooldown"
	L["Last Reincarnated"] = "Last Reincarnated"

	L["You only have %d ankhs left. Don't forget to restock!"] = "You only have %d ankhs left. Don't forget to restock!"
	L["Buying %d ankhs."] = "Buying %d ankhs."
	L["Reincarnation ready!"] = "Reincarnation ready!"

	L["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."
	L["Low ankh warning"] = "Low ankh warning"
	L["Show a warning dialog when you have fewer than this number of ankhs in your inventory. Set to 0 to disable warnings."] = "Show a warning dialog when you have fewer than this number of ankhs in your inventory. Set to 0 to disable warnings."
	L["Restock ankhs"] = "Restock ankhs"
	L["Restock ankhs up to this number when interacting with reagent vendors. Set to 0 to disable restocking."] = "Restock ankhs up to this number when interacting with reagent vendors. Set to 0 to disable restocking."
	L["Notify when buying"] = "Notify when buying"
	L["Enable notification in the chat frame when restocking ankhs."] = "Enable notification in the chat frame when restocking ankhs."
	L["Notify when ready"] = "Notify when ready"
	L["Enable notification in the raid warning frame when Reincarnation becomes ready."] = "Enable notification in the raid warning frame when Reincarnation becomes ready."
	L["Show monitor"] = "Show monitor"
	L["Show a small, movable monitor window for your Reincarnation cooldown."] = "Show a small, movable monitor window for your Reincarnation cooldown."
	L["Monitor scale"] = "Monitor scale"
	L["Adjust the size of the monitor window."] = "Adjust the size of the monitor window."
return end

------------------------------------------------------------------------
--	ruRU translations contributed by NAME
--	Last updated YYYY-MM-DD
------------------------------------------------------------------------

if locale == "ruRU" then
	L["Ankh"] = "Крестов"

	L["Ankhs"] = "Ankhs"
	L["Ready in..."] = "Ready in..."
	L["Reincarnation is..."] = "Reincarnation is..."
	L["Ready"] = "Ready"
	L["Cooldown"] = "Cooldown"
	L["Last Reincarnated"] = "Last Reincarnated"

	L["You only have %d ankhs left. Don't forget to restock!"] = "You only have %d ankhs left. Don't forget to restock!"
	L["Buying %d ankhs."] = "Buying %d ankhs."
	L["Reincarnation ready!"] = "Reincarnation ready!"

	L["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."
	L["Low ankh warning"] = "Low ankh warning"
	L["Show a warning dialog when you have fewer than this number of ankhs in your inventory. Set to 0 to disable warnings."] = "Show a warning dialog when you have fewer than this number of ankhs in your inventory. Set to 0 to disable warnings."
	L["Restock ankhs"] = "Restock ankhs"
	L["Restock ankhs up to this number when interacting with reagent vendors. Set to 0 to disable restocking."] = "Restock ankhs up to this number when interacting with reagent vendors. Set to 0 to disable restocking."
	L["Notify when buying"] = "Notify when buying"
	L["Enable notification in the chat frame when restocking ankhs."] = "Enable notification in the chat frame when restocking ankhs."
	L["Notify when ready"] = "Notify when ready"
	L["Enable notification in the raid warning frame when Reincarnation becomes ready."] = "Enable notification in the raid warning frame when Reincarnation becomes ready."
	L["Show monitor"] = "Show monitor"
	L["Show a small, movable monitor window for your Reincarnation cooldown."] = "Show a small, movable monitor window for your Reincarnation cooldown."
	L["Monitor scale"] = "Monitor scale"
	L["Adjust the size of the monitor window."] = "Adjust the size of the monitor window."
return end

------------------------------------------------------------------------
--	koKR translations contributed by NAME
--	Last updated YYYY-MM-DD
------------------------------------------------------------------------

if locale == "koKR" then
	L["Ankh"] = "십자가"

	L["Ankhs"] = "Ankhs"
	L["Ready in..."] = "Ready in..."
	L["Reincarnation is..."] = "Reincarnation is..."
	L["Ready"] = "Ready"
	L["Cooldown"] = "Cooldown"
	L["Last Reincarnated"] = "Last Reincarnated"

	L["You only have %d ankhs left. Don't forget to restock!"] = "You only have %d ankhs left. Don't forget to restock!"
	L["Buying %d ankhs."] = "Buying %d ankhs."
	L["Reincarnation ready!"] = "Reincarnation ready!"

	L["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."
	L["Low ankh warning"] = "Low ankh warning"
	L["Show a warning dialog when you have fewer than this number of ankhs in your inventory. Set to 0 to disable warnings."] = "Show a warning dialog when you have fewer than this number of ankhs in your inventory. Set to 0 to disable warnings."
	L["Restock ankhs"] = "Restock ankhs"
	L["Restock ankhs up to this number when interacting with reagent vendors. Set to 0 to disable restocking."] = "Restock ankhs up to this number when interacting with reagent vendors. Set to 0 to disable restocking."
	L["Notify when buying"] = "Notify when buying"
	L["Enable notification in the chat frame when restocking ankhs."] = "Enable notification in the chat frame when restocking ankhs."
	L["Notify when ready"] = "Notify when ready"
	L["Enable notification in the raid warning frame when Reincarnation becomes ready."] = "Enable notification in the raid warning frame when Reincarnation becomes ready."
	L["Show monitor"] = "Show monitor"
	L["Show a small, movable monitor window for your Reincarnation cooldown."] = "Show a small, movable monitor window for your Reincarnation cooldown."
	L["Monitor scale"] = "Monitor scale"
	L["Adjust the size of the monitor window."] = "Adjust the size of the monitor window."
return end

------------------------------------------------------------------------
--	zhCN translations contributed by NAME
--	Last updated YYYY-MM-DD
------------------------------------------------------------------------

if locale == "zhCN" then	
	L["Ankh"] = "十字章"

	L["Ankhs"] = "Ankhs"
	L["Ready in..."] = "Ready in..."
	L["Reincarnation is..."] = "Reincarnation is..."
	L["Ready"] = "Ready"
	L["Cooldown"] = "Cooldown"
	L["Last Reincarnated"] = "Last Reincarnated"

	L["You only have %d ankhs left. Don't forget to restock!"] = "You only have %d ankhs left. Don't forget to restock!"
	L["Buying %d ankhs."] = "Buying %d ankhs."
	L["Reincarnation ready!"] = "Reincarnation ready!"

	L["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."
	L["Low ankh warning"] = "Low ankh warning"
	L["Show a warning dialog when you have fewer than this number of ankhs in your inventory. Set to 0 to disable warnings."] = "Show a warning dialog when you have fewer than this number of ankhs in your inventory. Set to 0 to disable warnings."
	L["Restock ankhs"] = "Restock ankhs"
	L["Restock ankhs up to this number when interacting with reagent vendors. Set to 0 to disable restocking."] = "Restock ankhs up to this number when interacting with reagent vendors. Set to 0 to disable restocking."
	L["Notify when buying"] = "Notify when buying"
	L["Enable notification in the chat frame when restocking ankhs."] = "Enable notification in the chat frame when restocking ankhs."
	L["Notify when ready"] = "Notify when ready"
	L["Enable notification in the raid warning frame when Reincarnation becomes ready."] = "Enable notification in the raid warning frame when Reincarnation becomes ready."
	L["Show monitor"] = "Show monitor"
	L["Show a small, movable monitor window for your Reincarnation cooldown."] = "Show a small, movable monitor window for your Reincarnation cooldown."
	L["Monitor scale"] = "Monitor scale"
	L["Adjust the size of the monitor window."] = "Adjust the size of the monitor window."
return end

------------------------------------------------------------------------
--	zhTW translations contributed by NAME
--	Last updated YYYY-MM-DD
------------------------------------------------------------------------

if locale == "zhTW" then
	L["Ankh"] = "十字章"

	L["Ankhs"] = "Ankhs"
	L["Ready in..."] = "Ready in..."
	L["Reincarnation is..."] = "Reincarnation is..."
	L["Ready"] = "Ready"
	L["Cooldown"] = "Cooldown"
	L["Last Reincarnated"] = "Last Reincarnated"

	L["You only have %d ankhs left. Don't forget to restock!"] = "You only have %d ankhs left. Don't forget to restock!"
	L["Buying %d ankhs."] = "Buying %d ankhs."
	L["Reincarnation ready!"] = "Reincarnation ready!"

	L["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."
	L["Low ankh warning"] = "Low ankh warning"
	L["Show a warning dialog when you have fewer than this number of ankhs in your inventory. Set to 0 to disable warnings."] = "Show a warning dialog when you have fewer than this number of ankhs in your inventory. Set to 0 to disable warnings."
	L["Restock ankhs"] = "Restock ankhs"
	L["Restock ankhs up to this number when interacting with reagent vendors. Set to 0 to disable restocking."] = "Restock ankhs up to this number when interacting with reagent vendors. Set to 0 to disable restocking."
	L["Notify when buying"] = "Notify when buying"
	L["Enable notification in the chat frame when restocking ankhs."] = "Enable notification in the chat frame when restocking ankhs."
	L["Notify when ready"] = "Notify when ready"
	L["Enable notification in the raid warning frame when Reincarnation becomes ready."] = "Enable notification in the raid warning frame when Reincarnation becomes ready."
	L["Show monitor"] = "Show monitor"
	L["Show a small, movable monitor window for your Reincarnation cooldown."] = "Show a small, movable monitor window for your Reincarnation cooldown."
	L["Monitor scale"] = "Monitor scale"
	L["Adjust the size of the monitor window."] = "Adjust the size of the monitor window."
return end

------------------------------------------------------------------------