include("shared.lua")

ENT.DEBUG = false

ENT.KeysDown = {}
ENT.KeysWasDown = {}

ENT.AllowAdvancedMode = false
ENT.AdvancedMode = false
ENT.ShiftMode = false

--ENT.PageTurnSound = Sound( "GModTower/inventory/move_paper.wav" )
surface.CreateFont("InstrumentKeyLabel", {
	size = 22, weight = 400, antialias = true, font = "Impact"
})
surface.CreateFont("InstrumentNotice", {
	size = 30, weight = 400, antialias = true, font = "Impact"
})

// For drawing purposes
// Override by adding MatWidth/MatHeight to key data
ENT.DefaultMatWidth = 128
ENT.DefaultMatHeight = 128
// Override by adding TextX/TextY to key data
ENT.DefaultTextX = 5
ENT.DefaultTextY = 10
ENT.DefaultTextColor = Color(150, 150, 150, 255)
ENT.DefaultTextColorActive = Color(80, 80, 80, 255)
ENT.DefaultTextInfoColor = Color(120, 120, 120, 150)
ENT.DefaultTextLeaveColor = Color(255, 255, 255)

ENT.MaterialDir	= ""
ENT.KeyMaterials = {}

ENT.MainHUD = {
	Material = nil,
	X = 0,
	Y = 0,
	TextureWidth = 128,
	TextureHeight = 128,
	Width = 128,
	Height = 128,
}

ENT.AdvMainHUD = {
	Material = nil,
	X = 0,
	Y = 0,
	TextureWidth = 128,
	TextureHeight = 128,
	Width = 128,
	Height = 128,
}

function ENT:Initialize()
	self:PrecacheMaterials()
end

function ENT:Think()
	if !IsValid(LocalPlayer().Instrument) || LocalPlayer().Instrument != self then return end
	if self.DelayKey && self.DelayKey > CurTime() then return end

	for keylast, keyData in pairs(self.KeysDown) do
		self.KeysWasDown[keylast] = self.KeysDown[keylast]
	end

	for key, keyData in pairs(self.Keys) do
		self.KeysDown[key] = input.IsKeyDown(key)
		if self:IsKeyTriggered(key) then
			if self.ShiftMode && keyData.Shift then
				self:OnRegisteredKeyPlayed(keyData.Shift.Sound)
			elseif !self.ShiftMode then
				self:OnRegisteredKeyPlayed(keyData.Sound)
			end
		end
	end

	for key, keyData in pairs(self.ControlKeys) do
		self.KeysDown[key] = input.IsKeyDown(key)

		if self:IsKeyTriggered(key) then
			keyData(self, true)
		end
		
		if self:IsKeyReleased(key) then
			keyData(self, false)
		end
	end
end

function ENT:IsKeyTriggered(key)
	return self.KeysDown[key] && !self.KeysWasDown[key]
end

function ENT:IsKeyReleased(key)
	return self.KeysWasDown[key] && !self.KeysDown[key]
end

function ENT:OnRegisteredKeyPlayed(key)
	local sound = self:GetSound(key)
	self:EmitSound(sound, 100)

	net.Start("InstrumentNetwork")
		net.WriteUInt(self:EntIndex(), 13)
		net.WriteUInt(INSTNET_PLAY, 2)
		net.WriteString(key)
	net.SendToServer()
end

// Network it up, yo
function ENT:SendKeys()
	if !self.KeysToSend then return end

	// Send the queue of notes to everyone

	// Play on the client first
	for _, key in ipairs(self.KeysToSend) do
		local sound = self:GetSound(key)

		if sound then
			self:EmitSound(sound, 100)
		end
	end

	// Clear queue
	self.KeysToSend = nil
end

function ENT:DrawKey( mainX, mainY, key, keyData, bShiftMode )
	if keyData.Material then
		if (self.ShiftMode && bShiftMode && input.IsKeyDown(key)) ||
		   (!self.ShiftMode && !bShiftMode && input.IsKeyDown(key)) then

			surface.SetTexture(self.KeyMaterialIDs[ keyData.Material ])
			surface.DrawTexturedRect(mainX + keyData.X, mainY + keyData.Y, self.DefaultMatWidth, self.DefaultMatHeight)
		end
	end

	// Draw keys
	if keyData.Label then
		local offsetX = self.DefaultTextX
		local offsetY = self.DefaultTextY
		local color = self.DefaultTextColor

		if (self.ShiftMode && bShiftMode && input.IsKeyDown(key)) ||
		   (!self.ShiftMode && !bShiftMode && input.IsKeyDown(key)) then
		   
			color = self.DefaultTextColorActive
			if keyData.AColor then color = keyData.AColor end
		else
			if keyData.Color then color = keyData.Color end
		end

		// Override positions, if needed
		if keyData.TextX then offsetX = keyData.TextX end
		if keyData.TextY then offsetY = keyData.TextY end
		
		draw.DrawText(keyData.Label, "InstrumentKeyLabel", 
						mainX + keyData.X + offsetX,
						mainY + keyData.Y + offsetY,
						color, TEXT_ALIGN_CENTER)
	end
end

local mainX, mainY, mainWidth, mainHeight
function ENT:DrawHUD()
	surface.SetDrawColor(255, 255, 255, 255)

	// Draw main
	if self.MainHUD.Material && !self.AdvancedMode then
		mainX, mainY, mainWidth, mainHeight = self.MainHUD.X, self.MainHUD.Y, self.MainHUD.Width / 2, self.MainHUD.Height + 30

		surface.SetTexture(self.MainHUD.MatID)
		surface.DrawTexturedRect(mainX, mainY, self.MainHUD.TextureWidth, self.MainHUD.TextureHeight)
	end

	// Advanced main
	if self.AdvMainHUD.Material && self.AdvancedMode then
		mainX, mainY, mainWidth, mainHeight = self.AdvMainHUD.X, self.AdvMainHUD.Y, self.AdvMainHUD.Width / 2, self.AdvMainHUD.Height + 30

		surface.SetTexture(self.AdvMainHUD.MatID)
		surface.DrawTexturedRect(mainX, mainY, self.AdvMainHUD.TextureWidth, self.AdvMainHUD.TextureHeight)
	end

	// Draw keys (over top of main)
	for key, keyData in pairs(self.Keys) do
		self:DrawKey(mainX, mainY, key, keyData, false)
		
		if keyData.Shift then
			self:DrawKey(mainX, mainY, key, keyData.Shift, true)
		end
	end

	// Advanced mode
	if self.AllowAdvancedMode && !self.AdvancedMode then
		draw.DrawText("CONTROL FOR ADVANCED MODE", "InstrumentKeyLabel", 
						mainX + mainWidth, mainY + mainHeight, 
						self.DefaultTextInfoColor, TEXT_ALIGN_CENTER)			
	elseif self.AllowAdvancedMode && self.AdvancedMode then
		draw.DrawText("CONTROL FOR BASIC MODE", "InstrumentKeyLabel", 
						mainX + mainWidth, mainY + mainHeight, 
						self.DefaultTextInfoColor, TEXT_ALIGN_CENTER)
	end
end

function ENT:PrecacheMaterials()
	if !self.Keys then return end

	self.KeyMaterialIDs = {}
	for name, keyMaterial in pairs(self.KeyMaterials) do
		if type(keyMaterial) == "string" then // TODO: what the fuck, this table is randomly created
			self.KeyMaterialIDs[name] = surface.GetTextureID(keyMaterial)
		end
	end

	if self.MainHUD.Material then
		self.MainHUD.MatID = surface.GetTextureID(self.MainHUD.Material)
	end

	if self.AdvMainHUD.Material then
		self.AdvMainHUD.MatID = surface.GetTextureID(self.AdvMainHUD.Material)
	end
end

function ENT:Shutdown()
	self.AdvancedMode = false
	self.ShiftMode = false

	if self.OldKeys then
		self.Keys = self.OldKeys
		self.OldKeys = nil
	end
end

function ENT:ToggleAdvancedMode()
	self.AdvancedMode = !self.AdvancedMode
end

function ENT:ToggleShiftMode()
	self.ShiftMode = !self.ShiftMode
end

function ENT:ShiftMod() end
function ENT:CtrlMod() end

hook.Add("HUDPaint", "InstrumentPaint", function()
	if IsValid(LocalPlayer().Instrument) then
		local inst = LocalPlayer().Instrument
		inst:DrawHUD()

		surface.SetDrawColor(0, 0, 0, 180)
		surface.DrawRect(0, ScrH() - 60, ScrW(), 60)

		draw.SimpleText("PRESS TAB TO LEAVE THE PIANO", "InstrumentNotice", ScrW() / 2, ScrH() - 35, inst.DefaultTextLeaveColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1)
	end
end)

hook.Add("PlayerBindPress", "InstrumentHook", function(ply, bind, pressed)
	if IsValid(ply.Instrument) then
		return true
	end
end)

net.Receive("InstrumentNetwork", function(length, client)
	local ent = net.ReadEntity()
	local enum = net.ReadUInt(2)

	if enum == INSTNET_USE then
		if IsValid(LocalPlayer().Instrument) then
			LocalPlayer().Instrument:Shutdown()
		end

		ent.DelayKey = CurTime() + .2
		LocalPlayer().Instrument = ent
	elseif enum == INSTNET_HEAR then
		if !IsValid(ent) then return end

		if IsValid(LocalPlayer().Instrument) && LocalPlayer().Instrument == ent then
			return
		end

		local key = net.ReadString()
		local sound = ent:GetSound(key)
			
		if sound then
			ent:EmitSound(sound, 80)
		end
	end
end)