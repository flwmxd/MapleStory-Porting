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

require ("Serializable")

local GameObject = require ("GameObject")
local Sprite = require("Sprite")
local List = require ("List")

local Scene = class("Scene",GameObject)

function Scene:ctor(pos,dimen)
	GameObject.ctor(self,pos,dimen)
	self:init()
end

function Scene:init()
	GameObject.init(self)
end

function Scene:onCreate()
	log(self.name .. "Scene:onCreate()")
end

function Scene:onDestory()
	log(self.name .. "Scene:onDestory()")
end

function Scene:addLayer(layer)
	self:addChild(layer)
	layer:onCreate()
	return layer
end

function Scene:addSprite(nodePath,pos)
	self:addChild(Sprite.new(nodePath,pos),nodePath)
end


function Scene:saveScene()
	local file = io.open("scene/"..self.name..".scene","w")
	file:write(Serializable.serialize(self))
	file:flush()
	file:close()
	log("Scene "..self.name.." saved success")
end

function Scene.loadScene(sceneName)
	local file = io.open(sceneName)
	local data = file:read("*a")
	local data = Serializable.deserialize(data)
	file:close()
	return Scene.loadGameObject(data)
end

function Scene.loadGameObject(table)
	local name = table["__cname"]
	if(name ~= nil and name ~= "") then 
		local clazz = package.loaded[name] or require (name)
		local obj = clazz.new()
		for key, value in pairs(table) do
			if(key == "gameObjs") then
				for i,v in ipairs(value) do
					obj:addChild(Scene.loadGameObject(v))
				end
			elseif(key == "layers") then
				for i,v in ipairs(value) do
					obj:addLayer(Scene.loadGameObject(v))
				end
			elseif(type(value) == "table") then
				obj[key] = Scene.loadGameObject(value)
			else
				obj[key] = value
			end
		end
		if(obj.init ~= nil) then 
			obj:init()
		end 
		return obj
	end
	return table
end

return Scene