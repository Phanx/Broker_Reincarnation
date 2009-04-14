--[[--------------------------------------------------------------------
	AnkhUp: a shaman Reincarnation monitor
	by Phanx <addons@phanx.net>
	http://www.wowinterface.com/downloads/info6330-AnkhUp.html
	Copyright (c) 2005-2009 Alyssa S. Kinley, a.k.a. Phanx
	See included README for license terms and additional information.
----------------------------------------------------------------------]]

if not AnkhUp then return end

------------------------------------------------------------------------

local CreateCheckbox
do
	local function OnEnter(self)
		if self.hint then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.hint, nil, nil, nil, nil, true)
		end
	end

	local function OnLeave()
		GameTooltip:Hide()
	end

	function CreateCheckbox(parent, text, size)
		local check = CreateFrame("CheckButton", nil, parent)
		check:SetWidth(size or 26)
		check:SetHeight(size or 26)

		check:SetHitRectInsets(0, -100, 0, 0)

		check:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
		check:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
		check:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
		check:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
		check:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")

		check:SetScript("OnEnter", OnEnter)
		check:SetScript("OnLeave", OnLeave)

		check:SetScript("OnClick", Checkbox_OnClick)

		local label = check:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		label:SetPoint("LEFT", check, "RIGHT", 0, 1)
		label:SetText(text)

		check.label = label

		return check
	end
end

------------------------------------------------------------------------

local CreateSlider
do
	local function OnEnter(self)
		if self.hint then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.hint, nil, nil, nil, nil, true)
		end
	end

	local function OnLeave()
		GameTooltip:Hide()
	end

	local function OnMouseWheel(self, delta)
		local step = self:GetValueStep() * delta
		local minValue, maxValue = self:GetMinMaxValues()

		if step > 0 then
			self:SetValue(min(self:GetValue() + step, maxValue))
		else
			self:SetValue(max(self:GetValue() + step, minValue))
		end
	end

	local sliderBG = {
		bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
		edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
		edgeSize = 8, tile = true, tileSize = 8,
		insets = { left = 3, right = 3, top = 6, bottom = 6 }
	}

	function CreateSlider(parent, name, lowvalue, highvalue, valuestep, percent)
		local frame = CreateFrame("Frame", nil, parent)
		frame:SetWidth(144)
		frame:SetHeight(42)

		local slider = CreateFrame("Slider", nil, frame)
		slider:SetPoint("LEFT")
		slider:SetPoint("RIGHT")
		slider:SetHeight(17)
		slider:SetHitRectInsets(0, 0, -10, -10)
		slider:SetOrientation("HORIZONTAL")
		slider:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
		slider:SetBackdrop(sliderBG)

		local label = slider:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		label:SetPoint("BOTTOMLEFT", slider, "TOPLEFT")
		label:SetPoint("BOTTOMRIGHT", slider, "TOPRIGHT")
		label:SetJustifyH("LEFT")
		label:SetText(name)

		local low = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		low:SetPoint("TOPLEFT", slider, "BOTTOMLEFT", -4, 3)
		if percent then
			low:SetFormattedText("%.0f%%", lowvalue * 100)
		else
			low:SetText(lowvalue)
		end

		local high = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		high:SetPoint("TOPRIGHT", slider, "BOTTOMRIGHT", 4, 3)
		if percent then
			high:SetFormattedText("%.0f%%", highvalue * 100)
		else
			high:SetText(highvalue)
		end

		local value = slider:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		value:SetPoint("TOP", slider, "BOTTOM", 0, 3)
		value:SetTextColor(1, 0.8, 0)

		slider:SetMinMaxValues(lowvalue, highvalue)
		slider:SetValueStep(valuestep or 1)

		slider:EnableMouseWheel(true)
		slider:SetScript("OnMouseWheel", OnMouseWheel)
		slider:SetScript("OnEnter", OnEnter)
		slider:SetScript("OnLeave", OnLeave)

		slider.label = label
		slider.low = low
		slider.high = high
		slider.value = value

		return slider
	end
end

------------------------------------------------------------------------

local db
local shown
local cache = { }
local L = AnkhUp.L

local panel = CreateFrame("Frame", nil, UIParent)
panel.name = GetAddOnMetadata("AnkhUp", "Title")
panel:Hide()

------------------------------------------------------------------------

local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetPoint("TOPRIGHT", -16, -16)
title:SetText(panel.name)

local notes = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
notes:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
notes:SetPoint("TOPRIGHT", title, "BOTTOMRIGHT", 0, -8)
notes:SetHeight(32)
notes:SetJustifyH("LEFT")
notes:SetJustifyV("TOP")
notes:SetNonSpaceWrap(true)
notes:SetText(L["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."])

------------------------------------------------------------------------

local low = CreateSlider(panel, L["Low ankh warning"], 0, 20, 1)
low.hint = L["Show a warning dialog when you have fewer than this number of ankhs. Set to 0 to disable the warning."]
low:GetParent():SetPoint("TOPLEFT", notes, "BOTTOMLEFT", 6, -8)
low:SetScript("OnValueChanged", function(self)
	local value = math.floor(self:GetValue() + 0.5)
	self.value:SetText(value)
	db.low = value
	AnkhUp:BAG_UPDATE()
end)

------------------------------------------------------------------------

local buy = CreateSlider(panel, L["Restock ankhs"], 0, 20, 1)
buy.hint = L["Restock ankhs up to a total of this number when interacting with vendors. Set to 0 to disable restocking."]
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

------------------------------------------------------------------------

local quiet = CreateCheckbox(panel, L["Notify when restocking"])
quiet.hint = L["Enable notification in the chat frame when restocking ankhs."]
quiet:SetPoint("TOPLEFT", buy, "BOTTOMLEFT", -4, -12)
quiet:SetScript("OnClick", function(self)
	local checked = self:GetChecked() and true or false
	PlaySound(checked and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
	db.quiet = not checked
end)

------------------------------------------------------------------------

local ready = CreateCheckbox(panel, L["Notify when ready"])
ready.hint = L["Enable notification in the raid warning frame when Reincarnation becomes ready."]
ready:SetPoint("TOPLEFT", quiet, "BOTTOMLEFT", 0, -8)
ready:SetScript("OnClick", function(self)
	local checked = self:GetChecked() and true or false
	PlaySound(checked and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
	db.ready = checked
end)

------------------------------------------------------------------------

local show = CreateCheckbox(panel, L["Show monitor"])
show.hint = L["Show a small, movable monitor window for your Reincarnation cooldown."]
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

------------------------------------------------------------------------

local scale = CreateSlider(panel, "Scale", 0.05, 3, 0.05, true)
scale.hint = L["Adjust the size of the monitor window"]
scale:GetParent():SetPoint("TOPLEFT", show, "BOTTOMLEFT", 4, -12)
scale:SetScript("OnValueChanged", function(self)
	local value = math.floor(self:GetValue() * 100 + 0.5) / 100
	db.frame.scale = value
	scale.value:SetFormattedText("%.0f%%", value * 100)
	AnkhUpFrame:SetScale(value)
end)

------------------------------------------------------------------------

panel:SetScript("OnShow", function(self)
	if not db then db = AnkhUpDB end

	cache.low = db.low
	cache.buy = db.buy
	cache.quiet = db.quiet
	cache.ready = db.ready
	cache.show = db.frame.show
	cache.scale = db.frame.scale

	low:SetValue(db.low)
	low.value:SetText(db.low)

	buy:SetValue(db.buy)
	buy.value:SetText(db.buy)

	quiet:SetChecked(not db.quiet)

	ready:SetChecked(db.ready)

	show:SetChecked(db.frame.show)

	scale:SetValue(db.frame.scale)
	scale.value:SetFormattedText("%.0f%%", db.frame.scale * 100)

	shown = true
end)

------------------------------------------------------------------------

panel.okay = function()
	if not shown then return end

	wipe(cache)
	shown = false
end

------------------------------------------------------------------------

panel.cancel = function()
	if not shown then return end

	if db.low ~= cache.low then
		db.low = cache.low
		low:SetValue(db.low)
		low:GetScript("OnValueChanged")(low)
	end

	if db.buy ~= cache.buy then
		db.buy = cache.buy
		buy:SetValue(db.buy)
		buy:GetScript("OnValueChanged")(buy)
	end
	
	if db.quiet ~= cache.quiet then
		db.quiet = cache.quiet
		quiet:SetChecked(db.quiet)
		quiet:GetScript("OnClick")(quiet)
	end
	
	if db.ready ~= cache.ready then
		db.ready = cache.ready
		ready:SetChecked(db.ready)
		ready:GetScript("OnClick")(ready)
	end
	
	if db.frame.show ~= cache.show then
		db.frame.show = cache.show
		show:SetChecked(db.frame.show)
		show:GetScript("OnClick")(show)
	end
	
	if db.frame.scale ~= cache.scale then
		db.frame.scale = cache.scale
		scale:SetValue(db.frame.scale)
		scale:GetScript("OnValueChanged")(buy)
	end

	wipe(cache)
	shown = false
end

------------------------------------------------------------------------

panel.defaults = function()
	if db.low ~= 5 then
		db.low = 5
		low:SetValue(db.low)
		low:GetScript("OnValueChanged")(low)
	end

	if db.buy ~= 0 then
		db.buy = 0
		buy:SetValue(db.buy)
		buy:GetScript("OnValueChanged")(buy)
	end
	
	if db.quiet ~= false then
		db.quiet = false
		quiet:SetChecked(db.quiet)
		quiet:GetScript("OnClick")(quiet)
	end
	
	if db.ready ~= true then
		db.ready = true
		ready:SetChecked(db.ready)
		ready:GetScript("OnClick")(ready)
	end
	
	if db.frame.show ~= true then
		db.frame.show = true
		show:SetChecked(db.frame.show)
		show:GetScript("OnClick")(show)
	end
	
	if db.frame.scale ~= 1 then
		db.frame.scale = 1
		scale:SetValue(db.frame.scale)
		scale:GetScript("OnValueChanged")(buy)
	end

	if shown then
		cache.low = 5
		cache.buy = 0
		cache.quiet = false
		cache.ready = true
		cache.show = true
		cache.scale = 1
	end
end

------------------------------------------------------------------------

AnkhUp.configPanel = panel
InterfaceOptions_AddCategory(panel)
LibStub("tekKonfig-AboutPanel").new(panel.name, "AnkhUp")

SLASH_ANKHUP1 = "/ankhup"
SLASH_ANKHUP2 = "/aup"
SlashCmdList.ANKHUP = function()
	InterfaceOptionsFrame_OpenToCategory(panel)
end

------------------------------------------------------------------------