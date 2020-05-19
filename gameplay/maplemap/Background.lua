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
	self.rx = src["rx"]:toInt()
	self.ry = src["ry"]:toInt()
    self.type = src["type"]:toInt()
    local n = "ani"
    if not self.animated then n = "back" end
    Sprite.ctor(self,backNode[src["bS"] + ".img"][n][src["no"]:toString()],Vector.new(src["x"]:toInt(),src["y"]:toInt()))
end



return Background