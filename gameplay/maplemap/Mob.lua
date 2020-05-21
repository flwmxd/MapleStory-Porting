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

local TextView = require("TextView")
local Vector = require("Vector")
local GameObject = require("GameObject")
local MobData = require("MobData")
local Mob = class("Mob",GameObject)

function Mob:ctor(id,pos)
    GameObject.ctor(self,pos)
    local data = MobData.get(id)
    self.animations = {}
    for key, value in pairs(data.animations) do
        self.animations[key] = Animation.new(value.rawPtr)
    end
    self.stance = MobData.MobStance.STAND

    if self.animations[self.stance] ~= nil then 
        self.origin = self.animations[self.stance]:getOrigin()
        self.dimension = Vector.new(self.animations[self.stance]:getWidth(),self.animations[self.stance]:getHeight())
    end

    self.name = data.name
    self:addChild(TextView.new(Vector.new(0,0),Vector.new(0,0),text.CENTER,text.A12M,text.YELLOW,"[Lv.".. data.level .. "]"..self.name)):setNameTag(true)
end

function Mob:getOrigin()
    return self.animations[self.stance]:getOrigin()
end

function Mob:draw(camera)
    GameObject.draw(self,camera)
    self.animations[self.stance]:draw(camera:getViewProjection())
end

function Mob:update(dt)
    GameObject.update(self,dt)
    self.animations[self.stance]:update(dt)
end

function Mob:setNativeTransform()
    for k,v in pairs(self.animations) do
       v:updateTransform(self.transform)
    end
end

return Mob