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
	local db
	local shown
	local cache = { }

	local L = AnkhUp.L

	self.CreateCheckbox = LibStub:GetLibrary("PhanxConfig-Checkbox").CreateCheckbox
	self.CreateSlider = LibStub:GetLibrary("PhanxConfig-Slider").CreateSlider

	-------------------------------------------------------------------

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

	-------------------------------------------------------------------

	local low = self:CreateSlider(L["Low ankh warning"], 0, 20, 1)
	low.hint = L["Show a warning dialog when you have fewer than this number of ankhs (set to 0 to disable)"]
	low:GetParent():SetPoint("TOPLEFT", notes, "BOTTOMLEFT", 6, -8)
	low:SetScript("OnValueChanged", function(self)
		local value = math.floor(self:GetValue() + 0.5)
		self.value:SetText(value)
		db.low = value
		AnkhUp:BAG_UPDATE()
	end)

	-------------------------------------------------------------------

	local buy = self:CreateSlider(L["Restock ankhs"], 0, 20, 1)
	buy.hint = L["Restock ankhs up to a total of this number when interacting with vendors (set to 0 to disable)"]
	buy:GetParent():SetPoint("TOPLEFT", low, "BOTTOMLEFT", 0, -8)
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

	-------------------------------------------------------------------

	local quiet = self:CreateCheckbox(L["Notify when restocking"])
	quiet.hint = L["Enable notification in the chat frame when restocking ankhs"]
	quiet:SetPoint("TOPLEFT", buy, "BOTTOMLEFT", -4, -12)
	quiet:SetScript("OnClick", function(self)
		local checked = self:GetChecked() and true or false
		PlaySound(checked and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
		db.quiet = not checked
	end)

	-------------------------------------------------------------------

	local ready = self:CreateCheckbox(L["Notify when ready"])
	ready.hint = L["Enable notification in the raid warning frame when Reincarnation becomes ready"]
	ready:SetPoint("TOPLEFT", quiet, "BOTTOMLEFT", 0, -8)
	ready:SetScript("OnClick", function(self)
		local checked = self:GetChecked() and true or false
		PlaySound(checked and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
		db.ready = checked
	end)

	-------------------------------------------------------------------

	local show = self:CreateCheckbox(L["Show monitor"])
	show.hint = L["Show a standalone monitor window for your Reincarnation cooldown"]
	show:SetPoint("TOP", notes, "BOTTOM", 0, -16)
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

	-------------------------------------------------------------------

	local show = self:CreateCheckbox(L["Lock monitor"])
	show.hint = L["Lock the monitor window in place, preventing dragging"]
	show:SetPoint("TOP", notes, "BOTTOM", 0, -16)
	show:SetScript("OnClick", function(self)
		local checked = self:GetChecked() and true or false
		PlaySound(checked and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
		db.frame.lock = checked
	end)

	-------------------------------------------------------------------

	local scale = self:CreateSlider("Scale", 0.05, 3, 0.05, true)
	scale.hint = L["Adjust the size of the monitor window"]
	scale:GetParent():SetPoint("TOPLEFT", show, "BOTTOMLEFT", 4, -12)
	scale:SetScript("OnValueChanged", function(self)
		local value = math.floor(self:GetValue() * 100 + 0.5) / 100
		db.frame.scale = value
		scale.value:SetFormattedText("%.0f%%", value * 100)
		AnkhUpFrame:SetScale(value)
	end)

end)

------------------------------------------------------------------------

AnkhUp.configPanel = panel

InterfaceOptions_AddCategory(panel)

LibStub("tekKonfig-AboutPanel").new(panel.name, "AnkhUp")

SLASH_ANKHUP1 = "/ankhup"
SLASH_ANKHUP2 = "/aup"
SlashCmdList.ANKHUP = function() InterfaceOptionsFrame_OpenToCategory(panel) end

------------------------------------------------------------------------