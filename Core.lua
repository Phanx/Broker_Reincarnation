--[[--------------------------------------------------------------------
	AnkhUp
	A shaman Reincarnation monitor and ankh management helper
	by Phanx < addons@phanx.net >
	http://www.wowinterface.com/downloads/info6330-AnkhUp.html
	Copyright ©2006–2009 Alyssa "Phanx" Kinley
	See included README for license terms and additional information.
----------------------------------------------------------------------]]

if select(2, UnitClass("player")) ~= "SHAMAN" then
	return DisableAddOn("AnkhUp")
end

------------------------------------------------------------------------

local VERSION = GetAddOnMetadata("AnkhUp", "Version")

------------------------------------------------------------------------

local L = setmetatable(AnkhUpStrings or {}, { __index = function(t, k) rawset(t, k, k) return k end })

L["AnkhUp"] = GetAddOnMetadata("AnkhUp", "Title")
L["Ankh"] = GetItemInfo(17030) or L["Ankh"]
L["Reincarnation"] = GetSpellInfo(20608)

------------------------------------------------------------------------

local PREFIX = "|cff00ddba"..L["AnkhUp"]..":|r "

local function Print(str, ...)
	if select("#", ...) > 0 then
		str = str:format(...)
	end
	ChatFrame1:AddMessage(PREFIX..str)
end

local function Debug(lvl, str, ...)
	if lvl > 0 then return end
	if select("#", ...) > 0 then
		str = str:format(...)
	end
	ChatFrame1:AddMessage(PREFIX.."[DEBUG] "..str)
end

------------------------------------------------------------------------

local db
local ankhs = 0
local bookID = 0
local cooldown = 0
local downtime = 0
local resTime = 0

local function UpdateBookID()
	Debug(1, "UpdateBookID")
	bookID = 0
	if UnitLevel("player") >= 30 then
		local i = 1
		while true do
			local spell = GetSpellName(i, BOOKTYPE_SPELL)
			if not spell then
				break
			end
			if spell == L["Reincarnation"] then
				bookID = i
				break
			end
			i = i + 1
		end
	end
	return bookID
end

local function UpdateCooldown()
	Debug(1, "UpdateCooldown")
	local new = 60 - (select(5, GetTalentInfo(3, 3)) * 10) - (IsEquippedItem(22345) and 10 or 0)
	if new ~= cooldown then
		AnkhUp:DispatchCallbacks("CooldownChanged")
	end
	cooldown = new
	return cooldown
end

local function UpdateDowntime()
	Debug(3, "UpdateDowntime")
	if bookID == 0 or GetSpellName(bookID, BOOKTYPE_SPELL) ~= L["Reincarnation"] then
		UpdateBookID()
	end
	if bookID ~= 0 then
		local start, duration = GetSpellCooldown(bookID, BOOKTYPE_SPELL)
		if (start > 0) and (duration > 0) then
			downtime = duration - (GetTime() - start)
		else
			downtime = 0
		end
		return downtime
	end
end

------------------------------------------------------------------------

local AnkhUp = CreateFrame("Frame", "AnkhUp")
AnkhUp.L = L

local timer = 0
AnkhUp:SetScript("OnUpdate", function(self, elapsed)
	timer = timer + elapsed
	if timer > 0.1 then
		UpdateDowntime()
		if downtime == 0 then
			self:Hide()
			self:DispatchCallbacks("ReincarnationReady")
		end
		timer = 0
	end
end)
AnkhUp:Hide()

AnkhUp:SetScript("OnEvent", function(self, event, ...)
	if self[event] then return self[event](self, ...) end
end)

------------------------------------------------------------------------

function AnkhUp:BAG_UPDATE()
	Debug(2, "BAG_UPDATE")
	local new = GetItemCount(17030)
	if new ~= ankhs then
		self:DispatchCallbacks("AnkhsChanged")
		if (new == ankhs - 1) and (GetTime() - resTime < 1) then
			db.last = tostring(time() - 1100304000)
			self:DispatchCallbacks("ReincarnationUsed")
			self:Show()
		end
		ankhs = new
		if ankhs < db.low then
			self:DispatchCallbacks("AnkhsLow")
		end
	end
end

------------------------------------------------------------------------

function AnkhUp:CHARACTER_POINTS_CHANGED()
	Debug(1, "CHARACTER_POINTS_CHANGED")
	if bookID == 0 then
		UpdateBookID()
		if bookID ~= 0 then
			self:RegisterEvent("PLAYER_ALIVE")
			self:RegisterEvent("UNIT_INVENTORY_UPDATE")
			self:RegisterEvent("BAG_UPDATE")
			if db.buy > 0 then
				self:RegisterEvent("MERCHANT_SHOW")
			end
			UpdateCooldown()
		end
	else
		UpdateCooldown()
	end
end

AnkhUp.PLAYER_TALENT_UPDATE = AnkhUp.CHARACTER_POINTS_CHANGED

------------------------------------------------------------------------

function AnkhUp:PLAYER_ALIVE()
	Debug(1, "PLAYER_ALIVE")
	resTime = GetTime()
end

------------------------------------------------------------------------

function AnkhUp:PLAYER_LEVEL_UP()
	Debug(1, "PLAYER_LEVEL_UP")
	if UnitLevel("player") >= 30 then
		UpdateBookID()
		if bookID ~= 0 then
			self:RegisterEvent("PLAYER_ALIVE")
			self:RegisterEvent("UNIT_INVENTORY_CHANGED")
			self:RegisterEvent("BAG_UPDATE")
			if db.buy > 0 then
				self:RegisterEvent("MERCHANT_SHOW")
			end
		end
		self:RegisterEvent("CHARACTER_POINTS_CHANGED")
		self:RegisterEvent("PLAYER_TALENT_UPDATE")
		self:RegisterEvent("SPELLS_CHANGED")
		self:UnregisterEvent("PLAYER_LEVEL_UP")
	end
end

------------------------------------------------------------------------

function AnkhUp:SPELLS_CHANGED()
	Debug(1, "SPELLS_CHANGED")
	self:CHARACTER_POINTS_CHANGED()
end

------------------------------------------------------------------------

function AnkhUp:UNIT_INVENTORY_CHANGED(unit)
	if unit ~= "player" then return end
	Debug(3, "SPELLS_CHANGED")
	UpdateCooldown()
end

------------------------------------------------------------------------

function AnkhUp:ADDON_LOADED(addon)
	if addon ~= "AnkhUp" then return end

	Debug(1, "ADDON_LOADED")

	local defaults = {
		buy = 0,
		last = 0,
		low = 5,
		quiet = false,
		ready = true,
	}
	if not AnkhUpDB then
		AnkhUpDB = defaults
		db = AnkhUpDB
	else
		db = AnkhUpDB
		for k, v in pairs(defaults) do
			if db[k] == nil or type(db[k]) ~= type(v) then
				db[k] = v
			end
		end
	end

	StaticPopupDialogs["ANKHUP_LOW_ANKHS"] = {
		text = L["You only have %d ankhs left. Don't forget to restock!"],
		button1 = TEXT(OKAY),
		hideOnEscape = 1,
		showAlert = 0,
		timeout = 0,
	}

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
	Debug(1, "PLAYER_LOGIN")

	local level = UnitLevel("player")
	if level > 29 then
		UpdateBookID()

		if bookID ~= 0 then
			self:RegisterEvent("PLAYER_ALIVE")
			self:RegisterEvent("UNIT_INVENTORY_CHANGED")
			self:RegisterEvent("BAG_UPDATE")
			if db.buy > 0 then
				self:RegisterEvent("MERCHANT_SHOW")
			end
			UpdateCooldown()
			UpdateDowntime()
			if downtime ~= 0 then
				self:Show()
			end
		end

		self:RegisterEvent("CHARACTER_POINTS_CHANGED")
		self:RegisterEvent("SPELLS_CHANGED")
	else
		self:RegisterEvent("PLAYER_LEVEL_UP")
	end

	ankhs = GetItemCount(17030)
	if ankhs < db.low then
		self:DispatchCallbacks("AnkhsLow")
	end

	self:UnregisterEvent("PLAYER_LOGIN")
	self.PLAYER_LOGIN = nil
end

AnkhUp:RegisterEvent("ADDON_LOADED")

------------------------------------------------------------------------
--	Buy ankhs												--
------------------------------------------------------------------------

function AnkhUp:MERCHANT_SHOW()
	Debug(1, "MERCHANT_SHOW")
	if db.buy > 0 then
		local item
		for i = 1, GetMerchantNumItems() do
			item = GetMerchantItemInfo(i)
			if item == L["Ankh"] then
				local need = db.buy - ankhs
				if need > 0 then
					if not db.quiet then
						Print(string.format(L["Buying %d ankhs."], need))
					end
					while need > 10 do
						BuyMerchantItem(i, 10)
						need = need - 10
					end
					BuyMerchantItem(i, need)
				end
				do break end
			end
		end
	end
end

------------------------------------------------------------------------
--	Callbacks												--
------------------------------------------------------------------------

local callbacks = {
	["AnkhsChanged"] = {},
	["AnkhsLow"] = {},
	["CooldownChanged"] = {},
	["ReincarnationUsed"] = {},
	["ReincarnationReady"] = {},
}

function AnkhUp:RegisterCallback(type, handler, method)
	assert(callbacks[type], "Invalid arg1 '"..tostring(type).."' to RegisterCallback.")
	Debug(1, "RegisterCallback, "..type)
	callbacks[type][handler] = method or type
end

function AnkhUp:UnregisterCallback(type, handler)
	assert(callbacks[type], "Invalid arg1 '"..tostring(type).."' to UnregisterCallback.")
	Debug(1, "UnregisterCallback, "..type)
	callbacks[type][handler] = nil
end

function AnkhUp:DispatchCallbacks(type)
	assert(callbacks[type], "Invalid arg1 '"..tostring(type).."' to DispatchCallbacks.")
	Debug(1, "DispatchCallbacks, "..type)
	local dispatched = false
	for handler, method in pairs(callbacks[type]) do
		if handler[method] then
			handler[method](handler)
			dispatched = true
		end
	end
	if not dispatched then
		if type == "AnkhsLow" then
			StaticPopup_Show("ANKHUP_LOW_ANKHS", ankhs)
		elseif type == "ReincarnationReady" then
			RaidNotice_AddMessage(RaidWarningFrame, L["Reincarnation ready!"], RAID_CLASS_COLORS.SHAMAN)
		end
	end
end

------------------------------------------------------------------------
--	External API 											--
------------------------------------------------------------------------

function AnkhUp:Print(...)
	return Print(...)
end

function AnkhUp:GetCooldown()
	return cooldown
end

function AnkhUp:GetDowntime()
	return downtime
end

function AnkhUp:GetLast()
	return tonumber(db.last) + 1100304000
end

------------------------------------------------------------------------