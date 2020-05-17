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

require ("Engine")
local Vector = require ("Vector")
ImObjectEditor = {
	open = true,
    name = "ObjectEditor",
    value = 0,
    
}

function ImObjectEditor.draw()

    local obj = Engine.editorFocusedObject
    if( imgui.Begin(ImObjectEditor.name,ImObjectEditor.open) ) then 
        if(obj ~= nil) then
            imgui.Text(string.format( "UUID:%s",obj.uuid)) 
            imgui.Separator()
            imgui.Text(string.format( "[%s][name:%s]",obj.__cname,obj.name)) 
            imgui.Separator()
            imgui.Text("Position")
            
            ImObjectEditor.drawPosition(obj)
            ImObjectEditor.drawTextProperties(obj) 
            ImObjectEditor.drawEditProperties(obj) 

            ImObjectEditor.drawName(obj)
            ImObjectEditor.drawScale(obj)
            ImObjectEditor.drawDimension(obj)
            ImObjectEditor.drawActive(obj)
            ImObjectEditor.drawEnabled(obj)
            ImObjectEditor.drawDrag(obj)
            ImObjectEditor.drawShowRect(obj)
            ImObjectEditor.drawRectColor(obj)
            ImObjectEditor.drawListener(obj)
            ImObjectEditor.drawBindScript(obj)

          

            --ImObjectEditor.drawChildren(obj)
        end  
	end
    imgui.End()
end


function ImObjectEditor.drawEditProperties(obj) 
    if obj.__cname == "EditText" then
        local ret, str
        imgui.PushID(obj.uuid .. "Content")
        ret, str = imgui.InputText("Content",obj.str)
        if ret and str ~= obj.str then
             obj:setText(str)
        end
        imgui.PopID()
    end
end


function ImObjectEditor.drawTextProperties(obj) 
    if obj.__cname == "TextView" then
        imgui.PushID(obj.uuid.." Alignment")

        local  alignment = { [text.Left] = "Left", [text.Center] = "Center", [text.Right] = "Right" }

        if imgui.BeginCombo("Alignment",alignment[obj.alignment or 0]) then
            for key, value in pairs(alignment) do
                if imgui.Selectable("Alignment_"..value) then  
                    obj:setAlignment(key)
                end
            end
            imgui.EndCombo()
        end
        imgui.PopID()

        imgui.PushID(obj.uuid.." Font")

        local fonts = { 
            [text.A11M] = "A11M",
            [text.A11B] = "A11B",
            [text.A12M] = "A12M",
            [text.A12B] = "A12B",
            [text.A18M] = "A18M",
            [text.A18B] = "A18B",
         }

        if imgui.BeginCombo("Fonts",fonts[obj.textFont or 0]) then
            for key, value in pairs(fonts) do
                if imgui.Selectable("Font_"..value) then  
                    obj:setTextFont(key)
                end
            end
            imgui.EndCombo()
        end
        imgui.PopID()

        imgui.PushID(obj.uuid.." Color")

        local  colors = {
            [text.BLACK] = "BLACK",
            [text.WHITE] = "WHITE",
            [text.YELLOW] ="YELLOW",
            [text.BLUE] =  "BLUE",
            [text.RED] =   "RED",
            [text.DARKRED] = "DARKRED",
            [text.BROWN] = "BROWN",
            [text.LIGHTGREY] =  "LIGHTGREY",
            [text.DARKGREY] =  "DARKGREY",
            [text.ORANGE] =  "ORANGE",
            [text.MEDIUMBLUE] =  "MEDIUMBLUE",
            [text.VIOLET] =  "VIOLET"
         }

        if imgui.BeginCombo("Color",colors[obj.color or 0]) then
            for key, value in pairs(colors) do
                if imgui.Selectable("Color_"..value) then  
                    obj:setColor(key)
                end
            end
            imgui.EndCombo()
        end
        imgui.PopID()

        local ret, str
        ret, str = imgui.InputText("Content",obj:getText())
        if ret and str ~= obj:getText() then
             obj:changeText(str)
        end

    end
end

function ImObjectEditor.drawPosition(obj)
    local ret,x,y
    ret,x = imgui.DragFloat("x",obj.position.x,1,0,0,"%.0f");
    ret,y = imgui.DragFloat("y",obj.position.y,1,0,0,"%.0f");
    if x ~= obj.position.x or y ~= obj.position.y then
        log(".....")
        obj:setPosition(Vector.new(x,y))
    end
    imgui.Separator()
end


function ImObjectEditor.drawRectColor(obj)
    local open = imgui.ColorButton("Rect Color",obj.rectColor)
end

function ImObjectEditor.drawDimension(obj)
    local ret,x,y
    ret,x = imgui.DragFloat("width",obj.dimension.x,1,0,0,"%.0f");
    ret,y = imgui.DragFloat("height",obj.dimension.y,1,0,0,"%.0f");
    if x ~= obj.dimension.x or y ~= obj.dimension.y then
        obj:setDimension(Vector.new(x,y))
    end
    imgui.Separator()
end

function ImObjectEditor.drawDrag(obj)
    local ret, drag
    ret, drag = imgui.Checkbox("Drag",obj.drag)
    if drag ~= obj.drag then
        obj.drag = drag
    end
end

function ImObjectEditor.drawActive(obj)
    local ret, active
    ret, active = imgui.Checkbox("isActive",obj.active)
    if active ~= obj.active then
        obj.active = active
    end
    imgui.SameLine()
end

function ImObjectEditor.drawEnabled(obj)
    local ret, enable
    ret, enable = imgui.Checkbox("Enabled",obj.enable)
    if enable ~= obj.enable then
        obj.enable = enable
    end
    imgui.SameLine()
end

function ImObjectEditor.drawShowRect(obj)
    local ret, showRect
    ret, showRect = imgui.Checkbox("showRect",obj.showRect)
    if showRect ~= obj.showRect then
        obj.showRect = showRect
    end
    imgui.SameLine()
end

function ImObjectEditor.drawScale(obj)
    local ret,x,y
    ret,x = imgui.DragFloat("scaleX",obj.scaleX,0.001,0,0,"%.3f");
    ret,y = imgui.DragFloat("scaleY",obj.scaleY,0.001,0,0,"%.3f");
    if x ~= obj.scaleX or y ~= obj.scaleY then
        --obj:setScale(x,y,1)
    end
    imgui.Separator()
end

function ImObjectEditor.drawChildren(obj)
    imgui.Text("Children")
    for index, v in ipairs(obj.gameObjs) do
        local nodeName = string.format( "[%s][name:%s]",v.__cname,v.name)
        imgui.PushID(v.uuid)
        if imgui.Text(nodeName) then
            --v.showRect = not v.showRect
            --obj = v
        end
        imgui.Separator()
        imgui.PopID()
    end
    imgui.Separator()
end



function ImObjectEditor.drawName(obj)
    local ret, str
    ret, str = imgui.InputText("Resouces",obj.name)
    if ret and str ~= obj.name then
        obj.name = str
    end
end

function ImObjectEditor.drawBindScript(obj)

    if imgui.BeginCombo("Running Scripts","") then
        if obj.bindScripts ~= nil then
            for k,v in pairs(obj.bindScripts) do
                imgui.PushID(obj.uuid)
                if imgui.Selectable(k) then
                    print(v)
                end
                imgui.PopID()
            end
        end
        imgui.EndCombo()    
    end


    if imgui.BeginDragDropTarget() then
        local ret = imgui.AcceptDragDropPayload("DragFile")
        if ret ~= nil then
            local table = dofile(ret)
            obj:addScript(table.new(),table.__cname) -- use as module name
        end
        imgui.EndDragDropTarget()
    end
 
end

function ImObjectEditor.handleScriptCombo(obj,fileName,funcName,moduleName,tips)
    
    imgui.PushID(obj.uuid.." Script input"..tips)
    local ret, str
    ret, str = imgui.InputTextWithHint("",tips,obj[fileName])
    if ret and str ~= obj[fileName] then
        obj[fileName] = str
        obj[funcName] = ""
    end
    imgui.PopID()


    if imgui.BeginDragDropTarget() then
        local ret = imgui.AcceptDragDropPayload("DragFile")
		if ret ~= nil then
            obj[fileName] = ret
		end
		imgui.EndDragDropTarget()
	end
 
    if obj[fileName] ~= nil and obj[fileName] ~= "" then

        imgui.PushID(tips)
        if imgui.BeginCombo("",obj[funcName] or "") then
            if(obj[fileName] ~= "") then 
                local table = dofile(obj[fileName])
                if table ~= nil and instanceOf(table,"LuaScript") then
                    for k,v in pairs(table) do
                        if(type(v) == "function" and k ~= "new" and k ~= "update" and k ~= "onLoaded" and k ~= "init"  and k ~= "ctor" and k ~= "onDestory") then
                            if imgui.Selectable(k) then  
                                obj[moduleName] = table.__cname;
                                package.loaded[table.__cname] = nil
                                obj[funcName] = k
                            end
                        end
                    end
                end
            end
            imgui.EndCombo()
        end
        imgui.PopID()
    end
    imgui.Separator()
end

function ImObjectEditor.drawListener(obj)
    ImObjectEditor.handleScriptCombo(obj,"clickScriptName","clickFunName","clickModule","Click Listener")
    ImObjectEditor.handleScriptCombo(obj,"releaseScriptName","releaseFunName","releaseModule","Release Listener")
    ImObjectEditor.handleScriptCombo(obj,"moveScriptName","moveFunName","moveModule","Move Listener")
 
end




function ImObjectEditor.update(dt)
    
end

return ImObjectEditor