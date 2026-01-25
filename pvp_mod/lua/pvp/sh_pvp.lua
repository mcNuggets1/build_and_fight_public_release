team.SetUp(PVP.BuilderTeamNumber, PVP.BuilderName, PVP.BuilderColor)
team.SetUp(PVP.FighterTeamNumber, PVP.FighterName, PVP.FighterColor)

local meta = FindMetaTable("Player")

function meta:IsBuilder()
	return self:Team() == PVP.BuilderTeamNumber
end

function meta:IsFighter()
	return self:Team() == PVP.FighterTeamNumber
end

hook.Add("PlayerNoClip", "PVP_RestrictNoClip", function(ply)
	if ply:IsFighter() then
		return false
	end
end)