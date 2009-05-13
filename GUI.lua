--[[--------------------------------------------------------------------
	AnkhUp
	A shaman Reincarnation monitor and ankh management helper
	by Phanx < addons@phanx.net >
	http://www.wowinterface.com/downloads/info6330-AnkhUp.html
	Copyright ©2006–2009 Alyssa "Phanx" Kinley
	See included README for license terms and additional information.

	This file provides a standalone monitor window for AnkhUp.
----------------------------------------------------------------------]]

assert(AnkhUp, "AnkhUp not found!")

------------------------------------------------------------------------

local db
local curr
local objects = {}
local DataBroker = LibStub:GetLibrary("LibDataBroker-1.1")

local AnkhUpFrame = CreateFrame("Button", "AnkhUpFrame", UIParent)
AnkhUpFrame.icon = AnkhUpFrame:CreateTexture(nil, "ARTWORK")
AnkhUpFrame.text = AnkhUpFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")

AnkhUp.frame = AnkhUpFrame

------------------------------------------------------------------------

local function updateDisplay(event, name, attr, value, dataobj)
	if type(event) == "table" then
		dataobj = event
	end
	if dataobj == objects[curr] then
		AnkhUpFrame.text:SetText(dataobj.text)
	end
end

function AnkhUpFrame:RegisterObject(name)
	assert(DataBroker:GetDataObjectByName(name), "AnkhUp: '"..name.."' is not a valid data object")
	tinsert(objects, DataBroker:GetDataObjectByName(name))
	DataBroker.RegisterCallback(AnkhUpFrame, "LibDataBroker_AttributeChanged_"..name.."_text", updateDisplay)
	curr = #objects
end

------------------------------------------------------------------------

local orig = AnkhUp.PLAYER_LOGIN
function AnkhUp:PLAYER_LOGIN()
	orig(self)

	local defaults = {
		lock = false,
		point = "CENTER",
		scale = 1,
		show = true,
	}
	if not AnkhUpDB.frame then
		AnkhUpDB.frame = defaults
		db = AnkhUpDB.frame
	else
		db = AnkhUpDB.frame
		for k, v in pairs(defaults) do
			if db[k] == nil or type(db[k]) ~= type(v) then
				db[k] = v
			end
		end
	end

	local self = AnkhUpFrame

	self:SetBackdrop(GameTooltip:GetBackdrop())
	self:SetBackdropColor(GameTooltip:GetBackdropColor())
	self:SetBackdropBorderColor(GameTooltip:GetBackdropBorderColor())

	self:SetFrameStrata("BACKGROUND")
	self:SetWidth(110)
	self:SetHeight(32)
	self:SetScale(db.scale)
	self:SetPoint(db.point, db.x, db.y)

	self.icon:SetPoint("LEFT", self, 4, 0)
	self.icon:SetWidth(24)
	self.icon:SetHeight(24)
	self.icon:SetTexture("Interface\\AddOns\\AnkhUp\\Ankh")

	self.text:SetPoint("LEFT", self.icon, "RIGHT", 4, 0)
	self.text:SetPoint("RIGHT", self, -8, 0)
	self.text:SetJustifyH("LEFT")
	self.text:SetShadowOffset(1, -1)

	-------------------------------------------------------------------

	self:RegisterForClicks("AnyUp")

	-- GetTooltipAnchor function by Tekkub
	local function GetTooltipAnchor(frame)
		local x, y = frame:GetCenter()
		if not x or not y then return "TOPLEFT", "BOTTOMLEFT" end
		local hhalf = (x > UIParent:GetWidth() * 2 / 3) and "RIGHT" or (x < UIParent:GetWidth() / 3) and "LEFT" or ""
		local vhalf = (y > UIParent:GetHeight() / 2) and "TOP" or "BOTTOM"
		return vhalf..hhalf, frame, (vhalf == "TOP" and "BOTTOM" or "TOP")..hhalf
	end

	self:SetScript("OnEnter", function(self)
		if curr and objects[curr] and objects[curr].OnTooltipShow then
			GameTooltip:SetOwner(self, GetTooltipAnchor(self))
			objects[curr].OnTooltipShow(GameTooltip)
			GameTooltip:Show()
		end
	end)

	self:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)

	self:SetScript("OnClick", function(self, button)
		if curr and objects[curr] and objects[curr].OnClick then
			GameTooltip:Hide()
			objects[curr].OnClick(self, button)
		end
	end)

	-------------------------------------------------------------------

	-- GetUIParentAnchor function by Tekkub
	local function GetUIParentAnchor(frame)
		local w, h, x, y = UIParent:GetWidth(), UIParent:GetHeight(), frame:GetCenter()
		local hhalf, vhalf = (x > w/2) and "RIGHT" or "LEFT", (y > h/2) and "TOP" or "BOTTOM"
		local dx = hhalf == "RIGHT" and math.floor(frame:GetRight() + 0.5) - w or math.floor(frame:GetLeft() + 0.5)
		local dy = vhalf == "TOP" and math.floor(frame:GetTop() + 0.5) - h or math.floor(frame:GetBottom() + 0.5)

		return vhalf..hhalf, dx, dy
	end

	self:RegisterForDrag("LeftButton")
	self:SetMovable(true)
	self:SetClampedToScreen(true)

	self:SetScript("OnDragStart", function(self)
		self:GetScript("OnLeave")(self)
		self:StartMoving()
	end)

	self:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()

		db.point, db.x, db.y = GetUIParentAnchor(self)
		self:ClearAllPoints()
		self:SetPoint(db.point, db.x, db.y)

		self:GetScript("OnEnter")(self)
	end)

	self:SetScript("OnHide", function(self)
		self:StopMovingOrSizing()
	end)

	-------------------------------------------------------------------

	if db.show then
		self:Show()
	else
		self:Hide()
	end
end

------------------------------------------------------------------------