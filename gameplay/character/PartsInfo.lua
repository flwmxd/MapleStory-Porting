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

require("Stance")
require("WzFile")

local WzNode = require("WzNode")
local Body = require("Body")

local Vector = require("Vector")

PartsInfo = {}


PartsInfo.bodyPositions = {}
PartsInfo.armPositions  = {}
PartsInfo.handPositions = {}
PartsInfo.headPositions = {}
PartsInfo.hairPositions = {}
PartsInfo.facePositions = {}
PartsInfo.stanceDelays = {}




function PartsInfo.load()
	local bodyNode = WzFile.character["00002000.img"]
	local headNode = WzFile.character["00012000.img"]
    local tamNode = WzFile.character["TamingMob"]


    for i = 0, Stance.LENGTH - 1 do
        PartsInfo.stanceDelays[i] = {}
        PartsInfo.bodyPositions[i] = {}
        PartsInfo.armPositions[i] = {}
        PartsInfo.handPositions[i] = {}
        PartsInfo.headPositions[i] = {}
        PartsInfo.hairPositions[i] = {}
        PartsInfo.facePositions[i] = {}
    end

   local bodyShift  = {}

    bodyNode:foreach(function (st,v) 
        local attackDelay = 0
        local frame = 0
        local frameNode = v[frame]
        while frameNode:hasChildren() do
            local actionNode = frameNode["action"]
            if actionNode:hasChildren() and actionNode:toString() ~= "" then
                -- TODO
            else
                local stance = Stance.fromString(st)
                local delay = frameNode["delay"]:toInt()
                if delay<= 0 then
                    delay = 100
                end
                PartsInfo.stanceDelays[stance][frame] = delay
                local bodyshiftmap = {}

                for i = 0, Body.Layer.LENGTH - 1 do
                    bodyshiftmap[i] = {
                        ["hand"] = Vector.new(0,0),
                        ["navel"] = Vector.new(0,0),
                        ["neck"] = Vector.new(0,0),
                        ["brow"] = Vector.new(0,0),
                        ["handMove"] = Vector.new(0,0),
                        ["used"] = false
                    }
                end
----------------
                frameNode:foreach(function (part,partNode) 
                    if partNode:isUOL() then 
                        partNode:resolvePath()
                    end
                    if part ~= "delay" and part ~= "face" then
                        local zStr = partNode["z"]:toString()                  
                        if zStr ~= "" then
                            local z = Body.layerByName(zStr)
                            partNode["map"]:foreach(function(k,v) 
                                bodyshiftmap[z]["used"] = true
                                bodyshiftmap[z][k] = v:toVector()
                            end)
                        end
                    end
                end)
----------------
                local headMap = headNode[st][frame]["head"]
                if headMap:isUOL() then 
                    headMap:resolvePath()
                end
                headMap = headMap["map"]
                headMap:foreach(function(k,v) 
                    bodyshiftmap[Body.Layer.HEAD][k] = v:toVector()
                    bodyshiftmap[Body.Layer.HEAD]["used"] = true
                end)
                PartsInfo.bodyPositions[stance][frame] = bodyshiftmap[Body.Layer.BODY]["navel"]


                if bodyshiftmap[Body.Layer.ARM]["used"] then
                    PartsInfo.armPositions[stance][frame] =bodyshiftmap[Body.Layer.ARM]["hand"] - bodyshiftmap[Body.Layer.ARM]["navel"] + bodyshiftmap[Body.Layer.BODY]["navel"]
                else
                    PartsInfo.armPositions[stance][frame] =bodyshiftmap[Body.Layer.ARM_OVER_HAIR]["hand"] - bodyshiftmap[Body.Layer.ARM_OVER_HAIR]["navel"] + bodyshiftmap[Body.Layer.BODY]["navel"]
                end
                PartsInfo.handPositions[stance][frame] = bodyshiftmap[Body.Layer.HAND_BELOW_WEAPON]["handMove"]
                PartsInfo.headPositions[stance][frame] = bodyshiftmap[Body.Layer.BODY]["neck"] - bodyshiftmap[Body.Layer.HEAD]["neck"]
                PartsInfo.facePositions[stance][frame] = bodyshiftmap[Body.Layer.BODY]["neck"] - bodyshiftmap[Body.Layer.HEAD]["neck"] + bodyshiftmap[Body.Layer.HEAD]["brow"]
                PartsInfo.hairPositions[stance][frame] = bodyshiftmap[Body.Layer.HEAD]["brow"] - bodyshiftmap[Body.Layer.HEAD]["neck"] + bodyshiftmap[Body.Layer.BODY]["neck"]
            end
            frame = frame + 1-- next frame
			frameNode = v[frame]
        end
    end)
end


function PartsInfo.getHandPosition(stance,frame)
    local pos = PartsInfo.handPositions[stance][frame]
    return pos or Vector.new(0,0)
end

function PartsInfo.getBodyPosition(stance,frame)
    local pos = PartsInfo.bodyPositions[stance][frame]
    return pos or Vector.new(0,0)
end

function PartsInfo.getFacePosition(stance,frame)
    local pos = PartsInfo.facePositions[stance][frame]
    return pos or Vector.new(0,0)
end

function PartsInfo.getHeadPosition(stance,frame)
    local pos = PartsInfo.headPositions[stance][frame]
    return pos or Vector.new(0,0)
end

function PartsInfo.getHairPosition(stance,frame)
    local pos = PartsInfo.hairPositions[stance][frame]
    return pos or Vector.new(0,0)
end

return PartsInfo