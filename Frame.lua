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

------------------------------------------------------------------------

function ns.AnkhUp:CreateFrame()
	if AnkhUpFrame then return AnkhUpFrame end

	local db = AnkhUpDB

	local f = CreateFrame("Button", "AnkhUpFrame", UIParent)
	f:SetSize(100, 30)

	local scale, x, y = db.frameScale, db.frameX, db.frameY
	f:SetScale(scale)
	if x and y then
		f:SetPoint("CENTER", UIParent, "BOTTOMLEFT", math.floor(x / scale + 0.5), math.floor(y / scale + 0.5))
	else
		f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	end

	local backdrop = {
		bgFile = [[Interface\Buttons\WHITE8X8]], tile = true, tileSize = 16,
		edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]], edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	}
	f:SetBackdrop(backdrop)
	if PhanxBorder then
		PhanxBorder.AddBorder(f)
	end
	f:SetBackdropColor(db.frameBGR, db.frameBGG, db.frameBGB, db.frameBGA)
	f:SetBackdropBorderColor(db.frameBorderR, db.frameBorderG, db.frameBorderB, db.frameBorderA)

	local icon = f:CreateTexture(nil, "ARTWORK")
	icon:SetPoint("LEFT", 3, 0)
	icon:SetSize(24, 24)
	icon:SetTexture([[Interface\ICONS\Spell_Shaman_ImprovedReincarnation]])
	f.icon = icon

	local text = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	text:SetPoint("LEFT", icon, "RIGHT", 6, 0)
	text:SetPoint("RIGHT", -5, 0)
	text:SetJustifyH("LEFT")
	text:SetJustifyV("CENTER")
	f.text = text

	---------------
	--	Tooltip	 --
	---------------

	f:EnableMouse(true)

	local function GetTooltipAnchor(frame)
		local x, y = frame:GetCenter()
		if not x or not y then
			return "ANCHOR_BOTTOMRIGHT"
		end
		local h = (x > UIParent:GetWidth() / 2) and "LEFT" or "RIGHT"
		local v = (y > UIParent:GetHeight() / 2) and "BOTTOM" or "TOP"
		return format("ANCHOR_%s%s", v, h)
	end

	f:SetScript("OnEnter", function(self)
		if self.object and self.object.OnTooltipShow then
			GameTooltip:SetOwner(self, GetTooltipAnchor(self))
			self.object.OnTooltipShow(GameTooltip)
			GameTooltip:Show()
		end
	end)

	f:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)

	-------------
	--	Click  --
	-------------

	f:RegisterForClicks("AnyUp")

	f:SetScript("OnClick", function(self, button)
		if self.object and self.object.OnClick then
			self.object.OnClick(self, button)
		end
	end)

	------------
	--	Drag  --
	------------

	f:SetMovable(true)
	f:SetUserPlaced(false)
	f:SetClampedToScreen(true)
	f:RegisterForDrag("LeftButton")

	f:SetScript("OnDragStart", function(self)
		if db.frameLock then return end
		self:GetScript("OnLeave")(self)
		self:StartMoving()
		self.dragging = true
	end)

	local function OnDragStop(self)
		if not self.dragging then return end
		self:StopMovingOrSizing()
		self:SetUserPlaced(false)
		self.dragging = nil

		local s, x, y = db.frameScale, self:GetCenter()
		x, y = tonumber(format("%.0f", x)), tonumber(format("%.0f", y))
		db.frameX, db.frameY = x * s, y * s

		AnkhUpFrame:ClearAllPoints()
		AnkhUpFrame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", math.floor(x + 0.5), math.floor(y + 0.5))

		if self:IsMouseOver() then
			self:GetScript("OnEnter")(self)
		end
	end

	f:SetScript("OnDragStop", OnDragStop)
	f:SetScript("OnHide", OnDragStop)

	-------------------
	--	LDB display  --
	-------------------

	local DataBroker = LibStub("LibDataBroker-1.1")

	f.object = DataBroker:GetDataObjectByName("AnkhUp")

	DataBroker.RegisterCallback(self, "LibDataBroker_AttributeChanged_AnkhUp_text", function(event, name, attr, value, dataobj)
		if type(event) == "table" then
			dataobj = event
		end
		if dataobj == f.object then
			f.text:SetText(dataobj.text)
			if f.text:GetStringWidth() > 64 then
				f:SetWidth(120)
			else
				f:SetWidth(100)
			end
		end
	end)

	f:SetScript("OnShow", function(self)
		ns.AnkhUp:UpdateText()
		if self.object then
			self.icon:SetTexture(self.object.icon)
		end
	end)

	if db.frameShow then
		f:Show()
	else
		f:Hide()
	end

	return f
end

------------------------------------------------------------------------