--[[--------------------------------------------------------------------
	AnkhUp
	A shaman Reincarnation monitor and ankh management helper
	by Phanx < addons@phanx.net >
	http://www.wowinterface.com/downloads/info6330-AnkhUp.html
	Copyright ©2006–2009 Alyssa "Phanx" Kinley
	See included README for license terms and additional information.

	This file provides a configuration GUI for AnkhUp.
----------------------------------------------------------------------]]

assert(AnkhUp, "AnkhUp not found!")

------------------------------------------------------------------------

local Options = CreateFrame("Frame", nil, UIParent)
Options.name = GetAddOnMetadata("AnkhUp", "Title")
Options:Hide()

Options:SetScript("OnShow", function(self)
	local AnkhUp = AnkhUp
	local db = AnkhUpDB
	local L = AnkhUp.L

	self.CreateCheckbox = LibStub:GetLibrary("PhanxConfig-Checkbox").CreateCheckbox
	self.CreateSlider = LibStub:GetLibrary("PhanxConfig-Slider").CreateSlider

	local title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetPoint("TOPRIGHT", -16, -16)
	title:SetText(self.name)

	local notes = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	notes:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	notes:SetPoint("TOPRIGHT", title, "BOTTOMRIGHT", 0, -8)
	notes:SetHeight(32)
	notes:SetJustifyH("LEFT")
	notes:SetJustifyV("TOP")
	notes:SetNonSpaceWrap(true)
	notes:SetText(L["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."])

	local ready = self:CreateCheckbox(L["Notify when ready"])
	ready.hint = L["Enable notification in the raid warning frame when Reincarnation becomes ready"]
	ready:SetPoint("TOPLEFT", notes, "BOTTOMLEFT", 0, -16)
	ready:SetChecked(db.ready)
	ready:SetScript("OnClick", function(self)
		local checked = self:GetChecked() and true or false
		PlaySound(checked and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
		db.ready = checked
	end)

	local quiet = self:CreateCheckbox(L["Notify when restocking"])
	quiet.hint = L["Enable notification in the chat frame when restocking ankhs."]
	quiet:SetPoint("TOPLEFT", ready, "BOTTOMLEFT", 0, -8)
	quiet:SetChecked(db.checked)
	quiet:SetScript("OnClick", function(self)
		local checked = self:GetChecked() and true or false
		PlaySound(checked and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
		db.quiet = not checked
	end)

	local low = self:CreateSlider(L["Warning threshold"], 0, 20, 5)
	low.hint = L["Show a warning dialog when you have fewer than this number of ankhs. Set to 0 to disable the warning."]
	low.container:SetPoint("TOPLEFT", quiet, "BOTTOMLEFT", 2, -8)
	low.container:SetPoint("TOPRIGHT", notes, "BOTTOM", -10, -16 - ready:GetHeight() - 8 - quiet:GetHeight() - 8)
	low.value:SetText(db.low)
	low:SetValue(db.low)
	low:SetScript("OnValueChanged", function(self)
		local value = math.floor(self:GetValue() + 0.5)
		self.value:SetText(value)
		db.low = value
		AnkhUp:BAG_UPDATE()
	end)

	local buy = self:CreateSlider(L["Restock quantity"], 0, 20, 5)
	buy.hint = L["Restock ankhs up to a total of this number when interacting with vendors. Set to 0 to disable restocking."]
	buy.container:SetPoint("TOPLEFT", low.container, "BOTTOMLEFT", 0, -8)
	buy.container:SetPoint("TOPRIGHT", low.container, "BOTTOMRIGHT", 0, -8)
	buy.value:SetText(db.buy)
	buy:SetValue(db.buy)
	buy:SetScript("OnValueChanged", function(self)
		local value = math.floor(self:GetValue() + 0.5)
		self.value:SetText(value)
		db.buy = value
		if value > 0 then
			AnkhUp:RegisterEvent("MERCHANT_SHOW")
		else
			AnkhUp:UnregisterEvent("MERCHANT_SHOW")
		end
	end)

	local show = self:CreateCheckbox(L["Show monitor"])
	show.hint = L["Show a standalone monitor window for your Reincarnation cooldown."]
	show:SetPoint("TOPLEFT", notes, "BOTTOM", 0, -16)
	show:SetChecked(db.frame.show)
	show:SetScript("OnClick", function(self)
		local checked = self:GetChecked() and true or false
		PlaySound(checked and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
		db.frame.show = checked
		if checked then
			AnkhUpFrame:Show()
		else
			AnkhUpFrame:Hide()
		end
	end)

	local lock = self:CreateCheckbox(L["Lock monitor"])
	lock.hint = L["Lock the monitor window in place, preventing dragging."]
	lock:SetPoint("TOPLEFT", show, "BOTTOMLEFT", 0, -8)
	lock:SetChecked(db.frame.lock)
	lock:SetScript("OnClick", function(self)
		local checked = self:GetChecked() and true or false
		PlaySound(checked and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
		db.frame.lock = checked
	end)

	local scale = self:CreateSlider(L["Monitor scale"], 0.5, 2, 0.05, true)
	scale.hint = L["Adjust the size of the monitor window."]
	scale.container:SetPoint("TOPLEFT", lock, "BOTTOMLEFT", 2, -8)
	scale.container:SetPoint("TOPRIGHT", notes, "BOTTOMLEFT", -2, -16 - show:GetHeight() - 8 - lock:GetHeight() - 8)
	scale.value:SetFormattedText("%.0f%%", db.frame.scale * 100)
	scale:SetValue(db.frame.scale)
	scale:SetScript("OnValueChanged", function(self)
		local value = math.floor(self:GetValue() * 100 + 0.5) / 100
		db.frame.scale = value
		scale.value:SetFormattedText("%.0f%%", value * 100)
		AnkhUpFrame:SetScale(value)
	end)

	self:SetScript("OnShow", nil)
end)

------------------------------------------------------------------------

AnkhUp.configPanel = Options

InterfaceOptions_AddCategory(Options)

LibStub:GetLibrary("tekKonfig-AboutPanel").new(Options.name, "AnkhUp")

SLASH_ANKHUP1 = "/ankhup"
SLASH_ANKHUP2 = "/aup"
SlashCmdList.ANKHUP = function() InterfaceOptionsFrame_OpenToCategory(Options) end

------------------------------------------------------------------------