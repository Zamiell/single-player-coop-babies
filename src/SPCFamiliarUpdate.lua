local SPCFamiliarUpdate = {}

-- Includes
local SPCGlobals = require("src/spcglobals")
local SPCMisc    = require("src/spcmisc")

function SPCFamiliarUpdate:Main(familiar)
  -- Local variables
  local game = Game()
  local player = game:GetPlayer(0)
  local type = SPCGlobals.run.babyType
  local baby = SPCGlobals.babies[type]
  if baby == nil then
    return
  end

  if baby.name == "Sucky Baby" and -- 48
     familiar.Variant == FamiliarVariant.SUCCUBUS then -- 96

    -- Keep it locked on the player so emulate a Succubus aura
    familiar.Position = player.Position

  elseif baby.name == "Gurdy Baby" and -- 82
         familiar.Variant == FamiliarVariant.LIL_GURDY then -- 87

    -- All of the familiars will stack on top of each other, so manually keep them spread apart
    local entities = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.LIL_GURDY, -1, false, false) -- 3.87
    for i = 1, #entities do
      local familiar2 = entities[i]
      if SPCGlobals:InsideSquare(familiar.Position, familiar2.Position, 1) and
         familiar.Index < familiar2.Index then -- Use the index as a priority of which familiar is forced to move away

        familiar2.Position = SPCMisc:GetOffsetPosition(familiar2.Position, 7, familiar2.InitSeed)
      end
    end

  elseif baby.name == "Bloodsucker Baby" then -- 87
    -- Everything is tiny
    -- For some reason, familiars reset their SpriteScale on every frame, so we have to constantly set it back
    familiar.SpriteScale = Vector(0.5, 0.5)

  elseif baby.name == "New Jammies Baby" then -- 193
    -- Everything is giant
    -- For some reason, familiars reset their SpriteScale on every frame, so we have to constantly set it back
    familiar.SpriteScale = Vector(2, 2)

  elseif baby.name == "Geek Baby" and -- 326
         familiar.Variant == FamiliarVariant.ROBO_BABY_2 then -- 53

    -- All of the familiars will stack on top of each other, so manually keep them spread apart
    local entities = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ROBO_BABY_2, -1, false, false) -- 3.53
    for i = 1, #entities do
      local familiar2 = entities[i]
      if SPCGlobals:InsideSquare(familiar.Position, familiar2.Position, 1) and
         familiar.Index < familiar2.Index then -- Use the index as a priority of which Gurdy is forced to move away

        familiar2.Position = SPCMisc:GetOffsetPosition(familiar2.Position, 7, familiar2.InitSeed)
      end
    end

  elseif baby.name == "Dino Baby" and -- 376
         familiar.Variant == FamiliarVariant.BOBS_BRAIN and -- 59
         familiar.SubType == 1 then -- Bob's Brain familiars have a SubType of 1 after they explode

    familiar:Remove()

  elseif baby.name == "Pixie Baby" and -- 403
         familiar.Variant == FamiliarVariant.YO_LISTEN and -- 111
         familiar.FrameCount % 5 == 0 then

    -- Speed it up
    familiar.Velocity = familiar.Velocity * 2

  elseif baby.name == "Seraphim" and -- 538
         familiar.Variant == FamiliarVariant.CENSER then -- 89

    familiar.Position = player.Position
    local sprite = familiar:GetSprite()
    sprite:Load("gfx/003.089_censer_invisible.anm2", true)
    sprite:Play("Idle")

  elseif baby.name == "Graven Baby" and -- 453
         familiar.Variant == FamiliarVariant.BUMBO and -- 88
         familiar.FrameCount % 5 == 0 then

    -- Speed it up
    familiar.Velocity = familiar.Velocity * 2
  end
end

return SPCFamiliarUpdate
