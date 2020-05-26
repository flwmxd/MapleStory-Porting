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
local Mob = require("Mob")
local Portal = require("Portal")
local Background = require("Background")

local MapleMap = class("MapleMap",Scene)

function MapleMap:ctor(mapId)
    Scene.ctor(self,Vector.new(0,0),Vector.new(800,600))
    self.mapId = mapId
    self.name = MapleMap.getMapName(mapId) .. "("..mapId..")"
end

function MapleMap.getMapName(mapId)
    local node = WzFile.string["Map.img"];
    local name = mapId ..""

    return node:foreach(function(k,v) 
        return v:foreach(function(k2,v2) 
            if k2 == name then
                return v2["mapName"]:toString()
            end
        end) 
    end) or ""
end

function MapleMap:init()
    Scene.init(self)
    local id = string.format("%09d",self.mapId)
    local prefix = math.floor(self.mapId / 100000000)
    local src = WzFile.map["Map"]["Map"..prefix][id..".img"];
    local link = src["info"]["link"]
    
    if #link.children > 0 then
        prefix = tonumber(link) / 100000000
        src = WzFile.map["Map"]["Map"..prefix][link:toString()..".img"];
    end

    local bg,fg = self:loadBackground(src["back"])
    self:addLayer(bg)
    self:addTilesObjs(src)
    self:loadNpc(src)
    self:loadPortals(src)
    self:addLayer(fg)
    if self.spawnPoint ~= nil then
    --    SceneManager.camera:setTarget(self.spawnPoint)
    end
end

-- @param node -> wzNode
function MapleMap:addTilesObjs(node)
    for i = 0, 7 do
        local src = node[i]
        local ts = src["info"]["tS"]:toString() 
        if ts ~= ""  then 
            log(ts)
            ts = ts .. ".img"
            local layer = Layer.new(Vector.new(0,0),Vector.new(5000,5000))
            local tls = wz.expand(src["tile"])
            local objs = wz.expand(src["obj"])
            layer.drag = false
            layer.name = "MapTile"..i

            local mapObjs = GameObject.new()

            if objs ~= nil then
                objs:foreach(function(k,v)
                    if v ~= nil then
                        mapObjs:addChild(Obj.new(v))
                    end
                end)
            end

            table.sort(mapObjs.gameObjs, function (a,b)
                if a.z == b.z then return a.zId < b.zId end
                return a.z < b.z
            end)

            layer:addChild(mapObjs)

            local mapTiles = GameObject.new()

            if(tls ~= nil) then
                
                local tsNode = WzFile.map["Tile"][ts]
                tls:foreach(function(k,v) 
                    local desNode = tsNode[v["u"]][v["no"]]
                    if desNode ~= nil then
                        mapTiles:addChild(Tile.new(v,desNode))
                    end
                end)
            end

            table.sort(mapTiles.gameObjs, function (a,b)
                return a.z < b.z
            end)
            layer:addChild(mapTiles)
            self:addChild(layer)
        end 
    end
end

function MapleMap:loadPortals(node)
    node["portal"]:foreach(function(k,v)
        local sp = self:addChild(Portal.new(v))
        if sp:isSpawnPoint() then
            self.spawnPoint = sp
        end
    end)
end

function MapleMap:loadBackground(src)
    local no = 0
    local back = src[no]
    local backSrc = WzFile.map["Back"]
    local layer = Layer.new(Vector.new(0,0),Vector.new(5000,5000))
    local foreground = Layer.new(Vector.new(0,0),Vector.new(5000,5000))

    layer.name = "Backgrounds"
    foreground.name = "Foreground"
    while back:hasChildren() do
        local front = back["front"]:toBoolean()
        local type = src["type"]:toInt()
        if front then
            foreground:addChild(Background.new(back, backSrc))
        else 
            layer:addChild(Background.new(back, backSrc))
        end
        no = no + 1
        back = src[no]
    end
    return layer,foreground
end

function MapleMap:loadNpc(node)
  
    node["life"]:foreach(function(k,v)
        local id = v["id"]:toInt()
        if v["type"]:toString() == "m" then --mob
            self:addChild(Mob.new(id, Vector.new(v["x"]:toInt(),  v["y"]:toInt())))
        else
            self:addChild(Npc.new(id,v))
        end
    end)
end




return MapleMap