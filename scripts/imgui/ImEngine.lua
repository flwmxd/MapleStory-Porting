
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

require ("ImHierarchy")
require ("ImObjectEditor")
ImEngine = {
    components = {}
}

function ImEngine.onStart()
    table.insert(ImEngine.components,ImHierarchy )
    table.insert(ImEngine.components,ImObjectEditor)
end

function ImEngine.draw()
   for i,v in ipairs(ImEngine.components) do
       v.draw()
   end
end

function ImEngine.update(dt)
    for i,v in ipairs(ImEngine.components) do
        v.update(dt)
    end
end

return ImEngine