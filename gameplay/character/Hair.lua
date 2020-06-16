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
require("Stance")
require("WzFile")
local Vector = require("Vector")
local WzNode = require("WzNode")
local Hair = class("Hair")

Hair.Layer = {}
Hair.Layer.NONE = 0
Hair.Layer.DEFAULT = 1
Hair.Layer.BELOWBODY = 2
Hair.Layer.OVERHEAD = 3--//带上帽子之后正面的样
Hair.Layer.SHADE = 4--//阴影
Hair.Layer.BACK = 5--背面样式
Hair.Layer.BELOWCAP =6 --带上帽子之后背面的样


Hair.LayerNames = 
{
	["hair"] = Hair.Layer.DEFAULT,
	["hairBelowBody"] = Hair.Layer.BELOWBODY,
	["hairOverHead"] = Hair.Layer.OVERHEAD,
	["hairShade"] = Hair.Layer.SHADE,
	["backHair"] = Hair.Layer.BACK,
	["backHairBelowCap"] = Hair.Layer.BELOWCAP
}

Hair.Cache = {}
Hair.CacheKeyToName = {}
Hair.loaded = false

function Hair.loadData(key)
  if Hair.loaded ~= true then 
    local hairs = WzFile.string["Eqp.img"]["Eqp"]["Hair"]

    hairs:foreach(function (k,v) 
        Hair.Cache[v["name"]:toString()] = tonumber(k)
        Hair.CacheKeyToName[tonumber(k)] = v["name"]:toString()
    end)
    Hair.loaded = true
  end

  if type(key) == "number" then
    return Hair.CacheKeyToName[key]
  end

  return Hair.Cache[key]
end


function Hair:ctor(id,drawInfo)
  self.id = id
  local node = WzFile.character["Hair"][string.format( "000%d.img",id)]
  node:tryExpand()
  self.stances = {}
  for stance = 1, Stance.LENGTH - 1 do

    if self.stances[stance] == nil then
       self.stances[stance] = {}
    end

    local stanceName = Stance[stance]
      if stanceName~= "" then
          local stanceNode = node[stanceName]
          if stanceNode:hasChildren() then
            local frame = 0
            local frameNode = stanceNode[frame]
            while frameNode:hasChildren() do
              frameNode:foreach(function (name,layerNode) 
                if layerNode:isUOL() then 
                   layerNode = layerNode:resolvePath()
                end
                local layer = Hair.LayerNames[name]
                if layer ~= nil then

                  local layers = self.stances[stance][layer]
                  if layers == nil then
                    layers = {}
                    self.stances[stance][layer] = layers
                  end

                  local brow = layerNode["map"]["brow"]
                 
                  local shift = drawInfo.getHairPosition(stance, frame) - brow:toVector()
                  local anim = Animation.new(layerNode.rawPtr)
                  anim:shift(shift)
                  layers[frame] = anim
                end
              end) 
              frame = frame + 1
              frameNode = stanceNode[frame]
            end
          end
      end
  end
end

function Hair:draw(stance,layer,frame,args)
  local st = self.stances[stance]

  if st == nil then
    st = self.stances[Stance.STAND1]
  end

  if st ~= nil then 
      local ly = st[layer]
      if ly == nil then
         ly = st[Hair.Layer.DEFAULT]
      end
      if ly ~= nil then
          local anim = ly[frame]
          if anim ~= nil then
              anim:draw(args)
          end
      end
  end 
end

return Hair