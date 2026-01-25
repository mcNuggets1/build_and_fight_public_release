AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_networking.lua")
AddCSLuaFile("vgui/achframe.lua")
AddCSLuaFile("vgui/achnotify.lua")
AddCSLuaFile("vgui/achprogressbar.lua")

include("shared.lua")
include("sv_data.lua")
include("sv_player.lua")

AddCSLuaFile("skin/"..achievements.Skin..".lua")