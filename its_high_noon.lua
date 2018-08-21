local high_noon = {}

high_noon.Base = "weapon_base"
high_noon.PrintName = "Mccree's Pistol"
high_noon.Author = "26 E's"
high_noon.Instructions = "It's high noon!"
high_noon.Spawnable = true
high_noon.AdminOnly = true


high_noon.Secondary = {}
high_noon.Secondary.ClipSize = -1
high_noon.Secondary.DefaultClip	= -1
high_noon.Secondary.Automatic = false
high_noon.Secondary.Ammo = "none"

high_noon.Weight = 5
high_noon.AutoSwitchTo = false
high_noon.AutoSwitchFrom = false
high_noon.Slot = 2
high_noon.SlotPos = 2
high_noon.DrawAmmo = false
high_noon.DrawCrosshair	= true

high_noon.ViewModel = "models/weapons/v_357.mdl"
high_noon.WorldModel = "models/weapons/w_357.mdl"

high_noon.ShootSound = Sound("Weapon_357.Single")
high_noon.SpeakSound = "https://www.dropbox.com/s/exerbrvtw41j60h/mccree-its-high-noon.mp3?dl=1"
high_noon.BoneToLook = "ValveBiped.Bip01_Head1"

function high_noon:SecondaryAttack()
	if SERVER then
		local PlayersToShoot = {}
		for i,v in pairs(player.GetAll()) do
			if (self:GetOwner():VisibleVec(v:GetPos())) and not (v == self:GetOwner())  then
				table.insert(PlayersToShoot, v)
			end
		end
		
		timer.Simple(2.75, function()
			for k,v in pairs(PlayersToShoot) do
				if v:IsValid() then
					local targetBonePos, _
					if v:LookupBone(self.BoneToLook) then
						targetBonePos, _ = v:GetBonePosition(v:LookupBone(self.BoneToLook))
					else
						targetBonePos = v:GetPos()
					end
					
					local shootpos = self:GetOwner():GetShootPos()
					
					local bullet = {
						Num = 1,
						Src = self:GetOwner():GetShootPos(),
						Dir = (targetBonePos - shootpos),
						Spread = Vector(0,0,0),
						Tracer = 5,
						Force = 10,
						Damage = 100,
						AmmoType = "357"
					}
					
					for i = 1, 3 do
						self:GetOwner():FireBullets(bullet)
					end
				end
			end
			self:ShootEffects()
			self:EmitSound(self.ShootSound)
			self:SetNextSecondaryFire(CurTime()+1)
		end)
	else
		sound.PlayURL(self.SpeakSound, "", function(snd)
			snd:SetVolume(1)
			snd:SetPos(self:GetOwner():GetPos())
			snd:Play()
		end)
	end
end

weapons.Register(high_noon, "weapon_high_noon")
