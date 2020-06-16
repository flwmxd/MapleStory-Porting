------------------------------------------------------------------------------
-- This file is part of the PharaohStroy MMORPG client                      --
-- Copyright ?2020-2022 Prime Zeng                                          --
--                                                                          --
-- This program is free software: you can redistribute it and/or modify     --
-- it under the terms of the GNU Affero General Public License as           --
-- published by the Free Software Foundation= 1 either version 3 of the       --
-- License= 1 or (at your option) any later version.                          --
--                                                                          --
-- This program is distributed in the hope that it will be useful= 1          --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of           --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            --
-- GNU Affero General Public License for more details.                      --
--                                                                          --
-- You should have received a copy of the GNU Affero General Public License --
-- along with this program.  If not= 1 see <http://www.gnu.org/licenses/>.    --
------------------------------------------------------------------------------

Stance = {}

Stance.NONE= 0
Stance.ALERT= 1
Stance.DEAD= 2
Stance.FLY= 3
Stance.HEAL= 4
Stance.JUMP= 5
Stance.LADDER= 6
Stance.PRONE= 7
Stance.PRONESTAB= 8
Stance.ROPE= 9
Stance.SHOT= 10
Stance.SHOOT1= 11
Stance.SHOOT2= 12
Stance.SHOOTF= 13
Stance.SIT= 14
Stance.STABO1 = 15
Stance.STABO2 = 16
Stance.STABOF = 17
Stance.STABT1 = 18
Stance.STABT2 = 19
Stance.STABTF = 20
Stance.STAND1 = 21
Stance.STAND2 = 22
Stance.SWINGO1 = 23
Stance.SWINGO2 = 24
Stance.SWINGO3 = 25
Stance.SWINGOF = 26
Stance.SWINGP1 = 27
Stance.SWINGP2 = 28
Stance.SWINGPF = 29
Stance.SWINGT1 = 30
Stance.SWINGT2 = 31
Stance.SWINGT3 = 32
Stance.SWINGTF= 33
Stance.WALK1 = 34
Stance.WALK2 = 35
Stance.FIRE_BURNER = 36
Stance.COOLINGE_EFFECT = 37
Stance.TORPEDO = 38
Stance.CONNON = 39
Stance.LENGTH = 40


Stance[0] = ""
Stance[1] = "alert"
Stance[2] = "dead"
Stance[3] = "fly"
Stance[4] = "heal"
Stance[5] = "jump"
Stance[6] = "ladder"
Stance[7] = "prone"
Stance[8] = "proneStab"
Stance[9] = "rope"
Stance[10] = "shot"
Stance[11] = "shoot1"
Stance[12] = "shoot2"
Stance[13] = "shootF"
Stance[14] = "sit"
Stance[15] = "stabO1"
Stance[16] = "stabO2"
Stance[17] = "stabOF"
Stance[18] = "stabT1"
Stance[19] = "stabT2"
Stance[20] = "stabTF"
Stance[21] = "stand1"
Stance[22] = "stand2"
Stance[23] = "swingO1"
Stance[24] = "swingO2"
Stance[25] = "swingO3"
Stance[26] = "swingOF"
Stance[27] = "swingP1"
Stance[28] = "swingP2"
Stance[29] = "swingPF"
Stance[30] = "swingT1"
Stance[31] = "swingT2"
Stance[32] = "swingT3"
Stance[33] = "swingTF"
Stance[34] = "walk1"
Stance[35] = "walk2"
Stance[36] = "fireburner"
Stance[37] = "coolingeffect"
Stance[38] = "torpedo"
Stance[39] = "cannon"


Stance.Names = {
    "",
    "alert",
    "dead",
    "fly",
    "heal",
    "jump",
    "ladder",
    "prone",
    "proneStab",
    "rope",
    "shot",
    "shoot1",
    "shoot2",
    "shootF",
    "sit",
    "stabO1",
    "stabO2",
    "stabOF",
    "stabT1",
    "stabT2",
    "stabTF",
    "stand1",
    "stand2",
    "swingO1",
    "swingO2",
    "swingO3",
    "swingOF",
    "swingP1",
    "swingP2",
    "swingPF",
    "swingT1",
    "swingT2",
    "swingT3",
    "swingTF",
    "walk1",
    "walk2",
    "fireburner",
    "coolingeffect",
    "torpedo",
    "cannon"
}


function Stance.fromString(str)
    for k, v in pairs(Stance) do
        if v == str then
            return k
        end
    end
    return 0
end


return Stance


