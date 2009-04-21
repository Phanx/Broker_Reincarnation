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

local HINT = "|cffff0000Click|r to open the AnkhUp configuration panel."

if GetLocale() == "deDE" then
	HINT = "|cffff0000Click|r to open the AnkhUp configuration panel."
elseif GetLocale() == "esES" then
	HINT = "|cffff0000Click|r to open the AnkhUp configuration panel."
elseif GetLocale() == "frFR" then
	HINT = "|cffff0000Click|r to open the AnkhUp configuration panel."
elseif GetLocale() == "ruRU" then
	HINT = "|cffff0000Click|r to open the AnkhUp configuration panel."
elseif GetLocale() == "koKR" then
	HINT = "|cffff0000Click|r to open the AnkhUp configuration panel."
elseif GetLocale() == "zhCN" then
	HINT = "|cffff0000Click|r to open the AnkhUp configuration panel."
elseif GetLocale() == "zhTW" then
	HINT = "|cffff0000Click|r to open the AnkhUp configuration panel."
end

------------------------------------------------------------------------

local AnkhUp = AnkhUp
local TITLE = GetAddOnMetadata("AnkhUp", "Title")
local VERSION = GetAddOnMetadata("AnkhUp", "Version")
local L, db, ankhs, cooldown, ready

------------------------------------------------------------------------

local obj = LibStub("LibDataBroker-1.1"):NewDataObject("AnkhUp", {
	type = "data source",
	icon = "Interface\\AddOns\\AnkhUp\\Ankh",
	label = TITLE,
	text = "Loading...",
})

------------------------------------------------------------------------

local a = CreateFrame("Frame", nil, WorldFrame)
a:SetScript("OnEvent", function(self, event, ...) return self[event] and self[event](self, ...) end)
a:RegisterEvent("PLAYER_ENTERING_WORLD")

------------------------------------------------------------------------

function a:PLAYER_ENTERING_WORLD()
	L = AnkhUp.L
	db = AnkhUpDB
	ready = AnkhUp:GetDowntime() == 0

	obj.OnClick = function(self, btn)
		if AnkhUp.configPanel then
			InterfaceOptionsFrame_OpenToCategory(AnkhUp.configPanel)
		end
	end

	obj.OnTooltipShow = function(tooltip)
		tooltip:AddLine(L["AnkhUp"])
		tooltip:AddDoubleLine(L["Ankhs"], ankhs)

		local downtime = AnkhUp:GetDowntime()
		if downtime > 0 then
			tooltip:AddDoubleLine(L["Ready in..."], "|cffff7f7f"..string.format(SecondsToTimeAbbrev(downtime)).."|r")
		else
			tooltip:AddDoubleLine(L["Reincarnation is..."], "|cff7fff7f"..L["Ready"].."!|r")
		end

		tooltip:AddDoubleLine(L["Cooldown"], "|cffffffff"..cooldown.."m|r")
		tooltip:AddDoubleLine(L["Last Reincarnated"], db.last and date("|cffffffff"..L["%I:%M%p %A, %d %B, %Y"].."|r", AnkhUp:GetLast()) or "|cffffff7f"..L["Unknown"].."|r")

		if AnkhUp.configFrame then
			tooltip:AddLine(" ")
			tooltip:AddLine(HINT)
		end
	end

	self:AnkhsChanged()
	self:CooldownChanged()

	if ready then
		self:ReincarnationReady()
	else
		self:ReincarnationUsed()
	end

	AnkhUp:RegisterCallback("AnkhsChanged", self, "AnkhsChanged")
	AnkhUp:RegisterCallback("CooldownChanged", self, "CooldownChanged")
	AnkhUp:RegisterCallback("ReincarnationUsed", self, "ReincarnationUsed")
	AnkhUp:RegisterCallback("ReincarnationReady", self, "ReincarnationReady")

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self.PLAYER_ENTERING_WORLD = nil
end

------------------------------------------------------------------------

function a:AnkhsChanged()
	ankhs = GetItemCount(17030)
	if db.low > 0 then
		if ankhs > db.low then
			ankhs = "|cff7fff7f"..ankhs.."|r"
		elseif ankhs > 0 then
			ankhs = "|cffffff7f"..ankhs.."|r"
		else
			ankhs = "|cffff7f7f"..ankhs.."|r"
		end
	else
		ankhs = "|cff7f7f7f"..ankhs.."|r"
	end
end

------------------------------------------------------------------------

function a:CooldownChanged()
	cooldown = AnkhUp:GetCooldown()
end

------------------------------------------------------------------------

local counter = 0
local function update(self, elapsed)
	counter = counter + elapsed
	if counter > 0.2 then
		if not ready then
			local downtime = AnkhUp:GetDowntime()
			obj.text = "|cffff7f7f" .. date("%M:%S", downtime) .. " (|r" .. ankhs .. "|cffff7f7f)|r"
		else
			obj.text = "|cff7fff7f" .. L["Ready"] .. " (|r" .. ankhs .. "|cff7fff7f)|r"
		end
		counter = 0
	end
end

function a:ReincarnationUsed()
	self:SetScript("OnUpdate", update)
	ready = false
	update(self, 1000)
end

function a:ReincarnationReady()
	self:SetScript("OnUpdate", nil)
	ready = true
	update(self, 1000)
end

------------------------------------------------------------------------