--[[--------------------------------------------------------------------
	AnkhUp
	Reincarnation cooldown monitor for shamans.
	Copyright (c) 2006–2012 Phanx <addons@phanx.net>.
	All rights reserved. See LICENSE.txt for details.
	http://www.wowinterface.com/downloads/info6330-AnkhUp.html
	http://www.curse.com/addons/wow/ankhup
----------------------------------------------------------------------]]

if select(2, UnitClass("player")) ~= "SHAMAN" then
	return
end

local ADDON_NAME, ns = ...

local panel = LibStub("PhanxConfig-OptionsPanel").CreateOptionsPanel(ADDON_NAME, nil, function(self)
	local L = ns.L
	local db = AnkhUpDB
	local AnkhUp = ns.AnkhUp

	local CreateCheckbox = LibStub("PhanxConfig-Checkbox").CreateCheckbox
	local CreateColorPicker = LibStub("PhanxConfig-ColorPicker").CreateColorPicker
	local CreateSlider = LibStub("PhanxConfig-Slider").CreateSlider

	local title, notes = LibStub("PhanxConfig-Header").CreateHeader(self, ADDON_NAME,
		L["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."])

	--------------------
	--	Core options  --
	--------------------

	local readyAlert = CreateCheckbox(self, L["Notify when ready"],
		L["Show a notification message when Reincarnation's cooldown finishes."])
	readyAlert:SetPoint("TOPLEFT", notes, "BOTTOMLEFT", 0, -16)
	readyAlert.OnClick = function(self, checked)
		db.readyAlert = checked
	end

	------------------------------
	--	Monitor window options  --
	------------------------------

	local lock, bg, border, scale

	local show = CreateCheckbox(self, L["Show monitor"],
		L["Show a small movable window to track your Reincarnation cooldown."])
	show:SetPoint("TOPLEFT", notes, "BOTTOM", 8, -16)
	show.OnClick = function(self, checked)
		db.frameShow = checked
		if checked then
			if AnkhUpFrame then
				AnkhUpFrame:Show()
			else
				AnkhUp:CreateFrame()
			end
			lock:Show()
			bg:Show()
			border:Show()
			scale:Show()
		else
			if AnkhUpFrame then
				AnkhUpFrame:Hide()
			end
			lock:Hide()
			bg:Hide()
			border:Hide()
			scale:Hide()
		end
	end

	lock = CreateCheckbox(self, L["Lock monitor"],
		L["Lock the monitor window in place to prevent it from being moved."])
	lock:SetPoint("TOPLEFT", show, "BOTTOMLEFT", 0, -8)
	lock.OnClick = function(self, checked)
		db.frameLock = checked
	end

	bg = CreateColorPicker(self, L["Background color"],
		L["Change the monitor window's background color."], true)
	bg:SetPoint("TOPLEFT", lock, "BOTTOMLEFT", 3, -8)
	bg.GetColor = function(self)
		return db.frameBGR, db.frameBGG, db.frameBGB, db.frameBGA
	end
	bg.OnColorChanged = function(self, r, g, b, a)
		db.frameBGR, db.frameBGG, db.frameBGB, db.frameBGA = r, g, b, a
		if AnkhUpFrame then
			AnkhUpFrame:SetBackdropColor(r, g, b, a)
		end
	end

	border = CreateColorPicker(self, L["Border color"],
		L["Change the monitor window's border color."], true)
	border:SetPoint("TOPLEFT", bg, "BOTTOMLEFT", 0, -8)
	border.GetColor = function(self)
		return db.frameBorderR, db.frameBorderG, db.frameBorderB, db.frameBorderA
	end
	border.OnColorChanged = function(self, r, g, b, a)
		db.frameBorderR, db.frameBorderG, db.frameBorderB, db.frameBorderA = r, g, b, a
		if AnkhUpFrame then
			AnkhUpFrame:SetBackdropBorderColor(r, g, b, a)
		end
	end

	scale = CreateSlider(self, L["Monitor scale"], 0.1, 2, 0.1, true,
		L["Adjust the size of the monitor window."])
	scale:SetPoint("TOPLEFT", border, "BOTTOMLEFT", -3, -12)
	scale:SetPoint("RIGHT", -16, 0)
	scale.OnValueChanged = function(self, value)
		value = floor(value * 100 / 5 + 0.5) / 20
		db.frameScale = value
		if AnkhUpFrame then
			local s = AnkhUpFrame:GetScale()
			local p1, pr, p2, x, y = AnkhUpFrame:GetPoint()

			AnkhUpFrame:ClearAllPoints()
			AnkhUpFrame:SetPoint(p1, pr, p2, (x * s) / value, (y * s) / value)
			AnkhUpFrame:SetScale(value)
		end
		return value
	end

	-------------------
	--	About panel  --
	-------------------

	LibStub("LibAboutPanel").new(ADDON_NAME, ADDON_NAME)

	---------------
	--	Refresh  --
	---------------

	self.refresh = function()
		readyAlert:SetChecked(db.readyAlert)

		show:SetChecked(db.frameShow)
		lock:SetChecked(db.frameLock)
		bg:SetColor(db.frameBGR or TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, db.frameBGG or TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, db.frameBGB or TOOLTIP_DEFAULT_BACKGROUND_COLOR.b, db.frameBGA or 1)
		border:SetColor(db.frameBorderR or TOOLTIP_DEFAULT_COLOR.r, db.frameBorderG or TOOLTIP_DEFAULT_COLOR.g, db.frameBorderB or TOOLTIP_DEFAULT_COLOR.b, db.frameBorderA or 1)
		scale:SetValue(db.frameScale)

		if db.frameShow then
			lock:Show()
			bg:Show()
			border:Show()
			scale:Show()
		else
			lock:Hide()
			bg:Hide()
			border:Hide()
			scale:Hide()
		end
	end
end)

SLASH_ANKHUP1 = "/ankhup"
SlashCmdList.ANKHUP = function()
	InterfaceOptionsFrame_OpenToCategory(panel)
end

ns.AnkhUp.optionsPanel = panel