hook.Add("EntityTakeDamage", "VehicleGun_FixDamage", function(_, dmginfo)
	if (dmginfo:GetInflictor():IsVehicle() and dmginfo:GetDamage() < 1) then
		if (dmginfo:GetAmmoType() == 18) then 
			dmginfo:SetDamage(15)
		elseif (dmginfo:GetAmmoType() == 20) then
			dmginfo:SetDamage(3)
		end
	end
end)