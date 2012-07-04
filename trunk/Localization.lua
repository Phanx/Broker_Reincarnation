--[[--------------------------------------------------------------------
	AnkhUp
	Reincarnation cooldown monitor for shamans.
	Copyright (c) 2006–2012 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info6330-AnkhUp.html
	http://www.curse.com/addons/wow/ankhup
----------------------------------------------------------------------]]

if select(2, UnitClass("player")) ~= "SHAMAN" then
	return
end

local GAME_LOCALE = GetLocale()
if GAME_LOCALE:match("^en") then return end

local _, ns = ...

--[[--------------------------------------------------------------------
	German / Deutsch
	Last updated 2009-10-24 by Gyffes <www.ihl-gilneas.de>
----------------------------------------------------------------------]]

if GAME_LOCALE == "deDE" then ns.L = {
	["Cooldown"] = "Cooldown",
	["Ready"] = "Bereit",
	["Last Reincarnated"] = "Letzte Reinkarnation",
	["Today at %I:%M %p"] = "Heute um %H.%M Uhr", -- See: http://www.lua.org/pil/22.1.html
	["Yesterday at %I:%M %p"] = "Gestern um %H.%M Uhr",
	["%I:%M %p on %A, %B %d, %Y"] = "%A, %d. %B, %Y um %H.%M Uhr",
	["Right-click for options."] = "Rechtsklick für Optionen",

	["Reincarnation is ready!"] = "Reinkarnation wieder Verfügbar!",

	["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "In diesem Menü können Sie AnkhUp einstellen.",
	["Notify when ready"] = "Melde wenn Bereit",
	["Show a notification message when Reincarnation's cooldown finishes."] = "Benachrichtigt dich wenn die Reinkarnation wieder bereit ist.",
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
} return end

--[[--------------------------------------------------------------------
	Spanish / Español (EU) + Latin American Spanish / Español (AL)
	Last updated: 2011-03-02 by Akkorian
----------------------------------------------------------------------]]

if GAME_LOCALE == "esES" or GAME_LOCALE == "esMX" then ns.L = {
	["Cooldown"] = "Tiempo de reutilización",
	["Ready"] = "Listo",
	["Last Reincarnated"] = "Última reencarnación",
	["Today at %I:%M %p"] = "Hoy a las %H.%M", -- See: http://www.lua.org/pil/22.1.html
	["Yesterday at %I:%M %p"] = "Ayer a las %H.%M",
	["%I:%M %p on %A, %B %d, %Y"] = "%H.%M del %A, %d de %B de %Y",
	["Right-click for options."] = "Haz clic derecho para opciones.",

	["Reincarnation is ready!"] = "Reencarnación está listo!",

	["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "Este accesorio sigue el tiempo de reutilización de tu hechizo Reencarnación, y ayuda a administrar tus ankhs. Utilice estas opciones para configurarlo.",
	["Notify when ready"] = "Notificar de listo",
	["Show a notification message when Reincarnation's cooldown finishes."] = "Notificar cuando termine el tiempo de reutilización de tu hechizo Reencarnación.",
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
} return end

--[[--------------------------------------------------------------------
	French / Français
	Last updated: 2009-04-25 by Itania @ WoWInterface
----------------------------------------------------------------------]]

if GAME_LOCALE == "frFR" then ns.L = {
	["Cooldown"] = "Recharge",
	["Ready"] = "Disponible",
	["Last Reincarnated"] = "Dernière réincarnation",
	["Today at %I:%M %p"] = "Aujourd'hui à %H h %M", -- See: http://www.lua.org/pil/22.1.html
	["Yesterday at %I:%M %p"] = "Hier à %H h %M",
	["%I:%M %p on %A, %B %d, %Y"] = "%A %d %B %Y à %H h %M",
	["Right-click for options."] = "Clic droit pour afficher la fenêtre d'options.",

	["Reincarnation is ready!"] = "Réincarnation est disponible!",

	["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "Cette fenêtre vous permet de configurer les options pour contrôler votre Réincarnation et gérer vos Ankhs",
	["Notify when ready"] = "Notifier quand disponible",
	["Show a notification message when Reincarnation's cooldown finishes."] = "Active la notification lors Réincarnation devient disponible.",
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
} return end

--[[--------------------------------------------------------------------
	Russian / Русский
	Last updated: 2011-03-09 by Akkorian
----------------------------------------------------------------------]]

if GAME_LOCALE == "ruRU" then ns.L = {
	["Cooldown"] = "Восстановление",
	["Ready"] = "Готов",
	["Last Reincarnated"] = "Последнее Перерождение",
	["Today at %I:%M %p"] = "Сегодня в %I:%M %p", -- See: http://www.lua.org/pil/22.1.html
	["Yesterday at %I:%M %p"] = "Вчера в %I:%M %p",
	["%I:%M %p on %A, %B %d, %Y"] = "%A %d %B %Y в %I:%M %p",
	["Right-click for options."] = "Правый-Клик, чтобы открыть окно настроек.",

	["Reincarnation is ready!"] = "Перерождение готов!",

	["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "Позволяет управлять вариантов мониторинга восстановления Перерождение и управления кресты.",
	["Notify when ready"] = "Уведомл. о готова",
	["Show a notification message when Reincarnation's cooldown finishes."] = "Уведомление, когда восстановление Перерождения отделки.",
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
} return end

--[[--------------------------------------------------------------------
	Korean / 한국어
	Last updated: YYYY-MM-DD by UNKNOWN
----------------------------------------------------------------------]]

if GAME_LOCALE == "koKR" then ns.L = {
--	["Cooldown"] = "",
--	["Ready"] = "",
--	["Last Reincarnated"] = "",
	["Today at %I:%M %p"] = "%H시 %M분에서 오늘", -- See: http://www.lua.org/pil/22.1.html
	["Yesterday at %I:%M %p"] = "%H시 %M분에서 어제",
	["%I:%M %p on %A, %B %d, %Y"] = "%H시 %M분에서 %A %Y년 %m월 %d일",
	["Right-click for options."] = "옵션 메뉴을 열려면 오른쪽 버튼을 클릭하십시오.",

--	["Reincarnation is ready!"] = "",

--	["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "",
--	["Notify when ready"] = "",
--	["Show a notification message when Reincarnation's cooldown finishes."] = "",
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
} return end

--[[--------------------------------------------------------------------
	Simplified Chinese / 简体中文
	Last updated: 2010-06-06 by 8区_冬泉谷_东方小瑞 <kztit at 163 com>
----------------------------------------------------------------------]]

if GAME_LOCALE == "zhCN" then ns.L = {
	["Cooldown"] = "冷却：",
	["Ready"] = "OK",
	["Last Reincarnated"] = "上次复生时间：",
	["Today at %I:%M %p"] = "今天%p%A時%M分", -- See: http://www.lua.org/pil/22.1.html
	["Yesterday at %I:%M %p"] = "昨天%p%A時%M分",
	["%I:%M %p on %A, %B %d, %Y"] = "%A%Y年%m月%d日在%p%I時%M分",
	["Right-click for options."] = "右键单击可以看到设置选项。",

--	["Reincarnation is ready!"] = "",

--	["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "",
	["Notify when ready"] = "CD完成时通知",
	["Show a notification message when Reincarnation's cooldown finishes."] = "复生CD好后，在聊天框发出通知。",
	["Show monitor"] = "打开监视框",
	["Show a small movable window to track your Reincarnation cooldown."] = "可以查看冷却和复生情况。",
	["Lock monitor"] = "锁定监视框",
	["Lock the monitor window in place to prevent it from being moved."] = "这样就不会被拖动。",
	["Monitor scale"] = "监视框",
	["Adjust the size of the monitor window."] = "调整监视框大小。",
	["Background color"] = "背景颜色",
	["Change the monitor window's background color."] = "调整背景颜色。",
	["Border color"] = "外框颜色",
	["Change the monitor window's border color."] = "调整外框的颜色。",
} return end

--[[--------------------------------------------------------------------
	Traditional Chinese / 繁體中文
	Last updated: 2011-03-09 by wowuicn @ CurseForge
----------------------------------------------------------------------]]

if GAME_LOCALE == "zhTW" then ns.L = {
	["Cooldown"] = "冷卻",
	["Ready"] = "就緒",
	["Last Reincarnated"] = "最後一次複生",
	["Today at %I:%M %p"] = "今天%p%I时%M分", -- See: http://www.lua.org/pil/22.1.html
	["Yesterday at %I:%M %p"] = "昨天%p%I时%M分",
	["%I:%M %p on %A, %B %d, %Y"] = "%A%Y年%m月%d日在%p%I时%M分",
	["Right-click for options."] = "右鍵單擊可以看到設置選項。",

	["You only have %d |4ankh:ankhs; left. Don't forget to restock!"] = "你現在僅剩 %d |4十字章:十字章;. 不要忘記補購!",

	["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] = "這個面板允許你配置你的複生技能計時和管理你的十字章選項.",
	["Notify when ready"] = "當就緒時提醒",
	["Show a notification message when Reincarnation's cooldown finishes."] = "當複生技能冷卻顯示一條提醒消息.",
	["Show monitor"] = "顯示監視器",
	["Show a small movable window to track your Reincarnation cooldown."] = "顯示一個可移動的小窗體顯示你的複生技能的冷卻.",
	["Lock monitor"] = "鎖定監視器",
	["Lock the monitor window in place to prevent it from being moved."] = "鎖定監視器的當前位置.",
	["Monitor scale"] = "監視器縮放",
	["Adjust the size of the monitor window."] = "調整監視器的窗體大小.",
	["Background color"] = "背景顏色",
	["Change the monitor window's background color."] = "調整背景顏色。",
	["Border color"] = "邊框顏色",
	["Change the monitor window's border color."] = "調整邊框顏色。",
	["Set to 0 to disable this feature."] = "設定 0 為禁用這個功能",
} return end

------------------------------------------------------------------------