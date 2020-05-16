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

require "Engine" 

local View = require("View")
local GameObject = require("GameObject")
local TextView = require("TextView")
local Timer = require ("Timer")
local Vector = require ("Vector")

local EditText = class("EditText",View)

EditText.FOCUSED = 1
EditText.NORMAL = 0

function EditText:ctor(pos,dimension,str)
    View.ctor(self,pos,dimension)
    self.str = str
    self:init()
end

function EditText:init()
    self.gameObjs = {}
    self.textView = TextView.new(Vector.new(0, 0),Vector.new(0, 0),text.Left,text.A12M,text.BLACK,self.str)
    self.marker = TextView.new(Vector.new(0, 0),Vector.new(0, 0),text.Left,text.A12M,text.BLACK,"|")
    self.marker.enable = false
    self.textView.enable = false
    self:addChild(self.textView)
    self:addChild(self.marker)
    self.type = EditText.NORMAL
    self.showMarker = false
    self.markerPos = self.textView:length()
    self.elapsed = 0
    self.onTextChangedListener = nil
    self.focused = false
    GameObject.init(self)
end

function EditText:update(dt)
    GameObject.update(self,dt)
    self.elapsed = self.elapsed + dt
    if(self.elapsed > 0.5) then
        self.showMarker = not self.showMarker
        self.elapsed = 0
    end

    self.marker.active = self.type == EditText.FOCUSED and self.showMarker
    if self.marker.active then
        self.marker:setPosition(Vector.new(self.textView:advance(self.markerPos) - 2,0))    
    end

    if(not self.focused) then
        self.type = EditText.NORMAL
    else
        self.type = EditText.FOCUSED
    end
end

function EditText:setText(str)
    if(str ~= self.textView:getText()) then
        self.str = str
        self.textView:changeText(str)
        self.markerPos = self.textView:length()
        if(self.onTextChangedListener ~= nil) then
            self.onTextChangedListener(self)
        end
    end
end

function EditText:onKeyEvent(keyCode,type)
    if self.enable and self.type == EditText.FOCUSED then 
        if(type == event.KEY_DOWN ) then 
            --the visible ascii code
            if( keyCode >= 32 and keyCode <= 126 ) then 
                self.textView:append(keyCode,self.markerPos)
                self.markerPos = self.markerPos + 1 
                if(self.onTextChangedListener ~= nil) then
                    self.onTextChangedListener(self)
                end
            elseif(keyCode == event.KEY_LEFT_DPAD and self.markerPos > 0) then
                self.markerPos = self.markerPos - 1 
            elseif(keyCode == event.KEY_RIGHT_DPAD and self.markerPos ~= self.textView:length()) then
                self.markerPos = self.markerPos + 1
            end
            return true
        end
    end 
    return GameObject.onKeyEvent(keyCode,type)
end


function EditText:getText()
    return self.textView:getText()
end

function EditText:setOnTextChangedListener(callback)
    self.onTextChangedListener = callback
end

return EditText