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

local panel = LibStub( "PhanxConfig-OptionsPanel" ).CreateOptionsPanel( ADDON_NAME, nil, function( self )

	local L = ns.L
	local db = AnkhUpDB
	local AnkhUp = ns.AnkhUp

	local CreateCheckbox = LibStub( "PhanxConfig-Checkbox" ).CreateCheckbox
	local CreateSlider = LibStub( "PhanxConfig-Slider" ).CreateSlider

	local title, notes = LibStub( "PhanxConfig-Header" ).CreateHeader( self, ADDON_NAME,
		L["This panel allows you to configure options for monitoring your Reincarnation ability and managing your ankhs."] )

	--------------------
	--	Core options  --
	--------------------

	local readyAlert = CreateCheckbox( self, L["Notify when ready"],
		L["Show a notification message when Reincarnation's cooldown finishes."] )
	readyAlert:SetPoint( "TOPLEFT", notes, "BOTTOMLEFT", 0, -16 )
	readyAlert.OnClick = function( self, checked )
		db.readyAlert = checked
	end

	local buyAlert = CreateCheckbox( self, L["Notify when restocking"],
		L["Show a notification message when automatically buying ankhs."] )
	buyAlert:SetPoint( "TOPLEFT", readyAlert, "BOTTOMLEFT", 0, -12 )
	buyAlert.OnClick = function( self, checked )
		db.buyAlert = checked
	end

	local buy = CreateSlider( self, L["Restock quantity"], 0, 20, 5, nil,
		L["Buy ankhs up to a total of this number when you interact with a vendor."] .. " " .. L["Set to 0 to disable this feature."] )
	buy:SetPoint( "TOPLEFT", buyAlert, "BOTTOMLEFT", 2, -16 )
	buy:SetPoint( "TOPRIGHT", notes, "BOTTOM", -10, -16 - readyAlert:GetHeight( ) - 12 - buyAlert:GetHeight( ) - 16 )
	buy.OnValueChanged = function( self, value )
		value = math.floor( value + 0.5 )
		db.buy = value
		if value > 0 then
			AnkhUp:RegisterEvent( "MERCHANT_SHOW" )
		else
			AnkhUp:UnregisterEvent( "MERCHANT_SHOW" )
		end
		return value
	end

	local low = CreateSlider( self, L["Warning quantity"], 0, 20, 5, nil,
		L["Show a warning when you have fewer than this number of ankhs."] .. " " .. L["Set to 0 to disable this feature."] )
	low:SetPoint( "TOPLEFT", buy, "BOTTOMLEFT", 0, -16 )
	low:SetPoint( "TOPRIGHT", buy, "BOTTOMRIGHT", -0, -16 )
	low.OnValueChanged = function( self, value )
		value = math.floor( value + 0.5 )
		db.low = value
		return value
	end

	------------------------------
	--	Monitor window options  --
	------------------------------

	local lock, scale

	local show = CreateCheckbox( self, L["Show monitor"],
		L["Show a small movable window to track your Reincarnation cooldown."] )
	show:SetPoint( "TOPLEFT", notes, "BOTTOM", 8, -16 )
	show.OnClick = function( self, checked )
		db.frameShow = checked
		if checked then
			if AnkhUpFrame then
				AnkhUpFrame:Show()
			end
			lock:Show()
			scale:Show()
		else
			if AnkhUpFrame then
				AnkhUpFrame:Hide()
			end
			lock:Hide()
			scale:Hide()
		end
	end

	lock = CreateCheckbox( self, L["Lock monitor"],
		L["Lock the monitor window in place to prevent it from being moved."] )
	lock:SetPoint( "TOPLEFT", show, "BOTTOMLEFT", 0, -8 )
	lock.OnClick = function( self, checked )
		db.frameLock = checked
	end

	scale = CreateSlider( self, L["Monitor scale"], 0.1, 2, 0.1, true,
		L["Adjust the size of the monitor window."] )
	scale:SetPoint( "TOPLEFT", lock, "BOTTOMLEFT", 0, -8 )
	scale:SetPoint( "RIGHT", -16, 0 )
	scale.OnValueChanged = function( self, value )
		value = floor( value * 100 / 5 + 0.5 ) / 20
		db.frameScale = value
		if AnkhUpFrame then
			local s = AnkhUpFrame:GetScale()
			local p1, pr, p2, x, y = AnkhUpFrame:GetPoint()

			AnkhUpFrame:ClearAllPoints()
			AnkhUpFrame:SetPoint( p1, pr, p2, ( x * s ) / value, ( y * s ) / value )
			AnkhUpFrame:SetScale( value )
		end
		return value
	end

	-------------------
	--	About panel  --
	-------------------

	LibStub( "LibAboutPanel" ).new( ADDON_NAME, ADDON_NAME )

	---------------
	--	Refresh  --
	---------------

	self.refresh = function( )
		readyAlert:SetChecked( db.readyAlert )
		buyAlert:SetChecked( db.buyAlert )
		buy:SetValue( db.buy )
		low:SetValue( db.low )

		show:SetChecked( db.frameShow )
		lock:SetChecked( db.frameLock )
		scale:SetValue( db.frameScale )

		if db.frameShow then
			lock:Show()
			scale:Show()
		else
			lock:Hide()
			scale:Hide()
		end
	end

end )

SLASH_ANKHUP1 = "/ankhup"
SlashCmdList.ANKHUP = function()
	InterfaceOptionsFrame_OpenToCategory( panel )
end

ns.AnkhUp.optionsPanel = panel