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

local Vector = require("Vector")
local Rect = require("Rect")

local Camera = class("Camera")

function Camera:ctor(contentSize)
    self.viewPoint = Vector.new(400,300)
    self.contentSize = contentSize
    self.viewProjectionDirty = true
    self.projection = Matrix.identity()
    self.lookTarget = nil
    self.viewProjection = Matrix.identity()
    self.inverseTransform = Matrix.identity()
    self:recalculateProjection()
    self.visibileRect = Rect.new(
        -400,
        -300,
        400,
        300
    )
    self.currentRect = Rect.new(0,0,0,0 )
    self.x = 0
    self.y = 0
end


function Camera:getViewProjection()
    if(self.viewProjectionDirty) then
        self:calculateViewProjection()
    end
    return self.viewProjection
end



function Camera:getInverseProjection()
    if self.inverseDiry then
        self.inverseDiry = false
        self.inverseTransform = self:getViewProjection():invert()
    end
    return self.inverseTransform
end

function Camera:checkVisibility(transform,boundingBox,origin)
    --world pos
    local x,y,z = transform:getTranslation()
    --convert to screen location
    local cx,cy,cz = self:getViewProjection():transformVector(x,y,1)
    cx = cx * 400  - origin.x
    cy = -cy * 300 - origin.y
    -- don't new object in there because it can result in full gc and consume to much cpu resources
    self.currentRect:update(cx ,cy,cx + boundingBox.width,cy + boundingBox.height)
    --log(string.format( "%f,%f,%f,%f",self.currentRect.left,self.currentRect.top,self.currentRect.right,self.currentRect.bottom))
    return self.visibileRect:overlap(self.currentRect) 
end

function Camera:setPosition(x,y)
    self.x = x
    self.y = y
    self.projection:setOrthographic(-400+x,400+x,-300+y,300+y,1,-1)

    --self.projection:setOrthographic(self.x,800+self.x,self.y,600+self.y,1,-1)

    self.viewProjectionDirty = true
    self.inverseDiry = true
end

function Camera:setTarget(gameObj)
    log("Camera:setTarget")
    self.viewProjectionDirty = true
    self.lookTarget = gameObj
    self.inverseDiry = true
end

function Camera:recalculateProjection()
   self.projection:setOrthographic(-400,400,-300,300,1,-1)
   --self.projection:setOrthographic(0,800,0,600,1,-1)
end

function Camera:calculateViewProjection()
    if self.lookTarget ~= nil and self.lookTarget.inverseTransform ~= nil then
        self.viewProjection = self.projection * self.lookTarget.inverseTransform
    else
        self.viewProjection = self.projection * Matrix.identity()
    end
    self.viewProjectionDirty = false
end
return Camera