import Toybox.Application.Storage;

class AddFishStorage {
    private static const _key_prefix = "add_fish_";
    private static const _key_species = _key_prefix + "species";
    private static const _key_size = _key_prefix + "size";
    private static const _key_confirmed = _key_prefix + "confirmed";
    private static const _key_loc_lat = _key_prefix + "loc_lat";
    private static const _key_loc_lon = _key_prefix + "loc_lon";

    
    static function setSpecies(species) {
        Storage.setValue(_key_species, species);
    }

    static function getSpecies() {
        return Storage.getValue(_key_species);
    }

    static function resetSpecies() {
        Storage.deleteValue(_key_species);
    }

    static function setSize(size) {
        Storage.setValue(_key_size, size);
    }

    static function getSize() {
        return Storage.getValue(_key_size);
    }

    static function resetSize() {
        Storage.deleteValue(_key_size);
    }

    static function setConfirmed(confirmed) {
        Storage.setValue(_key_confirmed, confirmed);
    }

    static function getConfirmed() {
        return Storage.getValue(_key_confirmed);
    }

    static function resetConfirmed() {
        Storage.deleteValue(_key_confirmed);
    }

    static function setLocation(lat, lon) {
        Storage.setValue(_key_loc_lat, lat);
        Storage.setValue(_key_loc_lon, lon);
    }

    static function getLocation() {
        var lat = Storage.getValue(_key_loc_lat);
        var lon = Storage.getValue(_key_loc_lon);
        if (lat == null || lon == null) {
            return null;
        }
        return [lat, lon];
    }

    static function resetLocation() {
        Storage.deleteValue(_key_loc_lat);
        Storage.deleteValue(_key_loc_lon);
    }

    static function resetAll() {
        resetSpecies();
        resetSize();
        resetConfirmed();
        resetLocation();
    }
}
