--[[--------------------------------------------------------------------
	AnkhUp
	Reincarnation cooldown monitor for shamans.
	Copyright (c) 2006–2012 Phanx <addons@phanx.net>.
	All rights reserved. See LICENSE.txt for details.
	http://www.wowinterface.com/downloads/info6330-AnkhUp.html
	http://www.curse.com/addons/wow/ankhup
----------------------------------------------------------------------]]

local ADDON_NAME, ns = ...

if select(2, UnitClass("player")) ~= "SHAMAN" then
	return DisableAddOn(ADDON_NAME)
end

local db
local cooldown, cooldownStartTime, resurrectionTime = 0, 0, 0

local COOLDOWN_MAX_TIME = 1800

------------------------------------------------------------------------

if not ns.L then
	ns.L = { }
end

local L = setmetatable(ns.L, { __index = function(t, k)
	local v = tostring(k)
	t[k] = v
	return v
end })

L["Reincarnation"] = GetSpellInfo(20608)

------------------------------------------------------------------------

local AnkhUp = CreateFrame("Frame")
ns.AnkhUp = AnkhUp

AnkhUp:SetScript("OnEvent", function(self, event, ...)
	return self[event] and self[event](self, ...)
end)

AnkhUp:RegisterEvent("ADDON_LOADED")

------------------------------------------------------------------------

function AnkhUp:Debug(lvl, str, ...)
	if lvl > 10 then return end
	if str:match("%%[ds%d%.]") then
		print("|cffffcc00[DEBUG] AnkhUp:|r", str:format(...))
	else
		print("|cffffcc00[DEBUG] AnkhUp:|r", str)
	end
end

function AnkhUp:Print(str, ...)
	if str:match("%%[ds%d%.]") then
		print("|cff00ddbaAnkhUp:|r", str:format(...))
	else
		print("|cff00ddbaAnkhUp:|r", str)
	end
end

------------------------------------------------------------------------

local ABBR_DAY    =    DAY_ONELETTER_ABBR:gsub(" ", ""):lower()
local ABBR_HOUR   =   HOUR_ONELETTER_ABBR:gsub(" ", ""):lower()
local ABBR_MINUTE = MINUTE_ONELETTER_ABBR:gsub(" ", ""):lower()
local ABBR_SECOND = SECOND_ONELETTER_ABBR:gsub(" ", ""):lower()

local function GetAbbreviatedTime(seconds)
	if seconds >= 86400 then
		return ABBR_DAY:format(ceil(seconds / 86400))
	elseif seconds >= 3600 then
		return ABBR_HOUR:format(ceil(seconds / 3600))
	elseif seconds >= 60 then
		return ABBR_MINUTE:format(ceil(seconds / 60))
	end
	return ABBR_SECOND:format(seconds)
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
		self.dataObject.text = ("|cff%02x%02x%02x%s|r"):format(r * 255, g * 255, b * 255, GetAbbreviatedTime(cooldown))
	else
		self.dataObject.text = ("|cff33ff33%s|r"):format(L["Ready"])
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
		if db.notifyWhenReady then
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

	if not AnkhUpDB then
		AnkhUpDB = { }
	end
	db = AnkhUpDB

	local defaults = {
		notifyWhenReady = true,
		frameShow = true,
		frameLock = false,
		frameScale = 1,
	}
	for k, v in pairs(defaults) do
		if type(db[k]) ~= type(v) then
			db[k] = v
		end
	end

	if IsLoggedIn() then
		self:PLAYER_LOGIN()
	else
		self:RegisterEvent("PLAYER_LOGIN")
	end
end

------------------------------------------------------------------------

function AnkhUp:PLAYER_LOGIN()
	self:Debug(1, "PLAYER_LOGIN")

	if not IsSpellKnown(20608) then
		self:Debug(1, "Reincarnation not learned yet.")
		self:RegisterEvent("SPELLS_CHANGED")
		self:RegisterEvent("SPELL_LEARNED_IN_TAB")
		return
	end

	self:SPELLS_CHANGED()

	self:UnregisterEvent("PLAYER_LOGIN")
	self.PLAYER_LOGIN = nil
end

------------------------------------------------------------------------

function AnkhUp:PLAYER_LOGOUT()
	for k, v in pairs(self.defaults) do
		if db[k] == v then
			db[k] = nil
		end
	end
end

------------------------------------------------------------------------

function AnkhUp:PLAYER_ALIVE()
	self:Debug(1, "PLAYER_ALIVE")

	if UnitIsGhost("player") then
		return
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
			cooldownStartTime = start
			db.lastReincarnation = time() - (GetTime() - start)
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
	self:UnregisterEvent("SPELL_LEARNED_IN_TAB")

	self.dataObject = self.dataObject or LibStub("LibDataBroker-1.1"):NewDataObject(ADDON_NAME, {
		type  = "data source",
		icon  = [[Interface\ICONS\Spell_Shaman_ImprovedReincarnation]],
		label = ADDON_NAME,
		text  = "Loading...",
		OnClick = function(self, button)
			if button == "RightButton" then
				SlashCmdList.ANKHUP()
			end
		end,
		OnTooltipShow = function(tooltip)
			tooltip:AddLine(ADDON_NAME, 1, 1, 1)
			tooltip:AddLine(" ")

			if cooldown > 0 then
				local r, g, b = GetGradientColor(cooldown / COOLDOWN_MAX_TIME)
				tooltip:AddDoubleLine(L["Cooldown"], GetAbbreviatedTime(cooldown), nil, nil, nil, r, g, b)
			else
				tooltip:AddDoubleLine(L["Cooldown"], L["Ready"], nil, nil, nil, 0.2, 1, 0.2)
			end

			local last = db.lastReincarnation
			if db.lastReincarnation then
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
				tooltip:AddDoubleLine(L["Last Reincarnation"], " ", nil, nil, nil, 1, 1, 1)
				tooltip:AddDoubleLine(" ", text:gsub("([^:%d])0", "%1"), nil, nil, nil, 1, 1, 1)
			end

			tooltip:AddLine(" ")
			tooltip:AddLine(L["Right-click for options."])
		end,
	})

	if db.frameShow and not AnkhUpFrame then
		self:CreateFrame()
	end

	self:RegisterEvent("PLAYER_ALIVE")
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")

	local start, duration = GetSpellCooldown(L["Reincarnation"])
	if start and duration and start > 0 and duration > 0 then
		self:Debug(1, "Reincarnation is on cooldown.")
		cooldownStartTime = start
		db.lastReincarnation = time() - (GetTime() - start)
		timerGroup:Play()
	end

	self:Debug(1, "cooldown = %d", cooldown)

	self:UpdateText()
end

AnkhUp.SPELL_LEARNED_IN_TAB = AnkhUp.SPELLS_CHANGED

------------------------------------------------------------------------