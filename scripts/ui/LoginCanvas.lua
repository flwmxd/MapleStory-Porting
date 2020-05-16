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

require "Scheduler"
require "Engine"
require "SceneManager"

local Rect = require "Rect"
local Button = require "Button"
local Vector = require "Vector"
local TextView = require "TextView"
local EditText = require "EditText"
local ImageView = require "ImageView"
local Layer = require "Layer"

local LoginCanvas = class("LoginCanvas",Layer)

function LoginCanvas:onCreate()
   --[[local btnLogin = self:addChild(Button.new("UI/Login.img/Title/BtLogin/",Vector.new( 475,248)))
   local btnNew =   self:addChild(Button.new("UI/Login.img/Title/BtNew/",Vector.new(309,320)))
   local btnQuit =  self:addChild(Button.new("UI/Login.img/Title/BtQuit/",Vector.new(455,320)))
   btnLogin:setOnClickListener(function(btn) 
      
      local node = wz.flat("UI/");

      printTable(node)


   end)
   self:addChild(Button.new("UI/Login.img/Title/BtHomePage/",Vector.new(382, 320)))
   self:addChild(Button.new("UI/Login.img/Title/BtPasswdLost/",Vector.new(470, 300)))
   local iv = self:addChild(ImageView.new("UI/Login.img/Title/ID/", Vector.new(310, 249)));
   iv.enable = false
   self:addChild(ImageView.new("UI/Login.img/Title/PW/", Vector.new(310, 275))).enable = false
  
   local tv = self:addChild(TextView.new(text.Left,text.A12M,text.BLACK,Vector.new(630, 0),"Ver.0.01"))
   tv.enable = false

   local et = self:addChild(EditText.new("",Vector.new(315,249),150,30))
   et:setText("法老王冒险岛")

   Scheduler.addTask(function() 
      tv:changeText(string.format("FPS : %.2f",Engine.FPS))
      return false
   end)

   et:setOnTextChangedListener(function(et) 
      log(et:getText())
      iv.active = false
   end)
   --audio.playBGM("BgmUI.img/Title")
]]
end


return LoginCanvas

