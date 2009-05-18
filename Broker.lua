--[[--------------------------------------------------------------------
	AnkhUp
	A shaman Reincarnation monitor and ankh management helper
	by Phanx < addons@phanx.net >
	http://www.wowinterface.com/downloads/info6330-AnkhUp.html
	Copyright ©2006–2009 Alyssa "Phanx" Kinley
	See included README for license terms and additional information.

	This file adds a DataBroker feed for AnkhUp.
----------------------------------------------------------------------]]

assert(AnkhUp, "AnkhUp not found!")

if not LibStub:GetLibrary("LibDataBroker-1.1", true) then return end

------------------------------------------------------------------------

local HINT = "Click to open the AnkhUp configuration panel."

if GetLocale() == "deDE" then
	HINT = "Click to open the AnkhUp configuration panel."
elseif GetLocale() == "esES" then
	HINT = "Click to open the AnkhUp configuration panel."
elseif GetLocale() == "frFR" then
	HINT = "Click to open the AnkhUp configuration panel."
elseif GetLocale() == "ruRU" then
	HINT = "Click to open the AnkhUp configuration panel."
elseif GetLocale() == "koKR" then
	HINT = "Click to open the AnkhUp configuration panel."
elseif GetLocale() == "zhCN" then
	HINT = "Click to open the AnkhUp configuration panel."
elseif GetLocale() == "zhTW" then
	HINT = "Click to open the AnkhUp configuration panel."
end

------------------------------------------------------------------------

local date = date
local format = string.format
local SecondsToTimeAbbrev = SecondsToTimeAbbrev

local AnkhUp = AnkhUp
local L = AnkhUp.L

local db
local ankhstring = ""

------------------------------------------------------------------------

local obj = LibStub("LibDataBroker-1.1"):NewDataObject("AnkhUp", {
	type = "data source",
	icon = "Interface\\AddOns\\AnkhUp\\Ankh",
	label = GetAddOnMetadata("AnkhUp", "Title"),
	text = "|cff999999Inactive|r",
	OnClick = function(self, button)
		if AnkhUp.configPanel then
			InterfaceOptionsFrame_OpenToCategory(AnkhUp.configPanel)
		end
	end,
	OnTooltipShow = function(tooltip)
		tooltip:AddLine(L["AnkhUp"])

		local cooldown, maxcooldown = AnkhUp:GetCooldown()

		if maxcooldown == 0 then
			tooltip:AddLine(L["You have not yet learned the Reincarnation ability."], 0.6, 0.6, 0.6)
		else
			if not AnkhUp:HasGlyph() then
				tooltip:AddDoubleLine(L["Ankhs"], ankhstring)
			end

			if cooldown > 0 then
				tooltip:AddDoubleLine(L["Ready in..."], format(SecondsToTimeAbbrev(cooldown)), nil, nil, nil, 1, 0.25, 0.25)
			else
				tooltip:AddDoubleLine(L["Reincarnation is..."], L["Ready"], nil, nil, nil, 0.25, 1, 0.25)
			end

			tooltip:AddDoubleLine(L["Cooldown"], format(SecondsToTimeAbbrev(maxcooldown)), nil, nil, nil, 1, 1, 1)

			if db.last > 0 then
				tooltip:AddDoubleLine(L["Last Reincarnated"], date(L["%I:%M %p %A, %B %d, %Y"], db.last), nil, nil, nil, 1, 1, 1)
			else
				tooltip:AddDoubleLine(L["Last Reincarnated"], L["Unknown"], nil, nil, nil, 0.6, 0.6, 0.6)
			end
		end

		if AnkhUp.configFrame then
			tooltip:AddLine(" ")
			tooltip:AddLine(HINT, 0.25, 1, 0.25)
		end
	end,
})

------------------------------------------------------------------------

local AnkhUpBroker = CreateFrame("Frame")
AnkhUpBroker:Hide()

AnkhUp.Broker = AnkhUpBroker
AnkhUp.Broker.obj = obj

------------------------------------------------------------------------

function AnkhUpBroker:Initialize()
	self.Initialize = nil

	db = AnkhUpDB

	if AnkhUp.frame then
		AnkhUp.frame:RegisterObject("AnkhUp")
	end

	self:AnkhsChanged()

	if AnkhUp:GetCooldown() == 0 then
		self:ReincarnationReady()
	else
		self:ReincarnationUsed()
	end
end

------------------------------------------------------------------------

local NOT_READY = "%s |cffff3f3f(%s)"
local READY = "%s |cff3fff3f(" .. L["Ready"] .. ")|r"

local counter = 0
function AnkhUpBroker:Update(elapsed)
	counter = counter + (elapsed or 1000)
	if counter > 0.2 then
		local cooldown = AnkhUp:GetCooldown()
		if cooldown == 0 then
			obj.text = format(READY, ankhstring)
		else
			obj.text = format(NOT_READY, ankhstring, date("%M:%S", cooldown))
		end
		counter = 0
	end
end

AnkhUpBroker:SetScript("OnUpdate", AnkhUpBroker.Update)

function AnkhUpBroker:ReincarnationUsed()
	if self.Initialize then return self:Initialize() end

	self:Show()
end

function AnkhUpBroker:ReincarnationReady()
	if self.Initialize then return self:Initialize() end

	self:Hide()
	self:Update()
end

------------------------------------------------------------------------

local ANKHS = "|cff%s%s|r"

local GREEN = "3fff3f"
local YELLOW = "ffff3f"
local RED = "ff3f3f"

function AnkhUpBroker:AnkhsChanged()
	if self.Initialize then return self:Initialize() end

	local ankhs = GetItemCount(17030)
	if db.low > 0 then
		if ankhs > db.low then
			ankhstring = format(ANKHS, GREEN, ankhs)
		elseif ankhs > 0 then
			ankhstring = format(ANKHS, YELLOW, ankhs)
		else
			ankhstring = format(ANKHS, RED, ankhs)
		end
	else
		ankhstring = format(ANKHS, GREEN, ankhs)
	end

	self:Update()
end

------------------------------------------------------------------------

AnkhUp:RegisterCallback("AnkhsChanged", "AnkhsChanged", AnkhUpBroker)
AnkhUp:RegisterCallback("AnkhsLow", "AnkhsChanged", AnkhUpBroker)
AnkhUp:RegisterCallback("ReincarnationUsed", "ReincarnationUsed", AnkhUpBroker)
AnkhUp:RegisterCallback("ReincarnationReady", "ReincarnationReady", AnkhUpBroker)

------------------------------------------------------------------------