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

local PriorityQueue = require "PriorityQueue"

Scheduler = {
    queue = PriorityQueue.new(),
    time = 0,
    tasks = {}
} 

function Scheduler.update(dt)
    Scheduler.time = Scheduler.time + dt

    while( Scheduler.queue:empty() == false)
    do
        local top = Scheduler.queue:top()

        if top.when >= Scheduler.time then
            break
        end

        if top.callback then
            top.callback()
        end

        Scheduler.queue:pop()
    end
        
    for i = #Scheduler.tasks, 1, -1 do
        if Scheduler.tasks[i](dt) then
            table.remove(Scheduler.tasks, i)
        end
    end

end


-- add delay task
function Scheduler.schdule(delay, task)
    Scheduler.queue:put(task, Scheduler.time + delay / 1000)
end

-- add task in mainLoop, the task will be called in every frame
-- if the @task return true, it will remove in the table else continue to execute
function Scheduler.addTask(task)
    table.insert(Scheduler.tasks,task)
end

return Scheduler


