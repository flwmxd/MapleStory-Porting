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

    if(type(key) == "table") then
        key = key:toString()
    end

    local node = table.children[key]
    if type(node) == "table" then
        return node
    end

    if(node ~= nil) then -- replace rawPtr to children table
        local sub = WzNode.new(node,key)
        table.children[key] = sub
        return sub
    end
    if (table.rawPtr == nil) then 
        return nil
    end
    local sub = WzNode.new(wz.find(table.rawPtr,key),key)
    table.children[key] = sub
    return sub
end

function WzNode:toInt(default)
    if self.rawPtr == nil then
        return default or 0
    end
    return wz.toInt(self.rawPtr,default or 0)
end

function WzNode:toString(default)
    if self.rawPtr == nil then
        return default or ""
    end
    return wz.toString(self.rawPtr,default or "")
end

function WzNode:tryExpand()
    if self.rawPtr ~= nil then
        self.children = wz.tryExpand(self.rawPtr)
    end
end

function WzNode:toReal(default)
    if self.rawPtr == nil then
        return default or 0
    end
    return wz.toReal(self.rawPtr,default or 0)
end

function WzNode:toBoolean(default)
    if self.rawPtr == nil then
        return default or false
    end
    return wz.toBoolean(self.rawPtr,default or false)
end

function WzNode:toVector()
    return wz.toVector(self.rawPtr)
end

function WzNode:hasChildren()
    for key, value in pairs(self.children) do
        return true
    end
    return false
end

function WzNode:foreach(callback)
    local t
    for k, v in pairs(self.children) do
        if type(v) ~= "table" then
            t = callback(k,WzNode.new(v,k))
        else
            t = callback(k,v)
        end
        if t ~= nil then
            return t
        end
    end
end

--@param identity is an optional arg
function WzNode.new(path,identity)
    local instance = {}
    setmetatable(instance,WzNode)
    instance.rawPtr = nil
    if path ~= nil then
        if type(path) == "userdata" then
            instance.children = wz.expand(path)
            instance.rawPtr = path
            instance.identity = identity
        elseif path ~= nil then
            instance.children = wz.flat(path)
        else
            instance.children = {}
        end

        for k,v in pairs(WzNode) do
            instance[k] = v
        end
    end
    return instance
end

function WzNode.add(a,b)
    local left = a
    local right = b

    if type(a) == "table" then
        left = a:toString()
    end

    if type(b) == "table" then
        left = b:toString()
    end

    return left .. right
end

WzNode.__add = WzNode.add

return WzNode