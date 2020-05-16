
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


local Vector = require "Vector"

local Rect = class("Rect")

function Rect:ctor(left,top,right,bottom)
    self.position = Vector.new(left,top)
    self.dimension = {width = right-left,height = bottom - top}
    
    self.height = bottom - top
    self.width  = right-left

    self.left   = left
    self.top    = top
    self.right  = right
    self.bottom = bottom
end

function Rect:getWidth()
    return self.dimension.width
end

function Rect:getHeight()
    return self.dimension.height
end

function Rect:contains(pos)
    return pos.x >= self.left and pos.x <= self.right and pos.y >= self.top and pos.y <= self.bottom
end

function Rect:overlap(rect)
    return 
    self:contains(Vector.new(rect.left,rect.top)) or 
    self:contains(Vector.new(rect.right,rect.top)) or 
    self:contains(Vector.new(rect.left,rect.bottom)) or 
    self:contains(Vector.new(rect.right,rect.bottom))
end

function Rect.sub(rect,vector)
    rect.left = rect.left - vector.x
    rect.right = rect.right - vector.x
    rect.top = rect.top - vector.y
    rect.bottom = rect.bottom - vector.y
    return rect
end

function Rect.add(rect,vector)
    rect.left = rect.left + vector.x
    rect.right = rect.right + vector.x
    rect.top = rect.top + vector.y
    rect.bottom = rect.bottom + vector.y
    return rect
end

Rect.__sub = Rect.sub
Rect.__add = Rect.add

return Rect