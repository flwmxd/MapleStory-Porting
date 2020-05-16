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


local GameObject = require("GameObject")
local MapleMap = class("MapleMap",GameObject)

function MapleMap:ctor(mapId)
    GameObject.ctor(Vector.new(0,0),Vector.new(1000,1000))
    self.mapId = mapId
    self.name = string.format( "%09d",mapId)
    self:load()
end

function MapleMap:load()
    local prefix = mapId / 100000000
    

end

return GameObject



