
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

require "Scheduler" 

local Camera = require("Camera")
local Vector = require("Vector")

SceneManager = {
    updateScenes = true,
    transform = Transform.new(),
    rootScene = nil,
    scenes = {},
    drawQueue = {}
}

SceneManager.camera = Camera.new(Vector.new(800,600))


function SceneManager.addScene(scene)
    scene:init()
    scene:onCreate()
    SceneManager.rootScene = scene
    scene:visit(SceneManager.drawQueue,SceneManager.camera,SceneManager.transform,true)
    SceneManager.camera:setTarget(scene)
    return scene
end

function SceneManager.removeScene(scene)
    if SceneManager.rootScene ~= nil then 
        local v = SceneManager.rootScene
        if v.uuid == scene.uuid then
            v:onDestory()
        end
        SceneManager.rootScene = nil
    end
end

function SceneManager.draw()
    for i,v in ipairs(SceneManager.drawQueue) do
       v:draw(SceneManager.camera)
       SceneManager.drawQueue[i] = nil
    end
    --SceneManager.drawQueue = {}
end

function SceneManager.update(dt)
    local v = SceneManager.rootScene
    if v~= nil then
        v:visit(SceneManager.drawQueue,SceneManager.camera,SceneManager.transform,false)
        if v.active and not system_editor_mode then
            v:update(dt)
        end
    end
end

function SceneManager.onTouchEvent(x,y,touchId,type)
    local v = SceneManager.rootScene
    if v~= nil then
        if  v.active and v:onTouchEvent(x,y,touchId,type) then
            return true
        end
    end
    return false
end

function SceneManager.onKeyEvent(keyCode,type)
    local v = SceneManager.rootScene
    if v~= nil then
        if  v.active and v:onKeyEvent(keyCode,type) then
            return true
        end
    end
    return false
end

return SceneManager