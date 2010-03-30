--[[--------------------------------------------------------------------
	AnkhUp
	Reincarnation cooldown monitor shamans
	by Phanx < addons@phanx.net >
	Copyright © 2006–2010 Alyssa "Phanx" Kinley
	http://www.wowinterface.com/downloads/info6330-AnkhUp.html
	http://wow.curse.com/downloads/wow-addons/details/ankhup.aspx
----------------------------------------------------------------------]]

if select(2, UnitClass("player")) ~= "SHAMAN" then return end

local ADDON_NAME, ns = ...
local AnkhUp = ns.AnkhUp

AnkhUp.optionsFrame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
AnkhUp.optionsFrame.name = GetAddOnMetadata(ADDON_NAME, "Title")
AnkhUp.optionsFrame:Hide()

AnkhUp.optionsFrame:SetScript("OnShow", function(self)
	local db = AnkhUpDB
	local L = ns.L

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

	--
	--	db.readyAlert (boolean)
	--

	local readyAlert = self:CreateCheckbox(L["Notify when ready"])
	readyAlert:SetPoint("TOPLEFT", notes, "BOTTOMLEFT", 0, -16)

	readyAlert:SetChecked(db.readyAlert)

	readyAlert.desc = L["Notify you with a raid warning message when Reincarnation's cooldown finishes."]
	readyAlert.OnClick = function(self, checked)
		db.readyAlert = checked
	end

	--
	--	db.buyAlert (boolean)
	--

	local buyAlert = self:CreateCheckbox(L["Notify when buying"])
	buyAlert:SetPoint("TOPLEFT", readyAlert, "BOTTOMLEFT", 0, -8)

	buyAlert:SetChecked(db.buyAlert)

	buyAlert.desc = L["Notify you with a chat message when automatically buying ankhs."]
	buyAlert.OnClick = function(self, checked)
		db.buyAlert = checked
	end

	--
	--	db.buy (number)
	--

	local buy = self:CreateSlider(L["Buy quantity"], 0, 20, 5)
	buy.container:SetPoint("TOPLEFT", buyAlert, "BOTTOMLEFT", 2, -8)
	buy.container:SetPoint("TOPRIGHT", notes, "BOTTOM", -10, -16 - readyAlert:GetHeight() - 8 - buyAlert:GetHeight() - 8)

	buy:SetValue(db.buy)
	buy.valueText:SetText(db.buy)

	buy.desc = L["Buy ankhs up to a total of this number when interacting with vendors. Set to 0 to disable this feature."]
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

	--
	--	db.low (number)
	--

	local low = self:CreateSlider(L["Low ankh quantity"], 0, 20, 5)
	low.container:SetPoint("TOPLEFT", buy.container, "BOTTOMLEFT", 0, -8)
	low.container:SetPoint("TOPRIGHT", buy.container, "BOTTOMRIGHT", -0, -8)

	low:SetValue(db.low)
	low.valueText:SetText(db.low)

	low.desc = L["Show a warning dialog when you have fewer than this number of ankhs. Set to 0 to disable this feature."]
	low.OnValueChanged = function(self, value)
		value = math.floor(value + 0.5)
		db.low = value
		return value
	end

	--
	--	db.frameShow (boolean)
	--

	local frameShow = self:CreateCheckbox(L["Show monitor window"])
	frameShow:SetPoint("TOPLEFT", notes, "BOTTOM", 8, -16)

	frameShow:SetChecked(db.frameShow)

	frameShow.desc = L["Show a standalone monitor window for your Reincarnation cooldown."]
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

	--
	--	db.frameLock (boolean)
	--

	local frameLock = self:CreateCheckbox(L["Lock monitor window"])
	frameLock:SetPoint("TOPLEFT", frameShow, "BOTTOMLEFT", 0, -8)

	frameLock:SetChecked(db.frameLock)

	frameLock.desc = L["Lock the monitor window in place, preventing dragging."]
	frameLock.OnClick = function(self, checked)
		db.frameLock = checked
		if checked then
			AnkhUp.displayFrame:SetMovable(false)
		else
			AnkhUp.displayFrame:SetMovable(true)
		end
	end

	--
	--	db.frameScale (number)
	--

	local frameScale = self:CreateSlider(L["Monitor scale"], 0.5, 2, 0.05, true)
	frameScale.container:SetPoint("TOPLEFT", frameLock, "BOTTOMLEFT", 2, -8)
	frameScale.container:SetPoint("RIGHT", notes, "BOTTOMRIGHT", -2, -16 - frameShow:GetHeight() - 8 - frameLock:GetHeight() - 8)

	frameScale:SetValue(db.frameScale)
	frameScale.valueText:SetFormattedText("%.0f%%", db.frameScale * 100)

	frameScale.valueFormat = "%.0f%%"

	frameScale.desc = L["Adjust the size of the monitor window."]
	frameScale.OnValueChanged = function(self, value)
		value = math.floor(value * 100 + 0.5) / 100
		db.frameScale = value
		if AnkhUp.displayFrame then
			AnkhUp.displayFrame:SetScale(value)
			AnkhUp.displayFrame:SetPoint(db.framePoint, UIParent, db.frameX / value, db.frameY / value)
		end
		return value
	end

	--
	--	db.frameAlpha (number)
	--

	local frameAlpha = self:CreateSlider(L["Monitor opacity"], 0, 1, 0.05, true)
	frameAlpha.container:SetPoint("TOPLEFT", frameScale.container, "BOTTOMLEFT", 0, -8)
	frameAlpha.container:SetPoint("TOPRIGHT", frameScale.container, "BOTTOMRIGHT", 0, -8)

	frameAlpha:SetValue(db.frameAlpha)
	frameAlpha.valueText:SetFormattedText("%.0f%%", db.frameAlpha * 100)

	frameAlpha.valueFormat = "%.0f%%"

	frameAlpha.desc = L["Adjust the opacity of the monitor window's background."]
	frameAlpha.OnValueChanged = function(self, value)
		value = math.floor(value * 100 + 0.5) / 100
		db.frameAlpha = value
		if AnkhUp.displayFrame then
			AnkhUp.displayFrame:SetBackdropColor(0, 0, 0, 0.9 * value)
			AnkhUp.displayFrame:SetBackdropBorderColor(0.6, 0.6, 0.6, value)
		end
		return value
	end

	--
	--	That's all!
	--
	LibStub("LibAboutPanel").new(AnkhUp.optionsFrame.name, ADDON_NAME)
	self:SetScript("OnShow", nil)
end)

------------------------------------------------------------------------

InterfaceOptions_AddCategory(AnkhUp.optionsFrame)

SLASH_ANKHUP1 = "/ankhup"
SlashCmdList.ANKHUP = function()
	InterfaceOptionsFrame_OpenToCategory(AnkhUp.optionsFrame)
end

------------------------------------------------------------------------