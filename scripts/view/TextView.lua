------------------------------------------------------------------------------
-- This file is part of the PharaohStroy MMORPG client                      --
-- Copyright ?2020-2022 Prime Zeng                                          --
--                                                                          --
-- This program is free software: you can redistribute it and/or modify     --
-- it under the terms of the GNU Affero General Public License as           --
-- published by the Free Software Foundation, either version 3 of the       --
-- License, or (at your option) any later version.                          --
--                                                                          --
-- This program is distributed in the hope that it will be useful,          --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of           --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            --
-- GNU Affero General Public License for more details.                      --
--                                                                          --
-- You should have received a copy of the GNU Affero General Public License --
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.    --
------------------------------------------------------------------------------

dofile("scripts/Tools/Class.lua")

local View =   require "View"
local Vector =  require "Vector"
local GameObject = require "GameObject"
--Mapping to the native textview because it contains too much calculation

local TextView = class("TextView",View)


--[[
    @param alignment
	{
		text.LEFT,
		text.CENTER,
		text.RIGHT
	};
    @param textFont
	{
		text.A11M,
		text.A11B,
		text.A12M,
		text.A12B,
		text.A18M,
		text.A18B,
	};
	@param color
	{
		text.BLACK,
		text.WHITE,
		text.YELLOW,
		text.BLUE,
		text.RED,
		text.DARKRED,
		text.BROWN,
		text.LIGHTGREY,
		text.DARKGREY,
		text.ORANGE,
		text.MEDIUMBLUE,
		text.VIOLET,
	};
]]
function TextView:ctor(pos,dimension,alignment,textFont,color,txt)
	View.ctor(self,pos,dimension)
	self.alignment = alignment 
	self.textFont =textFont
	self.color = color
	self.txt = txt
	self:init()
end

function TextView:init()
	self.nativeText = NativeText.new(self.alignment or 0,self.textFont or 0,self.color or 0,self.txt or "")
	self.dimension =  Vector.new(self.nativeText:getWidth(),self.nativeText:getHeight())
	GameObject.init(self)
	if self.alignment == text.CENTER then
		self.origin = Vector.new(-self.dimension.x / 2,0)
	elseif self.alignment == text.RIGHT then
		self.origin = Vector.new(-self.dimension.x,0)
	end
end


function TextView:setAlignment(alig)
	self.alignment = alig
	self:init()
end

function TextView:setNameTag(tag)
	self.nativeText:setNameTag(tag)
end

function TextView:setTextFont(font)
	self.textFont = font
	self:init()
end

function TextView:setColor(color)
	self.color = color
	self:init()
end


function TextView:draw(camera)
    self.nativeText:draw(camera:getViewProjection())
    GameObject.draw(self,camera)
end

function TextView:update(dt)
    self.nativeText:update(dt)
    GameObject.update(self,dt)
end

function TextView:getText()
    return self.nativeText:getText()
end

function TextView:changeText(str)
    self.nativeText:changeText(str)
end

function TextView:advance(pos)
    return self.nativeText:advance(pos)
end

function TextView:length()
    return self.nativeText:length()
end

function TextView:append(str,pos)
    return self.nativeText:append(str,pos)
end

function TextView:setNativeTransform()
    self.nativeText:updateTransform(self.transform)
end



return TextView
