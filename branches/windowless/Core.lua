--[[--------------------------------------------------------------------
	AnkhUp
	Reincarnation cooldown monitor and ankh manager for shamans.
	Written by Phanx <addons@phanx.net>
	Maintained by Akkorian <akkorian@hotmail.com>
	Copyright © 2006–2011 Phanx. Some rights reserved. See LICENSE.txt for details.
	http://www.wowinterface.com/downloads/info6330-AnkhUp.html
	http://wow.curse.com/downloads/wow-addons/details/ankhup.aspx
----------------------------------------------------------------------]]

local ADDON_NAME, ns = ...
if select(2, UnitClass("player")) ~= "SHAMAN" then return DisableAddOn(ADDON_NAME) end
if not ns then ns = _G.AnkhUpNS end -- WoW China is still running 3.2

local db, hasGlyph
local cooldown, cooldownStart, numAnkhs, resurrectionTime = 0, 0, 0, 0

------------------------------------------------------------------------

if not ns.L then ns.L = { } end
local L = setmetatable(ns.L, { __index = function(t, k)
	local v = tostring(k)
	t[k] = v
	return v
end })

L["Ankh"] = GetItemInfo(17030) or L["Ankh"]
L["Reincarnation"] = GetSpellInfo(20608)

------------------------------------------------------------------------

local AnkhUp = CreateFrame("Frame")
AnkhUp:SetScript("OnEvent", function(self, event, ...) return self[event] and self[event](self, ...) end)
AnkhUp:RegisterEvent("ADDON_LOADED")
ns.AnkhUp = AnkhUp

------------------------------------------------------------------------

function AnkhUp:Debug(lvl, str, ...)
	if lvl > 0 then return end
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

local function abbrevTime(seconds)
	if seconds >= 86400 then
		return ABBR_DAY:format(ceil(seconds / 86400))
	elseif seconds >= 3600 then
		return ABBR_HOUR:format(ceil(seconds / 3600))
	elseif seconds >= 60 then
		return ABBR_MINUTE:format(ceil(seconds / 60))
	end
	return ABBR_SECOND:format(seconds)
end

function AnkhUp:UpdateText()
	if hasGlyph and cooldown > 0 then
		self.dataObject.text = ("|cffff3333%s|r"):format(abbrevTime(cooldown))
	elseif hasGlyph then
		self.dataObject.text = ("|cff33ff33%s|r"):format(L["Ready"])
	else
		local color
		if db.low > 0 and numAnkhs > db.low then
			color = "33ff33"
		elseif numAnkhs > 0 then
			color = "ffff33"
		else
			color = "ff3333"
		end
		if cooldown > 0 then
			self.dataObject.text = ("|cffff3333%s|r |cff%s(%d)|r"):format(abbrevTime(cooldown), color, numAnkhs)
		else
			self.dataObject.text = ("|cff33ff33%s|r |cff%s(%d)|r"):format(L["Ready"], color, numAnkhs)
		end
	end
end

------------------------------------------------------------------------

local timerGroup = AnkhUp:CreateAnimationGroup()
local timer = timerGroup:CreateAnimation()
timer:SetOrder(1)
timer:SetDuration(0.25)
timer:SetMaxFramerate(25)
timerGroup:SetScript("OnFinished", function(self, requested)
	cooldown = cooldownStart + 1800 - GetTime()
	AnkhUp:UpdateText()
	if cooldown <= 0 then
		if db.readyAlert then
			local color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS["SHAMAN"] or RAID_CLASS_COLORS["SHAMAN"]
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

	self.defaults = {
		readyAlert = true,
		buyAlert = true,
		buy = 0,
		low = 0,
		frameShow = true,
		frameLock = false,
		frameScale = 1,
	}
	for k, v in pairs(self.defaults) do
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

	if GetNumTalentTabs() == 0 then
		self:Debug(1, "Talents not loaded yet.")
		self:RegisterEvent("UNIT_NAME_UPDATE")
		return
	end

	self:SPELLS_CHANGED()
	self:GLYPH_UPDATED()

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

function AnkhUp:UNIT_NAME_UPDATE(unit)
	if unit and unit ~= "player" then return end
	self:Debug(1, "UNIT_NAME_UPDATE")

	self:Debug(1, "Loading talents complete.")
	self:UnregisterEvent("UNIT_NAME_UPDATE")

	self:PLAYER_LOGIN()
end

------------------------------------------------------------------------

local dialog = {
	text = L["You only have %d |4ankh:ankhs; left. Don't forget to restock!"],
	button1 = OKAY,
	hideOnEscape = 1,
	showAlert = 1,
	timeout = 0,
	OnShow = function(self)
		local icon = _G[self:GetName() .. "AlertIcon"]
		if icon then
			icon:SetWidth(48)
			icon:SetHeight(48)
			icon:ClearAllPoints()
			icon:SetPoint("LEFT", self, "LEFT", 24, 0)
			icon:SetTexture("Interface\\AddOns\\AnkhUp\\Ankh")
		end
	end,
	OnHide = function(self)
		local icon = _G[self:GetName() .. "AlertIcon"]
		if icon then
			icon:SetWidth(64)
			icon:SetHeight(64)
			icon:ClearAllPoints()
			icon:SetPoint("LEFT", self, "LEFT", 12, 12)
			icon:SetTexture("Interface\\DialogFrame\\DialogAlertIcon")
		end
	end,
}

function AnkhUp:BAG_UPDATE()
	self:Debug(3, "BAG_UPDATE")

	local ankhs = GetItemCount(17030)
	if numAnkhs == ankhs then return end

	numAnkhs = ankhs

	if numAnkhs < db.low then
		if not StaticPopupDialogs.LOW_ANKH_ALERT then
			StaticPopupDialogs.LOW_ANKH_ALERT = dialog
		end
		StaticPopup_Show("LOW_ANKH_ALERT", numAnkhs)
	end

	self:UpdateText()
end

------------------------------------------------------------------------

function AnkhUp:GLYPH_UPDATED()
	self:Debug(1, "GLYPH_UPDATED")

	local exists
	for i = 1, GetNumGlyphSockets() do
		local _, _, _, id = GetGlyphSocketInfo(i)
		self:Debug(2, "Scanning glyph socket %d; found glyph %d (%s)", i, id, (id and GetSpellInfo(id)) or "EMPTY")
		if id == 58059 then
			exists = true
			break
		end
	end

	if exists and not hasGlyph then
		self:Debug(1, "Glyph of Renewed Life was added.")

		hasGlyph = true

		self:UnregisterEvent("BAG_UPDATE")
		self:UpdateText()
	elseif hasGlyph and not exists then
		self:Debug(1, "Glyph of Renewed Life was removed.")

		hasGlyph = false

		self:RegisterEvent("PLAYER_LEAVING_WORLD")
		self:RegisterEvent("BAG_UPDATE")
		self:BAG_UPDATE()
	end
end

AnkhUp.GLYPH_ADDED = AnkhUp.GLYPH_UPDATED
AnkhUp.GLYPH_REMOVED = AnkhUp.GLYPH_UPDATED

------------------------------------------------------------------------

function AnkhUp:MERCHANT_SHOW()
	self:Debug(1, "MERCHANT_SHOW")

	if not hasGlyph and db.buy > 0 then
		for i = 1, GetMerchantNumItems() do
			if GetMerchantItemInfo(i) == L["Ankh"] then
				local need = db.buy - numAnkhs
				if need > 0 then
					if db.buyAlert then
						self:Print(L["Purchased %d |4ankh:ankhs;."], need)
					end
					local stack = GetMerchantItemMaxStack(i)
					while need > stack do
						BuyMerchantItem(i, stack)
						need = need - stack
					end
					BuyMerchantItem(i, need)
				end
				break
			end
		end
	end
end

------------------------------------------------------------------------

function AnkhUp:PLAYER_ALIVE()
	self:Debug(1, "PLAYER_ALIVE")

	if UnitIsGhost("player") then return end

	resurrectionTime = GetTime()
end

------------------------------------------------------------------------

function AnkhUp:PLAYER_ENTERING_WORLD()
	self:Debug(1, "PLAYER_ENTERING_WORLD")

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("BAG_UPDATE")
end

function AnkhUp:PLAYER_LEAVING_WORLD()
	self:Debug(1, "PLAYER_LEAVING_WORLD")

	self:UnregisterEvent("BAG_UPDATE")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
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
			cooldownStart = start
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
		icon  = "Interface\\AddOns\\AnkhUp\\Ankh",
		label = ADDON_NAME,
		text  = "Loading...",
		OnClick = function( self, button )
			if button == "RightButton" then
				SlashCmdList.ANKHUP()
			end
		end,
		OnTooltipShow = function( tooltip )
			tooltip:AddLine( ADDON_NAME )
			tooltip:AddLine( " " )

			if not hasGlyph then
				local r, g, b
				if db.low > 0 and numAnkhs > db.low then
					r, g, b = 0.2, 1, 0.2
				elseif numAnkhs > 0 then
					r, g, b = 1, 1, 0.2
				else
					r, g, b = 1, 0.2, 0.2
				end
				tooltip:AddDoubleLine( L["Ankhs"], numAnkhs, nil, nil, nil, r, g, b )
			end

			if cooldown > 0 then
				local r, g, b
				if cooldown / 1800 > 0.5 then
					r, g, b = 1, 0.2, 0.2
				else
					r, g, b = 1, 1, 0.2
				end
				tooltip:AddDoubleLine( L["Cooldown"], abbrevTime(cooldown), nil, nil, nil, r, g, b )
			else
				tooltip:AddDoubleLine( L["Cooldown"], L["Ready"], nil, nil, nil, 0.2, 1, 0.2 )
			end

			if db.lastReincarnation then
				local text = date( L["%I:%M%p %A, %d %B %Y"], db.lastReincarnation )
				if text:match( "^0" ) then
					text = text:sub( 2 )
				end
				tooltip:AddDoubleLine( L["Last Reincarnation"], " ", nil, nil, nil, 1, 1, 1 )
				tooltip:AddDoubleLine( " ", text, nil, nil, nil, 1, 1, 1 )
			end

			tooltip:AddLine( " " )
			tooltip:AddLine( L["Right-click for options."] )
		end,
	})

	if db.frameShow and not AnkhUpFrame then
		self:CreateFrame()
	end

	self:RegisterEvent("BAG_UPDATE")
	self:RegisterEvent("GLYPH_UPDATED")
	self:RegisterEvent("GLYPH_ADDED")
	self:RegisterEvent("GLYPH_REMOVED")
	self:RegisterEvent("MERCHANT_SHOW")
	self:RegisterEvent("PLAYER_ALIVE")
	self:RegisterEvent("PLAYER_LEAVING_WORLD")
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED")

	self:BAG_UPDATE()

	local start, duration = GetSpellCooldown(L["Reincarnation"])
	if start and duration and start > 0 and duration > 0 then
		self:Debug(1, "Reincarnation is on cooldown.")
		cooldownStart = start
		db.lastReincarnation = time() - (GetTime() - start)
		timerGroup:Play()
	end

	self:Debug(1, "numAnkhs = %d, cooldown = %d", numAnkhs, cooldown)

	self:UpdateText()
end
AnkhUp.SPELL_LEARNED_IN_TAB = AnkhUp.SPELLS_CHANGED

------------------------------------------------------------------------