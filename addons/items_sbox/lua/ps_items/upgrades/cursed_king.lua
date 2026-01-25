ITEM.Name = 'Verfluchter König (Einmalig)'
ITEM.Price = 5000
ITEM.Model = 'models/props_phx/games/chess/black_king.mdl'
ITEM.Description = "50% Chance auf erhöhte Schadensresistenz (35%).\n40% Chance auf Erblindung.\n10% Chance auf Verstümmelung.\n\nNur als Fighter verwendbar!"
ITEM.NoPreview = true

local function PS_Curse(ply)
	local chance = math.random(1, 100)
	if chance < 50 then
		ply:ChatPrint("Der verfluchte König hat dich verstärkt. (+40% Resistenz)")
		ply.PS_Cursed = true
	elseif chance < 90 then
		ply:ChatPrint("Der verfluchte König hat dich erblindet.")
		ply:SetNW2Bool("PS_Cursed", true)
	else
		ply:ChatPrint("Der verfluchte König hat dich verkrüppelt.")
		ply:SetNW2Bool("PS_Crippled", true)
	end
	ply:EmitSound("npc/fast_zombie/wake1.wav")
	local edata = EffectData()
	edata:SetOrigin(ply:GetPos() + Vector(0, 0, 2))
	util.Effect("curse_effect", edata, true, true)
	ply:PS_TakeItem("cursed_king")
end

function ITEM:CanPlayerEquip(ply)
	if ply:IsBuilder() then
		ply:PS_Notify("Dieses Item ist nur für Fighter verfügbar!")
		return false
	end
	return true
end

function ITEM:OnEquip(ply)
	PS_Curse(ply)
end

function ITEM:OnHolster(ply)
end

local local_ply

local cm = {}
cm["$pp_colour_brightness"] = -0.55
cm["$pp_colour_contrast"] = 1
cm["$pp_colour_addr"] = 0
cm["$pp_colour_addg"] = 0
cm["$pp_colour_addb"] = 0
cm["$pp_colour_mulr"] = 0
cm["$pp_colour_mulg"] = 0
cm["$pp_colour_mulb"] = 0
cm["$pp_colour_colour"] = 1
local function CurseEffect()
	local_ply = local_ply or LocalPlayer()
	if !local_ply:GetNW2Bool("PS_Cursed") then return end
	DrawColorModify(cm)
end
hook.Add("RenderScreenspaceEffects", "PS_Curse", CurseEffect)

local function CurseSpeed(ply, mv)
	if ply:GetNW2Bool("PS_Crippled") then
		mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * 0.6)
		mv:SetMaxSpeed(mv:GetMaxSpeed() * 0.6)
	end
end

local ply_tbl = {}
local hook_exists
local function CheckCrippled(ply, name, old, new)
	if name == "PS_Crippled" and old != new then
		ply_tbl[ply] = new
		local found
		for k in pairs(ply_tbl) do
			if IsValid(k) then
				found = true
				break
			else
				ply_tbl[k] = nil
			end
		end
		if found then
			if hook_exists then return end
			hook_exists = true
			hook.Add("Move", "PS_Curse", CurseSpeed)
		else
			hook_exists = nil
			hook.Remove("Move", "PS_Curse")
		end
	end
end
hook.Add("EntityNetworkedVarChanged", "PS_Curse", CheckCrippled) 

if SERVER then
	hook.Add("PlayerSpawn", "PS_Curse", function(ply)
		if ply.PS_Cursed or ply:GetNW2Bool("PS_Cursed") or ply:GetNW2Bool("PS_Crippled") then
			ply.PS_Cursed = nil
			ply:SetNW2Bool("PS_Cursed", false)
			ply:SetNW2Bool("PS_Crippled", false)
		end
	end)

	hook.Add("PlayerDeath", "PS_Curse", function(ply)
		if ply.PS_Cursed or ply:GetNW2Bool("PS_Cursed") or ply:GetNW2Bool("PS_Crippled") then
			ply.PS_Cursed = nil
			ply:SetNW2Bool("PS_Cursed", false)
			ply:SetNW2Bool("PS_Crippled", false)
		end
	end)

	hook.Add("PlayerDisconnected", "PS_Cure", function(ply)
		if ply.PS_Cursed or ply:GetNW2Bool("PS_Cursed") or ply:GetNW2Bool("PS_Crippled") then
			ply:SetNW2Bool("PS_Crippled", false)
		end
	end)

	hook.Add("EntityTakeDamage", "PS_Curse", function(ply, dmg)
		if ply.PS_Cursed then
			dmg:ScaleDamage(0.65)
		end
	end)
end