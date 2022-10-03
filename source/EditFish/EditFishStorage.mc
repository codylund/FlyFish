import Toybox.Application.Storage;

class EditFishStorage {
    private static const _key_prefix = "edit_fish_";
    private static const _key_cur_idx = _key_prefix + "idx";

    
    static function getIndex() as Number {
        var val = Storage.getValue(_key_cur_idx);
        if (val == null)  {
            val = 0;
            Storage.setValue(_key_cur_idx, val);
        }
        return val;
    }

    static function decIndex() {
        var val = getIndex();
        val += (FishDb.getAll().size() - 1);
        val %= FishDb.getAll().size();
        return Storage.setValue(_key_cur_idx, val);
    }

    static function incIndex() {
        var val = getIndex();
        val += 1;
        val %= FishDb.getAll().size();
        return Storage.setValue(_key_cur_idx, val);
    }

    static function resetIndex() {
        Storage.deleteValue(_key_cur_idx);
    }

    static function resetAll() {
        resetIndex();
    }
}
