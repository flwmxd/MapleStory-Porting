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

Timer = {}

-- 0 - 1 accmulate in mainLoop 
Timer.deltaTime = 0
-- 
Timer.totalTime = 0

function Timer.update(dt)
    if Timer.deltaTime >= 1.0 then
        Timer.deltaTime = Timer.deltaTime - 1.0
    end
    Timer.deltaTime = Timer.deltaTime + dt
    Timer.totalTime = Timer.totalTime + dt
end

return Timer