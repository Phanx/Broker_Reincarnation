--[[--------------------------------------------------------------------
	Broker: Reincarnation
	Reincarnation cooldown monitor for shamans.
	Copyright (c) 2006-2014 Phanx <addons@phanx.net>. All rights reserved.
	http://www.wowinterface.com/downloads/info6330-BrokerReincarnation.html
	http://www.curse.com/addons/wow/broker-reincarnation
	https://github.com/Phanx/Broker_Reincarnation
----------------------------------------------------------------------]]

local ADDON_NAME, ns = ...

if select(2, UnitClass("player")) ~= "SHAMAN" then
	return DisableAddOn(ADDON_NAME)
end

------------------------------------------------------------------------

local L = {
	Reincarnation = GetSpellInfo(20608),
	Ready = "Ready",
	Last = "Last Reincarnation:",
	Today = "Today at %I:%M %p",
	Yesterday = "Yesterday at %I:%M %p",
	Date = "%I:%M %p on %A, %B %d, %Y",
	Total = "Total Reincarnations:",
	TotalSinceDate = "%%d since %B %d, %Y",
	ReadyMessage = "Reincarnation is ready!",
	RightClickOptions = "Right-click for options.",
	NotifyReady = "Notify when ready",
	Reset = "Reset statistics",
}

local LOCALE = GetLocale()
-- See http://www.lua.org/pil/22.1.html for date/time format info.
if LOCALE == "deDE" then
	-- Translators: Gyffes <www.ihl-gilneas.de>
	L.Ready = "Bereit"
	L.Last = "Letzte Reinkarnation:"
	L.Today = "Heute um %H.%M Uhr"
	L.Yesterday = "Gestern um %H.%M Uhr"
	L.Date = "%A, %d. %B %Y um %H.%M Uhr"
	L.Total = "Reinkarnationen insgesamt:"
	L.TotalSinceDate = "%%d seit %d. %B %Y"
	L.ReadyMessage = "Reinkarnation ist wieder bereit!"
	L.RightClickOptions = "Rechtsklick für Optionen."
	L.NotifyReady = "Melden, wenn bereit"
	L.Reset = "Statistiken löschen"

elseif strmatch(LOCALE, "^es") then
	L.Ready = "Lista"
	L.Last = "Última reencarnación:"
	L.Today = "Hoy a las %H.%M"
	L.Yesterday = "Ayer a las %H.%M"
	L.Date = "%H.%M del %A, %d de %B de %Y"
	L.Total = "Reencarnaciones totales:"
	L.TotalSinceDate = "%%d desde %d de %B de %Y"
	L.ReadyMessage = "Reencarnación está lista!"
	L.RightClickOptions = "Clic derecho para opciones."
	L.NotifyReady = "Notificar cuando lista"
	L.Reset = "Eliminar estadísticas"

elseif LOCALE == "frFR" then
	-- Translators: Itania
	L.Ready = "Disponible"
	L.Last = "Dernière réincarnation:"
	L.Today = "Aujourd'hui à %H h %M"
	L.Yesterday = "Hier à %H h %M"
	L.Date = "%A %d %B %Y à %H h %M"
	L.Total = "Réincarnations totales:"
	L.TotalSinceDate = "%%d depuis %d %B %Y"
	L.ReadyMessage = "Réincarnation est disponible!"
	L.RightClickOptions = "Clic droit pour options."
	L.NotifyReady = "Notifier quand disponible"
	L.Reset = "Supprimer statistiques"

elseif LOCALE == "itIT" then
	L.Ready = "Pronta"
	L.Last = "Ultimo Reincarnato:"
	L.Today = "Oggi alle %H:%M"
	L.Yesterday = "Ieri alle %H:%M"
	L.Date = "%H:%M il %A %d %B %Y"
	L.Total = "Reincarnazioni totali:"
	L.TotalSinceDate = "%%d da %d %B %Y"
	L.ReadyMessage = "Reincarnazione è pronta!"
	L.RightClickOptions = "Pulsante destro per opzioni,"
	L.NotifyReady = "Notificare quando pronta"
	L.Reset = "Eliminare statistiche"

elseif strmatch(LOCALE, "^pt") then
	L.Ready = "Pronto"
	L.Last = "Última reencarnação:"
	L.Today = "Hoje às %H:%M"
	L.Yesterday = "Ontem às %H:M"
	L.Date = "%H:%M em %d de %B de %Y"
	L.Total = "Reencarnações total:"
	L.TotalSinceDate = "%%d desde %d de %B de %Y"
	L.ReadyMessage = "Reencarnação está pronto!"
	L.RightClickOptions = "Botão direito para opções."
	L.NotifyReady = "Notificar quando pronto"
	L.Reset = "Excluir estatísticas"

elseif LOCALE == "ruRU" then
	L.Ready = "Доступно"
	L.Last = "Последнее Перерождение"
	L.Today = "Сегодня в %I:%M %p"
	L.Yesterday = "Вчера в %I:%M %p"
	L.Date = "%A, %d %B %Y в %I:%M %p"
	L.Total = "Общий Перерождений"
	L.TotalSinceDate = "%dd поскольку %d %B %Y"
	L.ReadyMessage = "Перерождение доступно!"
	L.RightClickOptions = "Правый-Клик, чтобы открыть параметры."
	L.NotifyReady = "Уведомлять когда доступно"
	L.Reset = "Убрать статистики"

elseif LOCALE == "koKR" then
	L.Ready = "준비"
	L.Last = "최근 윤회:"
	L.Today = "%H시 %M분에서 오늘"
	L.Yesterday = "%H시 %M분에서 어제"
	L.Date = "%H시 %M분에서 %A %Y년 %m월 %d일"
	L.Total = "총 윤회:"
	L.TotalSinceDate = "%Y년 %m월 %d일 부터 %dd"
	L.ReadyMessage = "윤회 사용할 준비가!"
	L.RightClickOptions = "옵션 메뉴을 열려면 오른쪽 버튼을 클릭하십시오."
	L.NotifyReady = "되면 알림 사용할"
	L.Reset = "통계 삭제"

elseif LOCALE == "zhCN" then
	-- Translators: 8区_冬泉谷_东方小瑞 <kztit at 163 com>
	L.Ready = "OK"
	L.Last = "上次复生时间："
	L.Today = "今天%p%A時%M分"
	L.Yesterday = "昨天%p%A時%M分"
	L.Date = "%A%Y年%m月%d日在%p%I時%M分"
	L.Total = "总复生:"
	L.TotalSinceDate = "%%d自%Y年%m月%d日以来"
	L.ReadyMessage = "复生是準備好了！"
	L.RightClickOptions = "右键单击可以看到设置选项。"
	L.NotifyReady = "通知我当准备"
	L.Reset = "删除统计"

elseif LOCALE == "zhTW" then
	-- Translators: wowuicn
	L.Ready = "就緒"
	L.Last = "最後一次複生："
	L.Today = "今天%p%I时%M分"
	L.Yesterday = "昨天%p%I时%M分"
	L.Date = "%A%Y年%m月%d日在%p%I时%M分"
	L.Total = "總複生"
	L.TotalSinceDate = "%%d自%Y年%m月%d日以來"
	L.ReadyMessage = "復生是準備好了！"
	L.RightClickOptions = "右鍵單擊可以看到設置選項。"
	L.NotifyReady = "通知我當準備"
	L.Reset = "刪除統計"
end
LOCALE = nil

------------------------------------------------------------------------

local ceil, format, print, strfind, strjoin = ceil, format, print, strfind, strjoin

local db
local cooldown, cooldownStartTime, resurrectionTime = 0, 0, 0

local COOLDOWN_MAX_TIME = 1800

local Addon = CreateFrame("Frame")
Addon:SetScript("OnEvent", function(self, event, ...) return self[event] and self[event](self, ...) end)
Addon:RegisterEvent("ADDON_LOADED")

------------------------------------------------------------------------

function Addon:Debug(lvl, str, ...)
	if lvl <= 0 then
		if ... then
			if strfind(str, "%%[dfqsx%.%d]") then
				str = format(str, ...)
			else
				str = strjoin(", ", str, ...)
			end
		end
		print("|cffff7f7f[DEBUG] Broker Reincarnation:|r", str)
	end
end

function Addon:Print(str, ...)
	if (...) then
		if strfind(str, "%%[dfqsx%.%d]") then
			str = format(str, ...)
		else
			str = strjoin(", ", ...)
		end
	end
	print("|cffffcc00Broker Reincarnation:|r %s", str)
end

------------------------------------------------------------------------

local ABBR_DAY = strlower(gsub(DAY_ONELETTER_ABBR, " ", ""))
local ABBR_HOUR = strlower(gsub(HOUR_ONELETTER_ABBR, " ", ""))
local ABBR_MINUTE = strlower(gsub(MINUTE_ONELETTER_ABBR, " ", ""))
local ABBR_SECOND = strlower(gsub(SECOND_ONELETTER_ABBR, " ", ""))

local function GetAbbreviatedTime(seconds)
	if seconds >= 86400 then
		return format(ABBR_DAY, ceil(seconds / 86400))
	elseif seconds >= 3600 then
		return format(ABBR_HOUR, ceil(seconds / 3600))
	elseif seconds >= 60 then
		return format(ABBR_MINUTE, ceil(seconds / 60))
	end
	return format(ABBR_SECOND, seconds)
end

------------------------------------------------------------------------

local function GetGradientColor(percent)
	local r1, g1, b1, r2, g2, b2
	if percent <= 0.5 then
		percent = percent * 2
		r1, g1, b1 = 0.2, 1, 0.2
		r2, g2, b2 = 1, 1, 0.2
	else
		percent = percent * 2 - 1
		r1, g1, b1 = 1, 1, 0.2
		r2, g2, b2 = 1, 0.2, 0.2
	end
	return r1 + (r2 - r1) * percent, g1 + (g2 - g1) * percent, b1 + (b2 - b1) * percent
end

------------------------------------------------------------------------

function Addon:UpdateText()
	if cooldown > 0 then
		local r, g, b = GetGradientColor(cooldown / COOLDOWN_MAX_TIME)
		self.dataObject.text = format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, GetAbbreviatedTime(cooldown))
	else
		self.dataObject.text = format("|cff33ff33%s|r", L.Ready)
	end
end

------------------------------------------------------------------------

local timer = Addon:CreateAnimationGroup()
timer.animation = timer:CreateAnimation()
timer.animation:SetDuration(0.25)
timer:SetScript("OnFinished", function(self, requested)
	cooldown = cooldownStartTime + COOLDOWN_MAX_TIME - GetTime()
	Addon:UpdateText()
	if cooldown <= 0 then
		if db.notify then
			local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)["SHAMAN"]
			UIErrorsFrame:AddMessage(L.ReadyMessage, color.r, color.g, color.b)
		end
		cooldown = 0
	else
		self:Play()
	end
end)

------------------------------------------------------------------------

function Addon:Reincarnate(start)
	cooldownStartTime = start
	db.last = time() - (GetTime() - start)
	db.first = db.first or db.last
	db.total = 1 + (db.total or 0)
	timer:Play()
end

------------------------------------------------------------------------

function Addon:ADDON_LOADED(addon)
	if addon ~= ADDON_NAME then return end
	self:Debug(1, "ADDON_LOADED", addon)

	local defaults = {
		notify = true,
	}
	if not AnkhUpDB then
		AnkhUpDB = defaults
		db = AnkhUpDB
	else
		db = AnkhUpDB
		for k, v in pairs(defaults) do
			if type(db[k]) ~= type(v) then
				db[k] = v
			end
		end
	end

	self:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil

	if IsLoggedIn() then
		self:PLAYER_LOGIN()
	else
		self:RegisterEvent("PLAYER_LOGIN")
	end
end

------------------------------------------------------------------------

function Addon:PLAYER_LOGIN()
	self:Debug(1, "PLAYER_LOGIN")

	self:UnregisterEvent("PLAYER_LOGIN")
	self.PLAYER_LOGIN = nil

	self:SPELLS_CHANGED()
	if not self.dataObject then
		self:RegisterEvent("SPELLS_CHANGED")
	end
end

------------------------------------------------------------------------

function Addon:PLAYER_ALIVE()
	self:Debug(1, "PLAYER_ALIVE")

	if UnitIsGhost("player") then
		return self:Debug(1, "UnitIsGhost player")
	end

	resurrectionTime = GetTime()
end

------------------------------------------------------------------------

function Addon:SPELL_UPDATE_COOLDOWN()
	self:Debug(1, "SPELL_UPDATE_COOLDOWN")

	local now = GetTime()
	if now - resurrectionTime > 1 then return end
	self:Debug(1, "Player just resurrected.")

	local start, duration = GetSpellCooldown(L.Reincarnation)
	if start and duration and start > 0 and duration > 0 then
		if now - start < 1 then
			self:Debug(1, "Player just used Reincarnation.")
			self:Reincarnate(start)
			timer:Play()
		end
	end
end

------------------------------------------------------------------------

function Addon:SPELLS_CHANGED()
	self:Debug(1, "SPELLS_CHANGED")

	if not IsSpellKnown(20608) then
		self:Debug(1, "Reincarnation not learned yet.")
		return
	end

	self:UnregisterEvent("SPELLS_CHANGED")

	if self.dataObject then
		self:Debug(1, "Data object already created.")
		return
	end

	local menu = CreateFrame("Frame", "BrokerReincarnationMenu", UIParent, "UIDropDownMenuTemplate")
	menu.displayMode = "MENU"

	menu.GetNotify = function() return db.nofity end
	menu.SetNotify = function() db.notify = not db.notify end

	menu.Reset = function() db.total, db.first, db.last = nil, nil, nil end
	menu.Close = function() CloseDropDownMenus() end

	menu.initialize = function(self, level)
		if not level or level > 1 then return end

		local info = UIDropDownMenu_CreateInfo()
		info.text = ADDON_NAME
		info.isTitle = 1
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info, level)

		info = UIDropDownMenu_CreateInfo()
		info.text = L.NotifyReady
		info.checked = self.GetNotify
		info.func = self.SetNotify
		info.isNotRadio = true
		info.keepShownOnClick = 1
		UIDropDownMenu_AddButton(info, level)

		info = UIDropDownMenu_CreateInfo()
		info.text = L.Reset
		info.func = self.Reset
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info, level)

		info = UIDropDownMenu_CreateInfo()
		info.text = CLOSE
		info.func = self.Close
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info, level)
	end

	local function CleanDate(...)
		local text = date(...)
		text = gsub(text, "^0", "")
		text = gsub(text, "([^:%d])0", "%1")
		return text
	end

	self.dataObject = LibStub("LibDataBroker-1.1"):NewDataObject(ADDON_NAME, {
		type  = "data source",
		icon  = [[Interface\ICONS\Spell_Shaman_ImprovedReincarnation]],
		label = L.Reincarnation,
		text  = L.Ready,
		OnClick = function(self, button)
			if button == "RightButton" then
				ToggleDropDownMenu(1, nil, menu, self, 0, 0)
			end
		end,
		OnTooltipShow = function(tooltip)
			--tooltip:AddLine(L.Reincarnation, 1, 0.82, 0)
			if cooldown > 0 then
				local r, g, b = GetGradientColor(cooldown / COOLDOWN_MAX_TIME)
				tooltip:AddDoubleLine(L.Reincarnation, GetAbbreviatedTime(cooldown), nil, nil, nil, r, g, b)
				--tooltip:AddDoubleLine(COOLDOWN_REMAINING, GetAbbreviatedTime(cooldown), 1, 1, 1, r, g, b)
			else
				tooltip:AddDoubleLine(L.Reincarnation, L.Ready, nil, nil, nil, 0.2, 1, 0.2)
				--tooltip:AddLine(L.Ready, 0.2, 1, 0.2)
			end

			local last = db.last
			if db.last then
				local h, m = GetGameTime()
				local today = time() - (h * 3600) - (m * 60)
				local yesterday = today - 86400

				local text
				if last > today then
					text = CleanDate(L.Today, last)
				elseif last > yesterday then
					text = CleanDate(L.Yesterday, last)
				else
					text = CleanDate(L.Date, last)
				end
				tooltip:AddLine(" ")
				tooltip:AddLine(L.Last, 1, 0.8, 0)
				tooltip:AddDoubleLine(" ", text, nil, nil, nil, 1, 1, 1)

				if db.first and db.total and db.total > 1 then
					tooltip:AddLine(" ")
					tooltip:AddLine(L.Total, 1, 0.8, 0)
					tooltip:AddDoubleLine(" ", format(CleanDate(L.TotalSinceDate, db.first), db.total), nil, nil, nil, 1, 1, 1)
				end
			end

			tooltip:AddLine(" ")
			tooltip:AddLine(L.RightClickOptions, 1, 0.8, 0)
		end,
	})

	self:RegisterEvent("PLAYER_ALIVE")
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")

	local start, duration = GetSpellCooldown(L.Reincarnation)
	if start and duration and start > 0 and duration > 0 then
		self:Debug(1, "Reincarnation is on cooldown.")
		cooldownStartTime = start
		timer:Play()
	end

	self:Debug(1, "cooldown = %d", cooldown)

	self:UpdateText()
end

------------------------------------------------------------------------