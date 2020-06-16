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
require("Stance")
require("WzFile")
local Vector = require("Vector")
local WzNode = require("WzNode")

local Face = class("Face")
Face.FaceFrame = class("FaceFrame")
Face.Expression = {}
Face.Expression.DEFAULT = 0
Face.Expression.BLINK = 1
Face.Expression.HIT = 2
Face.Expression.SMILE = 3
Face.Expression.TROUBLED = 4
Face.Expression.CRY =5 
Face.Expression.ANGRY = 6
Face.Expression.BEWILDERED = 7
Face.Expression.STUNNED = 8
Face.Expression.BLAZE = 9
Face.Expression.BOWING = 10
Face.Expression.CHEERS = 11
Face.Expression.CHU = 12
Face.Expression.DAM = 13
Face.Expression.DESPAIR = 14
Face.Expression.GLITTER = 15
Face.Expression.HOT = 16
Face.Expression.HUM = 17
Face.Expression.LOVE = 17
Face.Expression.OOPS = 18
Face.Expression.PAIN = 19
Face.Expression.SHINE = 20
Face.Expression.VOMIT = 21
Face.Expression.WINK = 22
Face.Expression.LENGTH = 23

Face.Expression.Names = 
{
    ["default"] = 0,
	["blink"] = 1 ,
	["hit"] = 2,
	["smile"] =  3,
	["troubled"] =  4,
	["cry"] = 5,
	["angry"] = 6 ,
	["bewildered"] = 7 ,
	["stunned"] = 8,
	["blaze"] = 9,
	["bowing"] = 10,
	["cheers"] = 11,
	["chu"] = 12,
	["dam"] = 13,
	["despair"] =14, 
	["glitter"] = 15,
	["hot"] = 16,
	["hum"] = 17,
	["love"] = 18,
	["oops"] = 19,
	["pain"] = 20,
	["shine"] = 21,
	["vomit"] = 22,
	["wink"] = 23
}




function Face.FaceFrame:ctor(src)
    self.anim = Animation.new(src["face"].rawPtr)
    local shift = Vector.new(0,0) - src["face"]["map"]["brow"]:toVector()
    self.anim:shift(shift)
    self.delay = src["delay"]:toInt()
    if self.delay == 0 then
        self.delay = 2500
    end
end


function Face:ctor(faceId)
    local strId = "000"..faceId
    local faceNode = WzFile.character["Face"][strId..".img"]
    self.expressions = {}
    for name, exp in pairs(Face.Expression.Names) do
        if exp == Face.Expression.DEFAULT then
            self.expressions[Face.Expression.DEFAULT] = {[0] = Face.FaceFrame.new(faceNode[name])} 
        else
            local exps = self.expressions[exp]
            if exps == nil then
                exps = {}
                self.expressions[exp] = exps
            end
            local expNode = faceNode[name]
            local frame = 0 
            local frameNode = expNode[frame]

            while frameNode:hasChildren() do
                exps[frame] = Face.FaceFrame.new(frameNode)
                frame = frame + 1
                frameNode = expNode[frame]
            end
        end
    end
end

function Face:nextFrame(expression,frame)
     if self.expressions[expression][frame + 1] == nil then return frame + 1 else return 0 end
end

function Face:getDelay(expression,frame)
    local f = self.expressions[expression][frame]
    if f == nil then 
        return 100
    end
    return f.delay
end

function Face:draw(expression, frame, args)
    local f = self.expressions[expression][frame]
    if f ~= nil then
        f.anim:draw(args)
    end
end

return Face