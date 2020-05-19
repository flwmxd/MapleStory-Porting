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


local TextView = require("TextView")
local Vector = require("Vector")
local Rect = require("Rect")
local Sprite = require("Sprite")
local GameObject = require("GameObject")

local Npc = class("Npc",GameObject)


function Npc:ctor(id,node)
    self.id = id
    local strId = string.format("%07d.img",id)
    self.footHold = node["fh"]:toInt()
    local strSrc = WzFile.string["Npc.img"][id]
    self.animations = {}
    self.stances = {}
    local src = WzFile.npc[strId]
	local link = src["info"]["link"]
	if (link ~= nil) then
        link = link:toString()..".img"
		src = WzFile.npc[link]
    end
    self.stance = "stand"
    local info = src["info"]
    --[[self.dcRect = Rect.new(
		info["dcLeft"]:toInt(),
		info["dcRight"]:toInt(),
		info["dcTop"]:toInt(),
		info["dcBottom"]:toInt()
    )]]
    src:foreach(function(k,v)
        if k ~= "info" then
           self.animations[k] = Animation.new(v.rawPtr)
           self.dimension = Vector.new(self.animations[k]:getWidth(),self.animations[k]:getHeight())
           table.insert(self.stances,k)
        end
    end)

    GameObject.ctor(self, Vector.new(node["x"]:toInt(),  node["y"]:toInt()),Vector.new(self.animations[self.stance]:getWidth(),self.animations[self.stance]:getHeight()))
    self.origin = self.animations[self.stance]:getOrigin()
    self.name = strSrc["name"]:toString()
    self:addChild(TextView.new(Vector.new(0,0),Vector.new(0,0),text.CENTER,text.A12B,text.YELLOW,self.name)):setNameTag(true)
end

function Npc:getOrigin()
    return self.animations[self.stance]:getOrigin()
end

function Npc:draw(camera)
    GameObject.draw(self,camera)
    self.animations[self.stance]:draw(camera:getViewProjection())
end

function Npc:update(dt)
    GameObject.update(self,dt)
    self.animations[self.stance]:update(dt)
end

function Npc:setNativeTransform()
    for k,v in pairs(self.animations) do
       v:updateTransform(self.transform)
    end
end

return Npc