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

local Vector = require "Vector"
local GameObject = require "GameObject"
local uuid = require("uuid")
local Sprite = class("Sprite", GameObject)


---
---the param node could be string or node rawPtr
---@param node rawPtr
---@param node string
---@param pos Vector
function Sprite:ctor(node,pos)
    GameObject.ctor(self,pos,Vector.new(0,0))
    self.node = node
    if self.node ~= nil then
        self:init()
    end
end

function Sprite:init()
    GameObject.init(self)
    if(typeof(self.node) == "table") then
        self.animation = Animation.new(self.node.rawPtr)
        self.name = "Sprite "..uuid()
    else
        self.animation = Animation.new(self.node)
        self.name = self.node
    end
    self.dimension = Vector.new(self.animation:getWidth(),self.animation:getHeight())
    self.origin = self.animation:getOrigin()
    self:updateBox()
end

function Sprite:draw(camera)
    GameObject.draw(self,camera)
    if self.animation ~= nil then
        self.animation:draw(camera:getViewProjection())
    end
end

function Sprite:update(dt)
    if self.animation ~= nil then
        self.animation:update(dt)
    end
    GameObject.update(self,dt)
end

function Sprite:getOrigin()
    if self.animation == nil then return self.origin end return self.animation:getOrigin()
end

function Sprite:setNativeTransform()
    if self.animation ~= nil then
        self.animation:updateTransform(self.transform)
    end
end

function Sprite:getTexture()
    if self.animation ~= nil then
        return self.animation:getTexture()
    end
    return nil
end

return Sprite