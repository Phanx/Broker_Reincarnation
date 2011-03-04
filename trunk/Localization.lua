--[[--------------------------------------------------------------------
	AnkhUp
	Reincarnation cooldown monitor and ankh manager for shamans.
	Written by Phanx <addons@phanx.net>
	Maintained by Akkorian <akkorian@hotmail.com>
	Copyright © 2006–2011 Phanx. Some rights reserved. See LICENSE.txt for details.
	http://www.wowinterface.com/downloads/info6330-AnkhUp.html
	http://wow.curse.com/downloads/wow-addons/details/ankhup.aspx
----------------------------------------------------------------------]]

if select(2, UnitClass("player")) ~= "SHAMAN" then return end

local GAME_LOCALE = GetLocale()
if GAME_LOCALE:match("^en") then return end

local _, ns = ...
if not ns then -- WoW China is still running 3.2
	ns = { }
	_G.AnkhUpNS = ns
end

--[[--------------------------------------------------------------------
	German / Deutsch
	Last updated 2009-10-24 by Gyffes < www.ihl-gilneas.de >
----------------------------------------------------------------------]]

if GAME_LOCALE == "deDE" then ns.L = {

	["Ankh"] = "Ankh",

	["Ankhs"] = "Ankhs",
	["Cooldown"] = "Cooldown",
	["Ready"] = "Bereit",
	["Last Reincarnated"] = "Letzte Reinkarnation",
	["Today at %I:%M %p"] = "Heute um %H.%M Uhr", -- See: http://www.lua.org/pil/22.1.html
	["Yesterday at %I:%M %p"] = "Gestern um %H.%M Uhr",
	["%I:%M %p on %A, %B %d, %Y"] = "%A, %d. %B, %Y um %H.%M Uhr",

	["You only have %d |4ankh:ankhs; left. Don't forget to restock!"] = "Du hast nur noch %d |4Ankh:Ankhs;. Vergiss nicht, sie aufzufüllen!",
	["Purchased %d |4ankh:ankhs;."] = "Kaufe %d |4Ankh:Ankhs;.",
	["Reincarnation is ready!"] = "Reinkarnation wieder Verfügbar!",

	["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "In diesem Menü können Sie AnkhUp einstellen.",
	["Notify when ready"] = "Melde wenn Bereit",
	["Show a notification message when Reincarnation's cooldown finishes."] = "Benachrichtigt dich wenn die Reinkarnation wieder bereit ist.",
	["Notify when restocking"] = "Meldung beim auffüllen",
	["Show a notification message when automatically buying ankhs."] = "Sendet eine Benachrichtigung ins Chatfenster.",
	["Restock quantity"] = "Ankhs auffüllen",
	["Buy ankhs up to a total of this number when you interact with a vendor."] = "Kaufe Automatisch Ankhs beim Händler bis die eingestellte Menge im Inventar ist.",
	["Warning quantity"] = "Achtung wenige Ankhs",
	["Show a warning when you have fewer than this number of ankhs."] = "Zeigt eine Warnung wenn du weniger Ankhs hast als eingestellt.",
	["Set to 0 to disable this feature."] = "Stelle auf 0 zum Deaktivieren.",

	["Show monitor"] = "Zeige Fenster",
	["Show a small movable window to track your Reincarnation cooldown."] = "Zeigt ein Standalone-Monitor-Fenster für dein Reinkarnation Cooldown.",
	["Lock monitor"] = "Sperre Fenster",
	["Lock the monitor window in place to prevent it from being moved."] = "Sperrt das Fenster",
	["Monitor scale"] = "Fenstergröße",
	["Adjust the size of the monitor window."] = "Passt die Fenstergröße",

	["Right-click for options."] = "Rechtsklick für Optionen",

} return end

--[[--------------------------------------------------------------------
	Spanish / Español (EU) + Latin American Spanish / Español (AL)
	Last updated: 2011-03-02 by Akkorian
----------------------------------------------------------------------]]

if GAME_LOCALE == "esES" or GAME_LOCALE == "esMX" then ns.L = {

	["Ankh"] = "Ankh",

	["Ankhs"] = "Ankhs",
	["Cooldown"] = "Tiempo de reutilización",
	["Ready"] = "Listo",
	["Last Reincarnated"] = "Última reencarnación",
	["Today at %I:%M %p"] = "Hoy a las %H.%M", -- See: http://www.lua.org/pil/22.1.html
	["Yesterday at %I:%M %p"] = "Ayer a las %H.%M",
	["%I:%M %p on %A, %B %d, %Y"] = "%H.%M del %A, %d de %B de %Y",

	["You only have %d ankhs left. Don't forget to restock!"] = "Tienes sólo %s ankhs. No olvide de comprar más!",
	["Purchased %d |4ankh:ankhs;."] = "Compró %d |4ankh:ankhs;.",
	["Reincarnation is ready!"] = "Reencarnación está listo!",

	["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "Este accesorio sigue el tiempo de reutilización de tu hechizo Reencarnación, y ayuda a administrar tus ankhs. Utilice estas opciones para configurarlo.",
	["Notify when ready"] = "Notificar cuando listo",
	["Show a notification message when Reincarnation's cooldown finishes."] = "Notificar cuando termine el tiempo de reutilización de tu hechizo Reencarnación.",
	["Notify when restocking"] = "Notificar cuando reaprovisionar",
	["Show a notification message when automatically buying ankhs."] = "Notificar cuando autocomprar más ankhs.",
	["Restock quantity"] = "Cantidad para reaprovisionar",
	["Buy ankhs up to a total of this number when you interact with a vendor."] = "Comprar ankhs hasta un total de esta cantidad cuando hablas con un vendedor.",
	["Warning quantity"] = "Cantidad para avisar",
	["Show a warning when you have fewer than this number of ankhs."] = "Mostrar una advertencia cuando tienes menos de esta cantidad de ankhs.",
	["Set to 0 to disable this feature."] = "Establece en 0 para desactivar esta función.",

	["Show monitor"] = "Mostrar ventana",
	["Show a small movable window to track your Reincarnation cooldown."] = "Mostrar una pequeña ventana móvil para seguir el tiempo de reutilización de tu hechizo Reencarnación.",
	["Lock monitor"] = "Bloquear ventana",
	["Lock the monitor window in place to prevent it from being moved."] = "Bloquear la ventana para que no puedes moverlo.",
	["Monitor scale"] = "Tamaño de ventana",
	["Adjust the size of the monitor window."] = "Cambiar el tamaño de la ventana.",

	["Right-click for options."] = "Haz clic derecho para opciones.",

} return end

--[[--------------------------------------------------------------------
	French / Français
	Last updated: 2009-04-25 by Itania @ WoWInterface
----------------------------------------------------------------------]]

if GAME_LOCALE == "frFR" then ns.L = {

	["Ankh"] = "Ankh",

	["Ankhs"] = "Ankhs",
	["Cooldown"] = "Recharge",
	["Ready"] = "Disponible",
	["Last Reincarnated"] = "Dernière réincarnation",
	["Today at %I:%M %p"] = "Aujourd'hui à %H h %M", -- See: http://www.lua.org/pil/22.1.html
	["Yesterday at %I:%M %p"] = "Hier à %H h %M",
	["%I:%M %p on %A, %B %d, %Y"] = "%A %d %B %Y à %H h %M",

	["You only have %d |4ankh:ankhs; left. Don't forget to restock!"] = "Il ne vous reste que %d |4ankh:ankhs;. N'oubliez pas d'en racheter!",
	["Purchased %d |4ankh:ankhs;."] = "Achat de %d |4ankh:ankhs;.",
	["Reincarnation is ready!"] = "Réincarnation est disponible!",

	["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "Cette fenêtre vous permet de configurer les options pour contrôler votre Réincarnation et gérer vos Ankhs",
	["Notify when ready"] = "Notifier quand disponible",
	["Show a notification message when Reincarnation's cooldown finishes."] = "Active la notification dans la fenêtre de raid lorsque Réincarnation devient disponible.",
	["Notify when restocking"] = "Notification lors d'un rachat",
	["Show a notification message when automatically buying ankhs."] = "Active la notification sur la fenêtre de chat lors du rachat d'ankhs.",
	["Restock quantity"] = "Rachat d'ankhs",
	["Buy ankhs up to a total of this number when you interact with a vendor."] = "Rachète des Ankhs jusqu'à ce nombre lors d'une interaction avec un vendeur.",
	["Warning quantity"] = "Alerte ankhs",
	["Show a warning when you have fewer than this number of ankhs."] = "Affiche un message d'alerte lorsque vous avez moins que ce nombre d'ankhs.",
	["Set to 0 to disable this feature."] = "Mettre à 0 pour désactiver.",

	["Show monitor"] = "Afficher moniteur",
	["Show a small movable window to track your Reincarnation cooldown."] = "Affiche une petite fenêtre de contrôle déplaçable pour le temps de recharge de Réincarnation.",
--	["Lock monitor"] = "",
--	["Lock the monitor window in place to prevent it from being moved."] = "",
	["Monitor scale"] = "Taille d'moniteur",
	["Adjust the size of the monitor window."] = "Règle la taille du moniteur",

--	["Right-click for options."] = "",

} return end

--[[--------------------------------------------------------------------
	Russian / Русский
	Last updated: YYYY-MM-DD by UNKNOWN
----------------------------------------------------------------------]]

if GAME_LOCALE == "ruRU" then ns.L = {

	["Ankh"] = "Крест",

	["Ankhs"] = "Крестов",
--	["Cooldown"] = "",
--	["Ready"] = "",
--	["Last Reincarnated"] = "",
	["Today at %I:%M %p"] = "Сегодня в %I:%M %p", -- See: http://www.lua.org/pil/22.1.html
	["Yesterday at %I:%M %p"] = "Вчера в %I:%M %p",
	["%I:%M %p on %A, %B %d, %Y"] = "%A %d %B %Y в %I:%M %p",

--	["You only have %d |4ankh:ankhs; left. Don't forget to restock!"] = "",
--	["Purchased %d |4ankh:ankhs;."] = "",
--	["Reincarnation is ready!"] = "",

--	["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "",
--	["Notify when ready"] = "",
--	["Show a notification message when Reincarnation's cooldown finishes."] = "",
--	["Notify when restocking"] = "",
--	["Show a notification message when automatically buying ankhs."] = "",
--	["Restock quantity"] = "",
--	["Buy ankhs up to a total of this number when you interact with a vendor."] = "",
--	["Warning quantity"] = "",
--	["Show a warning when you have fewer than this number of ankhs."] = "",
--	["Set to 0 to disable this feature."] = "",

--	["Show monitor"] = "",
--	["Show a small movable window to track your Reincarnation cooldown."] = "",
--	["Lock monitor"] = "",
--	["Lock the monitor window in place to prevent it from being moved."] = "",
--	["Monitor scale"] = "",
--	["Adjust the size of the monitor window."] = "",

--	["Right-click for options."] = "",

} return end

--[[--------------------------------------------------------------------
	Korean / 한국어
	Last updated: YYYY-MM-DD by UNKNOWN
----------------------------------------------------------------------]]

if GAME_LOCALE == "koKR" then ns.L = {

	["Ankh"] = "십자가",

--	["Ankhs"] = "",
--	["Cooldown"] = "",
--	["Ready"] = "",
--	["Last Reincarnated"] = "",
	["Today at %I:%M %p"] = "%H시 %M분에서 오늘", -- See: http://www.lua.org/pil/22.1.html
	["Yesterday at %I:%M %p"] = "%H시 %M분에서 어제",
	["%I:%M %p on %A, %B %d, %Y"] = "%H시 %M분에서 %A %Y년 %m월 %d일",

--	["You only have %d |4ankh:ankhs; left. Don't forget to restock!"] = "",
--	["Purchased %d |4ankh:ankhs;."] = "",
--	["Reincarnation is ready!"] = "",

--	["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "",
--	["Notify when ready"] = "",
--	["Show a notification message when Reincarnation's cooldown finishes."] = "",
--	["Notify when restocking"] = "",
--	["Show a notification message when automatically buying ankhs."] = "",
--	["Restock quantity"] = "",
--	["Buy ankhs up to a total of this number when you interact with a vendor."] = "",
--	["Warning quantity"] = "",
--	["Show a warning when you have fewer than this number of ankhs."] = "",
--	["Set to 0 to disable this feature."] = "",

--	["Show monitor"] = "",
--	["Show a small movable window to track your Reincarnation cooldown."] = "",
--	["Lock monitor"] = "",
--	["Lock the monitor window in place to prevent it from being moved."] = "",
--	["Monitor scale"] = "",
--	["Adjust the size of the monitor window."] = "",

--	["Right-click for options."] = "",

} return end

--[[--------------------------------------------------------------------
	Simplified Chinese / 简体中文
	Last updated: YYYY-MM-DD by UNKNOWN
----------------------------------------------------------------------]]

if GAME_LOCALE == "zhCN" then ns.L = {

	["Ankh"] = "十字章",

--	["Ankhs"] = "",
--	["Cooldown"] = "",
--	["Ready"] = "",
--	["Last Reincarnated"] = "",
	["Today at %I:%M %p"] = "今天%p%A時%M分", -- See: http://www.lua.org/pil/22.1.html
	["Yesterday at %I:%M %p"] = "昨天%p%A時%M分",
	["%I:%M %p on %A, %B %d, %Y"] = "%A%Y年%m月%d日在%p%I時%M分",

--	["You only have %d |4ankh:ankhs; left. Don't forget to restock!"] = "",
--	["Purchased %d |4ankh:ankhs;."] = "",
--	["Reincarnation is ready!"] = "",

--	["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "",
--	["Notify when ready"] = "",
--	["Show a notification message when Reincarnation's cooldown finishes."] = "",
--	["Notify when restocking"] = "",
--	["Show a notification message when automatically buying ankhs."] = "",
--	["Restock quantity"] = "",
--	["Buy ankhs up to a total of this number when you interact with a vendor."] = "",
--	["Warning quantity"] = "",
--	["Show a warning when you have fewer than this number of ankhs."] = "",
--	["Set to 0 to disable this feature."] = "",

--	["Show monitor"] = "",
--	["Show a small movable window to track your Reincarnation cooldown."] = "",
--	["Lock monitor"] = "",
--	["Lock the monitor window in place to prevent it from being moved."] = "",
--	["Monitor scale"] = "",
--	["Adjust the size of the monitor window."] = "",

--	["Right-click for options."] = "",

} return end

--[[--------------------------------------------------------------------
	Traditional Chinese / 正體中文
	Last updated: YYYY-MM-DD by UNKNOWN
----------------------------------------------------------------------]]

if GAME_LOCALE == "zhTW" then ns.L = {

	["Ankh"] = "十字章",

--	["Ankhs"] = "",
--	["Cooldown"] = "",
--	["Ready"] = "",
--	["Last Reincarnated"] = "",
	["Today at %I:%M %p"] = "今天%p%I时%M分", -- See: http://www.lua.org/pil/22.1.html
	["Yesterday at %I:%M %p"] = "昨天%p%I时%M分",
	["%I:%M %p on %A, %B %d, %Y"] = "%A%Y年%m月%d日在%p%I时%M分",

--	["You only have %d |4ankh:ankhs; left. Don't forget to restock!"] = "",
--	["Purchased %d |4ankh:ankhs;."] = "",
--	["Reincarnation is ready!"] = "",

--	["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "",
--	["Notify when ready"] = "",
--	["Show a notification message when Reincarnation's cooldown finishes."] = "",
--	["Notify when restocking"] = "",
--	["Show a notification message when automatically buying ankhs."] = "",
--	["Restock quantity"] = "",
--	["Buy ankhs up to a total of this number when you interact with a vendor."] = "",
--	["Warning quantity"] = "",
--	["Show a warning when you have fewer than this number of ankhs."] = "",
--	["Set to 0 to disable this feature."] = "",

--	["Show monitor"] = "",
--	["Show a small movable window to track your Reincarnation cooldown."] = "",
--	["Lock monitor"] = "",
--	["Lock the monitor window in place to prevent it from being moved."] = "",
--	["Monitor scale"] = "",
--	["Adjust the size of the monitor window."] = "",

--	["Right-click for options."] = "",

} return end

------------------------------------------------------------------------