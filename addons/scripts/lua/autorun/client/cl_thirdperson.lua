CreateClientConVar("mg_thirdperson_enabled", 0, true, false)
CreateClientConVar("mg_thirdperson_easyswitch", 1, true, false)
CreateClientConVar("mg_thirdperson_bindkey", KEY_T, true, false)
CreateClientConVar("mg_thirdperson_smooth", 1, true, false)
CreateClientConVar("mg_thirdperson_smooth_mult_x", 0.3, true, false)
CreateClientConVar("mg_thirdperson_smooth_mult_y", 0.3, true, false)
CreateClientConVar("mg_thirdperson_smooth_mult_z", 0.3, true, false)
CreateClientConVar("mg_thirdperson_smooth_delay", 10, true, false)
CreateClientConVar("mg_thirdperson_collision", 1, true, false)
CreateClientConVar("mg_thirdperson_cam_distance", 100, true, false)
CreateClientConVar("mg_thirdperson_cam_right", 0, true, false)
CreateClientConVar("mg_thirdperson_cam_up", 0, true, false)
CreateClientConVar("mg_thirdperson_cam_pitch", 0, true, false)
CreateClientConVar("mg_thirdperson_cam_yaw", 0, true, false)
CreateClientConVar("mg_thirdperson_shoulderview_dist", 50, true, false)
CreateClientConVar("mg_thirdperson_shoulderview_up", 0, true, false)
CreateClientConVar("mg_thirdperson_shoulderview_right", 40, true, false)
CreateClientConVar("mg_thirdperson_shoulderview", 0, true, false)
CreateClientConVar("mg_thirdperson_shoulderview_bump", 1, true, false)
CreateClientConVar("mg_thirdperson_fov_smooth", 1, true, false)
CreateClientConVar("mg_thirdperson_fov_smooth_mult", 0.3, true, false)

local Editor = {}
Editor.DelayPos = nil
Editor.ViewPos = nil
Editor.ShoulderToggle = GetConVar("mg_thirdperson_shoulderview"):GetBool()
Editor.EnableToggle = GetConVar("mg_thirdperson_enabled"):GetBool()
Editor.CollisionToggle = GetConVar("mg_thirdperson_collision"):GetBool()
Editor.FOVToggle = GetConVar("mg_thirdperson_fov_smooth"):GetBool()
Editor.SmoothToggle = GetConVar("mg_thirdperson_smooth"):GetBool()
Editor.ShoulderBumpToggle = GetConVar("mg_thirdperson_shoulderview_bump"):GetBool()
Editor.TriggerToggle = GetConVar("mg_thirdperson_easyswitch"):GetBool()

local function BoolToInt(bool)
	if bool then
		return 1
	else
		return 0
	end
end

list.Set("DesktopWindows", "ThirdPerson", {
	title = "Third Person", 
	icon = "icon32/zoom_extend.png", 
	width = 300, 
	height = 170, 
	onewindow = true, 
	init = function(icn, pnl)
		Editor.PANEL = pnl
		Editor.PANEL:SetPos(ScrW() - 310, 40)
		Editor.PANEL.Sheet = Editor.PANEL:Add("DPropertySheet")
		Editor.PANEL.Sheet:Dock(LEFT)
		Editor.PANEL.Sheet:SetSize(290, 0)
		Editor.PANEL.Sheet:SetPos(5, 0)
		Editor.PANEL.Settings = Editor.PANEL.Sheet:Add("DPanelSelect")
		Editor.PANEL.Sheet:AddSheet("Einstellungen", Editor.PANEL.Settings, "icon16/cog_edit.png")
		Editor.PANEL.CameraSettings = Editor.PANEL.Sheet:Add("DPanelSelect")
		Editor.PANEL.Sheet:AddSheet("Kamera", Editor.PANEL.CameraSettings, "icon16/camera_edit.png")
		Editor.PANEL.SmoothSettings = Editor.PANEL.Sheet:Add("DPanelSelect")
		Editor.PANEL.Sheet:AddSheet("Glättung", Editor.PANEL.SmoothSettings, "icon16/chart_line.png")
		Editor.PANEL.ShoulderSettings = Editor.PANEL.Sheet:Add("DPanelSelect")
		Editor.PANEL.Sheet:AddSheet("Schulter", Editor.PANEL.ShoulderSettings, "icon16/camera_go.png")
		Editor.PANEL.AccessSettings = Editor.PANEL.Sheet:Add("DPanelSelect")
		Editor.PANEL.Sheet:AddSheet("Zugriff", Editor.PANEL.AccessSettings, "icon16/application_xp_terminal.png")
		Editor.PANEL.EnableThrd = Editor.PANEL.Settings:Add("DButton")
		Editor.PANEL.EnableThrd:SizeToContents()
		if Editor.EnableToggle then
			Editor.PANEL.EnableThrd:SetText("Third Person deaktivieren")
			Editor.PANEL.EnableThrd:SetTextColor(Color(150, 0, 0))
		else
			Editor.PANEL.EnableThrd:SetText("Third Person aktivieren")
			Editor.PANEL.EnableThrd:SetTextColor(Color(0, 150, 0))
		end
		Editor.PANEL.EnableThrd:SetPos(10, 6)
		Editor.PANEL.EnableThrd:SetSize(250, 20)
		Editor.PANEL.EnableThrd.DoClick = function()
			Editor.EnableToggle = !Editor.EnableToggle
			RunConsoleCommand("mg_thirdperson_enabled", BoolToInt(Editor.EnableToggle))
			if Editor.EnableToggle then
				Editor.PANEL.EnableThrd:SetText("Third Person deaktivieren")
				Editor.PANEL.EnableThrd:SetTextColor(Color(150, 0, 0))
			else
				Editor.PANEL.EnableThrd:SetText("Third Person aktivieren")
				Editor.PANEL.EnableThrd:SetTextColor(Color(0, 150, 0))
			end	
		end
		Editor.PANEL.Lbl_SPLIT = Editor.PANEL.Settings:Add("DLabel")
		Editor.PANEL.Lbl_SPLIT:SetPos(20, 29)
		Editor.PANEL.Lbl_SPLIT:SetText("------------------------ RESETS ------------------------")
		Editor.PANEL.Lbl_SPLIT:SizeToContents() 
		Editor.PANEL.ResetCam = Editor.PANEL.Settings:Add("DButton")
		Editor.PANEL.ResetCam:SizeToContents()
		Editor.PANEL.ResetCam:SetText("Kamera")
		Editor.PANEL.ResetCam:SetPos(10, 46)
		Editor.PANEL.ResetCam:SetSize(120, 20)
		Editor.PANEL.ResetCam.DoClick = function()
			RunConsoleCommand("mg_thirdperson_cam_distance", 100)
			RunConsoleCommand("mg_thirdperson_cam_right", 0)
			RunConsoleCommand("mg_thirdperson_cam_up", 0)
			RunConsoleCommand("mg_thirdperson_cam_yaw", 0)
			RunConsoleCommand("mg_thirdperson_cam_pitch", 0)
			chat.AddText(Color(255, 255, 255), "[", Color(255, 155, 0), "Third Person", Color(255, 255, 255), "] Kamera zurückgesetzt!")
		end
		Editor.PANEL.ResetShoulder = Editor.PANEL.Settings:Add("DButton")
		Editor.PANEL.ResetShoulder:SizeToContents()
		Editor.PANEL.ResetShoulder:SetText("Schultersicht")
		Editor.PANEL.ResetShoulder:SetPos(140, 46)
		Editor.PANEL.ResetShoulder:SetSize(120, 20)
			Editor.PANEL.ResetShoulder.DoClick = function()
				RunConsoleCommand("mg_thirdperson_shoulderview_dist", 50)
				RunConsoleCommand("mg_thirdperson_shoulderview_up", 0)
				RunConsoleCommand("mg_thirdperson_shoulderview_right", 40)
				chat.AddText(Color(255, 255, 255), "[", Color(255, 155, 0), "Third Person", Color(255, 255, 255), "] Schultersicht zurückgesetzt!")
			end
			Editor.PANEL.ResetSmooth = Editor.PANEL.Settings:Add("DButton")
			Editor.PANEL.ResetSmooth:SizeToContents()
			Editor.PANEL.ResetSmooth:SetText("Glättung")
			Editor.PANEL.ResetSmooth:SetPos(10, 76)
			Editor.PANEL.ResetSmooth:SetSize(120, 20)
			Editor.PANEL.ResetSmooth.DoClick = function()
				RunConsoleCommand("mg_thirdperson_smooth", 1)
				RunConsoleCommand("mg_thirdperson_smooth_mult_x", 0.3)
				RunConsoleCommand("mg_thirdperson_smooth_mult_y", 0.3)
				RunConsoleCommand("mg_thirdperson_smooth_mult_z", 0.3)
				RunConsoleCommand("mg_thirdperson_smooth_delay", 10)
				chat.AddText(Color(255, 255, 255), "[", Color(255, 155, 0), "Third Person", Color(255, 255, 255), "] Glättung zurückgesetzt!")
			end
			Editor.PANEL.ResetFOV = Editor.PANEL.Settings:Add("DButton")
			Editor.PANEL.ResetFOV:SizeToContents()
			Editor.PANEL.ResetFOV:SetText("FOV")
			Editor.PANEL.ResetFOV:SetPos(140, 76)
			Editor.PANEL.ResetFOV:SetSize(120, 20)
			Editor.PANEL.ResetFOV.DoClick = function()
				RunConsoleCommand("mg_thirdperson_fov_smooth", 1)
				RunConsoleCommand("mg_thirdperson_fov_smooth_mult", 0.3)
				chat.AddText(Color(255, 255, 255), "[", Color(255, 155, 0), "Third Person", Color(255, 255, 255), "] FOV zurückgesetzt!")
			end
			Editor.PANEL.CollisionButton = Editor.PANEL.CameraSettings:Add("DButton")
			Editor.PANEL.CollisionButton:SizeToContents()
			if Editor.CollisionToggle then
				Editor.PANEL.CollisionButton:SetText("Kamerakollision deaktivieren")
				Editor.PANEL.CollisionButton:SetTextColor(Color(150, 0, 0))
			else
				Editor.PANEL.CollisionButton:SetText("Kamerakollision aktivieren")
				Editor.PANEL.CollisionButton:SetTextColor(Color(0, 150, 0))
			end
			Editor.PANEL.CollisionButton:SetPos(10, 6)
			Editor.PANEL.CollisionButton:SetSize(250, 20)
			Editor.PANEL.CollisionButton.DoClick = function()
				Editor.CollisionToggle = !Editor.CollisionToggle
				RunConsoleCommand("mg_thirdperson_collision", BoolToInt(Editor.CollisionToggle))	
				if Editor.CollisionToggle then
					Editor.PANEL.CollisionButton:SetText("Kamerakollision deaktivieren")
					Editor.PANEL.CollisionButton:SetTextColor(Color(150, 0, 0))
				else
					Editor.PANEL.CollisionButton:SetText("Kamerakollision aktivieren")
					Editor.PANEL.CollisionButton:SetTextColor(Color(0, 150, 0))
				end
			end
			Editor.PANEL.CamDistanceTxt = Editor.PANEL.CameraSettings:Add("DLabel")
			Editor.PANEL.CamDistanceTxt:SetPos(10, 35)
			Editor.PANEL.CamDistanceTxt:SetText("Kamera-Distanz: ")
			Editor.PANEL.CamDistanceTxt:SizeToContents() 
			Editor.PANEL.CamDistanceLb = Editor.PANEL.CameraSettings:Add("DTextEntry")
			Editor.PANEL.CamDistanceLb:SetPos(100, 30)
			Editor.PANEL.CamDistanceLb:SetValue(GetConVar("mg_thirdperson_cam_distance"):GetInt())
			Editor.PANEL.CamDistanceLb:SizeToContents()
			Editor.PANEL.CamDistanceLb:SetNumeric(true)
			Editor.PANEL.CamDistanceLb:SetUpdateOnType(true)
			Editor.PANEL.CamDistanceLb.OnTextChanged  = function()
				RunConsoleCommand("mg_thirdperson_cam_distance", Editor.PANEL.CamDistanceLb:GetValue())
			end
			Editor.PANEL.CamYawTxt = Editor.PANEL.CameraSettings:Add("DLabel")
			Editor.PANEL.CamYawTxt:SetPos(145, 62)
			Editor.PANEL.CamYawTxt:SetText("Gierung: ")
			Editor.PANEL.CamYawTxt:SizeToContents() 
			Editor.PANEL.CamYawLb = Editor.PANEL.CameraSettings:Add("DTextEntry")
			Editor.PANEL.CamYawLb:SetPos(195, 57)
			Editor.PANEL.CamYawLb:SetValue(GetConVar("mg_thirdperson_cam_yaw"):GetInt())
			Editor.PANEL.CamYawLb:SizeToContents()
			Editor.PANEL.CamYawLb:SetNumeric(true)
			Editor.PANEL.CamYawLb:SetUpdateOnType(true)
			Editor.PANEL.CamYawLb.OnTextChanged  = function()
				RunConsoleCommand("mg_thirdperson_cam_yaw", Editor.PANEL.CamYawLb:GetValue())
			end
			Editor.PANEL.CamPitchTxt = Editor.PANEL.CameraSettings:Add("DLabel")
			Editor.PANEL.CamPitchTxt:SetPos(125, 85)
			Editor.PANEL.CamPitchTxt:SetText("Winkel: ")
			Editor.PANEL.CamPitchTxt:SizeToContents() 
			Editor.PANEL.CamPitchLb = Editor.PANEL.CameraSettings:Add("DTextEntry")
			Editor.PANEL.CamPitchLb:SetPos(160, 80)
			Editor.PANEL.CamPitchLb:SetValue(GetConVar("mg_thirdperson_cam_pitch"):GetInt())
			Editor.PANEL.CamPitchLb:SizeToContents()
			Editor.PANEL.CamPitchLb:SetNumeric(true)
			Editor.PANEL.CamPitchLb:SetUpdateOnType(true)
			Editor.PANEL.CamPitchLb.OnTextChanged  = function()
				RunConsoleCommand("mg_thirdperson_cam_pitch", Editor.PANEL.CamPitchLb:GetValue())
			end
			Editor.PANEL.CamUpTxt = Editor.PANEL.CameraSettings:Add("DLabel")
			Editor.PANEL.CamUpTxt:SetPos(10, 62)
			Editor.PANEL.CamUpTxt:SetText("Hochwärts: ")
			Editor.PANEL.CamUpTxt:SizeToContents() 
			Editor.PANEL.CamUpTxtLB = Editor.PANEL.CameraSettings:Add("DTextEntry")
			Editor.PANEL.CamUpTxtLB:SetPos(75, 57)
			Editor.PANEL.CamUpTxtLB:SetValue(GetConVar("mg_thirdperson_cam_up"):GetInt())
			Editor.PANEL.CamUpTxtLB:SizeToContents()
			Editor.PANEL.CamUpTxtLB:SetNumeric(true)
			Editor.PANEL.CamUpTxtLB:SetUpdateOnType(true)
			Editor.PANEL.CamUpTxtLB.OnTextChanged  = function()
				RunConsoleCommand("mg_thirdperson_cam_up", Editor.PANEL.CamUpTxtLB:GetValue())
			end
			Editor.PANEL.CamLeftTxt = Editor.PANEL.CameraSettings:Add("DLabel")
			Editor.PANEL.CamLeftTxt:SetPos(10, 85)
			Editor.PANEL.CamLeftTxt:SetText("Rechts: ")
			Editor.PANEL.CamLeftTxt:SizeToContents() 
			Editor.PANEL.CamLeftTxtLB = Editor.PANEL.CameraSettings:Add("DTextEntry")
			Editor.PANEL.CamLeftTxtLB:SetPos(55, 80)
			Editor.PANEL.CamLeftTxtLB:SetValue(GetConVar("mg_thirdperson_cam_right"):GetInt())
			Editor.PANEL.CamLeftTxtLB:SizeToContents()
			Editor.PANEL.CamLeftTxtLB:SetNumeric(true)
			Editor.PANEL.CamLeftTxtLB:SetUpdateOnType(true)
			Editor.PANEL.CamLeftTxtLB.OnTextChanged  = function()
				RunConsoleCommand("mg_thirdperson_cam_right", Editor.PANEL.CamLeftTxtLB:GetValue())
			end
			Editor.PANEL.SmoothButton = Editor.PANEL.SmoothSettings:Add("DButton")
			Editor.PANEL.SmoothButton:SizeToContents()
			if Editor.SmoothToggle then
				Editor.PANEL.SmoothButton:SetText("Kameraglättung deaktivieren")
				Editor.PANEL.SmoothButton:SetTextColor(Color(150, 0, 0))
			else
				Editor.PANEL.SmoothButton:SetText("Kameraglättung aktivieren")
				Editor.PANEL.SmoothButton:SetTextColor(Color(0, 150, 0))
			end
			Editor.PANEL.SmoothButton:SetPos(10, 6)
			Editor.PANEL.SmoothButton:SetSize(250, 20)
			Editor.PANEL.SmoothButton.DoClick = function()
				Editor.SmoothToggle = !Editor.SmoothToggle
				RunConsoleCommand("mg_thirdperson_smooth", BoolToInt(Editor.SmoothToggle))	
				if Editor.SmoothToggle then
					Editor.PANEL.SmoothButton:SetText("Kameraglättung deaktivieren")
					Editor.PANEL.SmoothButton:SetTextColor(Color(150, 0, 0))
				else
					Editor.PANEL.SmoothButton:SetText("Kameraglättung aktivieren")
					Editor.PANEL.SmoothButton:SetTextColor(Color(0, 150, 0))
				end					
			end
			Editor.PANEL.SmoothFOVButton = Editor.PANEL.SmoothSettings:Add("DButton")
			Editor.PANEL.SmoothFOVButton:SizeToContents()
			if Editor.FOVToggle then
				Editor.PANEL.SmoothFOVButton:SetText("FOV-Glättung deaktivieren")
				Editor.PANEL.SmoothFOVButton:SetTextColor(Color(150, 0, 0))
			else
				Editor.PANEL.SmoothFOVButton:SetText("FOV-Glättung aktivieren")
				Editor.PANEL.SmoothFOVButton:SetTextColor(Color(0, 150, 0))
			end
			Editor.PANEL.SmoothFOVButton:SetPos(10, 30)
			Editor.PANEL.SmoothFOVButton:SetSize(250, 20)
			Editor.PANEL.SmoothFOVButton.DoClick = function()
				Editor.FOVToggle = !Editor.FOVToggle
				RunConsoleCommand("mg_thirdperson_fov_smooth", BoolToInt(Editor.FOVToggle))
				if Editor.FOVToggle then
					Editor.PANEL.SmoothFOVButton:SetText("FOV-Glättung deaktivieren")
					Editor.PANEL.SmoothFOVButton:SetTextColor(Color(150, 0, 0))
				else
					Editor.PANEL.SmoothFOVButton:SetText("FOV-Glättung aktivieren")
					Editor.PANEL.SmoothFOVButton:SetTextColor(Color(0, 150, 0))
				end					
			end
			Editor.PANEL.CamSmoothDeTxt = Editor.PANEL.SmoothSettings:Add("DLabel")
			Editor.PANEL.CamSmoothDeTxt:SetPos(10, 60)
			Editor.PANEL.CamSmoothDeTxt:SetText("Verzögerung: ")
			Editor.PANEL.CamSmoothDeTxt:SizeToContents() 
			Editor.PANEL.CamSmoDelayLb = Editor.PANEL.SmoothSettings:Add("DTextEntry")
			Editor.PANEL.CamSmoDelayLb:SetPos(85, 55)
			Editor.PANEL.CamSmoDelayLb:SetValue(GetConVar("mg_thirdperson_smooth_delay"):GetFloat())
			Editor.PANEL.CamSmoDelayLb:SizeToContents()
			Editor.PANEL.CamSmoDelayLb:SetNumeric(true)
			Editor.PANEL.CamSmoDelayLb:SetUpdateOnType(true)
			Editor.PANEL.CamSmoDelayLb.OnTextChanged  = function()
				RunConsoleCommand("mg_thirdperson_smooth_delay", Editor.PANEL.CamSmoDelayLb:GetValue())
			end
			Editor.PANEL.CamSmoothMultXTxt = Editor.PANEL.SmoothSettings:Add("DLabel")
			Editor.PANEL.CamSmoothMultXTxt:SetPos(155, 60)
			Editor.PANEL.CamSmoothMultXTxt:SetText("Mult X: ")
			Editor.PANEL.CamSmoothMultXTxt:SizeToContents() 
			Editor.PANEL.CamSmoothMultXTxtLb = Editor.PANEL.SmoothSettings:Add("DTextEntry")
			Editor.PANEL.CamSmoothMultXTxtLb:SetPos(195, 55)
			Editor.PANEL.CamSmoothMultXTxtLb:SetValue(math.Round(GetConVar("mg_thirdperson_smooth_mult_x"):GetFloat(), 2))
			Editor.PANEL.CamSmoothMultXTxtLb:SizeToContents()
			Editor.PANEL.CamSmoothMultXTxtLb:SetNumeric(true)
			Editor.PANEL.CamSmoothMultXTxtLb:SetUpdateOnType(true)
			Editor.PANEL.CamSmoothMultXTxtLb.OnTextChanged  = function()
				RunConsoleCommand("mg_thirdperson_smooth_mult_x", Editor.PANEL.CamSmoothMultXTxtLb:GetValue())
			end
			Editor.PANEL.CamSmoothMultYTxt = Editor.PANEL.SmoothSettings:Add("DLabel")
			Editor.PANEL.CamSmoothMultYTxt:SetPos(10, 85)
			Editor.PANEL.CamSmoothMultYTxt:SetText("Mult Y: ")
			Editor.PANEL.CamSmoothMultYTxt:SizeToContents() 
			Editor.PANEL.CamSmoothMultYTxtLb = Editor.PANEL.SmoothSettings:Add("DTextEntry")
			Editor.PANEL.CamSmoothMultYTxtLb:SetPos(50, 80)
			Editor.PANEL.CamSmoothMultYTxtLb:SetValue(math.Round(GetConVar("mg_thirdperson_smooth_mult_y"):GetFloat(), 2))
			Editor.PANEL.CamSmoothMultYTxtLb:SizeToContents()
			Editor.PANEL.CamSmoothMultYTxtLb:SetNumeric(true)
			Editor.PANEL.CamSmoothMultYTxtLb:SetUpdateOnType(true)
			Editor.PANEL.CamSmoothMultYTxtLb.OnTextChanged  = function()
				RunConsoleCommand("mg_thirdperson_smooth_mult_y", Editor.PANEL.CamSmoothMultYTxtLb:GetValue())
			end
			Editor.PANEL.CamSmoothMultZTxt = Editor.PANEL.SmoothSettings:Add("DLabel")
			Editor.PANEL.CamSmoothMultZTxt:SetPos(120, 85)
			Editor.PANEL.CamSmoothMultZTxt:SetText("Mult Z: ")
			Editor.PANEL.CamSmoothMultZTxt:SizeToContents() 
			Editor.PANEL.CamSmoothMultZTxtLb = Editor.PANEL.SmoothSettings:Add("DTextEntry")
			Editor.PANEL.CamSmoothMultZTxtLb:SetPos(160, 80)
			Editor.PANEL.CamSmoothMultZTxtLb:SetValue(math.Round(GetConVar("mg_thirdperson_smooth_mult_z"):GetFloat(), 2))
			Editor.PANEL.CamSmoothMultZTxtLb:SizeToContents()
			Editor.PANEL.CamSmoothMultZTxtLb:SetNumeric(true)
			Editor.PANEL.CamSmoothMultZTxtLb:SetUpdateOnType(true)
			Editor.PANEL.CamSmoothMultZTxtLb.OnTextChanged  = function()
				RunConsoleCommand("mg_thirdperson_smooth_mult_z", Editor.PANEL.CamSmoothMultZTxtLb:GetValue())
			end
			Editor.PANEL.ShoulderButton = Editor.PANEL.ShoulderSettings:Add("DButton")
			Editor.PANEL.ShoulderButton:SizeToContents()
			if Editor.ShoulderToggle then
				Editor.PANEL.ShoulderButton:SetText("Schultersicht deaktivieren")
				Editor.PANEL.ShoulderButton:SetTextColor(Color(150, 0, 0))
			else
				Editor.PANEL.ShoulderButton:SetText("Schultersicht aktivieren")
				Editor.PANEL.ShoulderButton:SetTextColor(Color(0, 150, 0))
			end		
			Editor.PANEL.ShoulderButton:SetPos(10, 6)
			Editor.PANEL.ShoulderButton:SetSize(250, 20)
			Editor.PANEL.ShoulderButton.DoClick = function()
				Editor.ShoulderToggle = !Editor.ShoulderToggle
				RunConsoleCommand("mg_thirdperson_shoulderview", BoolToInt(Editor.ShoulderToggle))
				if Editor.ShoulderToggle then
					Editor.PANEL.ShoulderButton:SetText("Schultersicht deaktivieren")
					Editor.PANEL.ShoulderButton:SetTextColor(Color(150, 0, 0))
				else
					Editor.PANEL.ShoulderButton:SetText("Schultersicht aktivieren")
					Editor.PANEL.ShoulderButton:SetTextColor(Color(0, 150, 0))
				end						
			end
			Editor.PANEL.ShoulderBumpButton = Editor.PANEL.ShoulderSettings:Add("DButton")
			Editor.PANEL.ShoulderBumpButton:SizeToContents()
			if Editor.ShoulderBumpToggle then
				Editor.PANEL.ShoulderBumpButton:SetText("Schultersicht-Bewegung deaktivieren")
				Editor.PANEL.ShoulderBumpButton:SetTextColor(Color(150, 0, 0))
			else
				Editor.PANEL.ShoulderBumpButton:SetText("Schultersicht-Bewegung aktivieren")
				Editor.PANEL.ShoulderBumpButton:SetTextColor(Color(0, 150, 0))
			end	
			Editor.PANEL.ShoulderBumpButton:SetPos(10, 30)
			Editor.PANEL.ShoulderBumpButton:SetSize(250, 20)
			Editor.PANEL.ShoulderBumpButton.DoClick = function()
				Editor.ShoulderBumpToggle = !Editor.ShoulderBumpToggle
				RunConsoleCommand("mg_thirdperson_shoulderview_bump", BoolToInt(Editor.ShoulderBumpToggle))	
				if Editor.ShoulderBumpToggle then
					Editor.PANEL.ShoulderBumpButton:SetText("Schulter-Sicht-Bewegung deaktivieren")
					Editor.PANEL.ShoulderBumpButton:SetTextColor(Color(150, 0, 0))
				else
					Editor.PANEL.ShoulderBumpButton:SetText("Schulter-Sicht-Bewegung deaktivieren")
					Editor.PANEL.ShoulderBumpButton:SetTextColor(Color(0, 150, 0))
				end						
			end
			Editor.PANEL.ShoulderDistTxt = Editor.PANEL.ShoulderSettings:Add("DLabel")
			Editor.PANEL.ShoulderDistTxt:SetPos(10, 60)
			Editor.PANEL.ShoulderDistTxt:SetText("Schulter-Distanz: ")
			Editor.PANEL.ShoulderDistTxt:SizeToContents() 
			Editor.PANEL.ShoulderDistLb = Editor.PANEL.ShoulderSettings:Add("DTextEntry")
			Editor.PANEL.ShoulderDistLb:SetPos(100, 55)
			Editor.PANEL.ShoulderDistLb:SetValue(GetConVar("mg_thirdperson_shoulderview_dist"):GetFloat())
			Editor.PANEL.ShoulderDistLb:SizeToContents()
			Editor.PANEL.ShoulderDistLb:SetNumeric(true)
			Editor.PANEL.ShoulderDistLb:SetUpdateOnType(true)
			Editor.PANEL.ShoulderDistLb.OnTextChanged  = function()
				RunConsoleCommand("mg_thirdperson_shoulderview_dist", Editor.PANEL.ShoulderDistLb:GetValue())
			end
			Editor.PANEL.ShoulderUPTxt = Editor.PANEL.ShoulderSettings:Add("DLabel")
			Editor.PANEL.ShoulderUPTxt:SetPos(10, 85)
			Editor.PANEL.ShoulderUPTxt:SetText("Hoch: ")
			Editor.PANEL.ShoulderUPTxt:SizeToContents() 
			Editor.PANEL.ShoulderUpLb = Editor.PANEL.ShoulderSettings:Add("DTextEntry")
			Editor.PANEL.ShoulderUpLb:SetPos(45, 80)
			Editor.PANEL.ShoulderUpLb:SetValue(GetConVar("mg_thirdperson_shoulderview_up"):GetFloat())
			Editor.PANEL.ShoulderUpLb:SizeToContents()
			Editor.PANEL.ShoulderUpLb:SetNumeric(true)
			Editor.PANEL.ShoulderUpLb:SetUpdateOnType(true)
			Editor.PANEL.ShoulderUpLb.OnTextChanged  = function()
				RunConsoleCommand("mg_thirdperson_shoulderview_up", Editor.PANEL.ShoulderUpLb:GetValue())
			end
			Editor.PANEL.ShoulderRIGTxt = Editor.PANEL.ShoulderSettings:Add("DLabel")
			Editor.PANEL.ShoulderRIGTxt:SetPos(120, 85)
			Editor.PANEL.ShoulderRIGTxt:SetText("Rechtseitig:")
			Editor.PANEL.ShoulderRIGTxt:SizeToContents() 
			Editor.PANEL.ShoulderRIGLb = Editor.PANEL.ShoulderSettings:Add("DTextEntry")
			Editor.PANEL.ShoulderRIGLb:SetPos(182, 80)
			Editor.PANEL.ShoulderRIGLb:SetValue(GetConVar("mg_thirdperson_shoulderview_right"):GetFloat())
			Editor.PANEL.ShoulderRIGLb:SizeToContents()
			Editor.PANEL.ShoulderRIGLb:SetNumeric(true)
			Editor.PANEL.ShoulderRIGLb:SetUpdateOnType(true)
			Editor.PANEL.ShoulderRIGLb.OnTextChanged  = function()
				RunConsoleCommand("mg_thirdperson_shoulderview_right", Editor.PANEL.ShoulderRIGLb:GetValue())
			end
			Editor.PANEL.TriggerToggle = Editor.PANEL.AccessSettings:Add("DButton")
			Editor.PANEL.TriggerToggle:SizeToContents()
			if Editor.TriggerToggle then
				Editor.PANEL.TriggerToggle:SetText("Wechsel mittels Taste deaktivieren")
				Editor.PANEL.TriggerToggle:SetTextColor(Color(150, 0, 0))
			else
				Editor.PANEL.TriggerToggle:SetText("Wechsel mittels Taste aktivieren")
				Editor.PANEL.TriggerToggle:SetTextColor(Color(0, 150, 0))
			end
			Editor.PANEL.TriggerToggle:SetPos(10, 6)
			Editor.PANEL.TriggerToggle:SetSize(250, 20)
			Editor.PANEL.TriggerToggle.DoClick = function()
				Editor.TriggerToggle = !Editor.TriggerToggle
				RunConsoleCommand("mg_thirdperson_easyswitch", BoolToInt(Editor.TriggerToggle))	
				if Editor.TriggerToggle then
					Editor.PANEL.TriggerToggle:SetText("Wechsel mittels Taste deaktivieren")
					Editor.PANEL.TriggerToggle:SetTextColor(Color(150, 0, 0))
				else
					Editor.PANEL.TriggerToggle:SetText("Wechsel mittels Taste aktivieren")
					Editor.PANEL.TriggerToggle:SetTextColor(Color(0, 150, 0))
				end
			end
			Editor.PANEL.BindKeySelect = Editor.PANEL.AccessSettings:Add("DBinder")
			Editor.PANEL.BindKeySelect:SizeToContents()
			Editor.PANEL.BindKeySelect:SetPos(10, 35)
			Editor.PANEL.BindKeySelect:SetSize(250, 40)
			Editor.PANEL.BindKeySelect:SetValue(GetConVar("mg_thirdperson_bindkey"):GetInt())
			Editor.PANEL.BindKeySelect.OnChange = function(self, num)
				RunConsoleCommand("mg_thirdperson_bindkey", num)
				self:SetText(input.GetKeyName(num))
			end
		end
	}
)

concommand.Add("mg_thirdperson_shoulder_toggle", function()
	Editor.ShoulderToggle = !Editor.ShoulderToggle
	RunConsoleCommand("mg_thirdperson_shoulderview", BoolToInt(Editor.ShoulderToggle))
end)

concommand.Add("mg_thirdperson_enable_toggle", function()
	Editor.EnableToggle = !Editor.EnableToggle
	RunConsoleCommand("mg_thirdperson_enabled", BoolToInt(Editor.EnableToggle))
	Editor.DelayPos = nil
	Editor.ViewPos = nil
	Editor.DelayPosUpdate = nil
	if IsValid(Editor.PANEL) then
		if Editor.EnableToggle then
			Editor.PANEL.EnableThrd:SetText("Third Person deaktivieren")
			Editor.PANEL.EnableThrd:SetTextColor(Color(150, 0, 0))
		else
			Editor.PANEL.EnableThrd:SetText("Third Person aktivieren")
			Editor.PANEL.EnableThrd:SetTextColor(Color(0, 150, 0))
		end
	end
end)

local function IsCW2Busy(ply)
	local wep = ply:GetActiveWeapon()
	local bool = false
	if wep.CW20Weapon and wep.dt.State then
		if wep.dt.ReloadDelay != 0 or wep.dt.ShotgunReloadState != 0 then
			Editor.CW20AnimTime = UnPredictedCurTime() + 0.25
			bool = true
		elseif wep.dt.State == CW_CUSTOMIZE or wep.dt.State == CW_AIMING then
			Editor.CW20Anim = wep.dt.State
			Editor.CW20AnimTime = UnPredictedCurTime() + 0.25
			bool = true
		elseif Editor.CW20Anim != wep.dt.State then
			Editor.CW20Anim = wep.dt.State
		end
		if (Editor.CW20AnimTime or 0) > UnPredictedCurTime() then
			bool = true
		end
	end
	if bool then
		Editor.DelayPos = nil
		Editor.ViewPos = nil
		Editor.DelayPosUpdate = nil
	end
	return bool
end

local function ThirdPersonDrawLocalPlayer(ply)
	if ply:GetObserverMode() == OBS_MODE_CHASE then return end
	if GetConVar("mg_thirdperson_enabled"):GetBool() or ((ply.animationSWEPAngle or 0) > 1.1) then
		if ply:InVehicle() or !ply:Alive() then return end
		if IsCW2Busy(ply) then return end
		return true
	end
end
hook.Add("ShouldDrawLocalPlayer", "MG_ThirdPerson.ShouldDraw", ThirdPersonDrawLocalPlayer)

local local_ply
local function HUDShouldDraw(name)
	if !GetConVar("mg_thirdperson_enabled"):GetBool() or !GetConVar("mg_thirdperson_shoulderview"):GetBool() then return end
	local_ply = local_ply or LocalPlayer()
	if local_ply.GetObserverMode and local_ply:GetObserverMode() == OBS_MODE_CHASE then return end
	if !local_ply.InVehicle or local_ply:InVehicle() or !local_ply:Alive() then return end
	if IsCW2Busy(local_ply) then return end
	if name == "CHudCrosshair" then
		return false
	end
end
hook.Add("HUDShouldDraw", "MG_ThirdPerson.HUDShouldDraw", HUDShouldDraw)

local function ThirdPersonHUDPaint()
	local_ply = local_ply or LocalPlayer()
	if local_ply.GetObserverMode and local_ply:GetObserverMode() == OBS_MODE_CHASE then return end
	if (!GetConVar("mg_thirdperson_enabled"):GetBool() and ((local_ply.animationSWEPAngle or 0) <= 1.1)) or !GetConVar("mg_thirdperson_shoulderview"):GetBool() then return end
	if !local_ply.InVehicle or local_ply:InVehicle() or !local_ply:Alive() then return end
	local wep = local_ply:GetActiveWeapon()
	if wep.CW20Weapon then return end
	local t = {}
	t.start = local_ply:GetShootPos()
	t.endpos = t.start + local_ply:GetAimVector() * 9000
	t.filter = local_ply
	local tr = util.TraceLine(t)
	local pos = tr.HitPos:ToScreen()
	if (tr.HitPos - t.start):LengthSqr() < 6250000 then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawLine(pos.x - 5, pos.y, pos.x - 8, pos.y)
		surface.DrawLine(pos.x + 5, pos.y, pos.x + 8, pos.y)
		surface.DrawLine(pos.x - 1, pos.y, pos.x + 1, pos.y)
		surface.DrawLine(pos.x, pos.y - 1, pos.x, pos.y + 1)
	end
end
hook.Add("HUDPaint", "MG_ThirdPerson.HUDPaint", ThirdPersonHUDPaint)

local view = {}
local function RenderCameraView(ply, pos, angles, fov)
	if ply.GetObserverMode and ply:GetObserverMode() == OBS_MODE_CHASE then return end
	if GetConVar("mg_thirdperson_enabled"):GetBool() or (ply.animationSWEPAngle and ply.animationSWEPAngle > 1.1) then
		if ply:InVehicle() or !ply:Alive() then return end
		if IsCW2Busy(ply) then return end
		local eyepos = ply:EyePos()
		if Editor.DelayPos == nil then
			Editor.DelayPos = eyepos
		end
		if Editor.ViewPos == nil then
			Editor.ViewPos = eyepos
		end
		local Forward = math.Clamp(GetConVar("mg_thirdperson_cam_distance"):GetFloat(), 0, 100)
		local Up = math.Clamp(GetConVar("mg_thirdperson_cam_up"):GetFloat(), -10, 10)
		local Right = math.Clamp(GetConVar("mg_thirdperson_cam_right"):GetFloat(), -10, 10)
		local Pitch = math.Clamp(GetConVar("mg_thirdperson_cam_pitch"):GetFloat(), -30, 30)
		local Yaw = math.Clamp(GetConVar("mg_thirdperson_cam_yaw"):GetFloat(), -30, 30)
		Editor.DelayFov = fov
		if GetConVar("mg_thirdperson_shoulderview"):GetBool() then
			if GetConVar("mg_thirdperson_shoulderview_bump"):GetBool() and ply:GetMoveType() != MOVETYPE_NOCLIP then
				local leng = ply:GetVelocity():Length()
				angles.pitch = angles.pitch + (leng / 300) * math.sin(CurTime() * 10)
				angles.roll = angles.roll + (leng / 300) * math.cos(CurTime() * 10)
			end
			Forward = math.Clamp(GetConVar("mg_thirdperson_shoulderview_dist"):GetFloat(), 0, 100)
			Up = math.Clamp(GetConVar("mg_thirdperson_shoulderview_up"):GetFloat(), -10, 10)
			Right = GetConVar("mg_thirdperson_shoulderview_right"):GetFloat()
		else
			angles.p = angles.p + Pitch
			angles.y = angles.y + Yaw
		end
		if GetConVar("mg_thirdperson_smooth"):GetBool() then
			if (Editor.DelayPosUpdate or 0) > CurTime() then
				Editor.DelayPos = eyepos
			end
			Editor.DelayPosUpdate = CurTime() - 0.35
			Editor.DelayPos = Editor.DelayPos + (ply:GetVelocity() * (RealFrameTime() / GetConVar("mg_thirdperson_smooth_delay"):GetFloat()))
			Editor.DelayPos.x = math.Approach(Editor.DelayPos.x, pos.x, math.abs(Editor.DelayPos.x - pos.x) * GetConVar("mg_thirdperson_smooth_mult_x"):GetFloat())
			Editor.DelayPos.y = math.Approach(Editor.DelayPos.y, pos.y, math.abs(Editor.DelayPos.y - pos.y) * GetConVar("mg_thirdperson_smooth_mult_y"):GetFloat())
			Editor.DelayPos.z = math.Approach(Editor.DelayPos.z, pos.z, math.abs(Editor.DelayPos.z - pos.z) * GetConVar("mg_thirdperson_smooth_mult_z"):GetFloat())
		else
			Editor.DelayPos = pos
		end
		if GetConVar("mg_thirdperson_fov_smooth"):GetBool() then
			Editor.DelayFov = Editor.DelayFov + 20
			fov = math.Approach(fov, Editor.DelayFov, math.abs(Editor.DelayFov - fov) * GetConVar("mg_thirdperson_fov_smooth_mult"):GetFloat())
		else
			fov = Editor.DelayFov
		end
		if GetConVar("mg_thirdperson_collision"):GetBool() then
			local traceData = {}
			traceData.start = Editor.DelayPos
			traceData.endpos = traceData.start + angles:Forward() * -Forward
			traceData.endpos = traceData.endpos + angles:Right() * Right
			traceData.endpos = traceData.endpos + angles:Up() * Up
			traceData.filter = ply
			local trace = util.TraceLine(traceData)
			pos = trace.HitPos
			if trace.Fraction < 1 then
				pos = pos + trace.HitNormal * 5
			end
			view.origin = pos
		else
			local View = Editor.DelayPos + (angles:Forward()* -Forward)
			View = View + (angles:Right() * Right)
			View = View + (angles:Up() * Up)
			view.origin = View
		end
		view.angles = angles
		view.fov = fov
		return view
	end
end
hook.Add("CalcView", "MG_ThirdPerson.CameraView", RenderCameraView)

local last_switch = 0
hook.Add("PlayerButtonDown", "MG_ThirdPerson.SwitchThirdPerson", function(ply, button)
	if GetConVar("mg_thirdperson_easyswitch"):GetBool() and button == GetConVar("mg_thirdperson_bindkey"):GetInt() then
		if last_switch > CurTime() then return end
		last_switch = CurTime() + 0.3
		RunConsoleCommand("mg_thirdperson_enable_toggle")
	end
end)