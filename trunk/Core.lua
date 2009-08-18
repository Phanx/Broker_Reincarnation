--[[--------------------------------------------------------------------
	AnkhUp
	Reincarnation cooldown monitor shamans
	by Phanx < addons@phanx.net >
	http://www.wowinterface.com/downloads/info6330-AnkhUp.html
	Copyright ©2006–2009 Alyssa "Phanx" Kinley. All Rights Reserved.
	See accompanying README for license terms and other information.
----------------------------------------------------------------------]]

if select(2, UnitClass("player")) ~= "SHAMAN" then
	return DisableAddOn("AnkhUp")
end

------------------------------------------------------------------------

local alive = 0
local ankhs = -1
local cooldown = 0
local db
local duration = 0
local glyph = false
local start = 0

------------------------------------------------------------------------

local L = setmetatable(AnkhUpStrings or { }, { __index = function(t, k) t[k] = k return k end })
if AnkhUpStrings then AnkhUpStrings = nil end

L["AnkhUp"] = GetAddOnMetadata("AnkhUp", "Title")
L["Ankh"] = GetItemInfo(17030) or L["Ankh"]
L["Reincarnation"] = GetSpellInfo(20608)

------------------------------------------------------------------------

local AnkhUp = CreateFrame("Frame", "AnkhUp", UIParent)
AnkhUp:SetScript("OnEvent", function(self, event, ...) return self[event] and self[event](self, ...) end)
AnkhUp:RegisterEvent("ADDON_LOADED")

------------------------------------------------------------------------

local function debug(lvl, ...)
	if lvl > 0 then return end
	print(string.format("|cff00ddbaAnkhUp:|r %s", string.join(", ", ...)))
end

------------------------------------------------------------------------

AnkhUp.feed = LibStub("LibDataBroker-1.1"):NewDataObject("AnkhUp", {
	type = "data source",
	icon = "Interface\\AddOns\\AnkhUp\\Ankh",
	label = L["AnkhUp"],
	text = L["Unknown"],
	OnClick = function(self, button)
		if button == "RightButton" then
			if AnkhUp.options then
				InterfaceOptionsFrame_OpenToCategory(AnkhUp.options)
			end
		end
	end,
	OnTooltipShow = function(tooltip)
		AnkhUp:UpdateTooltip(tooltip)
	end,
})

function AnkhUp:UpdateText()
	if duration == 0 then
		self.feed.text = string.format("|cff999999%s|r", L["Unknown"])
	elseif glyph and cooldown > 0 then
		self.feed.text = string.format("|cffff3333%s|r", string.format(SecondsToTimeAbbrev(cooldown)))
	elseif glyph then
		self.feed.text = string.format("|cff33ff33%s|r", L["Ready"])
	else
		local color
		if ankhs > db.low then
			color = "33ff33"
		elseif ankhs > 0 then
			color = "ffff33"
		else
			color = "ff3333"
		end
		if cooldown > 0 then
			self.feed.text = string.format("|cff%s%d|r|cff999999 / |r|cffff3333%s|r", color, ankhs, string.format(SecondsToTimeAbbrev(cooldown)))
		else
			self.feed.text = string.format("|cff%s%d|r|cff999999 / |r|cff33ff33%s|r", color, ankhs, L["Ready"])
		end
	end
end

function AnkhUp:UpdateTooltip(tooltip)
	if not tooltip then tooltip = GameTooltip end

	tooltip:AddLine(L["AnkhUp"], 1, 0.8, 0)

	if not glyph then
		local r, g, b
		if ankhs > db.low then
			r, g, b = 0.2, 1, 0.2
		elseif ankhs > 0 then
			r, g, b = 1, 1, 0.2
		else
			r, g, b = 1, 0.2, 0.2
		end
		tooltip:AddDoubleLine(string.format("%s:", L["Ankhs"]), ankhs, 1, 0.8, 0, r, g, b)
	end

	if cooldown > 0 then
		tooltip:AddDoubleLine(string.format("%s:", "Remaining:"), string.format(SecondsToTimeAbbrev(cooldown)), 1, 0.8, 0, 1, 0.2, 0.2)
	else
		tooltip:AddDoubleLine(string.format("%s:", "Remaining:"), string.format("%s!", L["Ready"]), 1, 0.8, 0, 0.2, 1, 0.2)
	end

	tooltip:AddDoubleLine(string.format("%s:", "Cooldown:"), string.format(SecondsToTimeAbbrev(duration)), 1, 0.8, 0, 1, 1, 1)

	if db.last > 0 then
		tooltip:AddLine(string.format("%s:", "Last Reincarnated:"), 1, 0.8, 0)
		tooltip:AddDoubleLine(" ", date(L["%I:%M %p %A, %B %d, %Y"], db.last), nil, nil, nil, 1, 1, 1)
	end

	if self.options then
		tooltip:AddLine(" ")
		tooltip:AddLine(L["Right-click for options."], 0.2, 1, 0.2)
	end
end

------------------------------------------------------------------------

function AnkhUp:UpdateDuration()
	debug(2, "UpdateDuration")

	duration = 3600 - (select(5, GetTalentInfo(3, 3)) * 600) - (IsEquippedItem(22345) and 600 or 0)
end

------------------------------------------------------------------------

local counter = 0
function AnkhUp:UpdateCooldown(elapsed)
	counter = counter + elapsed
	if counter >= 0.25 then
		cooldown = start + duration - GetTime()
		if cooldown <= 0 then
			self:SetScript("OnUpdate", nil)
			self:Alert("ReincarnationReady")
			cooldown = 0
		end
		self:UpdateText()
		counter = 0
	end
end

------------------------------------------------------------------------

function AnkhUp:ADDON_LOADED(addon)
	if addon ~= "AnkhUp" then return end
	debug(1, "ADDON_LOAED")

	self.defaults = {
		buy = 10,
		low = 5,
		last = 0,
		quiet = false,
	}

	if not AnkhUpDB then AnkhUpDB = { } end
	db = AnkhUpDB

	for k, v in pairs(self.defaults) do
		if type(db[k]) ~= type(v) then
			db[k] = v
		end
	end

	self.L = L

	if self.SetupFrame then
		self:SetupFrame()
	end

	self:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil

	if IsLoggedIn() then
		self:PLAYER_LOGIN()
	else
		self:RegisterEvent("PLAYER_LOGIN")
	end
end

function AnkhUp:PLAYER_LOGIN()
	debug(1, "PLAYER_LOGIN")

	if not GetTalentInfo(3, 3) then
		debug(1, "Talents not loaded yet")
		self.loading = true
		self:RegisterEvent("PLAYER_ALIVE")
		return
	end

	self.CHARACTER_POINTS_CHANGED = self.PLAYER_TALENT_UPDATE
	self.GLYPH_ADDED = self.GLYPH_CHANGED
	self.GLYPH_REMOVED = self.GLYPH_CHANGED
	self.SPELL_LEARNED_IN_TAB = self.SPELLS_CHANGED

	if UnitLevel("player") < 30 then
		debug(1, "Not level 30 yet")
		self:RegisterEvent("PLAYER_LEVEL_UP")
		return
	end

	if not GetSpellInfo(L["Reincarnation"]) then
		debug(1, "Reincarnation not learned yet")
		self:RegisterEvent("SPELLS_CHANGED")
		self:RegisterEvent("SPELL_LEARNED_IN_TAB")
		return
	end

	self:RegisterEvent("PLAYER_ALIVE")

	self:RegisterEvent("PLAYER_TALENT_UPDATE")
	self:RegisterEvent("CHARACTER_POINTS_CHANGED")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED")

	self:RegisterEvent("GLYPH_CHANGED")
	self:RegisterEvent("GLYPH_ADDED")
	self:RegisterEvent("GLYPH_REMOVED")

	self:RegisterEvent("PLAYER_LEAVING_WORLD")
	self:RegisterEvent("BAG_UPDATE")
	self:RegisterEvent("MERCHANT_SHOW")

	self:BAG_UPDATE()

	self:UpdateDuration()

	local cdstart, cdduration = GetSpellCooldown(L["Reincarnation"])
	if cdstart > 0 and duration > 0 then
		debug(1, "Reincarnation on cooldown")
		start = cdstart
		db.last = time() - (GetTime() - cdstart)
		cooldown = cdstart + cdduration - GetTime()
		self:SetScript("OnUpdate", self.UpdateCooldown)
	end

	debug(1, string.format("ankhs %d, duration %d, cooldown %d", ankhs, duration, cooldown))

	self:UpdateText()
end

function AnkhUp:PLAYER_ALIVE()
	debug(1, "PLAYER_ALIVE")

	if self.loading then
		debug(1, "Loading")
		self.loading = nil
		self:UnregisterEvent("PLAYER_ALIVE")
		self:PLAYER_LOGIN()
		return
	end

	if UnitIsGhost("player") then
		debug(1, "Ghost")
		return
	end

	alive = GetTime()
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
end

function AnkhUp:SPELL_UPDATE_COOLDOWN()
	debug(1, "SPELL_UPDATE_COOLDOWN")

	self:UnregisterEvent("SPELL_UPDATE_COOLDOWN")

	local now = GetTime()
	if now - alive < 1 then
		debug(1, "Just resurrected")
		local cdstart, cdduration = GetSpellCooldown(L["Reincarnation"])
		if cdstart > 0 and cdduration > 0 then
			if now - cdstart < 1 then
				debug(1, "Just used Reincarnation")
				start = cdstart
				db.last = time() - (GetTime() - cdstart)
				self:SetScript("OnUpdate", self.UpdateCooldown)
			end
		end
	end
end

------------------------------------------------------------------------
--	Level up

function AnkhUp:PLAYER_LEVEL_UP(level)
	if not level then level = UnitLevel("player") end
	debug(1, "PLAYER_LEVEL_UP", level)

	if level < 30 then
		debug(1, "Not level 30 yet")
		return
	end

	self:UnregisterEvent("PLAYER_LEVEL_UP")
	self:RegisterEvent("SPELLS_CHANGED")
end

------------------------------------------------------------------------
--	Learn a new spell

function AnkhUp:SPELLS_CHANGED()
	debug(1, "SPELLS_CHANGED")

	if not GetSpellInfo(L["Reincarnation"]) then
		debug(1, "Reincarnation not learned yet")
		return
	end

	self:UnregisterEvent("SPELLS_CHANGED")

	self:RegisterEvent("PLAYER_TALENT_UPDATE")
	self:RegisterEvent("CHARACTER_POINTS_CHANGED")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED")

	self:RegisterEvent("GLYPH_CHANGED")
	self:RegisterEvent("GLYPH_ADDED")
	self:RegisterEvent("GLYPH_REMOVED")

	self:RegisterEvent("PLAYER_LEAVING_WORLD")
	self:RegisterEvent("BAG_UPDATE")
	self:RegisterEvent("MERCHANT_SHOW")
end

------------------------------------------------------------------------
--	Update cooldown

function AnkhUp:PLAYER_TALENT_UPDATE()
	debug(1, "PLAYER_TALENT_UPDATE")

	self:UpdateDuration()
end

function AnkhUp:UNIT_INVENTORY_CHANGED(unit)
	if unit ~= "player" then return end
	debug(1, "UNIT_INVENTORY_CHANGED")

	self:UpdateDuration()
end

------------------------------------------------------------------------
--	Update glyph

function AnkhUp:GLYPH_CHANGED()
	debug(1, "GLYPH_CHANGED")

	local new
	for i = 1, GetNumGlyphSockets() do
		local _, _, id = GetGlyphSocketInfo(i)
		if id == 58059 then
			new = true
			break
		end
	end

	if new and not glyph then
		debug(1, "Glyph of Renewed Life added")

		self:UnregisterEvent("BAG_UPDATE")
		self:UpdateText()
	elseif glyph and not new then
		debug(1, "Glyph of Renewed Life removed")

		self:RegisterEvent("PLAYER_LEAVING_WORLD")
		self:RegisterEvent("BAG_UPDATE")
		self:BAG_UPDATE()
	end
end

------------------------------------------------------------------------
--	Update ankh quantity

function AnkhUp:PLAYER_LEAVING_WORLD()
	debug(1, "PLAYER_LEAVING_WORLD")

	self:UnregisterEvent("BAG_UPDATE")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function AnkhUp:PLAYER_ENTERING_WORLD()
	debug(1, "PLAYER_ENTERING_WORLD")

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("BAG_UPDATE")
end

function AnkhUp:BAG_UPDATE()
	debug(3, "BAG_UPDATE")

	local new = GetItemCount(17030)
	if ankhs ~= new then
		ankhs = new

		if ankhs < db.low then
			self:Alert("LowAnkhs")
		end

		self:UpdateText()
	end
end

function AnkhUp:MERCHANT_SHOW()
	debug(1, "MERCHANT_SHOW")

	if not glyph and db.buy > 0 then
		for i = 1, GetMerchantNumItems() do
			if GetMerchantItemInfo(i) == "Ankh" then
				local need = db.buy - ankhs
				if need > 0 then
					if not db.quiet then
						print(string.format(L["Buying %d ankhs."], need))
					end
					while need > 10 do
						BuyMerchantItem(i, 10)
						need = need - 10
					end
					BuyMerchantItem(i, need)
				end
				break
			end
		end
	end
end

------------------------------------------------------------------------

StaticPopupDialogs["LOW_ANKH_ALERT"] = {
	text = L["You only have %d ankhs left.\nDon't forget to restock!"],
	button1 = OKAY,
	hideOnEscape = 1,
	showAlert = 1,
	timeout = 0,
	OnShow = function(self)
		print("StaticPopup: LOW_ANKH_ALERT")
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

function AnkhUp:Alert(type)
	if type == "LowAnkhs" then
		StaticPopup_Show("LOW_ANKH_ALERT", ankhs)
	elseif type == "ReincarnationReady" then
		local color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS.SHAMAN or RAID_CLASS_COLORS.SHAMAN
		RaidNotice_AddMessage(RaidBossEmoteFrame, L["Reincarnation is ready!"], color)
	end
end
------------------------------------------------------------------------