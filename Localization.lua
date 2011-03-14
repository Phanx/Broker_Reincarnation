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

local _, ns = ...
local GAME_LOCALE = GetLocale()

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
	["Background color"] = "Hintergrundfarbe",
	["Change the monitor window's background color."] = "Anpassen der Hintergrundfarbe.",
	["Border color"] = "Rahmenfarbe",
	["Change the monitor window's border color."] = "Anpassen der Rahmenfarbe.",

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

	["You only have %d |4ankh:ankhs; left. Don't forget to restock!"] = "Tienes sólo %s ankhs. No olvide de comprar más!",
	["Purchased %d |4ankh:ankhs;."] = "Compró %d |4ankh:ankhs;.",
	["Reincarnation is ready!"] = "Reencarnación está listo!",

	["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "Este accesorio sigue el tiempo de reutilización de tu hechizo Reencarnación, y ayuda a administrar tus ankhs. Utilice estas opciones para configurarlo.",
	["Notify when ready"] = "Notificar de listo",
	["Show a notification message when Reincarnation's cooldown finishes."] = "Notificar cuando termine el tiempo de reutilización de tu hechizo Reencarnación.",
	["Notify when restocking"] = "Notificar de compras",
	["Show a notification message when automatically buying ankhs."] = "Notificar cuando auto-comprar más ankhs.",
	["Restock quantity"] = "Cantidad a comprar",
	["Buy ankhs up to a total of this number when you interact with a vendor."] = "Comprar ankhs hasta un total de esta cantidad cuando hablas con un vendedor.",
	["Warning quantity"] = "Cantidad a avisar",
	["Show a warning when you have fewer than this number of ankhs."] = "Mostrar una advertencia cuando tienes menos de esta cantidad de ankhs.",
	["Set to 0 to disable this feature."] = "Establece en 0 para desactivar esta función.",

	["Show monitor"] = "Mostrar ventana",
	["Show a small movable window to track your Reincarnation cooldown."] = "Mostrar una pequeña ventana móvil para seguir el tiempo de reutilización de tu hechizo Reencarnación.",
	["Lock monitor"] = "Bloquear ventana",
	["Lock the monitor window in place to prevent it from being moved."] = "Bloquear la ventana para que no puedes moverlo.",
	["Monitor scale"] = "Tamaño de ventana",
	["Adjust the size of the monitor window."] = "Cambiar el tamaño de la ventana.",
	["Background color"] = "Color de fondo",
	["Change the monitor window's background color."] = "Cambiar el color del fondo de la ventana.",
	["Border color"] = "Color de borde",
	["Change the monitor window's border color."] = "Cambiar el color del borde de la ventana.",

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
	["Show a notification message when Reincarnation's cooldown finishes."] = "Active la notification lors Réincarnation devient disponible.",
	["Notify when restocking"] = "Notifier lors d'un rachat",
	["Show a notification message when automatically buying ankhs."] = "Active la notification lors du rachat d'ankhs.",
	["Restock quantity"] = "Rachat d'ankhs",
	["Buy ankhs up to a total of this number when you interact with a vendor."] = "Rachète des Ankhs jusqu'à ce nombre lors d'une interaction avec un vendeur.",
	["Warning quantity"] = "Alerte ankhs",
	["Show a warning when you have fewer than this number of ankhs."] = "Affiche un message d'alerte lorsque vous avez moins que ce nombre d'ankhs.",
	["Set to 0 to disable this feature."] = "Mettre à 0 pour désactiver.",

	["Show monitor"] = "Afficher moniteur",
	["Show a small movable window to track your Reincarnation cooldown."] = "Affiche une petite fenêtre de contrôle déplaçable pour le temps de recharge de Réincarnation.",
	["Lock monitor"] = "Immobiliser le moniteur",
	["Lock the monitor window in place to prevent it from being moved."] = "Immobilise le moniteur afin qu'elle ne peut pas être déplacée.",
	["Monitor scale"] = "Échelle d'moniteur",
	["Adjust the size of the monitor window."] = "Règle l'échelle du moniteur.",
	["Background color"] = "Arrière-plan",
	["Change the monitor window's background color."] = "Modifie la couleur de l'arrière-plan du moniteur.",
	["Border color"] = "Bordure",
	["Change the monitor window's border color."] = "Modifie la couleur de la bordure du moniteur.",

	["Right-click for options."] = "Clic droit pour afficher la fenêtre d'options.",

} return end

--[[--------------------------------------------------------------------
	Russian / Русский
	Last updated: 2011-03-09 by Akkorian
----------------------------------------------------------------------]]

if GAME_LOCALE == "ruRU" then ns.L = {

	["Ankh"] = "Крест",

	["Ankhs"] = "Крестов",
	["Cooldown"] = "Восстановление",
	["Ready"] = "Готов",
	["Last Reincarnated"] = "Последнее Перерождение",
	["Today at %I:%M %p"] = "Сегодня в %I:%M %p",
	["Yesterday at %I:%M %p"] = "Вчера в %I:%M %p",
	["%I:%M %p on %A, %B %d, %Y"] = "%A %d %B %Y в %I:%M %p",

	["You only have %d |4ankh:ankhs; left. Don't forget to restock!"] = "Только %d |4крест:кресты; остаются в инвентаре. Не забудьте купить больше!",
	["Purchased %d |4ankh:ankhs;."] = "Купил %s |4крест:крестов;.",
	["Reincarnation is ready!"] = "Перерождение готов!",

	["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "Позволяет управлять вариантов мониторинга восстановления Перерождение и управления кресты.",
	["Notify when ready"] = "Уведомл. о готова",
	["Show a notification message when Reincarnation's cooldown finishes."] = "Уведомление, когда восстановление Перерождения отделки.",
	["Notify when restocking"] = "Уведомл. о закупает",
	["Show a notification message when automatically buying ankhs."] = "Уведомление, когда автоматически покупке кресты.",
	["Restock quantity"] = "Количество купить",
	["Buy ankhs up to a total of this number when you interact with a vendor."] = "Купить до этого количество крестов, когда вы говорите с купцом.",
	["Warning quantity"] = "Низкое количество",
	["Show a warning when you have fewer than this number of ankhs."] = "Уведомление, когда менее чем это количество крестов остаются в инвентаре.",
	["Set to 0 to disable this feature."] = "Установите к 0, чтобы отключить функцию.",

	["Show monitor"] = "Показать окно",
	["Show a small movable window to track your Reincarnation cooldown."] = "Показать небольшое окно следить за восстановление Перерождение.",
	["Lock monitor"] = "Зафиксировать окно",
	["Lock the monitor window in place to prevent it from being moved."] = "Не разрешайте перемещения окна.",
	["Monitor scale"] = "Масштаб окна",
	["Adjust the size of the monitor window."] = "Изменение масштаба окна.",
	["Background color"] = "Цвет фона",
	["Change the monitor window's background color."] = "Изменение цвета фона окна.",
	["Border color"] = "Цвет границы",
	["Change the monitor window's border color."] = "Изменение цвета границы окна.",

	["Right-click for options."] = "Правый-Клик, чтобы открыть окно настроек.",

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
	["Background color"] = "배경 색상",
	["Change the monitor window's background color."] = "배경의 색상을 조정합니다.",
	["Border color"] = "테두리 색상",
	["Change the monitor window's border color."] = "테두리의 색상을 조정합니다.",

	["Right-click for options."] = "옵션 메뉴을 열려면 오른쪽 버튼을 클릭하십시오.",

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
	["Background color"] = "背景颜色",
	["Change the monitor window's background color."] = "调整背景颜色。",
	["Border color"] = "外框颜色",
	["Change the monitor window's border color."] = "调整外框的颜色。",

	["Right-click for options."] = "右键单击可以看到设置选项。",

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
	["Background color"] = "背景顏色",
	["Change the monitor window's background color."] = "調整背景顏色。",
	["Border color"] = "邊框顏色",
	["Change the monitor window's border color."] = "調整邊框顏色。",

	["Right-click for options."] = "右鍵單擊可以看到設置選項。",

} return end

------------------------------------------------------------------------