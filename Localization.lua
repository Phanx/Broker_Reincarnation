--[[--------------------------------------------------------------------
	AnkhUp
	Reincarnation cooldown monitor shamans
	by Phanx < addons@phanx.net >
	http://www.wowinterface.com/downloads/info6330-AnkhUp.html
	Copyright ©2006–2009 Alyssa "Phanx" Kinley
	See included README for license terms and additional information.

	This file provides translations of user interface strings.
----------------------------------------------------------------------]]

local locale = GetLocale()
if locale == "enUS" or locale == "enGB" then return end

AnkhUpStrings = {}
local L = AnkhUpStrings

--[[--------------------------------------------------------------------
	German
	Last updated: 2009-10-22 by Gyffes
	Contributors:
		Gyffes - www.ihl-gilneas.de
----------------------------------------------------------------------]]

if locale == "deDE" then
	L["Ankh"] = "Ankh"

	L["Ankhs"] = "Ankhs"
	L["Remaining"] = "Verfügbar in..."
	L["Ready"] = "Bereit"
	L["Cooldown"] = "Cooldown"
	L["Last Reincarnated"] = "Letzte Reinkarnation"
--	L["%I:%M %p %A, %B %d, %Y"] = "" -- See table at http://www.lua.org/pil/22.1.html

	L["You only have %d ankhs left. Don't forget to restock!"] = "Du hast nur noch %d Ankhs. Vergiss nicht, sie aufzufüllen!"
	L["Buying %d ankhs."] = "Kaufe %d Ankhs."
	L["Reincarnation is ready!"] = "Reinkarnation wieder Verfügbar!"

	L["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "In diesem Menü können Sie AnkhUp einstellen."
	L["Low ankh warning"] = "Achtung wenige Ankhs"
	L["Show a warning dialog when you have fewer than this number of ankhs (set to 0 to disable)"] = "Zeigt eine Warnung wenn du weniger Ankhs hast als eingestellt. Stelle auf 0 zum Deaktivieren."
	L["Restock ankhs"] = "Ankhs auffüllen"
	L["Restock ankhs up to a total of this number when interacting with vendors (set to 0 to disable)"] = "Kaufe Automatisch Ankhs beim Händler bis die eingestellte Menge im Inventar ist."
	L["Notify when restocking"] = "Benachrichtigung beim auffüllen."
	L["Enable notification in the chat frame when restocking ankhs"] = "Sendet eine Benachrichtigung ins Chatfenster."
	L["Notify when ready"] = "Benachrichtige wenn Bereit"
	L["Enable notification in the raid warning frame when Reincarnation becomes ready"] = "Benachrichtigt dich wenn die Reinkarnation wieder bereit ist."
	L["Show monitor"] = "Zeige Fenster"
	L["Show a standalone monitor window for your Reincarnation cooldown"] = "Zeigt ein Standalone-Monitor-Fenster für dein Reinkarnation Cooldown."
	L["Lock monitor"] = "Sperre Fenster"
	L["Lock the monitor window in place, preventing dragging"] = "Sperrt das Fenster"
	L["Monitor scale"] = "Fenstergröße"
	L["Adjust the size of the monitor window"] = "Passt die Fenstergröße"

	L["Right-click for options."] = "Rechtsklick für Optionen"
return end

--[[--------------------------------------------------------------------
	Spanish
	Last updated: YYYY-MM-DD by YourName
	Contributors:
		Add your name and any other info here
----------------------------------------------------------------------]]

if locale == "esES" then
	L["Ankh"] = "Ankh"

	L["Ankhs"] = "Ankhs"
--	L["Remaining"] = ""
--	L["Ready"] = ""
--	L["Cooldown"] = ""
--	L["Last Reincarnated"] = ""
--	L["%I:%M %p %A, %B %d, %Y"] = "" -- See table at http://www.lua.org/pil/22.1.html

--	L["You only have %d ankhs left. Don't forget to restock!"] = ""
--	L["Buying %d ankhs."] = ""
--	L["Reincarnation is ready!"] = ""

--	L["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = ""
--	L["Low ankh warning"] = ""
--	L["Show a warning dialog when you have fewer than this number of ankhs. Set to 0 to disable the warning."] = ""
--	L["Restock ankhs"] = ""
--	L["Restock ankhs up to a total of this number when interacting with vendors. Set to 0 to disable restocking."] = ""
--	L["Notify when restocking"] = ""
--	L["Enable notification in the chat frame when restocking ankhs."] = ""
--	L["Notify when ready"] = ""
--	L["Enable notification in the raid warning frame when Reincarnation becomes ready."] = ""
--	L["Show monitor"] = ""
--	L["Show a standalone monitor window for your Reincarnation cooldown."] = ""
--	L["Lock monitor"] = ""
--	L["Lock the monitor window in place, preventing dragging."] = ""
--	L["Monitor scale"] = ""
--	L["Adjust the size of the monitor window."] = ""

--	L["Right-click for options."] = ""
return end

--[[--------------------------------------------------------------------
	Latin American Spanish
	Last updated: YYYY-MM-DD by YourName
	Contributors:
		Add your name and any other info here
----------------------------------------------------------------------]]
if locale == "esMX" then
	L["Ankh"] = "Ankh"

--	L["Ankhs"] = ""
--	L["Remaining"] = ""
--	L["Ready"] = ""
--	L["Cooldown"] = ""
--	L["Last Reincarnated"] = ""
--	L["%I:%M %p %A, %B %d, %Y"] = "" -- See table at http://www.lua.org/pil/22.1.html

--	L["You only have %d ankhs left. Don't forget to restock!"] = ""
--	L["Buying %d ankhs."] = ""
--	L["Reincarnation is ready!"] = ""

--	L["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = ""
--	L["Low ankh warning"] = ""
--	L["Show a warning dialog when you have fewer than this number of ankhs. Set to 0 to disable the warning."] = ""
--	L["Restock ankhs"] = ""
--	L["Restock ankhs up to a total of this number when interacting with vendors. Set to 0 to disable restocking."] = ""
--	L["Notify when restocking"] = ""
--	L["Enable notification in the chat frame when restocking ankhs."] = ""
--	L["Notify when ready"] = ""
--	L["Enable notification in the raid warning frame when Reincarnation becomes ready."] = ""
--	L["Show monitor"] = ""
--	L["Show a standalone monitor window for your Reincarnation cooldown."] = ""
--	L["Lock monitor"] = ""
--	L["Lock the monitor window in place, preventing dragging."] = ""
--	L["Monitor scale"] = ""
--	L["Adjust the size of the monitor window."] = ""

--	L["Right-click for options."] = ""
return end

--[[--------------------------------------------------------------------
	French
	Last updated: 2009-04-25 by Itania
	Contributors:
		Itania @ WoWInterface
----------------------------------------------------------------------]]

if locale == "frFR" then
	L["Ankh"] = "Ankh"

	L["Ankhs"] = "Ankhs"
	L["Remaining"] = "Disponible dans..."
	L["Ready"] = "Disponible"
	L["Cooldown"] = "Recharge"
	L["Last Reincarnated"] = "Dernière réincarnation"
	L["%I:%M %p %A, %B %d, %Y"] = "%I:%M %p, %A %d %B %Y" -- See table at http://www.lua.org/pil/22.1.html

	L["You only have %d ankhs left. Don't forget to restock!"] = "Il ne vous reste que %d ankhs. N'oubliez pas d'en racheter!"
	L["Buying %d ankhs."] = "Achat de %d ankhs."
	L["Reincarnation is ready!"] = "Réincarnation est disponible!"

	L["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "Cette fenêtre vous permet de configurer les options pour contrôler votre Réincarnation et gérer vos Ankhs"
	L["Low ankh warning"] = "Alerte ankhs"
	L["Show a warning dialog when you have fewer than this number of ankhs. Set to 0 to disable the warning."] = "Affiche un message d'alerte lorsque vous avez moins que ce nombre d'ankhs. Mettre à 0 pour désactiver l'alerte."
	L["Restock ankhs"] = "Rachat d'ankhs"
	L["Restock ankhs up to a total of this number when interacting with vendors. Set to 0 to disable restocking."] = "Rachète des Ankhs jusqu'à ce nombre lors d'une interaction avec un vendeur. Mettre à 0 pour désactiver le rachat automatique."
	L["Notify when restocking"] = "Notification lors d'un rachat"
	L["Enable notification in the chat frame when restocking ankhs."] = "Active la notification sur la fenêtre de chat lors du rachat d'ankhs."
	L["Notify when ready"] = "Notifier quand disponible"
	L["Enable notification in the raid warning frame when Reincarnation becomes ready."] = "Active la notification dans la fenêtre de raid lorsque Réincarnation devient disponible."
	L["Show monitor"] = "Afficher moniteur"
	L["Show a small, movable monitor window for your Reincarnation cooldown."] = "Affiche une petite fenêtre de contrôle déplaçable pour le temps de recharge de Réincarnation."
	L["Monitor scale"] = "Taille d'moniteur"
	L["Adjust the size of the monitor window."] = "Règle la taille du moniteur"

--	L["Right-click for options."] = ""
return end

--[[--------------------------------------------------------------------
	Russian
	Last updated: YYYY-MM-DD by YourName
	Contributors:
		Add your name and any other info here
----------------------------------------------------------------------]]

if locale == "ruRU" then
	L["Ankh"] = "Крестов"

--	L["Ankhs"] = ""
--	L["Remaining"] = ""
--	L["Ready"] = ""
--	L["Cooldown"] = ""
--	L["Last Reincarnated"] = ""
--	L["%I:%M %p %A, %B %d, %Y"] = "" -- See table at http://www.lua.org/pil/22.1.html

--	L["You only have %d ankhs left. Don't forget to restock!"] = ""
--	L["Buying %d ankhs."] = ""
--	L["Reincarnation is ready!"] = ""

--	L["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = ""
--	L["Low ankh warning"] = ""
--	L["Show a warning dialog when you have fewer than this number of ankhs. Set to 0 to disable the warning."] = ""
--	L["Restock ankhs"] = ""
--	L["Restock ankhs up to a total of this number when interacting with vendors. Set to 0 to disable restocking."] = ""
--	L["Notify when restocking"] = ""
--	L["Enable notification in the chat frame when restocking ankhs."] = ""
--	L["Notify when ready"] = ""
--	L["Enable notification in the raid warning frame when Reincarnation becomes ready."] = ""
--	L["Show monitor"] = ""
--	L["Show a standalone monitor window for your Reincarnation cooldown."] = ""
--	L["Lock monitor"] = ""
--	L["Lock the monitor window in place, preventing dragging."] = ""
--	L["Monitor scale"] = ""
--	L["Adjust the size of the monitor window."] = ""

--	L["Right-click for options."] = ""
return end

--[[--------------------------------------------------------------------
	Korean
	Last updated: YYYY-MM-DD by YourName
	Contributors:
		Add your name and any other info here
----------------------------------------------------------------------]]

if locale == "koKR" then
	L["Ankh"] = "십자가"

--	L["Ankhs"] = ""
--	L["Remaining"] = ""
--	L["Ready"] = ""
--	L["Cooldown"] = ""
--	L["Last Reincarnated"] = ""
--	L["%I:%M %p %A, %B %d, %Y"] = "" -- See table at http://www.lua.org/pil/22.1.html

--	L["You only have %d ankhs left. Don't forget to restock!"] = ""
--	L["Buying %d ankhs."] = ""
--	L["Reincarnation is ready!"] = ""

--	L["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = ""
--	L["Low ankh warning"] = ""
--	L["Show a warning dialog when you have fewer than this number of ankhs. Set to 0 to disable the warning."] = ""
--	L["Restock ankhs"] = ""
--	L["Restock ankhs up to a total of this number when interacting with vendors. Set to 0 to disable restocking."] = ""
--	L["Notify when restocking"] = ""
--	L["Enable notification in the chat frame when restocking ankhs."] = ""
--	L["Notify when ready"] = ""
--	L["Enable notification in the raid warning frame when Reincarnation becomes ready."] = ""
--	L["Show monitor"] = ""
--	L["Show a standalone monitor window for your Reincarnation cooldown."] = ""
--	L["Lock monitor"] = ""
--	L["Lock the monitor window in place, preventing dragging."] = ""
--	L["Monitor scale"] = ""
--	L["Adjust the size of the monitor window."] = ""

--	L["Right-click for options."] = ""
return end

--[[--------------------------------------------------------------------
	Simplified Chinese
	Last updated: YYYY-MM-DD by YourName
	Contributors:
		Add your name and any other info here
----------------------------------------------------------------------]]

if locale == "zhCN" then
	L["Ankh"] = "十字章"

--	L["Ankhs"] = ""
--	L["Remaining"] = ""
--	L["Ready"] = ""
--	L["Cooldown"] = ""
--	L["Last Reincarnated"] = ""
--	L["%I:%M %p %A, %B %d, %Y"] = "" -- See table at http://www.lua.org/pil/22.1.html

--	L["You only have %d ankhs left. Don't forget to restock!"] = ""
--	L["Buying %d ankhs."] = ""
--	L["Reincarnation is ready!"] = ""

--	L["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = ""
--	L["Low ankh warning"] = ""
--	L["Show a warning dialog when you have fewer than this number of ankhs. Set to 0 to disable the warning."] = ""
--	L["Restock ankhs"] = ""
--	L["Restock ankhs up to a total of this number when interacting with vendors. Set to 0 to disable restocking."] = ""
--	L["Notify when restocking"] = ""
--	L["Enable notification in the chat frame when restocking ankhs."] = ""
--	L["Notify when ready"] = ""
--	L["Enable notification in the raid warning frame when Reincarnation becomes ready."] = ""
--	L["Show monitor"] = ""
--	L["Show a standalone monitor window for your Reincarnation cooldown."] = ""
--	L["Lock monitor"] = ""
--	L["Lock the monitor window in place, preventing dragging."] = ""
--	L["Monitor scale"] = ""
--	L["Adjust the size of the monitor window."] = ""

--	L["Right-click for options."] = ""
return end

--[[--------------------------------------------------------------------
	Traditional Chinese
	Last updated: YYYY-MM-DD by YourName
	Contributors:
		Add your name and any other info here
----------------------------------------------------------------------]]

if locale == "zhTW" then
	L["Ankh"] = "十字章"

--	L["Ankhs"] = ""
--	L["Remaining"] = ""
--	L["Ready"] = ""
--	L["Cooldown"] = ""
--	L["Last Reincarnated"] = ""
--	L["%I:%M %p %A, %B %d, %Y"] = "" -- See table at http://www.lua.org/pil/22.1.html

--	L["You only have %d ankhs left. Don't forget to restock!"] = ""
--	L["Buying %d ankhs."] = ""
--	L["Reincarnation is ready!"] = ""

--	L["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = ""
--	L["Low ankh warning"] = ""
--	L["Show a warning dialog when you have fewer than this number of ankhs. Set to 0 to disable the warning."] = ""
--	L["Restock ankhs"] = ""
--	L["Restock ankhs up to a total of this number when interacting with vendors. Set to 0 to disable restocking."] = ""
--	L["Notify when restocking"] = ""
--	L["Enable notification in the chat frame when restocking ankhs."] = ""
--	L["Notify when ready"] = ""
--	L["Enable notification in the raid warning frame when Reincarnation becomes ready."] = ""
--	L["Show monitor"] = ""
--	L["Show a standalone monitor window for your Reincarnation cooldown."] = ""
--	L["Lock monitor"] = ""
--	L["Lock the monitor window in place, preventing dragging."] = ""
--	L["Monitor scale"] = ""
--	L["Adjust the size of the monitor window."] = ""

--	L["Right-click for options."] = ""
return end

------------------------------------------------------------------------