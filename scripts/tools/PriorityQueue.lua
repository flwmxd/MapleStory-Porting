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

local floor = math.floor


local PriorityQueue = class("PriorityQueue")


function PriorityQueue:ctor()
    --[[  Initialization.
    Example:
        PriorityQueue = require("priorityQueue")
        pq = PriorityQueue()
    ]]--
    self.heap = {}
    self.currentSize = 0
end

function PriorityQueue:empty()
    return self.currentSize == 0
end

function PriorityQueue:size()
    return self.currentSize
end

function PriorityQueue:swim()
    -- Swim up on the tree and fix the order heap property.
    local heap = self.heap
    local floor = floor
    local i = self.currentSize

    while floor(i / 2) > 0 do
        local half = floor(i / 2)
        if heap[i][2] < heap[half][2] then
            heap[i], heap[half] = heap[half], heap[i]
        end
        i = half
    end
end

function PriorityQueue:put(v, p)
    --[[ Put an item on the queue.
    Args:
        v: the item to be stored
        p(number): the priority of the item
    ]]--
    --

    self.heap[self.currentSize + 1] = {callback = v, when = p}
    self.currentSize = self.currentSize + 1
    self:swim()
end

function PriorityQueue:sink()
    -- Sink down on the tree and fix the order heap property.
    local size = self.currentSize
    local heap = self.heap
    local i = 1

    while (i * 2) <= size do
        local mc = self:minChild(i)
        if heap[i][when] > heap[mc][when] then
            heap[i], heap[mc] = heap[mc], heap[i]
        end
        i = mc
    end
end

function PriorityQueue:minChild(i)
    if (i * 2) + 1 > self.currentSize then
        return i * 2
    else
        if self.heap[i * 2][when] < self.heap[i * 2 + 1][when] then
            return i * 2
        else
            return i * 2 + 1
        end
    end
end

function PriorityQueue:top()
    -- Remove and return the top priority item
    local heap = self.heap
    local retval = heap[1]
    return retval
end


function PriorityQueue:pop()
    -- Remove and return the top priority item
    local heap = self.heap
    local retval = heap[1]
    heap[1] = heap[self.currentSize]
    heap[self.currentSize] = nil
    self.currentSize = self.currentSize - 1
    self:sink()
    return retval
end

return PriorityQueue