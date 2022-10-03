class AddFishViewModel {

    var fish = new Fish();
    var confirmed = false;
    var replace_idx;
    
    function commit() {
        if (replace_idx == null) {
            // We are adding a brand new fish.
            fish.time = Time.now().value();
            FishDb.addFish(fish);
        } else {
            // We are replacing an existing fish with new data.
            // Update the existing fish with the new data.
            var cur_fish = FishDb.get(replace_idx);
            cur_fish.species = fish.species;
            cur_fish.size = fish.size;
            FishDb.replaceFish(replace_idx, cur_fish);
        }
    }
}