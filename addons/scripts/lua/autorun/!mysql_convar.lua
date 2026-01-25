if SERVER then
	CreateConVar("mg_mysql", game.IsDedicated() and 1 or 0, FCVAR_ARCHIVE)
end