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
require "Engine"
local LuaScript = require ("LuaScript")
local Vector = require 'Vector'
local Rect = require 'Rect'
local uuid = require("uuid")

local GameObject = class("GameObject")


GameObject.NORMAL = 0
GameObject.DISABLED = 1
GameObject.MOUSEOVER = 2
GameObject.PRESSED = 3

---
---create a GameObejct
---@param dimen Vector
---@param pos Vector
function GameObject:ctor(pos,dimen)
    self.dimension = dimen or Vector.new(0,0)
    self.position = pos or Vector.new(0,0)
	self.scaleX = 1
	self.scaleY = 1
    self.gameObjs = {}
    self.enable= true
    self.gameObj = nil
    self.active = true
    
    self.transform = Transform.new()
    self.calculatedTransform = Matrix.identity()
    self.transformDirty = true
    self.updateChildrenTransform = true
    self.touchId = -1
    self.touchs = { 
        [event.TOUCH_SCROLL]   =  self.onMove,
        [event.TOUCH_CLICK]    =  self.onPress,
        [event.TOUCH_RELEASE]  =  self.onRelease
    }
    self.bindScripts = {}
    
    self.moveScriptName = ""
    self.moveFunName = ""

    self.clickScriptName = ""
    self.clickFunName = ""

    self.releaseScriptName = ""
    self.releaseFunName = ""

    self.canSerialize = true
    self.name = ""
    self.state = GameObject.NORMAL
    self.rect = Rect.new(0,0,0,0)

    self.transform:setTranslation(self.position.x,self.position.y,0)
    self.transform:setScale(self.scaleX,self.scaleY,1)

----recommend it for editor mode-----
    self.uuid = uuid() -- enable it have a unique id ,make sure it can be used correctly in imgui
    self.drag = false
    self.showRect = false
    self.rectColor = 0xFF00FF80
-------------------------------------
end

---
---Init GameObejct and set its binded scripts at runtime
function GameObject:init()

    if self.gameObjs == nil then
        self.gameObjs = {}
    end

    if self.bindScripts == nil then
        self.bindScripts = {}
    end

    for k,v in pairs(self.bindScripts) do
        if #v == 0 and not system_editor_mode then
            local table = package.loaded[k] or require(k)
            local script = table.new()
            script.name = k
            script.gameObject = self
            script:onLoaded()
            self.bindScripts[k] = script
        end
    end
end

---
---Set scale of the current object 
---@param x number
---@param y number
---@param z number
function GameObject:setScale(x,y,z)
    self.scaleX = x;
    self.scaleY = y;
    self.scaleZ = z;
    self.transform:setScale(x,y,z)
    self:updateTransformDirty()
end

---
---Set Dimension of the current object 
---@param dimension Vector
function GameObject:setDimension(dimension)
    self.dimension = dimension
    self:updateTransformDirty()
end


---
---@param x number
function GameObject:setScaleX(scaleX)
    self.scaleX = scaleX;
    self.transform:setScale(self.scaleX,self.scaleY,1)
    self:updateTransformDirty()
end


---@param y number
function GameObject:setScaleY(scaleY)
    self.scaleY = scaleY;
    self.transform:setScale(self.scaleX,self.scaleY,1)
    self:updateTransformDirty()
end

-- set position in the world
---@param pos Vector
function GameObject:setPosition(newPos)
    self.position = newPos
    self.transform:setTranslation(self.position.x,self.position.y,0)
    self:updateTransformDirty()
end


-- set position in the world
---@param newRotation can be number and Quaternion or table which contains X,Y,Z
function GameObject:setRotation(newRotation)
    local theType = typeof(newRotation)
    assert(theType == "table" or theType == "Quaternion" or theType == "number","Rotation arg error")
    if theType == "number" then
        self.transform:setEulerAngles(0,0,newRotation);
    end
    self:updateTransformDirty()
end

function GameObject:updateTransform(transform)
    self.transform:setParentTansform(transform)
    self:updateTransformDirty()
end

function GameObject:updateTransformDirty()
    self.transformDirty = true
    for k,v in pairs(self.gameObjs) do
        v:updateTransformDirty()
    end
end


function GameObject:calculateTransform()
    self.transform:calculateLocalTransform()
    self.transformDirty = false
    self.updateChildrenTransform = true
    self.transform:calculateTransform()
    self.inverseTransform = self.transform:getInverseTranform()
    self:setNativeTransform()

    local x,y,z = self.transform:getTranslation()
    local lt = Vector.new(x,y) - self:getOrigin()
    local rb = lt + self.dimension * Vector.new(self.scaleX,self.scaleY);
    self.rect:update(lt.x,lt.y,rb.x,rb.y)
end

function GameObject:setNativeTransform()

end

-- it will be called before update() 
---@param drawQueue if current obj can be visibable, it will enqueue 
---@param camera  the view point you can see
---@param parentTransform transforms in parent
---@param parentDirty  if parent has expirence a transform, the chilld would recalculate
function GameObject:visit(drawQueue,camera,parentTransform, parentDirty)
  
    if(parentDirty) then 
        self:updateTransform(parentTransform)
    end

    if(self.transformDirty) then
        self:calculateTransform()
    end

    if camera:checkVisibility(self) and self.active then
        table.insert(drawQueue,self)
        for index, v in ipairs(self.gameObjs) do
            v:visit(drawQueue,camera,self.transform,self.updateChildrenTransform)
        end
    end
    
    self.updateChildrenTransform = false
end


function GameObject:addChild(child)
    assert(instanceOf(child,"GameObject") ,"child should be a subclass of GameObejct")
    if(child == nil ) then 
        log("child is nil")
        return nil
    end
    if(self.gameObjs == nil) then
        self.gameObjs = {}
    end
    child.parent = self
    child.parentMatrix = self.transform
    table.insert(self.gameObjs,child)
    return child
end


-- swap the position in children
---@param child1
---@param child2
function GameObject:swap(child,child2)
    local index1 , index2 = 0
    for i = #self.gameObjs, 1, -1 do
        local v = self.gameObjs[i]
        if(v.uuid == child.uuid) then
            index1 = i
        end
        if(v.uuid == child2.uuid) then
            index2 = i
        end
        if index1 ~= 0 and index2 then
            break
        end
    end
    self.gameObjs[index1] = child2
    self.gameObjs[index2] = child
end



function GameObject:removeChild(child)
    if(child ~= nil ) then 
        for i = #self.gameObjs, 1, -1 do
            local v = self.gameObjs[i]
            if(v.uuid == child.uuid) then
                table.remove(self.gameObjs,i)
                return v
            end
        end
    end
    return nil
end


function GameObject:draw(camera)
    self:drawBox(camera)
end

function GameObject:update(dt)
   
    for i,v in ipairs(self.gameObjs) do
        if v.active then
            v:update(dt)
        end
    end


    if not system_editor_mode then
        if self.bindScripts ~= nil then
            for i,v in pairs(self.bindScripts) do
                v:update(dt)
            end
        end
    end

end

function GameObject:drawBox(camera)
    if self.highligted or self.showRect then 
        --local vp = camera:getViewProjection() * self.transform:getTransform()
        local origin = self:getOrigin()
        render.drawRect(-origin.x,-origin.y,self.rect.width,self.rect.height,self.rectColor,camera:getViewProjection() * self.transform:getTransform())
        self.highligted = false
    end
end

-- get boundingBox based the left and top as the start point
function GameObject:bounds()
    return self.rect
end

function GameObject:getOrigin()
    return Vector.new(0,0)
end


function GameObject:onTouchEvent(x,y,touchId,type)
    
  
    local click = function(obj,x,y,touchId,type)
        if(type == event.TOUCH_CLICK) then
            return obj:onPress(x,y,touchId,type)
        elseif(type == event.TOUCH_RELEASE)then
            return obj:onRelease(x,y,touchId,type)
        elseif(type == event.TOUCH_SCROLL)then
            return obj:onMove(x,y,touchId,type)
        end
    end


    if self.drag then
        if type == event.TOUCH_CLICK and self:bounds():contains(Vector.new(x,y))then
            self.pressed = true
            self.lastPositon = Vector.new(x,y)
            self.touchId = touchId
            if not system_editor_mode then 
                return click(self,x,y,touchId,type)
            end
            return true
        elseif type == event.TOUCH_RELEASE and self.pressed then
            self.pressed = false
            self.lastPositon = Vector.new(x,y)
            self.touchId = -1
            if not system_editor_mode then 
                return click(self,x,y,touchId,type)
            end
            return true
        else
            if self.pressed	== true and self.touchId == touchId then
                local currPos = Vector.new(x,y)
                local pos = currPos - self.lastPositon
                self:setPosition(self.position + pos)
                self.lastPositon = currPos
                return true
            end
        end
    end
    
   
        if(self:bounds():contains(Vector.new(x,y))) then 
            for i = #self.gameObjs, 1, -1 do
                local v = self.gameObjs[i]
                if v.active and v.enable then
                    if v:onTouchEvent(x,y,touchId,type) then
                        return true
                    end
                end
            end

            if not system_editor_mode then 
                return click(self,x,y,touchId,type)
            end
            return false

        elseif(self.touchId == touchId) then 
                -- which means the view still contains the foucs
            if type == event.TOUCH_RELEASE or type == event.TOUCH_SCROLL and self.pressed then
                if not system_editor_mode then 
                    return click(self,x,y,touchId,type)
                end
                return false
            end
        else
            self:onLostMouse()
        end
    return false
end

function GameObject:onKeyEvent(keyCode,type)
    return false
end


function GameObject:onLostMouse()
    self.state = GameObject.NORMAL
    self.pressed = false
end

function GameObject:isActive()   
    return self.active
end

function GameObject:callScript(fileName,funcName,moduleName,scriptObj)

    if fileName ~= "" and funcName ~= "" then
        if scriptObj == nil or #scriptObj == 0 then
            local table = package.loaded[moduleName] or require(moduleName)
            if instanceOf(table,"LuaScript") then
                scriptObj = table.new()
                scriptObj.name = fileName
                scriptObj.gameObject = self
                self:addScript(scriptObj,moduleName)
            else
                log(string.format( "script %s is not a subclass of LuaScript",fileName))
            end
        end

        local func = scriptObj[funcName]
        if(func ~= nil) then
            func(scriptObj,self)
        end
    end
    return scriptObj
end

function GameObject:onPress(x,y,touchId,type)
    self.state = GameObject.PRESSED
    if not self.pressed then
        Engine.focusGameObject(self)
        self.touchId = touchId
        self.pressed = true
        if self.onClickListener ~= nil then 
            self.onClickListener(self)
        end
        self.scriptObjClick = self:callScript( self.clickScriptName,self.clickFunName,self.clickModule,self.scriptObjClick)
    end
    return true
end

function GameObject:onRelease(x,y,touchId,type)

    if self.touchId == touchId and self:bounds():contains(Vector.new(x,y)) then 
        self.state = GameObject.MOUSEOVER
    else
        self.state = GameObject.NORMAL
    end

    if(self.touchId == touchId and self.pressed) then 
        self.touchId = -1
        self.pressed = false
        if self.onReleaseListener ~= nil then 
            self.onReleaseListener(self)
            return true
        end
        self.scriptObjRelease = self:callScript(self.releaseScriptName,self.releaseFunName,self.releaseModule,self.scriptObjRelease)
        if self.scriptObjRelease ~= nil then
            return true
        end
    end
    return false
end

function GameObject:onMove(x,y,touchId,type)
    if(self.state ~= GameObject.PRESSED) then 
        self.state = GameObject.MOUSEOVER
    end

    self.scriptObjMove = self:callScript(self.moveScriptName,self.moveFunName,self.moveModule,self.scriptObjMove)
    if self.scriptObjMove then
        return true
    end
    
    if self.onMoveListener ~= nil then 
       self.onMoveListener(self)
       return true
    end
    return true
end

function GameObject:setOnClickListener(listener)
    self.onClickListener = listener
end

function GameObject:setOnMoveListener(listener)
    self.onMoveListener = listener
end

function GameObject:setOnReleaseListener(listener)
    self.onReleaseListener = listener
end

function GameObject:highlight()
    self.highligted = true
end

function GameObject:addScript(script,moduleName)
    assert(instanceOf(script,"LuaScript"),string.format( "script %s is not a subclass of LuaScript",moduleName))
    if self.bindScripts == nil then
        self.bindScripts = {}
    end

    if self.bindScripts[moduleName] == nil then
        if not system_editor_mode  then
            script.name = moduleName
            script.gameObject = self
            script:onLoaded()
            self.bindScripts[moduleName] = script
        else -- editor mode only save the state, not store the runtime information
            self.bindScripts[moduleName] = {}
        end
    end
end

return GameObject
