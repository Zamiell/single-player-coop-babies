import { getCurrentBaby } from "../misc";
import { PlayerTypeCustom } from "../types/enums";
import evaluateCacheBabyFunctions from "./evaluateCacheBabies";

export function main(player: EntityPlayer, cacheFlag: CacheFlag): void {
  const character = player.GetPlayerType();
  const [babyType, baby, valid] = getCurrentBaby();
  if (!valid) {
    return;
  }

  // Give the character a flat +1 damage as a bonus, similar to Samael
  if (
    character === PlayerTypeCustom.PLAYER_RANDOM_BABY &&
    cacheFlag === CacheFlag.CACHE_DAMAGE
  ) {
    player.Damage += 1;
  }

  // Handle blindfolded characters
  if (baby.blindfolded === true && cacheFlag === CacheFlag.CACHE_FIREDELAY) {
    player.MaxFireDelay = 100000;
    // (setting "player.FireDelay" here will not work,
    // so do it one frame later in the PostUpdate callback)
  }

  const babyFunc = evaluateCacheBabyFunctions.get(babyType);
  if (babyFunc !== undefined) {
    babyFunc(player, cacheFlag);
  }
}
