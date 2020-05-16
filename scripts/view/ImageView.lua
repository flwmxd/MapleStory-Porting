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

local Vector = require "Vector"
local View =   require "View"
local Sprite = require "Sprite"
local ImageView = class("ImageView",View)

function ImageView:ctor(pos,dimension,nodePath)
    View.ctor(self,pos,dimension)
    self.name = nodePath
    self:init()
end

function ImageView:init()
    self.sprite = Sprite.new(self.name,Vector.new(0,0))
    self.dimension = self.sprite.dimension
    self:addChild(self.sprite)
    GameObject.init(self)
end

function ImageView:getOrigin()
    return self.sprite.animation:getOrigin()
end

return ImageView