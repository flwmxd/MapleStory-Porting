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
require("PartsInfo")
require("Stance")

local Vector = require "Vector"
local GameObject = require("GameObject")
local CharLook = class("CharLook",GameObject)
local Body = require ("Body")
local Face = require ("Face")
local Hair = require ("Hair")


function CharLook:ctor(female,skin,hair,face,equips)
    GameObject.ctor(self,Vector.new(0,0),Vector.new(50,50))
    self.female = female
    self.skinId = skin
    self.faceId = face
    --todo equips
    self.stance = Stance.STAND1
    self.body = Body.new(skin,PartsInfo)
    self.face = Face.new(face)
    self:setHair(hair)
    self.faceShift = Matrix.identity()
    self:reset()
end


function CharLook:setHair(hair)
    self.hairId = hair
    self.hair = Hair.new(hair,PartsInfo)
end

function CharLook:reset()
    self.flip = true
    self.stance = Stance.STAND1
    self.expression = Face.Expression.DEFAULT
    self.expressionFrame = 0
    self.stanceFrame = 0
end


function CharLook:draw(camera)
    GameObject.draw(self,camera)
    --self.body:draw(Stance.STAND1,Body.Layer.BODY,0,camera:getViewProjection() * self.drawPos)
    self:drawLook(camera,self.transform:getTransform(),self.stance,self.expression,self.stanceFrame,self.expressionFrame)
end


function CharLook:drawLook(camera,args,stance,expression,frame,expFrame)

    local faceShift = PartsInfo.getFacePosition(stance,frame)
    self.faceShift:setTranslation(faceShift.x,faceShift.y,0)
    local faceArg = args * self.faceShift

    local drawArgs = camera:getViewProjection() * args
    local faceArgs = camera:getViewProjection() * faceArg
    --equip 1
    --equip 2

    self.hair:draw(stance,Hair.Layer.BELOWBODY,frame,drawArgs)
    self.body:draw(stance, Body.Layer.BODY, frame, drawArgs)
    --self.body:draw(stance, Body.Layer.ARM_BELOW_HEAD, frame, drawArgs)
    --self.body:draw(stance, Body.Layer.ARM_BELOW_HEAD_OVER_MAIL, frame, drawArgs)
    self.body:draw(stance, Body.Layer.HEAD, frame, drawArgs)
    self.hair:draw(stance,Hair.Layer.DEFAULT,frame,drawArgs)
    self.hair:draw(stance,Hair.Layer.SHADE,frame,drawArgs)
    self.face:draw(expression,expFrame,faceArgs)
    self.body:draw(stance, Body.Layer.ARM, frame, drawArgs)

    --self.body:draw(stance, Body.Layer.ARM_OVER_HAIR, frame, drawArgs)
    --self.body:draw(stance, Body.Layer.HAND_OVER_HAIR, frame, drawArgs)
    --self.body:draw(stance, Body.Layer.HAND_OVER_WEAPON, frame, drawArgs)
end

return CharLook