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
local Scene = require("Scene")
local Layer = require("Layer")
local GameObject = require("GameObject")
local Tile = require("Tile")
local Obj = require("Obj")
local Npc = require("Npc")
local Portal = require("Portal")

local MapleMap = class("MapleMap",Scene)

function MapleMap:ctor(mapId)
    Scene.ctor(self,Vector.new(0,0),Vector.new(800,600))
    self.mapId = mapId
    self.name = mapId .. ""
end

function MapleMap:init()
    Scene.init(self)
    local id = string.format("%09d",self.mapId)
    local prefix = math.floor(self.mapId / 100000000)
    local src = WzFile.map["Map"]["Map"..prefix][id..".img"];
    local link = src["info"]["link"]
    
    if linke ~= nil then
        prefix = tonumber(link) / 100000000
        src = WzFile.map["Map"]["Map"..prefix][link:toString()..".img"];
    end

    self:addTilesObjs(src)
    self:loadNpc(src)
    self:loadPortals(src)
end

-- @param node -> wzNode
function MapleMap:addTilesObjs(node)
    log("addTilesObjs")
    for i = 0, 7 do
        local src = node[i]
        if src ~= nil then 
            local ts = src["info"]["tS"]
            if(ts ~= nil) then 
                ts = ts:toString() .. ".img";
                local layer = Layer.new(Vector.new(0,0),Vector.new(5000,5000))
                local tls = wz.expand(src["tile"])
                local objs = wz.expand(src["obj"])
                layer.drag = false
                layer.name = "MapTile"..i
                if(tls ~= nil) then
                   
                    local tsNode = WzFile.map["Tile"][ts]
                    tls:foreach(function(k,v) 
                        local desNode = tsNode[v["u"]][v["no"]]
                        if desNode ~= nil then
                            layer:addChild(Tile.new(v,desNode))
                        end
                    end)
                    
                end

                if objs ~= nil then
                    objs:foreach(function(k,v)
                        if v ~= nil then
                            layer:addChild(Obj.new(v))
                        end
                    end)
                end

                self:addChild(layer)

            end 
        end
    end
end

function MapleMap:loadPortals(node)
    node["portal"]:foreach(function(k,v)
        self:addChild(Portal.new(v))
    end)
end


function MapleMap:loadNpc(node)
  
    node["life"]:foreach(function(k,v)
        if v["type"]:toString() == "m" then --mob
                
        else
            local id = v["id"]:toInt()
            self:addChild(Npc.new(id,v))
        end
    end)
end


return MapleMap