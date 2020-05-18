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

local Vector = require("Vector")
local Sprite = require("Sprite")
local Obj = class("Obj",Sprite)


function Obj:ctor(node)
    local pos = Vector.new(node["x"]:toInt(),  node["y"]:toInt())
    local spNode = WzFile.map["Obj"][node["oS"]:toString() .. ".img"][node["l0"]][node["l1"]][node["l2"]]
    if(spNode ~= nil) then
        Sprite.ctor(self,spNode,pos)
    end
end


return Obj