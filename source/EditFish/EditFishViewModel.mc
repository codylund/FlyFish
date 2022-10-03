class EditFishViewModel {
    private var _idx = 0;

    function dec() {
        _idx += (FishDb.getAll().size() - 1);
        _idx %= FishDb.getAll().size();
    }

    function inc() {
        _idx += 1;
        _idx %= FishDb.getAll().size();
    }

    function getCurrentIndex() as Number {
        return _idx;
    }

    function getCurrentFish() as Fish {
        return FishDb.get(_idx);
    }
}
