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

local Moveable = class("Moveable")

function Moveable:ctor(x,y)
    self.x = x
    self.y = y
    self.hspeed = 0
    self.vspeed = 0
end

function Moveable:setX(x)
    self.x = x
end

function Moveable:setY(y)
    self.y = y
end

function Moveable:move(dt)
    self.x = self.x + self.hspeed * dt * 2
    self.y = self.y + self.vspeed * dt * 2
end

function Moveable:nextX()
    return self.x + self.hspeed
end

function Moveable:nextY()
    return self.y + self.vspeed
end

function Moveable:isHorizontal()
    return self.hspeed ~= 0.0
end

function Moveable:isVertical()
    return self.vspeed ~= 0.0
end

function Moveable:getAbsoluteX(viewX) 
    return self.x + viewX
end

function Moveable:getAbsoluteY(viewY) 
    return self.y + viewY
end

return Moveable
