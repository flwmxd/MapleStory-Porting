
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
local List = class("List")

local Node = class("Node")

function Node:ctor(val)
    self.val = val
end

function List:ctor()
    self.head = Node.new()
    self.current = self.head
end

function List:add(val)
    local node = Node.new(val)
    self.current.next = node
    self.current = node
end

function List:remove(val)
    local curr = self.head.next
    local prev = self.head

    while curr do
        if curr.val == val then 
            prev.next = curr.next
            if prev.next == nil then
                self.current = prev
            end
            break;
        end
        curr = curr.next
        prev = prev.next
    end
end

function List:foreach(lambda)
    local curr = self.head.next
    while curr do
        lambda(curr.val)
        curr = curr.next
    end
end

function List:forReverse(lambda)
    return recursion(self.head,lambda)
end

function recursion(node,lambda)
    local curr = node.next
    if curr then
        recursion(curr,lambda)
        if lambda(curr.val) then 
            return true
        end
    end
    return false
end

function List:output()
    local curr = self.head.next
    while curr do
        log(curr.val)
        curr = curr.next
    end
end

return List