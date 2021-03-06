import { getCurrentBaby } from "../misc";
import { CollectibleTypeCustom } from "../types/enums";
import postPickupInitBabyFunctions from "./postPickupInitBabies";

export function main(pickup: EntityPickup): void {
  const [babyType, , valid] = getCurrentBaby();
  if (!valid) {
    return;
  }

  // All baby effects should ignore the Checkpoint
  if (
    pickup.Variant === PickupVariant.PICKUP_COLLECTIBLE &&
    pickup.SubType === CollectibleTypeCustom.COLLECTIBLE_CHECKPOINT
  ) {
    return;
  }

  const babyFunc = postPickupInitBabyFunctions.get(babyType);
  if (babyFunc !== undefined) {
    babyFunc(pickup);
  }
}
