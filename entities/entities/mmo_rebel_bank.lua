
AddCSLuaFile()
-- Banking Terminal
ENT.Type = "anim"

ENT.PrintName		= "Banking Terminal"
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
			if activator:Team() == 1 then
				net.Start("MMO_OpenBank")
					net.WriteTable(activator.BankInventory)
					net.WriteTable(activator.Inventory)
					net.Send(activator)
				sound.Play("buttons/button3.wav", self:GetPos())
			else
				sound.Play("buttons/button8.wav", self:GetPos())
			end
		end
	end
	
	function ENT:Initialize()
		self:SetModel("models/props_lab/tpswitch.mdl")
		self:PhysicsInit(SOLID_NONE)
		self:SetSolid(SOLID_VPHYSICS)
		self.last_use = CurTime()
	end
end