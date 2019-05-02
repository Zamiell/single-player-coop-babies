local PostLaserUpdate = {}

-- Includes
local g    = require("babies_mod/globals")
local Misc = require("babies_mod/misc")

-- ModCallbacks.MC_POST_LASER_UPDATE (48)
function PostLaserUpdate:Main(laser)
  -- Local variables
  local sprite = laser:GetSprite()
  local data = laser:GetData()
  local type = g.run.babyType
  local baby = g.babies[type]
  if baby == nil then
    return
  end

  --[[
  Isaac.DebugString("MC_POST_LASER_UPDATE - " ..
                    tostring(laser.Type) .. "." .. tostring(laser.Variant) .. "." .. tostring(laser.SubType))
  Isaac.DebugString("  FrameCount: " .. tostring(laser.FrameCount))
  Isaac.DebugString("  Spawner: " .. tostring(laser.SpawnerType) .. "." .. tostring(laser.SpawnerVariant))
  Isaac.DebugString("  MaxDistance: " .. tostring(laser.MaxDistance))
  --]]

  if baby.name == "Glass Baby" and -- 14
     data ~= nil and
     data.ring == true then

    -- Keep the ring centered on the player
    laser.Position = g.p.Position

  elseif baby.name == "Belial Baby" then -- 51
    if laser.SpawnerType == EntityType.ENTITY_PLAYER and -- 1
       laser.FrameCount == 0 then

      -- Azazel-style Brimstone
      -- The formula for distance is: 32 - 2.5 * player.TearHeight (provided by Nine)
      -- For simplicity and to make it more difficult, we will instead hardcode the default Azazel distance
      laser:SetMaxDistance(75.125) -- This is the vanilla Azazel distance

      -- Making the laser invisible earlier also muted the sound effect, so play it manually
      g.sfx:Play(SoundEffect.SOUND_BLOOD_LASER_LARGE, 0.75, 0, false, 1) -- 7
      -- (Azazel brimstone is the "large" sound effect instead of the normal one for some reason)
      -- (a volume of 1 is a bit too loud)
    end

    if sprite:GetFilename() == "gfx/007.001_Thick Red Laser.anm2" and
       laser.FrameCount == 1 then

      -- We made the laser invisible in the MC_POST_LASER_INIT function,
      -- and it takes a frame for the "laser:SetMaxDistance()" function to take effect
      laser.Visible = true
    end

  elseif baby.name == "404 Baby" and -- 463
         laser.FrameCount == 0 then

    -- This does not work in the MC_POST_LASER_INIT callback for some reason
    Misc:SetRandomColor(laser)
  end
end

return PostLaserUpdate