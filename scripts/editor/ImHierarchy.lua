
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



--- single instance is OK for imgui component

require "SceneManager"

local Scene = require("Scene")
local Layer = require("Layer")
local Vector = require("Vector")

local TextView = require("TextView")
local EditText = require("EditText")

local GameObject = require("GameObject")

ImHierarchy = {
    darkMode = true,
	open = true,
	name = "Hierarchy"
}

function ImHierarchy.draw()
	if( imgui.Begin(ImHierarchy.name,ImHierarchy.open) ) then 
		ImHierarchy.rightClick()
		ImHierarchy.listScenes()
		--local inverse = SceneManager.camera:getInverseProjection()
		--local tans = inverse:getTranslation()
		--imgui.Text(string.format("%f,%f",tans.x,tans.y))
		imgui.Separator()
		local ret,x,y
		ret,x = imgui.DragFloat("Camera X", SceneManager.camera.x,1,0,0,"%.0f");
		ret,y = imgui.DragFloat("Camera Y", SceneManager.camera.y,1,0,0,"%.0f");
	
		if x ~= SceneManager.camera.x or y ~= SceneManager.camera.y then
			SceneManager.camera:setPosition(x,y)
		end

			
	end
	imgui.End()
end

function ImHierarchy.listScenes()
	local v = SceneManager.rootScene
	if v~= nil then 
		if(imgui.TreeNode(string.format("%s(%s) , size : %d",v.name,v.__cname,#v.gameObjs))) then
			ImHierarchy.sceneNodeClick(v,v.__cname)
			ImHierarchy.focusItem(v)
			ImHierarchy.listSubItems(v,v.gameObjs)
			imgui.TreePop()
		end
	end
end


function ImHierarchy.sceneNodeClick(scene,nodeName)
	if imgui.BeginPopupContextItem(nodeName) then 
		
		if imgui.MenuItem("Layer") then
			scene:addLayer(Layer.new(Vector.new(0,0),Vector.new(800,600)))
		end

		imgui.Separator();

		if imgui.MenuItem("GameObject") then
			scene:addChild(GameObject.new(Vector.new(50,50),Vector.new(50,50)))
		end
	
		imgui.Separator();
		if imgui.BeginMenu("UI") then
			if imgui.MenuItem("TextView") then
				scene:addChild(TextView.new(
					Vector.new(50,50),Vector.new(0,0),text.LEFT,text.BLACK,text.A11M,"Sample Text"
				))
			end
			imgui.Separator();
			if imgui.MenuItem("EditText") then
				scene:addChild(EditText.new(
					Vector.new(300,400),Vector.new(100,50),"Sample Input"
				))
			end
			imgui.EndMenu();
		end

		imgui.Separator();

		if imgui.MenuItem("Save") then
			scene:saveScene()
		end
	
		if imgui.MenuItem("Close") then
			scene:saveScene()
			SceneManager.removeScene(scene)
		end

		imgui.EndPopup();
	end
end	



function ImHierarchy.gameObjectClick(parent,obj,nodeName)
	if imgui.BeginPopupContextItem(nodeName) then 
		
		if imgui.MenuItem("GameObject") then
			local child = obj:addChild(GameObject.new(Vector.new(50,50),Vector.new(50,50)))
			child.showRect = true
			if Engine.editorFocusedObject ~= nil then
				Engine.editorFocusedObject.showRect = false
			end
			Engine.editorFocusedObject = child
		end
	
		if imgui.MenuItem("Delete") then
			parent:removeChild(obj)
		end

		if imgui.MenuItem("PrintTable") then
			printTable(obj)
		end

		imgui.Separator();
		if imgui.BeginMenu("UI") then
			if imgui.MenuItem("TextView") then
				local child = obj:addChild(TextView.new(
					Vector.new(50,50),Vector.new(0,0),text.LEFT,text.BLACK,text.A11M,"Sample Text"
				))
				child.showRect = true
				if Engine.editorFocusedObject ~= nil then
					Engine.editorFocusedObject.showRect = false
				end
				Engine.editorFocusedObject = child
			end
			imgui.Separator();
			if imgui.MenuItem("EditText") then
				local child = obj:addChild(EditText.new(
					Vector.new(300,400),Vector.new(100,50),"Sample Input"
				))
				
				child.showRect = true
				if Engine.editorFocusedObject ~= nil then
					Engine.editorFocusedObject.showRect = false
				end
				Engine.editorFocusedObject = child
			end
			imgui.EndMenu();
		end
		imgui.EndPopup();
	end
end	



function ImHierarchy.rightClick()
	if imgui.BeginPopupContextWindow("Scene Menu") then
		if imgui.Selectable("Add Scene") then
			local scene = SceneManager.addScene(Scene.new(Vector.new(0,0),Vector.new(800,600)))
			scene.name = "SampleScene"
			scene.showRect = true
		end
		imgui.EndPopup()	
	end
end

function ImHierarchy.listSubItems(parent,subNode)

	for i,v in ipairs(subNode) do
		local nodeName = string.format( "%s(%s) visibile",v.name,v.__cname)
		if not v.visibile  then 
			nodeName = string.format( "%s(%s)",v.name,v.__cname)
		end 
		imgui.PushID(v.uuid)

		if #v.gameObjs > 0 then
			if imgui.TreeNode(nodeName) then
				ImHierarchy.focusItem(v)
				ImHierarchy.dragReorder(v,true)
				ImHierarchy.gameObjectClick(parent,v,nodeName)
				ImHierarchy.listSubItems(v,v.gameObjs)
				imgui.TreePop()
			else
				ImHierarchy.dragReorder(v,true)
			end
		
		else
			
			if imgui.Selectable(nodeName) then 
				Engine.editorFocusedObject = v
				--SceneManager.camera:setTarget(v)
			end
			
			ImHierarchy.gameObjectClick(parent,v,nodeName)
			ImHierarchy.dragReorder(v,false)
		end

		if imgui.IsItemHovered() then
			v:highlight()
		end

		imgui.PopID()
	end
end


function ImHierarchy.dragReorder(cur,asChild)
	if imgui.BeginDragDropSource() then
		imgui.SetDragDropPayload("dragReorder",cur);
		imgui.EndDragDropSource()
	end
	if imgui.BeginDragDropTarget() then
		local ret = imgui.AcceptDragDropPayload("dragReorder")
		if ret ~= nil then
			if ret.parent ~= cur then
				if asChild then 
					local removed = ret.parent:removeChild(ret)
					cur:addChild(removed)
				elseif ret.parent == cur.parent then
					ret.parent:swap(cur,ret)
				end
			else
				cur.parent:addChild(ret.parent:removeChild(ret))
			end
		end
		imgui.EndDragDropTarget()
	end
end

function ImHierarchy.focusItem(v)
	if(imgui.IsItemClicked()) then
		Engine.editorFocusedObject = v
		
	end
end

function ImHierarchy.update(dt)
    
end

return ImHierarchy