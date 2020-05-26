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

require ("WzFile")
require("Timer")

local Moveable = require("Moveable")
local Sprite = require("Sprite")
local Vector = require("Vector")
local Background = class("Background",Sprite)


Background.NORMAL = 0
Background.HTILED = 1 
Background.VTILED = 2
Background.TILED = 3
Background.HMOVEA = 4
Background.VMOVEA = 5
Background.HMOVEB = 6
Background.VMOVEB = 7

-- remember, background sprite doesn't need to transform with it's parent node
-- for some type of background elements can transform with camera, but for others there is no need to transform

function Background:ctor(src, backNode)
    self.animated = src["ani"]:toBoolean()
	self.opacity = src["a"]:toInt()
	self.flipped = src["f"]:toBoolean()
	self.cx = src["cx"]:toInt()
	self.cy = src["cy"]:toInt()
	self.rx = src["rx"]:toReal()
	self.ry = src["ry"]:toReal()
	self.type = src["type"]:toInt()
    local n = "ani"
	if not self.animated then n = "back" end
	Sprite.ctor(self,backNode[src["bS"] + ".img"][n][src["no"]:toString()],Vector.new(0,0))

	self.skipCamera = true
	self.moveObject = Moveable.new(src["x"]:toInt(),src["y"]:toInt())
	if self.flipped then
		self:setScaleX(-1)
	end
	self.drawPos = Matrix.identity()
	self:setType()
end


function Background:setType()

	local width = 800
	local height = 600

	self.moveV = false
	self.moveH = false

	if self.cx == 0 then
		self.cx = math.max(self.dimension.x, 1)
	end
	if self.cy == 0 then
		self.cy = math.max(self.dimension.y, 1)
	end

	self.htile = 1
	self.vtile = 1

	--Horizontal
	if self.type == Background.HTILED or self.type == Background.HMOVEA then
		self.htile = width / self.cx + 6
	end
	--Verticle
	if self.type == Background.VTILED or self.type == Background.VMOVEA then
		self.vtile = height / self.cy + 6
	end

	if self.type == Background.TILED or self.type == Background.HMOVEB  or self.type == Background.VMOVEB then
		self.htile = width / self.cx + 6;
		self.vtile = height / self.cy + 6;
	end

	if self.type  == Background.HMOVEA or self.type == Background.HMOVEB then 
		self.moveObject.hspeed = self.rx 
	end

	if self.type  == Background.VMOVEA or self.type == Background.VMOVEB then 
		self.moveObject.vspeed = self.ry
	end
end	


function Background:update(dt)
	Sprite.update(self,dt)
	self.moveObject:move(dt)
end

function Background:draw(camera)
	local halfWidth = 400
	local halfHeight = 300
	local view = camera:getInverseProjection():getTranslation()
	local x = 0
	local y = 0

	if self.moveObject:isHorizontal() then
		x = self.moveObject.x + view.x
	else
		x = self.moveObject.x  + self.rx * (halfWidth - view.x) / 500   + view.x
	end

	if self.moveObject:isVertical() then
		y = self.moveObject.y + view.y
	else
		y = self.moveObject.y - self.ry * (halfHeight - view.y) / 500  + view.y
	end


	if (self.htile > 1 ) then
		while (x > view.x) do
			x = x - self.cx
		end
		while (x < view.x -self.cx) do
			x = x + self.cx
		end
	end

	if (self.vtile > 1 )then
		while (y > view.y) do
			y = y - self.cy
		end
		while (y < view.y - self.cy) do
			y = y + self.cy
		end
	end

	x = math.floor(x + 0.5) 
	y = math.floor(y + 0.5) 

	for tx = 0,self.htile - 1 do
		for ty = 0,self.vtile - 1 do
			if self.type == Background.TILED then 
				self.drawPos:setTranslation(x + tx * self.cx - 400 , y + ty * self.cy - 300,0)
			elseif self.type == Background.VTILED then 
				self.drawPos:setTranslation(x + tx * self.cx , y + ty * self.cy- 300,0)
			elseif self.type == Background.HTILED then 
				self.drawPos:setTranslation(x + tx * self.cx - 400, y + ty * self.cy,0)
			else
				self.drawPos:setTranslation(x + tx * self.cx, y + ty * self.cy,0)
			end
			if self.animation ~= nil then
				self.animation:draw(camera:getViewProjection() * self.drawPos)
			end
		end
	end
end

return Background