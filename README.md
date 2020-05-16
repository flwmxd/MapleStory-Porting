
# Pharaoh MapleStory

Pharaoh-MapleStory is a collection of tools for MapleStory, which contains a client-editor, a file-browser and the client itself. It support the **.wz** files(include **GMS KMS CMS**).

The business logic are written by lua.



|Windows10|Others|
| ----|------|
[![Build status](https:img.shields.io/badge/build-pass-green.svg)]()|[![Build Status](https:img.shields.io/badge/porting-progressing-red.svg)]()

![image](http://github.com/flwmxd/pharaohstory/raw/master/img/main-screen.png)


# Usage 

The editor contains a MapleStory-FileSystem-Browser, so you can use it find a resource and add it into game scene


http://github.com/flwmxd/pharaohstory/raw/master/img

![image](http://github.com/flwmxd/pharaohstory/raw/master/img/add-sprite.gif)


Beside, it support script-binding like Unity. so you can drag your own script to some specific GameObject 

![image](http://github.com/flwmxd/pharaohstory/raw/master/img/drag-script.gif)

### Others

if you want to add your own function,please read more NativeAPI for lua under the document.


# Dependency

* [glfw3](https:github.com/glfw/glfw) 
* [glew](https:github.com/nigels-com/glew) 
* [freetype2](https:www.freetype.org/) 
* [iconv](http:www.gnu.org/software/libiconv/) 
* [lua](http:www.lua.org/) 
* [openal](www.openal.org/) 
* [zlib](www.zlib.net/) 
* [imgui](https:github.com/ocornut/imgui)
* [WzTools](https:github.com/flwmxd/WzTools)

# Main features

* Language: C++ 17, with Lua, and lower dependency on os
* High quality code and modern game engine architecture
* Use own editor can be easily to create UI layer
* Basic Buttons,EditText TextView (Supprot maplestory rich-text)
* Smart memory management
* Support SIMD
* Support ImGui
* Support for .ttf fonts
* Support UTF-8 and UTF-16 and none-ascii characters

# Current Code

Those code in this repository are lua script. the C++ code will be updated in the future because they are so messy now.

# Architecture

this engine include two parts, one is the lua which is used to write core business and editor-plugin

in the native framework, it support the basic engine function such as Audio,Graphics,etc

![image](http://github.com/flwmxd/pharaohstory/raw/master/img/Architecture.png)

## Engine Architecture 

in lua framework, it include all upper engine components (GameObject,Scene,Sprite,Other UI components)


![image](http://github.com/flwmxd/pharaohstory/raw/master/img/lua-framework.png)

## Processing Graph

![image](http://github.com/flwmxd/pharaohstory/raw/master/img/processing.png)


# Some Concepts


## GameObject 

GameObject is a container and basic updatable, drawable, transformable, eventable,scriptable,serializable object. it's the root object in whole engine. it has a strong connection with engine and editor


## Sprite
Sprite is a 2d graphic object which can change its color, transform(scale rotation postion,etc)

![image](http://github.com/flwmxd/pharaohstory/raw/master/img/sprite.png)


## Scene

Scene is also a container, which is responsibilty for managing the whole game business logic and others components like sprite and UI . you can create it by using editor and can be switch easily. 


## UI

UI is user interface, these are components like **Button**  **TextView** **EditText**. 

The **Button** implements the original maplestory button logic, so you can add button from asserts easily.

The **TextView** implements the maplestory **Rich-Text** in native.

![image](http://github.com/flwmxd/pharaohstory/raw/master/img/text.gif)



# Roadmap

Platform | Windows | Mac | Linux | Android | iOS | Switch
:-: | :-: | :-: | :-: | :-: | :-: | :-:
Basic Render | Done(OpenGL 2.0) | - | - | Done(OpenGL ES 2.0) | Done(OpenGL ES 2.0) | -
Native Event | Done(glfw3)
Audio | XAudio | - | - | OpenSLES | OpenAL | -
FileSystem | Done |  - | - |  - | - | - |
SIMD | SSE | SSE | SSE | NEON | NEON | NEON
Lua Wrapper | Progrssing
Editor | Progrssing
Script Binding | Progrssing
Physics | Future
Particle System | Future
Game Business | Future

# Some Native Api for Lua

* Matrix  (Native)

the matrix object is created by native because it involve a large number of calculation.

##### Example : 
``` lua 
--create a zero matrix
    local matrix = Matrix.new()  
-- or 
    local matrix = Matrix.new({
        1,0,0,0,
        0,1,0,0,
        0,0,1,0,
        0,0,0,1
    })  
-- create an identity 
    local matrix = Matrix.identity()

-- there are others apis for transform

    function setTranslation(x,y,z) end
    function setRotation(Quaternion) end
    function setScale(x,y,z) end
    function setOrthographic(l,r,t,b,zNearPlane,zFarPlane) end

-- get a inverse matrix
-- @return a new matrix
    function invert() end
-- matrix also support the mul operator
    local m =  Matrix.new() *  Matrix.new()

```

* Quaternion (Native)


##### Example : 
``` lua 
-- create a Quaternion
    local q = Quaternion.new()
--or
    local q = Quaternion.identity()
-- set euler angle 
    function setEulerAngles(x,y,z) end

--combine with matrix
    local q = Quaternion.new()
    q:setEulerAngles(x,y,z)
    local rotationMatrix = Matrix.new()
    rotationMatrix:setRotation(self.rotation)
```



#### Example : 
``` lua
-- get a wz-node under UI.wz/UIWindow.img/AdminClaim
-- @return the WzNode which is a lua object
local node = WzFile.ui["UIWindow.img"]["AdminClaim"]["BtPClaim"]
```
* if the current node is a sprite type, which can be used to init a sprite

``` lua

local node = ......
--create a sprite with given node
local sprite = Sprite.new(node)
-- add into you scene
scene:addChild(sprite)

```


* WzNode (Native)

```lua
-- parse the path resource
wz.flat(string path) -> table {
    name ->  WzNode(lightuserdata),
    name2 -> WzNode(lightuserdata)
    .....
}

-- expand the rawPtr, get all sub node in it
wz.expand(rawPtr) -> table {
    name ->  WzNode(lightuserdata),
    name2 -> WzNode(lightuserdata)
    .....
}

-- convert the current node into different data type 
wz.toInt(@lightuserdata rawPtr,default) -> lua_number

wz.toReal(@lightuserdata rawPtr,default) -> lua_number

wz.toString(@lightuserdata rawPtr,default) -> lua_string

wz.toVector(@lightuserdata rawPtr) -> lua_number

```

* Audio (Native)

Audio component is a native engine which is desigined for play music and effect.

```lua
--- @param nodePath string
audio.playBGM(nodePath)

--- @param node string or id(which is pre-defined)
audio.playEffect(node)

-- there are all pre-defined audio effects
audio.BUTTONCLICK,
audio.BUTTONOVER,
audio.SELECTCHAR,
audio.GAMESTART,
audio.SCROLLUP,
audio.ATTACK,
audio.ALERT,
audio.JUMP,
audio.DROP,
audio.PICKUP,
audio.PORTAL,
audio.LEVELUP,
audio.DIED,
audio.INVITE,
audio.BUY_SHOP_ITEM,
audio.USE,
audio.TRANSFORM,
audio.QUEST_ALERT,
audio.QUEST_CLEAR,
audio.ENCHANT_FAILURE,
audio.ENCHANT_SUCCESS,

```


# License

```

 This file is part of the PharaohStroy MMORPG client                      
 Copyright ?2020-2022 Prime Zeng                                          
                                                                          
 This program is free software: you can redistribute it and/or modify     
 it under the terms of the GNU Affero General Public License as           
 published by the Free Software Foundation, either version 3 of the       
 License, or (at your option) any later version.                          
                                                                          
 This program is distributed in the hope that it will be useful,          
 but WITHOUT ANY WARRANTY; without even the implied warranty of           
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            
 GNU Affero General Public License for more details.                      
                                                                          
 You should have received a copy of the GNU Affero General Public License 
 along with this program.  If not, see <http:www.gnu.org/licenses/>.    

```