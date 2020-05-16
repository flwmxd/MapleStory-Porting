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

local WzNode = {}

WzNode.__index = function(table, key) 
    if(type(key) == "number") then
        key = key..""
    end
    local node = table.children[key]
    if(node ~= nil) then
        local sub = WzNode.expand(node)
        table.children[key] = sub
        return sub
    end
    return nil
end

function WzNode:toInt(default)
    return wz.toInt(self.rawPtr,default)
end

function WzNode:toString(default)
    return wz.toString(self.rawPtr,default)
end

function WzNode:toReal(default)
    return wz.toReal(self.rawPtr,default)
end

function WzNode:toVector()
    return wz.toVector(self.rawPtr)
end

function WzNode.new(path)
    local instance = {}
    setmetatable(instance,WzNode)
    if(path ~= nil) then
        instance.children = wz.flat(path)
    end
    for k,v in pairs(WzNode) do
        instance[k] = v
    end
    return instance
end

function WzNode.expand(rawPtr)
    local node = WzNode.new()
    node.children = wz.expand(rawPtr)
    node.rawPtr = rawPtr
    return node
end

return WzNode