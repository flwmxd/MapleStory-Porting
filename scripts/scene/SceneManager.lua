
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
    defaultMt = Matrix.identity(),
    rootScene = nil,
    scenes = {},
    drawQueue = {}
}

SceneManager.camera = Camera.new(Vector.new(800,600))


function SceneManager.addScene(scene)
    scene:init()
    scene:onCreate()
    SceneManager.scenes = {}
    table.insert(SceneManager.scenes,1,scene)
    scene:updateTransform(Matrix:identity())
    SceneManager.rootScene = scene
    SceneManager.camera:setTarget(scene)
    return scene
end

function SceneManager.removeScene(scene)
    for i = #SceneManager.scenes, 1, -1 do
        local v = SceneManager.scenes[i]
        if v.uuid == scene.uuid then
            table.remove( SceneManager.scenes,i)
            scene:onDestory()
        end
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
    v:visit(SceneManager.drawQueue,SceneManager.camera,SceneManager.defaultMt,SceneManager.updateScenes)
    if v.active and not system_editor_mode then
        v:update(dt)
    end
    SceneManager.updateScenes = false
end

function SceneManager.onTouchEvent(x,y,touchId,type)
    for i,v in ipairs(SceneManager.scenes) do
        if  v.active and v:onTouchEvent(x,y,touchId,type) then
            return true
        end
    end
    return false
end

function SceneManager.onKeyEvent(keyCode,type)
    for i = #SceneManager.scenes, 1, -1 do
        local v = SceneManager.scenes[i]
        if  v.active and v:onKeyEvent(keyCode,type) then
            return true
        end
    end
    return false
end

return SceneManager