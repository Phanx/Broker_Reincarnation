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

local L = setmetatable(AnkhUpStrings or {}, { __index = function(t, k) rawset(t, k, k) return k end })

L["AnkhUp"] = GetAddOnMetadata("AnkhUp", "Title")
L["Ankh"] = GetItemInfo(17030) or L["Ankh"]
L["Reincarnation"] = GetSpellInfo(20608)

------------------------------------------------------------------------

local CHATPREFIX = "|cff00ddba" .. L["AnkhUp"] .. ":|r "

local function Print(str, ...)
	if select(1, ...) then
		str = str:format(...)
	end
	print(CHATPREFIX .. str)
end

local function Debug(lvl, str, ...)
	if lvl > 0 then return end
	if select(1, ...) then
		str = str:format(...)
	end
	print("[DEBUG] AnkhUp: " .. str)
end

------------------------------------------------------------------------

local db
local glyph = false
local aliveTime = 0
local ankhs = 0
local bookID = 0
local cooldown = 0
local maxCooldown = 0
local startTime = 0

------------------------------------------------------------------------

local AnkhUp = CreateFrame("Frame", "AnkhUp")
AnkhUp.L = L
AnkhUp:Hide()
AnkhUp:SetScript("OnEvent", function(self, event, ...) return self[event] and self[event](self, ...) end)
AnkhUp:RegisterEvent("ADDON_LOADED")

------------------------------------------------------------------------

local function UpdateBookID()
	Debug(3, "UpdateBookID")
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
	Debug(3, "bookID = %d", bookID)
	return bookID
end

------------------------------------------------------------------------

local function UpdateMaxCooldown()
	Debug(3, "UpdateMaxCooldown")
	local new = 60 * (60 - (select(5, GetTalentInfo(3, 3)) * 10) - (IsEquippedItem(22345) and 10 or 0))
	if new ~= maxcooldown then
		AnkhUp:DispatchCallbacks("CooldownChanged")
	end
	maxcooldown = new
	return maxcooldown
end

------------------------------------------------------------------------

local BOOKTYPE_SPELL = BOOKTYPE_SPELL
local REINCARNATION = L["Reincarnation"]
local min = math.min
local GetSpellCooldown = GetSpellCooldown
local GetSpellName = GetSpellName
local GetTime = GetTime

local function UpdateCooldown()
	Debug(5, "UpdateCooldown")
	if bookID == 0 or GetSpellName(bookID, BOOKTYPE_SPELL) ~= REINCARNATION then
		UpdateBookID()
	end
	if bookID > 0 then
		if startTime == 0 then
			local start, duration = GetSpellCooldown(bookID, BOOKTYPE_SPELL)
			if start > 0 and duration > 0 then
				startTime = start
			end
		end
		cooldown = maxcooldown - min(GetTime() - startTime, maxcooldown)
		return cooldown
	end
end

------------------------------------------------------------------------
--	Update cooldown

local counter = 0
AnkhUp:SetScript("OnUpdate", function(self, elapsed)
	counter = counter + elapsed
	if counter > 0.1 then
		UpdateCooldown()
		if cooldown == 0 then
			self:Hide()
			self:DispatchCallbacks("ReincarnationReady")
		end
		counter = 0
	end
end)

------------------------------------------------------------------------
--	Initialize

function AnkhUp:ADDON_LOADED(addon)
	if addon ~= "AnkhUp" then return end
	Debug(1, "ADDON_LOADED")

	self.defaults = {
		buy = 0,
		last = 0,
		low = 5,
		quiet = false,
		ready = true,
	}
	if not AnkhUpDB then
		AnkhUpDB = self.defaults
		db = AnkhUpDB
	else
		db = AnkhUpDB
		for k, v in pairs(self.defaults) do
			if type(db[k]) ~= type(v) then
				db[k] = v
			end
		end
	end

	StaticPopupDialogs["ANKHUP_LOW_ANKHS"] = {
		text = L["You only have %d ankhs left.\nDon't forget to restock!"],
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

function AnkhUp:PLAYER_LOGIN()
	Debug(1, "PLAYER_LOGIN")
	if UnitLevel("player") >= 30 then
		self:RegisterEvent("SPELLS_CHANGED")
		self:SPELLS_CHANGED()

		ankhs = GetItemCount(17030)
		if ankhs < db.low then
			self:DispatchCallbacks("AnkhsLow")
		end
	else
		self:RegisterEvent("PLAYER_LEVEL_UP")
	end

	self:UnregisterEvent("PLAYER_LOGIN")
	self.PLAYER_LOGIN = nil
end

------------------------------------------------------------------------
--	Detect Reincarnation

function AnkhUp:PLAYER_DEAD()
	Debug(1, "PLAYER_DEAD")
	self:RegisterEvent("PLAYER_ALIVE")
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
end

function AnkhUp:PLAYER_ALIVE()
	if UnitIsGhost("player") then return end
	Debug(1, "PLAYER_ALIVE")

	aliveTime = GetTime()
end

function AnkhUp:SPELL_UPDATE_COOLDOWN()
	Debug(2, "SPELL_UPDATE_COOLDOWN")
	local nowTime = GetTime()
	if nowTime - aliveTime < 1 then
		Debug(2, "Less than 1 second has elapsed since we resurrected.")
		local start, duration = GetSpellCooldown(bookID, BOOKTYPE_SPELL)
		if start > 0 and duration > 0 then
			Debug(2, "Reincarnation is on cooldown.")
			if nowTime - start < 1 then
				Debug(2, "Reincarnation just went on cooldown.")
				startTime = start
				db.last = time() - (GetTime() - start)
				self:DispatchCallbacks("ReincarnationUsed")
				self:Show()
			else
				Debug(2, "Reincarnation has been on cooldown for %d seconds.", nowTime - start)
			end
		else
			Debug(2, "We resurrected %d seconds ago.", nowTime - aliveTime)
			return
		end
	end
	self:UnregisterEvent("PLAYER_ALIVE")
	self:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
end

------------------------------------------------------------------------
--	Update ankhs

function AnkhUp:BAG_UPDATE()
	Debug(4, "BAG_UPDATE")
	local new = GetItemCount(17030)
	if new ~= ankhs then
		ankhs = new
		self:DispatchCallbacks("AnkhsChanged")
		if ankhs < db.low then
			self:DispatchCallbacks("AnkhsLow")
		end
	end
end

------------------------------------------------------------------------
--	Update max cooldown

function AnkhUp:UNIT_INVENTORY_CHANGED(unit)
	Debug(3, "UNIT_INVENTORY_CHANGED")
	if unit ~= "player" then return end
	UpdateMaxCooldown()
end

function AnkhUp:CHARACTER_POINTS_CHANGED()
	Debug(1, "CHARACTER_POINTS_CHANGED")
	UpdateMaxCooldown()
end

function AnkhUp:PLAYER_TALENT_UPDATE()
	Debug(1, "PLAYER_TALENT_UPDATE")
	UpdateMaxCooldown()
end

------------------------------------------------------------------------
--	Update glyphs

function AnkhUp:GLYPH_CHANGED()
	Debug(1, "GLYPH_CHANGED")

	local newglyph
	for i = 1, GetNumGlyphSockets() do
		local _, _, id = GetGlyphSocketInfo(i)
		if id == 58059 then -- Glyph of Renewed Life
			newglyph = true
			break
		end
	end

	if newglyph and not glyph then
		glyph = newglyph
		self:UnregisterEvent("BAG_UPDATE")
		self:RegisterEvent("GLYPH_ADDED")
		self:RegisterEvent("GLYPH_CHANGED")
		self:RegisterEvent("GLYPH_REMOVED")
		self:DispatchCallbacks("GlyphChanged")
	elseif glyph and not newglyph then
		self:UnregisterEvent("GLYPH_ADDED")
		self:UnregisterEvent("GLYPH_CHANGED")
		self:UnregisterEvent("GLYPH_REMOVED")
		self:RegisterEvent("BAG_UPDATE")
		self:DispatchCallbacks("GlyphChanged")
	end
end

AnkhUp.GLYPH_ADDED = AnkhUp.GLYPH_CHANGED
AnkhUp.GLYPH_REMOVED = AnkhUp.GLYPH_CHANGED

------------------------------------------------------------------------
--	Update events

function AnkhUp:SPELLS_CHANGED()
	Debug(2, "SPELLS_CHANGED")
	UpdateBookID()
	if bookID > 0 then
		UpdateMaxCooldown()
		UpdateCooldown()
		if cooldown == 0 then
			self:DispatchCallbacks("ReincarnationReady")
		else
			self:DispatchCallbacks("ReincarnationUsed")
			self:Show()
		end

		self:GLYPH_CHANGED()
		if not glyph then
			self:RegisterEvent("BAG_UPDATE")
			self:DispatchCallbacks("GlyphChanged")
		end

		self:RegisterEvent("PLAYER_DEAD")
		self:RegisterEvent("UNIT_INVENTORY_CHANGED")
		self:RegisterEvent("CHARACTER_POINTS_CHANGED")
		self:RegisterEvent("PLAYER_TALENT_UPDATE")
		if db.buy > 0 then
			self:RegisterEvent("MERCHANT_SHOW")
		end
	end
end

function AnkhUp:PLAYER_LEVEL_UP(level)
	if not level then
		level = UnitLevel("player")
	end
	Debug(1, "PLAYER_LEVEL_UP: %d", level)

	if level >= 30 then
		self:UnregisterEvent("PLAYER_LEVEL_UP")

		self:RegisterEvent("SPELLS_CHANGED")
	end
end

------------------------------------------------------------------------
--	Restock ankhs

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
--	Callback API

local callbacks = {
	["AnkhsChanged"] = { },
	["AnkhsLow"] = { },
	["CooldownChanged"] = { },
	["GlyphChanged"] = { },
	["ReincarnationReady"] = { },
	["ReincarnationUsed"] = { },
}

function AnkhUp:RegisterCallback(callback, method, handler)
	Debug(1, "RegisterCallback: %s, %s, %s", tostring(callback), tostring(method), tostring(handler))
	assert(callbacks[callback], "Invalid argument #1 to RegisterCallback")
	assert(type(method) == "function" or type(method) == "string", "Invalid argument #2 to RegisterCallback (function or string expected)")
	if type(method) == "string" then
		assert(type(handler) == "table", "Invalid argument #3 to RegisterCallback (table expected)")
		assert(type(handler[method]) == "function", "Invalid argument #2 to RegisterCallback (method not found)")
		
		method = handler[method]
	end
	if callbacks[callback][method] then return end
	callbacks[callback][method] = handler or true
end

function AnkhUp:UnregisterCallback(callback, method, handler)
	Debug(1, "UnregisterCallback: %s, %s, %s", tostring(type), tostring(method), tostring(handler))
	assert(callbacks[callback], "Invalid argument #1 to UnregisterCallback")
	assert(type(method) == "function" or type(method) == "string", "Invalid argument #2 to UnregisterCallback (function or string expected)")
	if type(method) == "string" then
		assert(type(handler) == "table", "Invalid argument #3 to UnregisterCallback (table expected)")
		assert(type(handler[method]) == "function", "Invalid argument #2 to UnregisterCallback (method not found)")
		
		method = handler[method]
	end
	if not callbacks[callback][method] then return end
	callbacks[callback][method] = nil
end

function AnkhUp:DispatchCallbacks(callback)
	Debug(2, "DispatchCallbacks: %s", tostring(callback))
	assert(callbacks[callback], "Invalid argument #1 to DispatchCallbacks")
	local dispatched
	for method, handler in pairs(callbacks[callback]) do
		method(handler ~= true and handler)
		dispatched = true
	end
	if not dispatched then
		if callback == "AnkhsLow" then
			StaticPopup_Show("ANKHUP_LOW_ANKHS", ankhs)
		elseif callback == "ReincarnationReady" then
			RaidNotice_AddMessage(RaidWarningFrame, L["Reincarnation ready!"], CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS.SHAMAN or RAID_CLASS_COLORS.SHAMAN)
		end
	end
end

------------------------------------------------------------------------
--	Public API

function AnkhUp:GetCooldown() return cooldown, maxcooldown end
function AnkhUp:HasGlyph() return glyph end

------------------------------------------------------------------------
--	Misc

function AnkhUp:Debug(...) return Debug(...) end
function AnkhUp:Print(...) return Print(...) end

------------------------------------------------------------------------