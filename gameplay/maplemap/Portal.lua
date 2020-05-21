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

require("WzFile")

local Vector = require("Vector")
local Sprite = require("Sprite")
local Portal = class("Portal",Sprite)


--[[
sp  ：  Start Point   
pi  ：  Invisible   
pv  ：  Visible   
pc  ：  Collision   
pg  ：  hangable   
pgi ：  Changable Invisible   
tp  ：  Town Portal   
ps  ：  Script   
psi ：  Script Invisible   
pcs ：  Script Collision   
ph  ：  Hidden   
psh ：  Script Hidden   
pcj ：  Vertical Spring   
pci ：  Custom Impact Spring   
pcig ： Unknown (PCIG) 
]]


Portal.SPAWN = 0
Portal.REGULAR = 2
Portal.TOUCH = 3
Portal.WARP = 6
Portal.SCRIPTED = 7
Portal.HIDDEN = 10

function Portal:ctor(node)
    local pos = Vector.new(node["x"]:toInt(),  node["y"]:toInt())
    --portal type
    self.pt = node["pt"]:toInt()
    Sprite.ctor(self,Portal.loadAnimation(self.pt),pos)
    self.name = node["pn"]:toString()
    self:updateBox()
end

function Portal:isSpawnPoint()
    return self.pt == "sp"
end

function Portal.loadAnimation(pt)
    if Portal.animations == nil then
        Portal.animations = {}
        local node = WzFile.map["MapHelper.img"]
        local src = node["portal"]["game"]
        Portal.animations[Portal.HIDDEN] = src["ph"]["default"]["portalContinue"]
        Portal.animations[Portal.REGULAR] = src["pv"]
        Portal.animations[Portal.SCRIPTED] = src["pv"]
        if  system_editor_mode then 
            local editor = node["portal"]["editor"]
            Portal.animations[Portal.WARP] = editor["ps"]
            Portal.animations[Portal.SPAWN] = editor["sp"]
            Portal.animations[Portal.TOUCH] = editor["pc"]
        end
    end
    return Portal.animations[pt]
end

return Portal