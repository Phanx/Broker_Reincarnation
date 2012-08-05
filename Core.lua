--[[--------------------------------------------------------------------
	AnkhUp
	Reincarnation cooldown monitor for shamans.
	Copyright (c) 2006–2012 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info6330-AnkhUp.html
	http://www.curse.com/addons/wow/ankhup
----------------------------------------------------------------------]]

local ADDON_NAME, ns = ...

if select(2, UnitClass("player")) ~= "SHAMAN" then
	return DisableAddOn(ADDON_NAME)
end

------------------------------------------------------------------------

local L = setmetatable({
	["Reincarnation"] = GetSpellInfo(20608)
}, { __index = function(t, k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end })

do
	local LOCALE = GetLocale()
	-- See http://www.lua.org/pil/22.1.html for date/time format info.

	if LOCALE == "deDE" then
		-- Last updated 2009-10-24 by Gyffes <www.ihl-gilneas.de>
		L["Ready"] = "Bereit"
		L["Last Reincarnation:"] = "Letzte Reinkarnation:"
		L["Today at %I:%M %p"] = "Heute um %H.%M Uhr"
		L["Yesterday at %I:%M %p"] = "Gestern um %H.%M Uhr"
		L["%I:%M %p on %A, %B %d, %Y"] = "%A, %d. %B %Y um %H.%M Uhr"
		L["Total Reincarnations:"] = "Reinkarnationen insgesamt:"
		L["%%d since %B %d, %Y"] = "%%d seit %d. %B %Y"
		L["Reincarnation is ready!"] = "Reinkarnation wieder Verfügbar!"
		L["Right-click for options."] = "Rechtsklick für Optionen."
		L["Notify when ready"] = "Melde wenn Bereit"
		L["Reset statistics"] = "Statistiken löschen"

	elseif LOCALE == "esES" or LOCALE == "esMX" then
		L["Ready"] = "Lista"
		L["Last Reincarnation:"] = "Última reencarnación:"
		L["Today at %I:%M %p"] = "Hoy a las %H.%M"
		L["Yesterday at %I:%M %p"] = "Ayer a las %H.%M"
		L["%I:%M %p on %A, %B %d, %Y"] = "%H.%M del %A, %d de %B de %Y"
		L["Total Reincarnations:"] = "Reencarnaciones totales:"
		L["%%d since %B %d, %Y"] = "%%d desde %d de %B de %Y"
		L["Reincarnation is ready!"] = "Reencarnación está lista!"
		L["Right-click for options."] = "Haz clic derecho para opciones."
		L["Notify when ready"] = "Notificar cuando lista"
		L["Reset statistics"] = "Eliminar estadísticas"

	elseif LOCALE == "frFR" then
		-- Last updated: 2009-04-25 by Itania @ WoWInterface
		L["Ready"] = "Disponible"
		L["Last Reincarnation:"] = "Dernière réincarnation:"
		L["Today at %I:%M %p"] = "Aujourd'hui à %H h %M"
		L["Yesterday at %I:%M %p"] = "Hier à %H h %M"
		L["%I:%M %p on %A, %B %d, %Y"] = "%A %d %B %Y à %H h %M"
		L["Total Reincarnations:"] = "Réincarnations totales:"
		L["%%d since %B %d, %Y"] = "%%d depuis %d %B %Y"
		L["Reincarnation is ready!"] = "Réincarnation est disponible!"
		L["Right-click for options."] = "Clic droit pour options."
		L["Notify when ready"] = "Notifier quand disponible"
		L["Reset statistics"] = "Supprimer statistiques"

	elseif LOCALE == "itIT" then
		L["Ready"] = "Pronta"
		L["Last Reincarnation:"] = "Ultimo Reincarnato:"
		L["Today at %I:%M %p"] = "Oggi alle %H:%M"
		L["Yesterday at %I:%M %p"] = "Ieri alle %H:%M"
		L["%I:%M %p on %A, %B %d, %Y"] = "%H:%M il %A %d %B %Y"
		L["Total Reincarnations:"] = "Reincarnazioni totali:"
		L["%%d since %B %d, %Y"] = "%%d da %d %B %Y"
		L["Reincarnation is ready!"] = "Reincarnazione è pronta!"
		L["Right-click for options."] = "Pulsante destro per opzioni,"
		L["Notify when ready"] = "Notificare quando pronta"
		L["Reset statistics"] = "Eliminare statistiche"

	elseif LOCALE == "ptBR" then
		L["Ready"] = "Pronto"
		L["Last Reincarnation:"] = "Última reencarnação:"
		L["Today at %I:%M %p"] = "Hoje às %H:%M"
		L["Yesterday at %I:%M %p"] = "Ontem às %H:M"
		L["%I:%M %p on %A, %B %d, %Y"] = "%H:%M em %d de %B de %Y"
		L["Total Reincarnations:"] = "Reencarnações total:"
		L["%%d since %B %d, %Y"] = "%%d desde %d de %B de %Y"
		L["Reincarnation is ready!"] = "Reencarnação está pronto!"
		L["Right-click for options."] = "Botão direito para opções."
		L["Notify when ready"] = "Notificar quando pronto"
		L["Reset statistics"] = "Excluir estatísticas"

	elseif LOCALE == "ruRU" then
		L["Ready"] = "Доступно"
		L["Last Reincarnation:"] = "Последнее Перерождение"
		L["Today at %I:%M %p"] = "Сегодня в %I:%M %p"
		L["Yesterday at %I:%M %p"] = "Вчера в %I:%M %p"
		L["%I:%M %p on %A, %B %d, %Y"] = "%A, %d %B %Y в %I:%M %p"
		L["Total Reincarnations:"] = "Общий Перерождений"
		L["%%d since %B %d, %Y"] = "%dd поскольку %d %B %Y"
		L["Reincarnation is ready!"] = "Перерождение доступно!"
		L["Right-click for options."] = "Правый-Клик, чтобы открыть параметры."
		L["Notify when ready"] = "Уведомлять когда доступно"
		L["Reset statistics"] = "Убрать статистики"

	elseif LOCALE == "koKR" then
		L["Ready"] = "준비"
		L["Last Reincarnation:"] = "최근 윤회:"
		L["Today at %I:%M %p"] = "%H시 %M분에서 오늘"
		L["Yesterday at %I:%M %p"] = "%H시 %M분에서 어제"
		L["%I:%M %p on %A, %B %d, %Y"] = "%H시 %M분에서 %A %Y년 %m월 %d일"
		L["Total Reincarnations:"] = "총 윤회:"
		L["%%d since %B %d, %Y"] = "%Y년 %m월 %d일 부터 %dd"
		L["Reincarnation is ready!"] = "윤회 사용할 준비가!"
		L["Right-click for options."] = "옵션 메뉴을 열려면 오른쪽 버튼을 클릭하십시오."
		L["Notify when ready"] = "되면 알림 사용할"
		L["Reset statistics"] = "통계 삭제"

	elseif LOCALE == "zhCN" then
		-- Last updated: 2010-06-06 by 8区_冬泉谷_东方小瑞 <kztit at 163 com>
		L["Ready"] = "OK"
		L["Last Reincarnation:"] = "上次复生时间："
		L["Today at %I:%M %p"] = "今天%p%A時%M分"
		L["Yesterday at %I:%M %p"] = "昨天%p%A時%M分"
		L["%I:%M %p on %A, %B %d, %Y"] = "%A%Y年%m月%d日在%p%I時%M分"
		L["Total Reincarnations:"] = "总复生:"
		L["%%d since %B %d, %Y"] = "%%d自%Y年%m月%d日以来"
		L["Reincarnation is ready!"] = "复生是準備好了！"
		L["Right-click for options."] = "右键单击可以看到设置选项。"
		L["Notify when ready"] = "通知我当准备"
		L["Reset statistics"] = "删除统计"

	elseif LOCALE == "zhTW" then
		-- Last updated: 2011-03-09 by wowuicn @ CurseForge
		L["Ready"] = "就緒"
		L["Last Reincarnation:"] = "最後一次複生："
		L["Today at %I:%M %p"] = "今天%p%I时%M分"
		L["Yesterday at %I:%M %p"] = "昨天%p%I时%M分"
		L["%I:%M %p on %A, %B %d, %Y"] = "%A%Y年%m月%d日在%p%I时%M分"
		L["Total Reincarnations:"] = "總複生"
		L["%%d since %B %d, %Y"] = "%%d自%Y年%m月%d日以來"
		L["Reincarnation is ready!"] = "復生是準備好了！"
		L["Right-click for options."] = "右鍵單擊可以看到設置選項。"
		L["Notify when ready"] = "通知我當準備"
		L["Reset statistics"] = "刪除統計"

	end
end

------------------------------------------------------------------------

local ceil, format = ceil, format

local db
local cooldown, cooldownStartTime, resurrectionTime = 0, 0, 0

local COOLDOWN_MAX_TIME = 1800

local AnkhUp = CreateFrame("Frame")
ns.AnkhUp = AnkhUp

AnkhUp:SetScript("OnEvent", function(self, event, ...)
	return self[event] and self[event](self, ...)
end)

AnkhUp:RegisterEvent("ADDON_LOADED")

------------------------------------------------------------------------

function AnkhUp:Debug(lvl, str, ...)
	if lvl > 0 then return end
	if ... then
		if str:match("%%dfqsx%.%d") then
			str = format(str, ...)
		else
			str = join(", ", str, ...)
		end
	end
	print(format("|cffff7f7f[DEBUG] AnkhUp:|r %s", str))
end

function AnkhUp:Print(str, ...)
	if (...) then
		if str:match("%%dfqsx%.%d") then
			str = format(str, ...)
		else
			str = join(", ", ...)
		end
	end
	print(format("|cffffcc00AnkhUp:|r %s", str))
end

------------------------------------------------------------------------

local ABBR_DAY    =    DAY_ONELETTER_ABBR:gsub(" ", ""):lower()
local ABBR_HOUR   =   HOUR_ONELETTER_ABBR:gsub(" ", ""):lower()
local ABBR_MINUTE = MINUTE_ONELETTER_ABBR:gsub(" ", ""):lower()
local ABBR_SECOND = SECOND_ONELETTER_ABBR:gsub(" ", ""):lower()

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

function AnkhUp:UpdateText()
	if cooldown > 0 then
		local r, g, b = GetGradientColor(cooldown / COOLDOWN_MAX_TIME)
		self.dataObject.text = format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, GetAbbreviatedTime(cooldown))
	else
		self.dataObject.text = format("|cff33ff33%s|r", L["Ready"])
	end
end

------------------------------------------------------------------------

function AnkhUp:Reincarnate(start)
	cooldownStartTime = start
	db.last = time() - (GetTime() - start)
	db.total = db.total + 1
	if not db.first then
		db.first = db.last
	end
end

------------------------------------------------------------------------

local timerGroup = AnkhUp:CreateAnimationGroup()
local timer = timerGroup:CreateAnimation()
timer:SetOrder(1)
timer:SetDuration(0.25)
timerGroup:SetScript("OnFinished", function(self, requested)
	cooldown = cooldownStartTime + COOLDOWN_MAX_TIME - GetTime()
	AnkhUp:UpdateText()
	if cooldown <= 0 then
		if db.notify then
			local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)["SHAMAN"]
			UIErrorsFrame:AddMessage(L["Reincarnation is ready!"], color.r, color.g, color.b)
		end
		cooldown = 0
	else
		self:Play()
	end
end)

------------------------------------------------------------------------

function AnkhUp:ADDON_LOADED(addon)
	if addon ~= "AnkhUp" then return end
	self:Debug(1, "ADDON_LOADED", addon)

	local defaults = {
		notify = true,
		total = 0,
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

function AnkhUp:PLAYER_LOGIN()
	self:Debug(1, "PLAYER_LOGIN")

	self:SPELLS_CHANGED()

	if self.dataObject then
		self:UnregisterEvent("PLAYER_LOGIN")
		self.PLAYER_LOGIN = nil
	end
end

------------------------------------------------------------------------

function AnkhUp:PLAYER_ALIVE()
	self:Debug(1, "PLAYER_ALIVE")

	if UnitIsGhost("player") then
		return self:Debug(1, "UnitIsGhost player")
	end

	resurrectionTime = GetTime()
end

------------------------------------------------------------------------

function AnkhUp:SPELL_UPDATE_COOLDOWN()
	self:Debug(1, "SPELL_UPDATE_COOLDOWN")

	local now = GetTime()
	if now - resurrectionTime > 1 then return end
	self:Debug(1, "Player just resurrected.")

	local start, duration = GetSpellCooldown(L["Reincarnation"])
	if start and duration and start > 0 and duration > 0 then
		if now - start < 1 then
			self:Debug(1, "Player just used Reincarnation.")
			self:Reincarnate(start)
			timerGroup:Play()
		end
	end
end

------------------------------------------------------------------------

function AnkhUp:SPELLS_CHANGED()
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

	local menu = CreateFrame("Frame", "AnkhUpMenu", nil, "UIDropDownMenuTemplate")
	menu.displayMode = "MENU"

	menu.GetNotify = function() return db.nofity end
	menu.SetNotify = function() db.notify = not db.notify end

	menu.Reset = function() db.total, db.first, db.last = 0, nil, nil end

	menu.Close = function() CloseDropDownMenus() end

	menu.initialize = function(self, level)
		if not level or level > 1 then return end
		local info = UIDropDownMenu_CreateInfo()

		info.text = ADDON_NAME
		info.isTitle = 1
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info, level)

		info.text = L["Notify when ready"]
		info.checked = self.GetNotify
		info.func = self.SetNotify
		info.disabled = nil
		info.isNotRadio = true
		info.isTitle = nil
		info.keepShownOnClick = 1
		info.notCheckable = nil
		UIDropDownMenu_AddButton(info, level)

		info.text = L["Reset statistics"]
		info.func = self.Reset
		info.keepShownOnClick = nil
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info, level)

		info.text = CLOSE
		info.func = self.Close
		UIDropDownMenu_AddButton(info, level)
	end

	self.dataObject = LibStub("LibDataBroker-1.1"):NewDataObject(ADDON_NAME, {
		type  = "data source",
		icon  = [[Interface\ICONS\Spell_Shaman_ImprovedReincarnation]],
		label = L["Reincarnation"],
		text  = "Loading...",
		OnClick = function(self, button)
			if button == "RightButton" then
				ToggleDropDownMenu(1, nil, menu, self, 0, 0)
			end
		end,
		OnTooltipShow = function(tooltip)
			tooltip:AddLine(L["Reincarnation"], 1, 0.8, 0)
			if cooldown > 0 then
				local r, g, b = GetGradientColor(cooldown / COOLDOWN_MAX_TIME)
				tooltip:AddDoubleLine(COOLDOWN_REMAINING, GetAbbreviatedTime(cooldown), 1, 1, 1, r, g, b)
			else
				tooltip:AddLine(L["Ready"], 0.2, 1, 0.2)
			end

			local last = db.last
			if db.last then
				local h, m = GetGameTime()
				local today = time() - (h * 3600) - (m * 60)
				local yesterday = today - 86400

				local text
				if last > today then
					text = date(L["Today at %I:%M %p"], last)
				elseif last > yesterday then
					text = date(L["Yesterday at %I:%M %p"], last)
				else
					text = date(L["%I:%M %p on %A, %B %d, %Y"], last)
				end
				tooltip:AddLine(" ")
				tooltip:AddLine(L["Last Reincarnation:"], 1, 0.8, 0)
				tooltip:AddLine(gsub(gsub(text, "^0", ""), "([^:%d])0", "%1"), 1, 1, 1)

				if db.first and db.total > 1 then
					tooltip:AddLine(" ")
					tooltip:AddLine(L["Total Reincarnations:"], 1, 0.8, 0)
					tooltip:AddLine(format(date(L["%%d since %B %d, %Y"], db.first), db.total), 1, 1, 1)
				end
			end

			tooltip:AddLine(" ")
			tooltip:AddLine(L["Right-click for options."], 1, 0.8, 0)
		end,
	})

	self:RegisterEvent("PLAYER_ALIVE")
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")

	local start, duration = GetSpellCooldown(L["Reincarnation"])
	if start and duration and start > 0 and duration > 0 then
		self:Debug(1, "Reincarnation is on cooldown.")
		self:Reincarnate(start)
		timerGroup:Play()
	end

	self:Debug(1, "cooldown = %d", cooldown)

	self:UpdateText()
end

------------------------------------------------------------------------