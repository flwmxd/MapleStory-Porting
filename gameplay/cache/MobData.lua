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
MobCache = {}
local Vector = require("Vector")
local Sprite = require("Sprite")
local MobData = class("MobData")

MobData.MobStance = {
    MOVE = 2,
    STAND = 4,
    JUMP = 6,
    HIT = 8,
    DIE = 10,
    ATTACK_1 = 12,
    ATTACK_2 = 14,
    ATTACK_3 = 16,
    ATTACK_4 = 18,
    SKILL_1 = 20,
    SKILL_2 = 22,
    SKILL_3 = 24,
    SKILL_4 = 26,
}

function MobData:ctor(id)
    local strId = string.format( "%07d",id)
    local src = WzFile.mob[strId..".img"]
    local info = src["info"]

    local link = info["link"]:toInt() 
    if link ~= 0 then
		strId = string.format("%07d",link)
		src = WzFile.mob[strId ..".img"];
		info = src["info"];
    end
    self.level = info["level"]:toInt()
    self.animations = {}

    self.hasSkill = info["skill"]:hasChildren() or info["skill1"]:hasChildren()
    if self.hasSkill then

    end
    self.canFly = src["fly"]:hasChildren()
    self.canMove = src["move"]:hasChildren() or self.canFly 
    self.canJump = src["jump"]:hasChildren()

    if self.canFly then 
        self.animations[MobData.MobStance.STAND] = src["fly"]
        self.animations[MobData.MobStance.MOVE] = src["fly"]
    else
        self.animations[MobData.MobStance.STAND] = src["stand"]
        self.animations[MobData.MobStance.MOVE] = src["move"]
    end

    self.animations[MobData.MobStance.JUMP] = src["jump"]
    self.animations[MobData.MobStance.HIT] = src["hit1"]
    self.animations[MobData.MobStance.DIE] = src["die1"]
    
    local sndSrc = WzFile.sound["Mob.img"][strId];

    self.hitSound = sndSrc["Damage"];
	self.dieSound = sndSrc["Die"];
  
    self.name = WzFile.string["Mob.img"][id]["name"]:toString()
end


function MobData.get(id)
    local data = MobCache[id]
    if data == nil then 
        data = MobData.new(id)
        MobCache[id] = data
    end
    return data
end

return MobData