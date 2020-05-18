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
    self:recalculateProjection()
    self.visibileRect = Rect.new(
        0,0,
        self.contentSize.x,
        self.contentSize.y
    )
end


function Camera:getViewProjection()
    if(self.viewProjectionDirty) then
        self:calculateViewProjection()
    end
    return self.viewProjection
end

function Camera:checkVisibility(gameObject)
    local bounds = gameObject:bounds()
    -- it has transformed into the world location,
    -- but in a sample 2d game, the world localtion is equal to screen location
    --
    -- the default Pos is zero (left,top in screen as the origin)
    return self.visibileRect:overlap(bounds) or true
   -- return true
end

function Camera:setTarget(gameObj)
    log("Camera:setTarget")
    self.viewProjectionDirty = true
    self.lookTarget = gameObj
end

function Camera:recalculateProjection()
    self.projection:setOrthographic(-400,400,-300,300,1,-1)
    --self.projection:setOrthographicFromSize(800,600, -1.0, 1.0);
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