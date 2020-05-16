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

local Vector = {}
Vector.mt ={}

function Vector.new(x,y)
	local vec = {x = x,y = y,z = 0}
	vec["__cname"] = "Vector"
	setmetatable(vec,Vector.mt)
    return vec
end

function Vector.add(a,b)
	return Vector.new(a.x + b.x , a.y + b.y)
end

function Vector.sub(a,b)
	return Vector.new(a.x - b.x , a.y - b.y)
end

function Vector.mul(a,b)
	local theType = type(b)
	if theType == "number" then
		Vector.new(a.x * b ,a.y * b)
	elseif theType == "table" then
		return Vector.new(a.x * b.x ,a.y * b.y)
	else
		log("unsupport vector type "..theType)
	end
end


function Vector.div(a,b)
	return Vector.new(a.x / b , a.y / b)
end

function Vector.equal(a,b)
	return a.x == b.x and a.y == b.y
end


Vector.mt.__div = Vector.div
Vector.mt.__mul = Vector.mul
Vector.mt.__sub = Vector.sub
Vector.mt.__add = Vector.add
Vector.mt.__eq  = Vector.equal
return Vector


