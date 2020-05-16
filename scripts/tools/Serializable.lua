
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


Serializable = {}

function Serializable.serialize(obj,level)
    
    local t = type(obj)


    level = level or 1
    local lua = ""

    local prefix = ""
    for i = 1, level do
        prefix = prefix.."\t"
    end

 
    if t == "number" then
        lua = lua .. obj
    elseif t == "boolean" then
        lua = lua .. tostring(obj)
    elseif t == "string" then
        lua = lua .. string.format("%q", obj)
    elseif t == "table" then
        lua = lua .. "{\n"
        
        local s = obj.canSerialize 
        if s ~= nil and not s then
            return lua .."}\n"
        end


    for k, v in pairs(obj) do
        if (type(v) ~= "function" and type(v) ~= "userdata" and k ~= "super" and k~= "parent" and k~= "gameObject" and k~= "__index" ) then 
            local next = level + 1
            lua = lua ..prefix.. "[" .. Serializable.serialize(k,level) .. "]=" .. Serializable.serialize(v,next) .. ",\n"
        end
    end
    local metatable = getmetatable(obj)
        if metatable ~= nil and type(metatable.__index) == "table"  then
        for k, v in pairs(metatable.__index) do
            if (type(v) ~= "function"  and ser and type(v) ~= "userdata" and k ~= "super" and k~= "parent" and k~= "gameObject" and k~= "__index") then 
                local next = level + 1
                lua = lua ..prefix.. "[" .. Serializable.serialize(k,level) .. "]=" .. Serializable.serialize(v,next) .. ",\n"
            end
        end
    end
        local tab = ""
        for i = 1, level - 1 do
            tab = tab.."\t"
        end

        lua = lua ..tab.. "}"
    elseif t == "nil" then
        return nil
    else
        --error("can not serialize a " .. t .. " type.")
    end
    return lua
end


function Serializable.deserialize(lua)
    local t = type(lua)
    if t == "nil" or lua == "" then
        return nil
    elseif t == "number" or t == "string" or t == "boolean" then
        lua = tostring(lua)
    else
        error("can not unserialize a " .. t .. " type.")
    end
    lua = "return " .. lua
    local func = load(lua)
    if func == nil then
        return nil
    end
    return func()
end

return Serializable