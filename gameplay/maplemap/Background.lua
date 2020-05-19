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
Background.VMOVE = 7

-- remember, background sprite doesn't need to transform with it's parent node
-- for some type of background elements can transform with camera, but for others there is no need to transform

function Background:ctor(src, backNode)
    self.animated = src["ani"]:toBoolean();
	self.opacity = src["a"]
	self.flipped = src["f"]:toBoolean();
	self.cx = src["cx"]:toInt()
	self.cy = src["cy"]:toInt()
	self.rx = src["rx"]:toReal()
	self.ry = src["ry"]:toReal()
	self.type = src["type"]:toInt()


    local n = "ani"
    if not self.animated then n = "back" end
    Sprite.ctor(self,backNode[src["bS"] + ".img"][n][src["no"]:toString()],Vector.new(src["x"]:toInt(),src["y"]:toInt()))

	if self.flipped then
		self:setScaleX(-1)
	end
	self.hspeed = 0
	self.vspeed = 0
	self:setType()
	self.drawPos = Matrix.new()
end



function Background:setType()


	local width = 800
	local height = 600


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
		self.vtile = height / self.cx + 6
	end

	if self.type == Background.TILED or self.type == Background.HMOVEB  or self.type == Background.VMOVEB then
		self.htile = width / self.cx + 6;
		self.vtile = height / self.cy + 6;
	end


	if self.type  == Background.HMOVEA or self.type == Background.HMOVEB then 
		self.hspeed = self.rx / 16
	end

	if self.type  == Background.VMOVEA or self.type == Background.VMOVEB then 
		self.vspeed = self.ry / 16
	end

end	


function Background:update(dt)
	Sprite.update(self,dt)

	if self.hspeed ~= 0 then
		self.position.x = self.position.x + self.hspeed
	else -- give a delta effect if the camera move
		
	end
	
	if self.vspeed ~= 0 then
		self.position.y = self.position.y + self.vspeed

	else

	end

	if self.htile > 1 then
		while (self.position.x > 0) do
			self.position.x = self.position.x - self.cx;
		end
		while (self.position.x < -self.cx) do
			self.position.x = self.position.x + self.cx;
		end
	end

	if (self.vtile > 1) then
	
		while (self.position.y > 0)  do
			self.position.y = self.position.y - self.cy;
		end
		while (self.position.y < -self.cy)  do
			self.position.y = self.position.y + self.cy;
		end
	end
	
end

function Background:draw(camera)

	local ix = math.modf(self.position.x)
	local iy = math.modf(self.position.y)

	local tw = self.cx * self.htile;
	local th = self.cy * self.vtile; 

	for tx = 0,self.htile - 1 do
		for ty = 0,self.vtile - 1 do
			self.drawPos:setTranslation(ix + tx * self.cx, iy + ty * self.cx,0)
			if self.animation ~= nil then
				self.animation:draw(camera:getViewProjection() * self.drawPos)
			end
		end
	end

end

function Background:setNativeTransform()
    if self.animation ~= nil then
       self.animation:updateTransform(self.transform)
    end
end

function Background:calculateTransform()
	self.transform:setTranslation(self.position.x,self.position.y,0)
    self.transform:calculateLocalTransform()
    self.transformDirty = false
    self.updateChildrenTransform = true
    --self.transform:calculateTransform()
    --self.inverseTransform = self.transform:getInverseTranform()
    self:setNativeTransform()
end

return Background