local PostGameStarted  = {}

-- Includes
local g            = require("babies_mod/globals")
local PostNewLevel = require("babies_mod/postnewlevel")

-- ModCallbacks.MC_POST_GAME_STARTED (15)
function PostGameStarted:Main(saveState)
  -- Don't do anything if this is not a new run
  if saveState then
    return
  end

  -- Local variables
  local seeds = g.g:GetSeeds()
  local itemPool = g.g:GetItemPool()
  local character = g.p:GetPlayerType()
  local challenge = Isaac.GetChallenge()

  Isaac.DebugString("MC_POST_GAME_STARTED (BM)")

  -- Reset variables
  g:InitRun()

  -- Also reset the list of past babies that have been chosen
  -- (but don't do this if we are in the middle of a multi-character custom challenge)
  local resetPastBabies = true
  if challenge == Isaac.GetChallengeIdByName("R+7 (Season 5)") and
     RacingPlusSpeedrun ~= nil and
     RacingPlusSpeedrun.charNum >= 2 then

    resetPastBabies = false
  end
  if resetPastBabies then
    g.pastBabies = {}
  end

  -- Easter Eggs from babies are normally removed upon going to the next floor
  -- We also have to check to see if they reset the game while on a baby with a custom Easter Egg effect
  for i = 1, #g.babies do
    local baby = g.babies[i]
    if baby.seed ~= nil then
      if seeds:HasSeedEffect(baby.seed) then
        seeds:RemoveSeedEffect(baby.seed)
      end
    end
  end

  -- Also remove seeds that are turned on manually in the MC_POST_UPDATE callback
  if seeds:HasSeedEffect(SeedEffect.SEED_OLD_TV) then -- 8
    seeds:RemoveSeedEffect(SeedEffect.SEED_OLD_TV) -- 8
  end

  -- Only do the following things if we are not on the Random Baby character
  if character == Isaac.GetPlayerTypeByName("Random Baby") then
    -- We want to keep track that we started the run as the "Random Baby" character,
    -- in case the player changes their character later through Judas' Shadow, etc.
    g.run.enabled = true
  else
    return
  end

  -- Random Baby always starts with the Schoolbag
  if RacingPlusGlobals == nil then
    g.p:AddCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG, 0, false) -- 534
    itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG) -- 534
  else
    g.p:AddCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG_CUSTOM, 0, false)
    itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_SCHOOLBAG_CUSTOM)
  end

  -- Remove some items from pools
  itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_GUILLOTINE) -- 206
  -- (this item will not properly display and there is no good way to fix it)
  itemPool:RemoveCollectible(CollectibleType.COLLECTIBLE_CLICKER) -- 482
  -- (there is no way to know which character that you Clicker to, so just remove this item)
  itemPool:RemoveTrinket(TrinketType.TRINKET_BAT_WING) -- 118
  -- (Bat Wing causes graphical bugs which are annoying to fix, so just remove this trinket)

  -- Call PostNewLevel manually (they get naturally called out of order)
  PostNewLevel:NewLevel()
end

return PostGameStarted