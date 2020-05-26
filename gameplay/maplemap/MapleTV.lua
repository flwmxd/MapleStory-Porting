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
local GameObject = require("GameObject")
local MapleTV = class("MapleTV",GameObject)

function MapleTV:ctor(infoNode)
    GameObject.ctor(self)
	local tv = WzFile.ui["MapleTV.img"]
	local adAnim = Sprite.new(tv["TVon"], Vector.new(infoNode["MapleTVmsgX"]:toInt(),infoNode["MapleTVmsgY"]:toInt()))
    local mediaAnim = Sprite.new(tv["TVmedia"]["0"],Vector.new(infoNode["MapleTVadX"]:toInt(),infoNode["MapleTVadY"]:toInt()))
	mediaAnim:setAnchroPoint(0, 0);
    adAnim:setAnchroPoint(0, 0);
    self:addChild(adAnim)
    self:addChild(mediaAnim)
end

return MapleTV