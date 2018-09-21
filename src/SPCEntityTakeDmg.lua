local SPCEntityTakeDmg = {}

-- Includes
local SPCGlobals = require("src/spcglobals")

-- ModCallbacks.MC_ENTITY_TAKE_DMG (11)
-- (this must return nil or false)
function SPCEntityTakeDmg:Main(tookDamage, damageAmount, damageFlag, damageSource, damageCountdownFrames)
  -- Local variables
  local type = SPCGlobals.run.babyType
  local baby = SPCGlobals.babies[type]
  if baby == nil then
    return
  end

  --[[
  Isaac.DebugString("MC_ENTITY_TAKE_DMG - " ..
                    tostring(damageSource.Type) .. "." .. tostring(damageSource.Variant) .. "." ..
                    tostring(damageSource.SubType) .. " --> " ..
                    tostring(tookDamage.Type) .. "." .. tostring(tookDamage.Variant) .. "." ..
                    tostring(tookDamage.SubType))
  --]]

  local player = tookDamage:ToPlayer()
  if player ~= nil then
    return SPCEntityTakeDmg:Player(player, damageAmount, damageCountdownFrames)
  else
    return SPCEntityTakeDmg:Entity(tookDamage, damageAmount, damageSource, damageCountdownFrames)
  end
end

function SPCEntityTakeDmg:Player(player, damageAmount, damageCountdownFrames)
  -- Local variables
  local game = Game()
  local gameFrameCount = game:GetFrameCount()
  local type = SPCGlobals.run.babyType
  local baby = SPCGlobals.babies[type]
  local zeroVelocity = Vector(0, 0)

  -- Check to see if the player is supposed to be temporarily invulnerable
  if SPCGlobals.run.invulnerabilityFrame ~= 0 and
     SPCGlobals.run.invulnerabilityFrame >= gameFrameCount then

    return false
  end
  if SPCGlobals.run.invulnerable == true then
    return false
  end

  if baby.name == "Host Baby" then -- 9
    for i = 1, 10 do
      player:AddBlueSpider(player.Position)
    end

  elseif baby.name == "Lost Baby" then -- 10
    local creep = game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, -- 46
                             player.Position, Vector(0, 0), player, 0, 0)
    creep:ToEffect().Scale = 10
    creep:ToEffect().Timeout = 240

  elseif baby.name == "Glass Baby" then -- 14
    -- Spawn a random pickup
    SPCGlobals.run.randomSeed = SPCGlobals:IncrementRNG(SPCGlobals.run.randomSeed)
    math.randomseed(SPCGlobals.run.randomSeed)
    local pickupVariant = math.random(1, 11)
    SPCGlobals.run.randomSeed = SPCGlobals:IncrementRNG(SPCGlobals.run.randomSeed)

    if pickupVariant == 1 then -- Heart
      -- Random Heart - 5.10.0
      game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, player.Position, zeroVelocity,
                 player, 0, SPCGlobals.run.randomSeed)

    elseif pickupVariant == 2 then -- Coin
      -- Random Coin - 5.20.0
      game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, player.Position, zeroVelocity,
                 player, 0, SPCGlobals.run.randomSeed)

    elseif pickupVariant == 3 then -- Key
      -- Random Key - 5.30.0
      game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, player.Position, zeroVelocity,
                 player, 0, SPCGlobals.run.randomSeed)

    elseif pickupVariant == 4 then -- Bomb
      -- Random Bomb - 5.40.0
      game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, player.Position, zeroVelocity,
                 player, 0, SPCGlobals.run.randomSeed)

    elseif pickupVariant == 5 then -- Chest
      -- Random Chest - 5.50
      game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST, player.Position, zeroVelocity,
                 player, 0, SPCGlobals.run.randomSeed)

    elseif pickupVariant == 6 then -- Sack
      -- Random Chest - 5.69
      game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_GRAB_BAG, player.Position, zeroVelocity,
                 player, 0, SPCGlobals.run.randomSeed)

    elseif pickupVariant == 7 then -- Lil' Battery
      -- Lil' Battery - 5.90
      game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, player.Position, zeroVelocity,
                 player, 0, SPCGlobals.run.randomSeed)

    elseif pickupVariant == 8 then -- Pill
      -- Random Pill - 5.70.0
      game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, player.Position, zeroVelocity,
                 player, 0, SPCGlobals.run.randomSeed)

    elseif pickupVariant == 9 then -- Card / Rune
      -- Random Card / Rune - 5.300.0
      game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, player.Position, zeroVelocity,
                 player, 0, SPCGlobals.run.randomSeed)

    elseif pickupVariant == 10 then -- Trinket
      -- Random Card / Rune - 5.350.0
      game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, player.Position, zeroVelocity,
                 player, 0, SPCGlobals.run.randomSeed)

    elseif pickupVariant == 11 then -- Collectible
      -- Random Collectible - 5.100.0
      game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, player.Position, zeroVelocity,
                 player, 0, SPCGlobals.run.randomSeed)
    end

  elseif baby.name == "Wrapped Baby" then -- 20
    -- Use Kamikaze on the next 5 frames
    SPCGlobals.run.wrappedBabyKami = 5

  elseif baby.name == "-0- Baby" then -- 24
    return false

  elseif baby.name == "Yellow Baby" then -- 33
    player:UsePill(PillEffect.PILLEFFECT_LEMON_PARTY, 0) -- 26

  elseif baby.name == "Blinding Baby" then -- 46
    -- Sun Card - 5.300.20
    game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, player.Position, zeroVelocity, player, 20, 0)

  elseif baby.name == "Revenge Baby" then -- 50
    -- Random Heart - 5.10.0
    SPCGlobals.run.randomSeed = SPCGlobals:IncrementRNG(SPCGlobals.run.randomSeed)
    game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, player.Position, zeroVelocity,
               player, 0, SPCGlobals.run.randomSeed)

  elseif baby.name == "Half Head Baby" and -- 98
         SPCGlobals.run.halfHeadBabyDD == false then

    -- Take double damage
    SPCGlobals.run.halfHeadBabyDD = true
    player:TakeDamage(damageAmount, 0, EntityRef(player), damageCountdownFrames)
    SPCGlobals.run.halfHeadBabyDD = false

  elseif baby.name == "Banshee Baby" then -- 293
    player:UseActiveItem(CollectibleType.COLLECTIBLE_CRACK_THE_SKY, false, false, false, false) -- 160

  elseif baby.name == "Starry Eyed Baby" then -- 310
    -- Stars Card (5.300.18)
    game:Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, player.Position, zeroVelocity, player, 18, 0)

  elseif baby.name == "Puzzle Baby" then -- 315
    player:UseActiveItem(CollectibleType.COLLECTIBLE_D6, false, false, false, false) -- 105

  elseif baby.name == "Tortoise Baby" then -- 330
    SPCGlobals.run.randomSeed = SPCGlobals:IncrementRNG(SPCGlobals.run.randomSeed)
    math.randomseed(SPCGlobals.run.randomSeed)
    local avoidChance = math.random(1, 2)
    if avoidChance == 2 then
      return false
    end

  elseif baby.name == "Skinless Baby" and -- 322
         SPCGlobals.run.skinlessBabyDD == false then

    -- Take double damage
    SPCGlobals.run.skinlessBabyDD = true
    player:TakeDamage(damageAmount, 0, EntityRef(player), damageCountdownFrames)
    SPCGlobals.run.skinlessBabyDD = false

  elseif baby.name == "Hero Baby" then -- 336
    -- We want to evaluate the cache, but we can't do it here because the damage is not applied yet,
    -- so mark to do it later in the PostUpdate callback
    SPCGlobals.run.heroBabyEval = true

  elseif baby.name == "Fiery Baby" then -- 366
    player:ShootRedCandle(Vector(0, 0))

  elseif baby.name == "Fairyman Baby" then -- 385
    SPCGlobals.run.fairymanBabyHits = SPCGlobals.run.fairymanBabyHits + 1
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE) -- 1
    player:EvaluateItems()
  end
end

function SPCEntityTakeDmg:Entity(entity, damageAmount, damageSource, damageCountdownFrames)
  -- Local variables (2)
  local game = Game()
  local level = game:GetLevel()
  local stage = level:GetStage()
  local player = game:GetPlayer(0)
  local type = SPCGlobals.run.babyType
  local baby = SPCGlobals.babies[type]

  if baby.name == "Water Baby" and -- 3
     damageSource.Type == EntityType.ENTITY_TEAR and -- 2
     damageSource.Entity.SubType == 1 then

    -- Make the tears from Isaac's Tears do a lot of damage,
    -- like a Polyphemus tear (that scales with the floor)
    local damage = damageAmount * 10 * (1 + stage * 0.1)
    entity:TakeDamage(damage, 0, EntityRef(player), damageCountdownFrames)

  elseif baby.name == "Lost Baby" and -- 10
         damageSource.Type == EntityType.ENTITY_EFFECT and -- 1000
         damageSource.Variant == EffectVariant.PLAYER_CREEP_RED then -- 46

    -- By default, player creep only deals 2 damage per tick, so increase the damage
    local damage = player.Damage * 2
    entity:TakeDamage(damage, 0, EntityRef(player), damageCountdownFrames)

  elseif baby.name == "Rider Baby" and -- 295
         SPCGlobals.run.dealingExtraDamage == false then

    -- Make the Pony do extra damage
    local damage = player.Damage * 4
    SPCGlobals.run.dealingExtraDamage = true
    entity:TakeDamage(damage, 0, EntityRef(player), damageCountdownFrames)
    SPCGlobals.run.dealingExtraDamage = false

  elseif baby.name == "Elf Baby" and -- 377
         SPCGlobals.run.dealingExtraDamage == false then

    -- Make the Spear of Destiny do extra damage
    local damage = player.Damage * 4
    SPCGlobals.run.dealingExtraDamage = true
    entity:TakeDamage(damage, 0, EntityRef(player), damageCountdownFrames)
    SPCGlobals.run.dealingExtraDamage = false

  elseif baby.name == "Astronaut Baby" and -- 406
         damageSource.Type == EntityType.ENTITY_TEAR then -- 2

    -- 5% chance for a black hole to spawn
    math.randomseed(damageSource.Entity.InitSeed)
    local chance = math.random(1, 100)
    if chance <= 5 then
      game:Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLACK_HOLE, -- 107
                 damageSource.Position, damageSource.Entity.Velocity, nil, 0, 0)
    end
  end
end

return SPCEntityTakeDmg
