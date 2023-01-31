AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = "models/cpthazama/ball.mdl"
ENT.PhysicsType = SOLID_VPHYSICS
ENT.SolidType = SOLID_CUSTOM
ENT.CollisionGroup = COLLISION_GROUP_PROJECTILE
ENT.MoveCollide = COLLISION_GROUP_PROJECTILE
ENT.MoveType = MOVETYPE_VPHYSICS
ENT.StartHealth = 10
ENT.NextParticleT = 0
ENT.CanFade = true
ENT.FadeTime = 10

function ENT:Physics()
	local phys = self:GetPhysicsObject()
	if(phys:IsValid()) then
		phys:Wake()
		phys:SetMass(0.4)
		phys:EnableGravity(true)
	end
	self:SetNoDraw(true)
	if self.ImpactSound == nil then
		-- self.ImpactSound = "cpthazama/fallout4/fx/FX_Explosion_MirelurkEgg_0" .. math.random(1,2) .. ".mp3"
	end
	if self.ImpactSoundVolume == nil then
		self.ImpactSoundVolume = 80
	end
	if self.ImpactSoundPitch == nil then
		self.ImpactSoundPitch = 100
	end
	ParticleEffectAttach("antlion_spit_trail",PATTACH_ABSORIGIN_FOLLOW,self,0)
end

function ENT:OnTouch(data,phys)
	if self.IsDead == false then
		self.IsDead = true
		self:SetHitEntity(data.HitEntity)
		if self:GetHitEntity():IsPlayer() or self:GetHitEntity():IsNPC() then
			if self:GetHitEntity():GetClass() != "npc_turret_floor" then
				local dmg = DamageInfo()
				dmg:SetDamage(self.Damage)
				dmg:SetAttacker(self:GetEntityOwner())
				dmg:SetInflictor(self)
				dmg:SetDamagePosition(data.HitPos)
				dmg:SetDamageType(DMG_ACID)
				self:GetHitEntity():TakeDamageInfo(dmg)
			elseif !self:GetHitEntity().bSelfDestruct then
				self:GetHitEntity():GetPhysicsObject():ApplyForceCenter(self:GetVelocity():GetNormal() *1000)
				self:GetHitEntity():Fire("selfdestruct","",0)
				self:GetHitEntity().bSelfDestruct = true
			end
			util.AddAttackEffect(self:GetEntityOwner(),self:GetHitEntity(),5,DMG_POI,1,10)
		end
		CPT_ParticleEffect("antlion_gib_02_gas",self:GetPos(),Angle(0,0,0),self)
		-- self:EmitSound(Sound(self:GetImpactSound()),self.ImpactSoundVolume,self.ImpactSoundPitch)
		self:Remove()
	end
end