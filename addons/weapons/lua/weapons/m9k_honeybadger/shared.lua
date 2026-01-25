SWEP.Category = "M9K Assault Rifles"
SWEP.PrintName = "AAC Honey Badger"
SWEP.AimHideCrosshair = true
SWEP.Slot = 2
SWEP.SlotPos = 5
SWEP.Weight = 30
SWEP.HoldType = "ar2"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_aacbadger.mdl"
SWEP.WorldModel = Model("models/weapons/w_aac_honeybadger.mdl")
SWEP.Base = "mg_sniper_base"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Primary.Sound = Sound("Weapon_HoneyB.single")
SWEP.Primary.RPM = 750
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.KickUp = 0.6
SWEP.Primary.KickHorizontal = 0.3
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
SWEP.CanSelectFire = true
SWEP.Secondary.ScopeZoom = 3.5	
SWEP.Secondary.UseAimpoint = true
SWEP.ScopeScale = 0.7
SWEP.Primary.Damage = 25
SWEP.Primary.Spread = 0.032
SWEP.Primary.IronAccuracy = 0.013
SWEP.SightsPos = Vector(-3.096, -3.695, 0.815)
SWEP.SightsAng = Vector(0.039, 0, 0)
SWEP.RunSightsPos = Vector(4.094, -2.454, -0.618)
SWEP.RunSightsAng = Vector(-8.957, 53.188, -9.195)
SWEP.WeaponType = "assault"

SWEP.WElements = {
	["lense"] = {type = "Model", model = "models/xqm/panel360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.671, 0.832, -8.141), angle = Angle(0, 0, 0), size = Vector(0.039, 0.039, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/wystan/attachments/aimpoint/lense", skin = 0, bodygroup = {}},
	["scope"] = {type = "Model", model = "models/wystan/attachments/aimpoint.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-2.543, 0.463, 1.733), angle = Angle(-180, 90, 0), size = Vector(1.45,1.45,1.45), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
	["lense+"] = {type = "Model", model = "models/xqm/panel360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.041, 0.832, -8.1), angle = Angle(0, 0, 0), size = Vector(0.039, 0.039, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/wystan/attachments/aimpoint/lense", skin = 0, bodygroup = {}}
}
SWEP.VElements = {
	["aimpoint"] = {type = "Model", model = "models/wystan/attachments/aimpoint.mdl", bone = "Gun", rel = "", pos = Vector(0.228, 7.487, -4.416), angle = Angle(0, 180, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}},
	["lense"] = {type = "Model", model = "models/xqm/panel360.mdl", bone = "Gun", rel = "aimpoint", pos = Vector(0.298, 4.546, 6.756), angle = Angle(0, 90, 38.293), size = Vector(0.024, 0.024, 0.024), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/wystan/attachments/aimpoint/lense", skin = 0, bodygroup = {}}
}

if !ConVarExists("mg_m9k_defaultclip") then
	print("mg_m9k_defaultclip ConVar was not set up properly!")
else
	if GetConVar("mg_m9k_defaultclip"):GetInt() != -1 then
		SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * GetConVar("mg_m9k_defaultclip"):GetInt()
	end
end