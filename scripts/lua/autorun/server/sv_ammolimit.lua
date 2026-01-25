sbox_max_ammo = {
	["pistol"] = 100,
	["357"] = 60,
	["smg1"] = 300,
	["ar2"] = 300,
	["buckshot"] = 50,
	["lmg"] = 400,
	["sniperpenetratedround"] = 40,
	["grenade"] = 2,
	["m61_frag"] = 2,
	["sticky_grenade"] = 2,
	["smg1_grenade"] = 1,
	["ar2altfire"] = 1,
	["slam"] = 1,
	["rpg_round"] = 2,
	["m79_nade"] = 2,
	["rpg7_round"] = 2,
	["xbowbolt"] = 10,

	["aimbot"] = 250,
	["arrows"] = 15,
	["cannonballs"] = 2,
	["rainbow"] = 2
}

local next_think = 0
hook.Add("Think", "AmmoLimit_RestrictAmmo", function()
	if next_think > CurTime() then return end
	next_think = CurTime() + 0.1
	for _, ply in ipairs(player.GetAll()) do
		if ply.IsBuilder and ply:IsBuilder() then continue end
		for k, v in pairs(sbox_max_ammo) do
			if ply:GetAmmoCount(k) > v then
				ply:SetAmmo(v, k)
			end
		end
	end
end)