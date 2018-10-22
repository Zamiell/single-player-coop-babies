local SPCUseItem = {}

-- Includes
local SPCGlobals = require("src/spcglobals")

-- ModCallbacks.MC_USE_ITEM (3)
function SPCUseItem:Main(collectibleType, RNG)
  -- Certain items like The Nail mess up the player sprite (if they are standing still)
  -- If we reload the sprite in this callback, it won't work, so mark to update it in the MC_POST_UPDATE callback
  SPCGlobals.run.reloadSprite = true
end

-- CollectibleType.COLLECTIBLE_MONSTROS_TOOTH (86)
function SPCUseItem:Item86(collectibleType, RNG)
  -- Local variables
  local game = Game()
  local gameFrameCount = game:GetFrameCount()
  local type = SPCGlobals.run.babyType
  local baby = SPCGlobals.babies[type]
  if baby == nil then
    return
  end

  if baby.name == "Drool Baby" then -- 221
    -- Summon extra Monstro's, spaced apart
    SPCGlobals.run.babyCounters = SPCGlobals.run.babyCounters + 1
    if SPCGlobals.run.babyCounters == baby.num then
      SPCGlobals.run.babyCounters = 0
      SPCGlobals.run.babyFrame = 0
    else
      SPCGlobals.run.babyFrame = gameFrameCount + 15
    end
  end
end

-- CollectibleType.COLLECTIBLE_HOW_TO_JUMP (282)
function SPCUseItem:Item282(collectibleType, RNG)
  -- Local variables
  local game = Game()
  local gameFrameCount = game:GetFrameCount()
  local type = SPCGlobals.run.babyType
  local baby = SPCGlobals.babies[type]
  if baby == nil then
    return
  end

  if baby.name == "Rabbit Baby" then -- 350
    SPCGlobals.run.babyFrame = gameFrameCount + baby.num
  end
end

function SPCUseItem:ClockworkAssembly(collectibleType, RNG)
  -- Local variables
  local game = Game()
  local player = game:GetPlayer(0)

  -- Spawn a Restock Machine (6.10)
  SPCGlobals.run.clockworkAssembly = true
  player:UseCard(Card.CARD_WHEEL_OF_FORTUNE) -- 11
  player:AnimateCollectible(Isaac.GetItemIdByName("Clockwork Assembly"), "UseItem", "PlayerPickup")
end

function SPCUseItem:FlockOfSuccubi(collectibleType, RNG)
  -- Local variables
  local game = Game()
  local player = game:GetPlayer(0)
  local effects = player:GetEffects()

  -- Spawn 10 temporary Succubi
  -- (for some reason, adding 7 actually adds 28)
  for i = 1, 7 do
    effects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_SUCCUBUS, false)
  end
  player:AnimateCollectible(Isaac.GetItemIdByName("Flock of Succubi"), "UseItem", "PlayerPickup")
end

function SPCUseItem:ChargingStation(collectibleType, RNG)
  -- Local variables
  local game = Game()
  local player = game:GetPlayer(0)
  local coins = player:GetNumCoins()
  local sfx = SFXManager()

  if coins == 0 or
     RacingPlusGlobals == nil or
     RacingPlusSchoolbag == nil or
     player:HasCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG_CUSTOM) == false or
     RacingPlusGlobals.run.schoolbag.item == 0 then

    return
  end

  player:AddCoins(-1)
  RacingPlusSchoolbag:AddCharge(true) -- Giving an argument will make it only give 1 charge
  player:AnimateCollectible(Isaac.GetItemIdByName("Charging Station"), "UseItem", "PlayerPickup")
  sfx:Play(SoundEffect.SOUND_BEEP, 1, 0, false, 1) -- 171
end

return SPCUseItem
