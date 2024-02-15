-- |RCL 3.0 by BenBonez
-- |If you have any questions regarding the configuration feel free to contact me.
-- |If a line appears as underlined red make sure it has a semicolon ; at the end of it.

local tool, player = script.Parent, game.Players.LocalPlayer return {

ToolName = nil;
ToolIcon = nil;
ToolDesc = nil;

AmmoClip = 12;
AmmoTotal = 60;
AmmoLimited = true;

SpreadBase = 0.7;  

ReloadDuration = 3;
ReloadWhenEmpty = true;
ReloadUnequipped = true;

FireRate = 0.12; 
FireAuto = false;
FireBurst = false; 
FireMulti = 1;

DamageDefault = 10; 
DamageSpecific = {["Head"] = 10; ["Handle"] = 10};
DamageNeutrals = true;
DamageFriendly = false;

CursorEquipping = "rbxasset://textures\\GunCursor.png"; 
CursorReloading = "rbxasset://textures\\GunWaitCursor.png";

HitSoundOn = false;
HitSoundAsset = "rbxasset://sounds\\metalgrass2.mp3";

RayOriginOffset = CFrame.new(0,-0.75,0);
RayMaxDistance = 999;

ReflectionEnabled = true;
ReflectionLimit = 4;

LeftArmWeldC1 = nil;
RightArmWeldC1 = nil;

ProjectileOriginOffset = CFrame.new(1, 0, 0);

}