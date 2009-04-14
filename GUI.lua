--[[--------------------------------------------------------------------
	AnkhUp: a shaman Reincarnation monitor
	by Phanx < addons@phanx.net >
	http://www.wowinterface.com/downloads/info6330-AnkhUp.html
	Copyright (c) 2005-2009 Alyssa Kinley, aka Phanx
	See the included README text file for license and additional information.
----------------------------------------------------------------------]]

if not AnkhUp then return end

------------------------------------------------------------------------

local db
local curr
local objects = {}
local DataBroker = LibStub:GetLibrary("LibDataBroker-1.1")

local frame = CreateFrame("Button", "AnkhUpFrame", UIParent)
frame:SetFrameStrata("BACKGROUND")
frame:SetPoint("CENTER", UIParent)
frame:SetWidth(128)
frame:SetHeight(32)
frame:RegisterForClicks("anyUp")
frame:RegisterForDrag("LeftButton")
frame:SetMovable(true)
frame:SetClampedToScreen(true)

frame.icon = frame:CreateTexture(nil, "ARTWORK")
frame.icon:SetPoint("LEFT", frame, 4, 0)
frame.icon:SetWidth(24)
frame.icon:SetHeight(24)
frame.icon:SetTexture("Interface\\AddOns\\AnkhUp\\Ankh")

frame.text = frame:CreateFontString(nil, "OVERLAY")
frame.text:SetFontObject(GameFontNormal)
frame.text:SetShadowOffset(1, -1)
frame.text:SetPoint("LEFT", frame.icon, "RIGHT", 4, 0)
frame.text:SetPoint("RIGHT", frame, -8, 0)

------------------------------------------------------------------------

local function updateDisplay(event, name, attr, value, dataobj)
	if type(event) == "table" then
		dataobj = event
	end
	if dataobj == objects[curr] then
		frame.text:SetText(dataobj.text)
--		frame:SetWidth(frame.text:GetStringWidth() + 40)
	end
end

function frame:RegisterObject(name)
	assert(DataBroker:GetDataObjectByName(name), "AnkhUp: '"..name.."' is not a valid data object")
	tinsert(objects, DataBroker:GetDataObjectByName(name))
	DataBroker.RegisterCallback(frame, "LibDataBroker_AttributeChanged_"..name.."_text", updateDisplay)
	curr = #objects
end

------------------------------------------------------------------------

local function GetTooltipAnchor(frame)
	local x,y = frame:GetCenter()
	if not x or not y then return "TOPLEFT", "BOTTOMLEFT" end
	local hhalf = (x > UIParent:GetWidth()*2/3) and "RIGHT" or (x < UIParent:GetWidth()/3) and "LEFT" or ""
	local vhalf = (y > UIParent:GetHeight()/2) and "TOP" or "BOTTOM"
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

frame:SetScript("OnClick", function(self, btn)
	if curr and objects[curr] and objects[curr].OnClick and IsAltKeyDown() then
		GameTooltip:Hide()
		objects[curr].OnClick(self, btn)
	end
end)

------------------------------------------------------------------------

local function GetUIParentAnchor(frame)
	local w, h, x, y = UIParent:GetWidth(), UIParent:GetHeight(), frame:GetCenter()
	local hhalf, vhalf = (x > w/2) and "RIGHT" or "LEFT", (y > h/2) and "TOP" or "BOTTOM"
	local dx = hhalf == "RIGHT" and math.floor(frame:GetRight() + 0.5) - w or math.floor(frame:GetLeft() + 0.5)
	local dy = vhalf == "TOP" and math.floor(frame:GetTop() + 0.5) - h or math.floor(frame:GetBottom() + 0.5)

	return vhalf..hhalf, dx, dy
end

frame:SetScript("OnDragStart", function(self)
	if IsAltKeyDown() then
		self.isMoving = true
		self:StartMoving()
	end
end)

frame:SetScript("OnDragStop", function(self)
	if self.isMoving then
		self:StopMovingOrSizing()
		self:ClearAllPoints()
		db.point, db.x, db.y = GetUIParentAnchor(self)
		self:SetPoint(db.point, UIParent, db.x, db.y)
		self.isMoving = false
	end
end)

frame:SetScript("OnHide", function(self)
	if self.isMoving then
		self:StopMovingOrSizing()
	end
end)

------------------------------------------------------------------------

frame:SetScript("OnEvent", function(self, event, addon)
	self:SetWidth(self.text:GetStringWidth() + 40)
end)

local orig = AnkhUp.PLAYER_LOGIN
function AnkhUp:PLAYER_LOGIN()
	orig(self)

	local self = frame

	local defaults = {
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
	
	self:SetScale(db.scale)
	self:SetPoint(db.point, db.x, db.y)
	self:SetWidth(110)

	self:SetBackdrop(GameTooltip:GetBackdrop())
	self:SetBackdropColor(GameTooltip:GetBackdropColor())
	self:SetBackdropBorderColor(GameTooltip:GetBackdropBorderColor())

	if db.show then
		self:Show()
	else
		self:Hide()
	end
	
	self:RegisterObject("AnkhUp")
--	self:RegisterEvent("ADDON_LOADED")
end

AnkhUp.frame = frame