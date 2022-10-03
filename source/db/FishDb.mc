import Toybox.Application.Storage;

// Database for storing Fish objects.
class FishDb {
    private static const _key_fish = "fishdb_fish";
    private static const _key_fish_count = "fishdb_count";

    static function get(idx as Number) as Fish {
        return Fish.fromSerializable(getAllSerializable()[idx]);
    }

    static function getAll() as Array<Fish> {
        var fishArraySerializable = getAllSerializable();
        
        var fishArray = [];
        for (var i = 0; i < fishArraySerializable.size(); i++) {
            fishArray.add(Fish.fromSerializable(fishArraySerializable[i]));
        }

        return fishArray;
    }

    private static function getAllSerializable() {
        var fishArray = Storage.getValue(_key_fish);
        
        if (fishArray == null) {
            return [];
        }

        return fishArray;
    }

    static function addFish(fish as Fish) {
        var fishArray = getAllSerializable();
        fishArray.add(fish.toSerializable());
        Storage.setValue(_key_fish, fishArray);
    }

    static function deleteFish(idx as Number) {
        var fishArray = getAllSerializable();
        var fish = fishArray[idx];
        fishArray.remove(fish);
        Storage.setValue(_key_fish, fishArray);
    }

    static function replaceFish(idx as Number, newFish as Fish) {
       var fishArray = getAllSerializable();
       fishArray[idx] = newFish.toSerializable();
       Storage.setValue(_key_fish, fishArray);
    }
}

// A recorded catch.
class Fish {
    var time as Number;
    var loc as Array<Float>;
    var species as String;
    var size as Long;

    // Convert object to serializable variant, so it can be stored in a DB.
    function toSerializable() as Dictionary<String, Object> {
        return {
            "time" => time,
            "loc" => loc,
            "species" => species,
            "size" => size
        };
    }

    static function fromSerializable(val) as Fish {
        var fish = new Fish();
        fish.time = val["time"];
        fish.loc = val["loc"];
        fish.species = val["species"];
        fish.size = val["size"];
        return fish;
    }
}
