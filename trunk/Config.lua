--[[--------------------------------------------------------------------
	AnkhUp
	Reincarnation cooldown monitor shamans
	by Phanx < addons@phanx.net >
	Copyright © 2006–2009 Alyssa "Phanx" Kinley
	http://www.wowinterface.com/downloads/info6330-AnkhUp.html
	http://wow.curse.com/downloads/wow-addons/details/ankhup.aspx
----------------------------------------------------------------------]]

local ADDON_NAME, AnkhUp = ...
if select(2, UnitClass("player")) ~= "SHAMAN" then return end

AnkhUp.optionsFrame = CreateFrame("Frame", nil, UIParent)
AnkhUp.optionsFrame.name = GetAddOnMetadata(ADDON_NAME, "Title")
AnkhUp.optionsFrame:Hide()

AnkhUp.optionsFrame:SetScript("OnShow", function(self)
	local AnkhUp = AnkhUp
	local db = AnkhUp.db
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

	--
	--	db.readyAlert (boolean)
	--

	local readyAlert = self:CreateCheckbox(L["Notify when Reincarnation is ready"])
	readyAlert:SetPoint("TOPLEFT", notes, "BOTTOMLEFT", 0, -16)

	readyAlert:SetChecked(db.readyAlert)

	readyAlert.desc = L["Add a message to the raid warning frame when Reincarnation's cooldown finishes."]
	readyAlert.func = function(self, checked)
		db.readyAlert = checked
	end

	--
	--	db.buyAlert (boolean)
	--

	local buyAlert = self:CreateCheckbox(L["Notify when restocking ankhs"])
	buyAlert:SetPoint("TOPLEFT", readyAlert, "BOTTOMLEFT", 0, -8)

	buyAlert:SetChecked(db.buyAlert)

	buyAlert.hint = L["Add a message to the chat frame when automatically restocking your ankhs."]
	buyAlert.func = function(self, checked)
		db.buyAlert = checked
	end)

	--
	--	db.low (number)
	--

	local low = self:CreateSlider(L["Low ankh warning threshold"], 0, 20, 5)
	low.container:SetPoint("TOPLEFT", readyAlert, "BOTTOMLEFT", 0, -8)
	low.container:SetPoint("TOPRIGHT", notes, "BOTTOM", -8, -16 - readyAlert:GetHeight() - 8 - buyAlert():GetHeight() - 8)

	low:SetValue(db.low)
	low.valueText:SetText(db.low)

	low.desc = L["Show a warning dialog when you have fewer than this number of ankhs. Set to 0 to disable the warning."]
	low.func = function(self, value)
		value = math.floor(value + 0.5)
		self.value:SetText(value)
		db.low = value
		return value
	end)

	--
	--	db.buy (number)
	--

	local buy = self:CreateSlider(L["Restock quantity"], 0, 20, 5)
	buy.container:SetPoint("TOPLEFT", low.container, "BOTTOMLEFT", 0, -8)
	buy.container:SetPoint("TOPRIGHT", low.container, "BOTTOMRIGHT", 0, -8)

	buy:SetValue(db.buy)
	buy.valueText:SetText(db.buy)

	buy.desc = L["Restock ankhs up to a total of this number when interacting with vendors. Set to 0 to disable restocking."]
	buy.func = function(self, value)
		value = math.floor(value + 0.5)
		db.buy = value
		if value > 0 then
			AnkhUp:RegisterEvent("MERCHANT_SHOW")
		else
			AnkhUp:UnregisterEvent("MERCHANT_SHOW")
		end
		return value
	end)

	--
	--	db.frameShow (boolean)
	--

	local frameShow = self:CreateCheckbox(L["Show monitor window"])
	frameShow:SetPoint("TOPLEFT", notes, "BOTTOM", 8, -16)

	frameShow:SetChecked(db.frameShow)

	frameShow.hint = L["Show a standalone monitor window for your Reincarnation cooldown."]
	frameShow.func = function(self, checked)
		db.frameShow = checked
		if checked then
			if AnkhUp.displayFrame then
				AnkhUp.displayFrame:Show()
			else
				AnkhUp:CreateDisplayFrame()
			end
		else
			AnkhUp.displayFrame:Hide()
		end
	end)

	--
	--	db.frameLock (boolean)
	--

	local frameLock = self:CreateCheckbox(L["Lock monitor window"])
	frameLock:SetPoint("TOPLEFT", frameShow, "BOTTOMLEFT", 0, -8)

	frameLock:SetChecked(db.frameLock)

	frameLock.hint = L["Lock the monitor window in place, preventing dragging."]
	frameLock.func = function(self, checked)
		db.frameLock = checked
	end)

	--
	--	db.frameScale (number)
	--

	local frameScale = self:CreateSlider(L["Monitor scale"], 0.5, 2, 0.05, true)
	scale.container:SetPoint("TOPLEFT", lock, "BOTTOMLEFT", 2, -8)
	scale.container:SetPoint("TOPRIGHT", notes, "BOTTOMRIGHT", -2, -16 - frameShow:GetHeight() - 8 - frameLock:GetHeight() - 8)

	scale:SetValue(db.frameScale)
	scale.valueText:SetFormattedText("%.0f%%", db.frameScale * 100)

	scale.valueFormat = "%.0f%%"

	scale.desc = L["Adjust the size of the monitor window."]
	scale.func = function(self, value)
		value = math.floor(value * 100 + 0.5) / 100
		db.frameScale = value
		if AnkhUp.displayFrame then
			AnkhUp.displayFrame:SetScale(value)
			AnkhUp.displayFrame:SetPoint(db.framePoint, UIParent, db.frameX / value, db.frameY / value)
		end
		return value
	end)

	--
	--	That's all!
	--

	LibStub("LibAboutPanel").new(self.name, ADDON_NAME)
	self:SetScript("OnShow", nil)
end)

------------------------------------------------------------------------

InterfaceOptions_AddCategory(AnkhUp.optionsFrame)

SLASH_ANKHUP1 = "/ankhup"
SlashCmdList.ANKHUP = function() InterfaceOptionsFrame_OpenToCategory(AnkhUp.optionsFrame) end

------------------------------------------------------------------------