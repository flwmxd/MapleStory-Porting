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
local WzNode = require("WzNode")

WzFile = {
    ui = WzNode.new("UI/"),
    character = WzNode.new("Character/"),
    sound = WzNode.new("Sound/"),
    effect = WzNode.new("Effect/"),
    skill = WzNode.new("Skill/"),
    mob = WzNode.new("Mob/"),
    string = WzNode.new("String/"),
    item = WzNode.new("Item/"),
    map = WzNode.new("Map/"),
    morph = WzNode.new("Morph/"),
    npc = WzNode.new("Npc/"),
    etc = WzNode.new("Etc/"),
    tamingMob = WzNode.new("TamingMob/"),
    reactor = WzNode.new("Reactor/"),
    quest = WzNode.new("Quest/")
}

return WzFile