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
local View =   require "View"
local Rect =   require "Rect"
local GameObject = require("GameObject")
local Button = class("Button",View)

function Button:ctor(pos,dimension,nodePath)
    View.ctor(self,pos,Vector.new(0,0))
    self.name = nodePath
    self:init()
end

function Button:init()
    GameObject.init(self)
    self.animations = {}
    self.state = GameObject.NORMAL
    if self.name ~= nil then 
        self.animations[GameObject.NORMAL] = Animation.new(self.name.."normal");
        self.animations[GameObject.DISABLED] = Animation.new(self.name.."disabled");
        self.animations[GameObject.MOUSEOVER] = Animation.new(self.name.."mouseOver");
        self.animations[GameObject.PRESSED] = Animation.new(self.name.."pressed");        
    end
    self.soundCounter = 0
    self:updateDimension()
end

function Button:updateDimension()
    local anim = self.animations[self.state or GameObject.NORMAL]
    if anim ~= nil then
        self.dimension.x = anim:getWidth()
        self.dimension.y = anim:getHeight()
    end
end

function Button:draw(camera)
    GameObject.draw(self,camera)
    local anim = self.animations[self.state]
    if anim ~= nil then
        anim:draw(camera:getViewProjection())
    end
end

function Button:update(dt)
    GameObject.update(self,dt)
    local anim = self.animations[self.state]
    self:updateDimension()
    if anim ~= nil then
        anim:update(dt)
    end
end

function Button:getOrigin()
    return self.animations[self.state]:getOrigin()
end

function Button:onMove(x,y,touchId,type)
    if(self.soundCounter < 1) then
        audio.playEffect(audio.BUTTONOVER)
    end

    self.soundCounter = self.soundCounter + 1
    return GameObject.onMove(self,x,y,touchId,type)
end

function Button:onLostMouse()
    GameObject.onLostMouse(self)
    self.soundCounter = 0
end

function Button:setNativeTransform()
    for k,v in pairs(self.animations) do
        v:updateTransform(self.transform)
    end
end

return Button