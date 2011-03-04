--[[--------------------------------------------------------------------
	AnkhUp
	Reincarnation cooldown monitor and ankh manager for shamans.
	Written by Phanx <addons@phanx.net>
	Maintained by Akkorian <akkorian@hotmail.com>
	Copyright © 2006–2011 Phanx. Some rights reserved. See LICENSE.txt for details.
	http://www.wowinterface.com/downloads/info6330-AnkhUp.html
	http://wow.curse.com/downloads/wow-addons/details/ankhup.aspx
----------------------------------------------------------------------]]

if select( 2, UnitClass( "player" ) ) ~= "SHAMAN" then return end

local ADDON_NAME, ns = ...
if not ns then ns = _G.AnkhUpNS end -- WoW China is still running 3.2

------------------------------------------------------------------------

function ns.AnkhUp:CreateFrame()
	if AnkhUpFrame then return AnkhUpFrame end

	local db = AnkhUpDB

	local f = CreateFrame( "Frame", "AnkhUpFrame", UIParent )
	f:SetSize( 100, 30 )

	local p = db.framePoint
	if p then
		f:SetPoint( p, UIParent, p, db.frameX / db.frameScale, db.frameY / db.frameScale )
	else
		f:SetPoint( "CENTER", UIParent, "CENTER", 0, 0 )
	end

	if db.frameShow then
		f:Show()
	else
		f:Hide()
	end

	f:SetBackdrop({
		bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tile = true, tileSize = 16,
		edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]], edgeSize = 16,
		insets = { left = 5, right = 5, top = 5, bottom = 5 }
	})
	f:SetBackdropBorderColor( TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b )
	f:SetBackdropColor( TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b )

	local icon = f:CreateTexture( nil, "ARTWORK" )
	icon:ClearAllPoints()
	icon:SetPoint( "LEFT", 5, 0 )
	icon:SetSize( 24, 24 )
	f.icon = icon

	local text = f:CreateFontString( nil, "OVERLAY", "GameTooltipHeaderText" )
	text:SetPoint( "LEFT", icon, "RIGHT", 2, -1 )
	text:SetPoint( "RIGHT", -5, -1 )
	text:SetJustifyH( "LEFT" )
	text:SetJustifyV( "CENTER" )
	f.text = text

	---------------
	--	Tooltip	 --
	---------------

	f:EnableMouse( true )

	local function GetTooltipAnchor( frame )
		local x, y = frame:GetCenter()
		if not x or not y then
			return "ANCHOR_BOTTOMRIGHT"
		end
		local h = ( x > UIParent:GetWidth() / 2 ) and "LEFT" or "RIGHT"
		local v = ( y > UIParent:GetHeight() / 2 ) and "BOTTOM" or "TOP"
		return format( "ANCHOR_%s%s", v, h )
	end

	self.displayFrame:SetScript( "OnEnter", function(self)
		if self.object and self.object.OnTooltipShow then
			GameTooltip:SetOwner( self, GetTooltipAnchor( self ) )
			self.object.OnTooltipShow( GameTooltip )
			GameTooltip:Show()
		end
	end )

	self.displayFrame:SetScript( "OnLeave", function(self)
		GameTooltip:Hide()
	end )

	-------------
	--	Click  --
	-------------

	f:RegisterForClicks( "AnyUp" )

	self.displayFrame:SetScript( "OnClick", function( self, button )
		if self.object and self.object.OnClick then
			self.object.OnClick( self, button )
		end
	end )

	------------
	--	Drag  --
	------------

	f:SetMovable( true )
	f:SetUserPlaced( false )
	f:SetClampedToScreen( true )
	f:RegisterForDrag( "LeftButton" )

	f:SetScript( "OnDragStart", function( self )
		if db.frameLock then return end
		self:GetScript( "OnLeave" )( self )
		self:StartMoving()
		self.dragging = true
	end )

	local function GetUIParentAnchor( frame )
		local w, h, x, y = UIParent:GetWidth(), UIParent:GetHeight(), AnkhUpFrame:GetCenter()
		local hhalf = ( x > w / 2 ) and "RIGHT" or "LEFT"
		local vhalf = ( y > h / 2 ) and "TOP" or "BOTTOM"
		local dx = hhalf == "RIGHT" and math.floor( frame:GetRight() + 0.5 ) - w or math.floor( frame:GetLeft() + 0.5 )
		local dy = vhalf == "TOP" and math.floor( frame:GetTop() + 0.5 ) - h or math.floor( frame:GetBottom() + 0.5 )

		return vhalf..hhalf, dx, dy
	end

	local function OnDragStop( self )
		if not self.dragging then return end
		self.dragging = nil
		self:SetUserPlaced( false )

		local s, p, x, y = self:GetScale(), GetUIParentAnchor( AnkhUpFrame )
		AnkhUpFrame:ClearAllPoints()
		AnkhUpFrame:SetPoint( p, UIParent, p, ( x * s ) / value, ( y * s ) / value )
		AnkhUpFrame:SetScale( value )

		if self:IsMouseOver() then
			self:GetScript( "OnEnter" )( self )
		end
	end

	f:SetScript( "OnDragStop", OnDragStop )
	f:SetScript( "OnHide", OnDragStop )

	-------------------
	--	LDB display  --
	-------------------

	local DataBroker = LibStub("LibDataBroker-1.1")

	self.object = DataBroker:GetDataObjectByName( "AnkhUp" )

	DataBroker.RegisterCallback( self, "LibDataBroker_AttributeChanged_" .. name .. "_text", function( event, name, attr, value, dataobj )
		if type( event ) == "table" then
			dataobj = event
		end
		if dataobj == self.object then
			f.text:SetText( dataobj.text )
		end
	end )

	f:SetScript( "OnShow", function( self )
		AnkhUp:UpdateText()
		if self.object then
			self.text:SetText( self.object.text )
		end
	end )

	return f
end

------------------------------------------------------------------------