--[[--------------------------------------------------------------------
	AnkhUp
	Reincarnation monitor for shamans.
	by Phanx < addons@phanx.net >
	Copyright © 2006–2010 Alyssa "Phanx" Kinley
	http://www.wowinterface.com/downloads/info6330-AnkhUp.html
	http://wow.curse.com/downloads/wow-addons/details/ankhup.aspx
----------------------------------------------------------------------]]

local ADDON_NAME, ns = ...
if select(2, UnitClass("player")) ~= "SHAMAN" then return DisableAddOn(ADDON_NAME) end
if not ns.L then ns.L = { } end

local L = setmetatable(ns.L, { __index = function(t, k) t[k] = k return k end })
L["AnkhUp"] = GetAddOnMetadata(ADDON_NAME, "Title")
L["Ankh"] = GetItemInfo(17030) or L["Ankh"]
L["Reincarnation"] = GetSpellInfo(20608)

local db, hasGlyph
local cooldown, cooldownMax, cooldownStart, numAnkhs, resurrectionTime = 0, 0, 0, 0, 0

------------------------------------------------------------------------

local AnkhUp = CreateFrame("Frame")
AnkhUp:SetScript("OnEvent", function(self, event, ...) return self[event] and self[event](self, ...) end)
AnkhUp:RegisterEvent("ADDON_LOADED")
AnkhUp:Hide()

ns.AnkhUp = AnkhUp
_G.AnkhUp = AnkhUp

------------------------------------------------------------------------

local ABBR_DAY    =    DAY_ONELETTER_ABBR:gsub("%s", ""):lower()
local ABBR_HOUR   =   HOUR_ONELETTER_ABBR:gsub("%s", ""):lower()
local ABBR_MINUTE = MINUTE_ONELETTER_ABBR:gsub("%s", ""):lower()
local ABBR_SECOND = SECOND_ONELETTER_ABBR:gsub("%s", ""):lower()

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
	if cooldownMax == 0 then
		self.dataObject.text = ("|cff999999%s|r"):format(L["Unknown"])
	elseif hasGlyph and cooldown > 0 then
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

function AnkhUp:UpdateTooltip(tooltip)
	tooltip:AddLine(L["AnkhUp"], 1, 0.8, 0)
	tooltip:AddLine()

	if not hasGlyph then
		local r, g, b
		if db.low > 0 and numAnkhs > db.low then
			r, g, b = 0.2, 1, 0.2
		elseif numAnkhs > 0 then
			r, g, b = 1, 1, 0.2
		else
			r, g, b = 1, 0.2, 0.2
		end
		tooltip:AddDoubleLine(L["Ankhs"], numAnkhs, 1, 0.8, 0, r, g, b)
	end

	if cooldown > 0 then
		local r, g, b
		if cooldown / cooldownMax > 0.5 then
			r, g, b = 1, 0.2, 0.2
		else
			r, g, b = 1, 1, 0.2
		end
		tooltip:AddDoubleLine(L["Cooldown"], ("%s / %s"):format(abbrevTime(cooldown), abbrevTime(cooldownMax)), 1, 0.8, 0, r, g, b)
	else
		tooltip:AddDoubleLine(L["Cooldown"], ("%s / %s"):format(L["Ready"], abbrevTime(cooldownMax)), 1, 0.8, 0, 0.2, 1, 0.2)
	end

	if db.lastReincarnation then
		local str = date(L["%I:%M%p %A, %d %B %Y"], db.lastReincarnation)
		if str:match("^0") then
			str = str:sub(2)
		end
		tooltip:AddDoubleLine(L["Last Reincarnation"], " ", 1, 0.8, 0, 1, 1, 1)
		tooltip:AddDoubleLine(" ", str, 1, 0.8, 0, 1, 1, 1)
	end
end

------------------------------------------------------------------------

local counter = 0
AnkhUp:SetScript("OnUpdate", function(self, elapsed)
	counter = counter + elapsed
	if counter >= 0.25 then
		cooldown = cooldownStart + cooldownMax - GetTime()
		if cooldown <= 0 then
			self:SetScript("OnUpdate", nil)
			if db.readyAlert then
				RaidNotice_AddMessage(RaidBossEmoteFrame, L["Reincarnation is ready!"], CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS.SHAMAN or RAID_CLASS_COLORS.SHAMAN)
			end
			cooldown = 0
		end
		self:UpdateText()
		counter = 0
	end
end)

------------------------------------------------------------------------

function AnkhUp:UpdateCooldownMax()
	self:Debug(1, "UpdateCooldownMax")
	local talentPoints = select(5, GetTalentInfo(3, 3))

	if talentPoints == 2 then
		cooldownMax =  900 - (IsEquippedItem(22345) and 300 or 0)
	elseif talentPoints == 1 then
		cooldownMax = 1380 - (IsEquippedItem(22345) and 300 or 0)
	else
		cooldownMax = 1800 - (IsEquippedItem(22345) and 300 or 0)
	end

	return cooldownMax
end

------------------------------------------------------------------------

function AnkhUp:ADDON_LOADED(addon)
	if addon ~= ADDON_NAME then return end
	self:Debug(1, "ADDON_LOADED", addon)

	if not AnkhUpDB then
		AnkhUpDB = { }
	end
	db = AnkhUpDB

	self.defaults = {
		low = 0,
		buy = 0,
		buyAlert = true,
		readyAlert = true,
		frameShow = true,
		frameLock = false,
		framePoint = "CENTER",
		frameScale = 1,
		frameAlpha = 1,
		frameX = 0,
		frameY = 0,
		-- lastReincarnation (number)
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

	if UnitLevel("player") < 30 then
		self:Debug(1, "Not level 30 yet.")
		self:RegisterEvent("PLAYER_LEVEL_UP")
		return
	end

	if not GetTalentInfo(3, 3) then
		self:Debug(1, "Talents not loaded yet.")
		self:RegisterEvent("UNIT_NAME_UPDATE")
		return
	end

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
	for k, v in pairs(self.defaultDB) do
		if self.db[k] == v then
			self.db[k] = nil
		end
	end
end

------------------------------------------------------------------------

local dialog = {
	text = L["You only have %d ankhs left.\nDon't forget to restock!"],
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
	if numAnkhs ~= ankhs then
		numAnkhs = ankhs

		if numAnkhs < db.low then
			if not StaticPopupDialogs.LOW_ANKH_ALERT then
				StaticPopupDialogs.LOW_ANKH_ALERT = dialog
			end
			StaticPopup_Show("LOW_ANKH_ALERT", numAnkhs)
		end

		self:UpdateText()
	end
end

------------------------------------------------------------------------

function AnkhUp:GLYPH_CHANGED()
	self:Debug(1, "GLYPH_CHANGED")

	local exists
	for i = 1, GetNumGlyphSockets() do
		local _, _, id = GetGlyphSocketInfo(i)
		if id == 58059 then
			exists = true
			break
		end
	end

	if exists and not hasGlyph then
		self:Debug(1, "Glyph of Renewed Life was added.")

		self:UnregisterEvent("BAG_UPDATE")
		self:UpdateText()
	elseif hasGlyph and not exists then
		self:Debug(1, "Glyph of Renewed Life was removed.")

		self:RegisterEvent("PLAYER_LEAVING_WORLD")
		self:RegisterEvent("BAG_UPDATE")
		self:BAG_UPDATE()
	end
end
AnkhUp.GLYPH_ADDED = AnkhUp.GLYPH_CHANGED
AnkhUp.GLYPH_REMOVED = AnkhUp.GLYPH_CHANGED

------------------------------------------------------------------------

function AnkhUp:MERCHANT_SHOW()
	self:Debug(1, "MERCHANT_SHOW")

	if not hasGlyph and db.buy > 0 then
		for i = 1, GetMerchantNumItems() do
			if GetMerchantItemInfo(i) == L["Ankh"] then
				local need = db.buy - numAnkhs
				if need > 0 then
					if db.buyAlert then
						self:Print(L["Buying %d ankhs."], need)
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

function AnkhUp:PLAYER_LEVEL_UP(level)
	if not level then level = UnitLevel("player") end
	self:Debug(1, "PLAYER_LEVEL_UP", level)

	if level < 30 then
		self:Debug(1, "Not level 30 yet.")
		return
	end

	self:UnregisterEvent("PLAYER_LEVEL_UP")
	self:RegisterEvent("SPELLS_CHANGED")
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

function AnkhUp:PLAYER_TALENT_UPDATE()
	self:Debug(1, "PLAYER_TALENT_UPDATE")

	self:UpdateCooldownMax()
end
AnkhUp.CHARACTER_POINTS_CHANGED = AnkhUp.PLAYER_TALENT_UPDATE

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
			self:Show()
		end
	end
end

------------------------------------------------------------------------

function AnkhUp:SPELLS_CHANGED()
	self:Debug(1, "SPELLS_CHANGED")

	if not IsSpellKnown(20608) then
		self:Debug(1, "Reincarnation not learned yet")
		return
	end

	self:UnregisterEvent("SPELLS_CHANGED")
	self:UnregisterEvent("SPELL_LEARNED_IN_TAB")

	if not self.dataObject then
		self:CreateDataObject()
	end

	if db.frameShow and not self.displayFrame then
		self:CreateDisplayFrame()
	end

	self:RegisterEvent("BAG_UPDATE")
	self:RegisterEvent("CHARACTER_POINTS_CHANGED")
	self:RegisterEvent("GLYPH_CHANGED")
	self:RegisterEvent("GLYPH_ADDED")
	self:RegisterEvent("GLYPH_REMOVED")
	self:RegisterEvent("MERCHANT_SHOW")
	self:RegisterEvent("PLAYER_ALIVE")
	self:RegisterEvent("PLAYER_TALENT_UPDATE")
	self:RegisterEvent("PLAYER_LEAVING_WORLD")
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED")

	self:BAG_UPDATE()

	self:UpdateCooldownMax()

	local start, duration = GetSpellCooldown(L["Reincarnation"])
	if start and duration and start > 0 and duration > 0 then
		self:Debug(1, "Reincarnation is on cooldown.")
		cooldownStart = start
		db.lastReincarnation = time() - (GetTime() - start)
		self:Show()
	end

	self:Debug(1, "numAnkhs = %d, cooldown = %d, cooldownMax = %d", numAnkhs, cooldown, cooldownMax)

	self:UpdateText()
end
AnkhUp.SPELL_LEARNED_IN_TAB = AnkhUp.SPELLS_CHANGED

------------------------------------------------------------------------

function AnkhUp:CreateDataObject()
	if self.dataObject then return end
	self:Debug(1, "CreateDataObject")

	self.dataObject = LibStub("LibDataBroker-1.1"):NewDataObject("AnkhUp", {
		type  = "data source",
		icon  = "Interface\\AddOns\\AnkhUp\\Ankh",
		label = L["AnkhUp"],
		text  = L["Unknown"],
		OnClick = function(this, button)
			if button == "RightButton" then
				InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
			end
		end,
		OnTooltipShow = function(tooltip)
			self:UpdateTooltip(tooltip)
		end,
	})
end

function AnkhUp:CreateDisplayFrame()
	if self.displayFrame then return end
	self:Debug(1, "CreateDisplayFrame")

	local DataBroker = LibStub("LibDataBroker-1.1")

	local curr
	local objects = { }

	self.displayFrame = CreateFrame("Button", nil, UIParent)
	self.displayFrame:SetFrameStrata("BACKGROUND")
	self.displayFrame:SetWidth(110)
	self.displayFrame:SetHeight(32)

	self.displayFrame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})

	self.displayFrame.icon = self.displayFrame:CreateTexture(nil, "ARTWORK")
	self.displayFrame.icon:SetPoint("LEFT", 4, 0)
	self.displayFrame.icon:SetWidth(24)
	self.displayFrame.icon:SetHeight(24)
	self.displayFrame.icon:SetTexture("Interface\\AddOns\\AnkhUp\\Ankh")

	self.displayFrame.text = self.displayFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	self.displayFrame.text:SetPoint("LEFT", self.displayFrame.icon, "RIGHT", 4, 0)
	self.displayFrame.text:SetPoint("RIGHT", -8, 0)
	self.displayFrame.text:SetHeight(24)
	self.displayFrame.text:SetJustifyH("RIGHT")
	self.displayFrame.text:SetShadowOffset(1, -1)

	-- GetTooltipAnchor function by Tekkub
	local function GetTooltipAnchor(frame)
		local x, y = frame:GetCenter()
		if not x or not y then return "TOPLEFT", "BOTTOMLEFT" end
		local hhalf = (x > UIParent:GetWidth() * 2 / 3) and "RIGHT" or (x < UIParent:GetWidth() / 3) and "LEFT" or ""
		local vhalf = (y > UIParent:GetHeight() / 2) and "TOP" or "BOTTOM"
		return vhalf..hhalf, frame, (vhalf == "TOP" and "BOTTOM" or "TOP")..hhalf
	end

	self.displayFrame:SetScript("OnEnter", function(self)
		if curr and objects[curr] and objects[curr].OnTooltipShow then
			GameTooltip:SetOwner(self, GetTooltipAnchor(self))
			objects[curr].OnTooltipShow(GameTooltip)
			GameTooltip:Show()
		end
	end)

	self.displayFrame:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)

	self.displayFrame:RegisterForClicks("AnyUp")

	self.displayFrame:SetScript("OnClick", function(self, button)
		if curr and objects[curr] and objects[curr].OnClick then
			GameTooltip:Hide()
			objects[curr].OnClick(self, button)
		end
	end)

	self.displayFrame:SetMovable(true)
	self.displayFrame:SetClampedToScreen(true)
	self.displayFrame:RegisterForDrag("LeftButton")

	self.displayFrame:SetScript("OnDragStart", function(self)
		if db.frameLock then return end

		self:GetScript("OnLeave")(self)
		self:StartMoving()
	end)

	self.displayFrame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		if db.frameLock then return end

		local scale = self:GetScale()
		local left, top = self:GetLeft() * scale, self:GetTop() * scale
		local right, bottom = self:GetRight() * scale, self:GetBottom() * scale
		local pwidth, pheight = UIParent:GetWidth(), UIParent:GetHeight()

		local x, y, point
		if left < (pwidth - right) and left < abs((left + right) / 2 - pwidth / 2) then
			x = left
			point = "LEFT"
		elseif (pwidth - right) < abs((left + right) / 2 - pwidth / 2) then
			x = right - pwidth
			point = "RIGHT"
		else
			x = (left + right) / 2 - pwidth / 2
			point = ""
		end

		if bottom < (pheight - top) and bottom < abs((bottom + top) / 2 - pheight / 2) then
			y = bottom
			point = "BOTTOM" .. point
		elseif (pheight - top) < abs((bottom + top) / 2 - pheight / 2) then
			y = top - pheight
			point = "TOP" .. point
		else
			y = (bottom + top) / 2 - pheight / 2
		end

		if point == "" then
			point = "CENTER"
		end

		db.frameX = x
		db.frameY = y
		db.framePoint = point
		db.frameScale = scale

		self:ClearAllPoints()
		self:SetPoint(point, UIParent, x / scale, y / scale)

		if self:IsMouseOver() then
			self:GetScript("OnEnter")(self)
		end
	end)

	self.displayFrame:SetScript("OnHide", function(self)
		self:StopMovingOrSizing()
	end)

	self.displayFrame:SetScript("OnShow", function(self)
		AnkhUp:UpdateText()
		self.text:SetText(AnkhUp.dataObject.text)
	end)

	local function updateDisplay(event, name, attr, value, dataobj)
		if type(event) == "table" then
			dataobj = event
		end
		if dataobj == objects[curr] then
			self.displayFrame.text:SetText(dataobj.text)
		end
	end

	function self.displayFrame:RegisterObject(name)
		assert(DataBroker:GetDataObjectByName(name), "AnkhUp: '"..name.."' is not a valid data object")
		tinsert(objects, DataBroker:GetDataObjectByName(name))
		DataBroker.RegisterCallback(self, "LibDataBroker_AttributeChanged_" .. name .. "_text", updateDisplay)
		curr = #objects
	end

	self.displayFrame:RegisterObject("AnkhUp")

	self.displayFrame:SetScale(db.frameScale)
	self.displayFrame:SetPoint(db.framePoint, UIParent, db.frameX / db.frameScale, db.frameY / db.frameScale)

	self.displayFrame:SetBackdropColor(0, 0, 0, 0.9 * db.frameAlpha)
	self.displayFrame:SetBackdropBorderColor(0.6, 0.6, 0.6, db.frameAlpha)

	if db.frameShow then
		self.displayFrame:Show()
	else
		self.displayFrame:Hide()
	end
end

------------------------------------------------------------------------

function AnkhUp:Debug(lvl, str, ...)
	if lvl > 3 then return end
	if ... then
		if str:match("%%") then str = str:format(...) else str = string.join(", ", str, ...) end
	end
	print(("|cffffcc00[DEBUG] AnkhUp:|r %s"):format(str))
end

function AnkhUp:Print(str, ...)
	if ... then
		if str:match("%%") then str = str:format(...) else str = string.join(", ", str, ...) end
	end
	print(("|cff00ddbaAnkhUp:|r %s"):format(str))
end

------------------------------------------------------------------------