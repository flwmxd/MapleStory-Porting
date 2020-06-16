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
require("Stance")
local Vector = require("Vector")
local Body = class("Body")

Body.Layer = {}
Body.Layer.NONE = 0
Body.Layer.BODY = 1
Body.Layer.ARM = 2
Body.Layer.ARM_BELOW_HEAD = 3
Body.Layer.ARM_BELOW_HEAD_OVER_MAIL = 4
Body.Layer.ARM_OVER_HAIR = 5
Body.Layer.ARM_OVER_HAIR_BELOW_WEAPON = 6
Body.Layer.HAND_BELOW_WEAPON = 7
Body.Layer.HAND_OVER_HAIR = 8
Body.Layer.HAND_OVER_WEAPON = 9
Body.Layer.HEAD = 10
Body.Layer.LENGTH = 11

Body.LayerNames = 
{
    ["body"] = Body.Layer.BODY,
	["backBody"] = Body.Layer.BODY,
	["arm"] = Body.Layer.ARM,
	["armBelowHead"] = Body.Layer.ARM_BELOW_HEAD,
	["armBelowHeadOverMailChest"] =  Body.Layer.ARM_BELOW_HEAD_OVER_MAIL,
	["armOverHair"] =  Body.Layer.ARM_OVER_HAIR,
	["armOverHairBelowWeapon"] =  Body.Layer.ARM_OVER_HAIR_BELOW_WEAPON,
	["handBelowWeapon"] =  Body.Layer.HAND_BELOW_WEAPON,
	["handOverHair"] =  Body.Layer.HAND_OVER_HAIR,
	["handOverWeapon"] =  Body.Layer.HAND_OVER_WEAPON,
	["head"] =  Body.Layer.HEAD
}

function Body:ctor(skinId,drawInfo)
   
    local strId = skinId .. ""
    if string.len(strId) < 2 then
        strId = "0"..strId
    end

	local bodynode = WzFile.character["000020"..strId..".img"]
    local headnode = WzFile.character["000120"..strId..".img"]

    self.stances = {}

    for stance = 1, Stance.LENGTH - 1 do
        local stanceName = Stance[stance]
        local frame = 0

        local stances = self.stances[stance] 
        if stances == nil then
            stances = {}
            self.stances[stance] = stances
        end

        local stanceNode = bodynode[stanceName]
        if stanceNode:hasChildren() then 
            local frameNode = stanceNode[frame]
            while frameNode:hasChildren() do
                frameNode:foreach(function(part,partNode) 
                    if partNode:isUOL() then 
                        partNode:resolvePath()
                    end

                    if (part ~= "delay" and part ~= "face" and part ~= "") then
                        local z = partNode["z"]:toString()
                        if z ~= "" then
                            local layer = Body.layerByName(z)
                        

                            if layer ~= Body.Layer.NONE then

                                local layers = stances[layer] 
                                if layers == nil then 
                                    layers = {}
                                    stances[layer] = layers
                                end

                                if part == "arm" and stance == Stance.SWINGPF then
                                    layer = Body.Layer.ARM
                                end

                                local shift = nil
                                if layer == Body.Layer.HAND_BELOW_WEAPON then
                                    shift = drawInfo.getHandPosition(stance,frame) - partNode["map"]["handMove"]:toVector()
                                else
                                    shift = drawInfo.getBodyPosition(stance,frame) - partNode["map"]["navel"]:toVector()
                                 
                                end
                                local anim = Animation.new(partNode.rawPtr)
                                anim:shift(shift)
                                layers[frame] = anim
                            end
                        end
                    end
                end) 

                local sf = headnode[stanceName][frame]["head"]
                if sf:isUOL() then 
                    sf = sf:resolvePath()
                end
                if sf:hasChildren() then
                    local shift = drawInfo.getHeadPosition(stance, frame)
                    local anim = Animation.new(sf.rawPtr)
                    anim:shift(shift)
                    local layers = stances[Body.Layer.HEAD]
                    if layers == nil then
                        layers = {}
                        stances[Body.Layer.HEAD] = layers
                    end
                    layers[frame] = anim
                end
        
                frame = frame + 1
                frameNode = stanceNode[frame]
            end
        end
    end

end


function Body:draw(stance, layer,frame, args)
    local st = self.stances[stance]
    if st ~= nil then 
        local ly = st[layer]
        if ly ~= nil then
            local anim = ly[frame]
            if anim ~= nil then
                --local origin = anim:getOrigin()
                --render.drawRect(-origin.x,-origin.y,anim:getWidth(),anim:getHeight(),0xFF00FF80,args)
                anim:draw(args)
            end
        end
    end 
end


function Body.layerByName(name)
    for k, v in pairs(Body.LayerNames) do
        if k == name then
            return v
        end
    end
    return Body.Layer.NONE
end

return Body

