
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
require "SceneManager"
require "Timer"
require "PartsInfo"

-- single instance of current Game
Engine = {
    focusedGameObject = nil,
    editorFocusedObject = nil,
    elasped = 0,
    frames = 0,
    FPS = 0
}


function Engine.onStart()
    PartsInfo.load()
end

function Engine.draw()
    ImEngine.draw()
    SceneManager.draw()
    
    Engine.frames = Engine.frames + 1
    if(Engine.frames >= 100) then
        Engine.FPS = Engine.frames / Engine.elasped
        log("FPS " .. Engine.FPS)
        Engine.elasped = 0
        Engine.frames = 0
    end
end

function Engine.update(dt)
    --if not system_editor_mode then
        Timer.update(dt)
        Scheduler.update(dt)
    --end
    ImEngine.update(dt)
    SceneManager.update(dt)
    Engine.elasped = Engine.elasped + dt
end

function Engine.onTouchEvent(x,y,touchId,type)
    return SceneManager.onTouchEvent(x,y,touchId,type)
end

function Engine.onKeyEvent(keyCode,type)
    if(Engine.focusedGameObject ~= nil) then
        return Engine.focusedGameObject:onKeyEvent(keyCode,type)
    end
    return SceneManager.onKeyEvent(keyCode,type)
end

function Engine.focusGameObject(gameObj)
    
    if(Engine.focusedGameObject ~= nil) then -- the prev gameObj
        Engine.focusedGameObject.focused = false
    end

    if(gameObj ~= nil) then
        gameObj.focused = true
    end

    Engine.focusedGameObject = gameObj
end

return Engine