--[[--------------------------------------------------------------------
	AnkhUp
	Shaman Reincarnation cooldown monitor
	by Phanx < addons@phanx.net >
	Copyright © 2006–2010 Phanx. See README for license terms.
	http://www.wowinterface.com/downloads/info6330-AnkhUp.html
	http://wow.curse.com/downloads/wow-addons/details/ankhup.aspx
----------------------------------------------------------------------]]

if select(2, UnitClass("player")) ~= "SHAMAN" then return end

local ADDON_NAME, ns = ...
local AnkhUp = ns and ns.AnkhUp or _G.AnkhUp

AnkhUp.optionsFrame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
AnkhUp.optionsFrame.name = GetAddOnMetadata("AnkhUp", "Title")
AnkhUp.optionsFrame:Hide()

AnkhUp.optionsFrame:SetScript("OnShow", function(self)
	local db = AnkhUpDB
	local L = AnkhUp.L

	self.CreateCheckbox = LibStub:GetLibrary("PhanxConfig-Checkbox").CreateCheckbox
	self.CreateSlider = LibStub:GetLibrary("PhanxConfig-Slider").CreateSlider

	local title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetPoint("TOPRIGHT", -16, -16)
	title:SetJustifyH("LEFT")
	title:SetText(self.name)

	local notes = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	notes:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	notes:SetPoint("TOPRIGHT", title, "BOTTOMRIGHT", 0, -8)
	notes:SetHeight(32)
	notes:SetJustifyH("LEFT")
	notes:SetJustifyV("TOP")
	notes:SetNonSpaceWrap(true)
	notes:SetText(L["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."])

	--------------------------------------------------------------------

	local readyAlert = self:CreateCheckbox(L["Notify when ready"])
	readyAlert.desc = L["Notify you with a raid warning message when Reincarnation's cooldown finishes."]
	readyAlert:SetPoint("TOPLEFT", notes, "BOTTOMLEFT", 0, -16)
	readyAlert:SetChecked(db.readyAlert)

	readyAlert.OnClick = function(self, checked)
		db.readyAlert = checked
	end

	--------------------------------------------------------------------

	local buyAlert = self:CreateCheckbox(L["Notify when buying"])
	buyAlert.desc = L["Notify you with a chat message when automatically buying ankhs."]
	buyAlert:SetPoint("TOPLEFT", readyAlert, "BOTTOMLEFT", 0, -8)
	buyAlert:SetChecked(db.buyAlert)

	buyAlert.OnClick = function(self, checked)
		db.buyAlert = checked
	end

	--------------------------------------------------------------------

	local buy = self:CreateSlider(L["Buy quantity"], 0, 20, 5)
	buy.desc = L["Buy ankhs up to a total of this number when interacting with vendors. Set to 0 to disable this feature."]
	buy:SetPoint("TOPLEFT", buyAlert, "BOTTOMLEFT", 2, -8)
	buy:SetPoint("TOPRIGHT", notes, "BOTTOM", -10, -16 - readyAlert:GetHeight() - 8 - buyAlert:GetHeight() - 8)
	buy:SetValue(db.buy)

	buy.OnValueChanged = function(self, value)
		value = math.floor(value + 0.5)
		db.buy = value
		if value > 0 then
			AnkhUp:RegisterEvent("MERCHANT_SHOW")
		else
			AnkhUp:UnregisterEvent("MERCHANT_SHOW")
		end
		return value
	end

	--------------------------------------------------------------------

	local low = self:CreateSlider(L["Low ankh quantity"], 0, 20, 5)
	low.desc = L["Show a warning dialog when you have fewer than this number of ankhs. Set to 0 to disable this feature."]
	low:SetPoint("TOPLEFT", buy, "BOTTOMLEFT", 0, -8)
	low:SetPoint("TOPRIGHT", buy, "BOTTOMRIGHT", -0, -8)
	low:SetValue(db.low)

	low.OnValueChanged = function(self, value)
		value = math.floor(value + 0.5)
		db.low = value
		return value
	end

	--------------------------------------------------------------------

	local frameShow = self:CreateCheckbox(L["Show monitor window"])
	frameShow.desc = L["Show a standalone monitor window for your Reincarnation cooldown."]
	frameShow:SetPoint("TOPLEFT", notes, "BOTTOM", 8, -16)
	frameShow:SetChecked(db.frameShow)

	frameShow.OnClick = function(self, checked)
		db.frameShow = checked
		if checked then
			if not AnkhUp.displayFrame then
				AnkhUp:CreateDisplayFrame()
			end
			AnkhUp.displayFrame:Show()
			AnkhUp:UpdateText()
			AnkhUp.displayFrame.text:SetText(AnkhUp.dataObject.text)
		else
			AnkhUp.displayFrame:Hide()
		end
	end

	--------------------------------------------------------------------

	local frameLock = self:CreateCheckbox(L["Lock monitor window"])
	frameLock.desc = L["Lock the monitor window in place, preventing dragging."]
	frameLock:SetPoint("TOPLEFT", frameShow, "BOTTOMLEFT", 0, -8)
	frameLock:SetChecked(db.frameLock)

	frameLock.OnClick = function(self, checked)
		db.frameLock = checked
		if checked then
			AnkhUp.displayFrame:SetMovable(false)
		else
			AnkhUp.displayFrame:SetMovable(true)
		end
	end

	--------------------------------------------------------------------

	local frameScale = self:CreateSlider(L["Monitor scale"], 0.5, 2, 0.05, true)
	frameScale.desc = L["Adjust the size of the monitor window."]
	frameScale:SetPoint("TOPLEFT", frameLock, "BOTTOMLEFT", 2, -8)
	frameScale:SetPoint("RIGHT", notes, "BOTTOMRIGHT", -2, -16 - frameShow:GetHeight() - 8 - frameLock:GetHeight() - 8)
	frameScale:SetValue(db.frameScale)

	frameScale.OnValueChanged = function(self, value)
		value = math.floor(value * 100 + 0.5) / 100
		db.frameScale = value
		if AnkhUp.displayFrame then
			AnkhUp.displayFrame:SetScale(value)
			AnkhUp.displayFrame:SetPoint(db.framePoint, UIParent, db.frameX / value, db.frameY / value)
		end
		return value
	end

	--------------------------------------------------------------------

	local frameAlpha = self:CreateSlider(L["Monitor opacity"], 0, 1, 0.05, true)
	frameAlpha.desc = L["Adjust the opacity of the monitor window's background."]
	frameAlpha:SetPoint("TOPLEFT", frameScale, "BOTTOMLEFT", 0, -8)
	frameAlpha:SetPoint("TOPRIGHT", frameScale, "BOTTOMRIGHT", 0, -8)
	frameAlpha:SetValue(db.frameAlpha)

	frameAlpha.OnValueChanged = function(self, value)
		value = math.floor(value * 100 + 0.5) / 100
		db.frameAlpha = value
		if AnkhUp.displayFrame then
			AnkhUp.displayFrame:SetBackdropColor(0, 0, 0, 0.9 * value)
			AnkhUp.displayFrame:SetBackdropBorderColor(0.6, 0.6, 0.6, value)
		end
		return value
	end

	--------------------------------------------------------------------

	self:SetScript("OnShow", nil)
end)

------------------------------------------------------------------------

InterfaceOptions_AddCategory(AnkhUp.optionsFrame)
LibStub("LibAboutPanel").new("AnkhUp", "AnkhUp")

SLASH_ANKHUP1 = "/ankhup"
SlashCmdList.ANKHUP = function()
	InterfaceOptionsFrame_OpenToCategory(AnkhUp.optionsFrame)
end

------------------------------------------------------------------------