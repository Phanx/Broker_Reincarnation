--[[--------------------------------------------------------------------
	AnkhUp
	Reincarnation cooldown monitor shamans
	by Phanx < addons@phanx.net >
	http://www.wowinterface.com/downloads/info6330-AnkhUp.html
	Copyright ©2006–2009 Alyssa "Phanx" Kinley
	See included README for license terms and additional information.

	This file provides a standalone display frame for AnkhUp.
----------------------------------------------------------------------]]

if not AnkhUp then return end

function AnkhUp:SetupFrame()
	local curr
	local objects = {}
	local DataBroker = LibStub("LibDataBroker-1.1")

	-----

	local defaults = {
		lock = false,
		point = "CENTER",
		scale = 1,
		show = true,
	}

	if not AnkhUpDB.frame then AnkhUpDB.frame = { } end
	local db = AnkhUpDB.frame

	for k, v in pairs(defaults) do
		if type(db[k]) ~= type(v) then
			db[k] = v
		end
	end

	-----

	local frame = CreateFrame("Button", nil, UIParent)
	self.frame = frame

	frame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 },
	})
	frame:SetBackdropColor(0, 0, 0, 0.9)
	frame:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)

	frame:SetFrameStrata("BACKGROUND")
	frame:SetWidth(110)
	frame:SetHeight(32)
	frame:SetScale(db.scale)
	frame:SetPoint(db.point, db.x, db.y)

	local icon = frame:CreateTexture(nil, "ARTWORK")
	icon:SetPoint("LEFT", frame, 4, 0)
	icon:SetWidth(24)
	icon:SetHeight(24)
	icon:SetTexture("Interface\\AddOns\\AnkhUp\\Ankh")
	frame.icon = icon

	local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	text:SetPoint("LEFT", icon, "RIGHT", 4, 0)
	text:SetPoint("RIGHT", frame, -8, 0)
	text:SetJustifyH("LEFT")
	text:SetShadowOffset(1, -1)
	frame.text = text

	-----

	-- GetTooltipAnchor function by Tekkub
	local function GetTooltipAnchor(frame)
		local x, y = frame:GetCenter()
		if not x or not y then return "TOPLEFT", "BOTTOMLEFT" end
		local hhalf = (x > UIParent:GetWidth() * 2 / 3) and "RIGHT" or (x < UIParent:GetWidth() / 3) and "LEFT" or ""
		local vhalf = (y > UIParent:GetHeight() / 2) and "TOP" or "BOTTOM"
		return vhalf..hhalf, frame, (vhalf == "TOP" and "BOTTOM" or "TOP")..hhalf
	end

	frame:SetScript("OnEnter", function(self)
		if curr and objects[curr] and objects[curr].OnTooltipShow then
			GameTooltip:SetOwner(self, GetTooltipAnchor(self))
			objects[curr].OnTooltipShow(GameTooltip)
			GameTooltip:Show()
		end
	end)

	frame:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)

	-----

	frame:RegisterForClicks("AnyUp")

	frame:SetScript("OnClick", function(self, button)
		if curr and objects[curr] and objects[curr].OnClick then
			GameTooltip:Hide()
			objects[curr].OnClick(self, button)
		end
	end)

	-----

	-- GetUIParentAnchor function by Tekkub
	local function GetUIParentAnchor(frame)
		local w, h, x, y = UIParent:GetWidth(), UIParent:GetHeight(), frame:GetCenter()
		local hhalf, vhalf = (x > w/2) and "RIGHT" or "LEFT", (y > h/2) and "TOP" or "BOTTOM"
		local dx = hhalf == "RIGHT" and math.floor(frame:GetRight() + 0.5) - w or math.floor(frame:GetLeft() + 0.5)
		local dy = vhalf == "TOP" and math.floor(frame:GetTop() + 0.5) - h or math.floor(frame:GetBottom() + 0.5)

		return vhalf..hhalf, dx, dy
	end

	frame:SetMovable(true)
	frame:SetClampedToScreen(true)
	frame:RegisterForDrag("LeftButton")

	frame:SetScript("OnDragStart", function(self)
		self:GetScript("OnLeave")(self)
		self:StartMoving()
	end)

	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()

		db.point, db.x, db.y = GetUIParentAnchor(self)
		self:ClearAllPoints()
		self:SetPoint(db.point, db.x, db.y)

		self:GetScript("OnEnter")(self)
	end)

	frame:SetScript("OnHide", function(self)
		self:StopMovingOrSizing()
	end)

	-----

	local function updateDisplay(event, name, attr, value, dataobj)
		if type(event) == "table" then
			dataobj = event
		end
		if dataobj == objects[curr] then
			text:SetText(dataobj.text)
		end
	end

	function frame:RegisterObject(name)
		assert(DataBroker:GetDataObjectByName(name), "AnkhUp: '"..name.."' is not a valid data object")
		tinsert(objects, DataBroker:GetDataObjectByName(name))
		DataBroker.RegisterCallback(frame, "LibDataBroker_AttributeChanged_" .. name .. "_text", updateDisplay)
		curr = #objects
	end

	frame:RegisterObject("AnkhUp")

	-----

	if db.show then
		frame:Show()
	else
		frame:Hide()
	end

	-----

	self.SetupFrame = nil
end