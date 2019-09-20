
AddCSLuaFile()
-- Gunsmithing Equipment
ENT.Type = "anim"

ENT.PrintName		= "Gunsmithing Terminal"
ENT.Author			= "RhapidFyre"
ENT.Purpose			= "Allow players to bank money and valuables"

if (CLIENT) then
	function ENT:Draw()
		self:DrawModel()
	end
end

if (SERVER) then
	function ENT:Use(activator, user, use_type, value)
		if self.last_use + 0.5 < CurTime() then
			self.last_use = CurTime()
			if activator:Team() ~= 0 then
				sound.Play("items/ammocrate_open.wav", self:GetPos())
				net.Start("MMO_InteractMenu")
					net.WriteString("Gunsmithing")
					net.Send(activator)
			end
		end
	end
	
	function ENT:Initialize()
		self:SetModel("models/items/ammocrate_smg1.mdl")
		self:PhysicsInit(SOLID_NONE)
		self:SetSolid(SOLID_VPHYSICS)
		self.last_use = CurTime()
	end
end