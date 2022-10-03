import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.WatchUi;

using Toybox.Time;

class AddFishView extends WatchUi.View {

    private var _logger = new Logger("AddFishView");

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        // No real layout. We just use this to view to organize child menus.
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        _logger.log("onShow()");

        var species = AddFishStorage.getSpecies();
        if (species == null) {
            _logger.log("Showing species options.");
            showSpeciesOptions();
            return;
        }

        var size = AddFishStorage.getSize();
        if (size == null) {
            _logger.log("showing size input.");
            showSizeInput();
            return;
        }

        var confirmed = AddFishStorage.getConfirmed();
        if (confirmed == null || confirmed != true) {
            _logger.log("showing confirmation.");
            showConfirmation(species, size);
            return;
        }

        var loc = AddFishStorage.getLocation();
        if (loc == null) {
            _logger.log("fetching location");
            fetchLoc();
            return;
        }


        var fish = new Fish();
        fish.time = Time.now().value();
        fish.loc = loc;
        fish.species = species;
        fish.size = size;
        FishDb.addFish(fish);

        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }
}

function showSpeciesOptions() {
    WatchUi.pushView(new FishSpeciesMenu(), new FishSpeciesInputDelegate(), WatchUi.SLIDE_IMMEDIATE);
}

function showSizeInput() {
    WatchUi.pushView(new FishSizeMenu(), new FishSizeMenu(), WatchUi.SLIDE_IMMEDIATE);
}

function showConfirmation(species, size) {
    WatchUi.pushView(new ConfirmFishMenu(), new ConfirmFishInputDelegate(), WatchUi.SLIDE_IMMEDIATE);
}

function fetchLoc() {
    WatchUi.pushView(new AddFishGetLocationProgressBar(), new AddFishGetLocationBehaviorDelegate(), WatchUi.SLIDE_IMMEDIATE);
}

class AddFishDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
        // New fish. Clear existing storage state.
        AddFishStorage.resetAll();
    }
}

class FishSpeciesMenu extends WatchUi.Menu2 {
    function initialize() {
        Menu2.initialize({:title=>"Species"});
        addItem(new WatchUi.MenuItem("Brown", null, "Brown", {}));
        addItem(new WatchUi.MenuItem("Cutthroat", null, "Cutthroat", {}));
        addItem(new WatchUi.MenuItem("Lake", null, "Lake", {}));
        addItem(new WatchUi.MenuItem("Rainbow", null, "Rainbow", {}));
    }

    function onShow() {
        Menu2.onShow();
        // Update values.
        update(ID_SPECIES, AddFishStorage.getSpecies());
        update(ID_SIZE, AddFishStorage.getSize() + " in");
    }
}

class FishSpeciesInputDelegate extends WatchUi.Menu2InputDelegate {
    private var _logger = new Logger("FishSpeciesInputDelegate");

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        var species = item.getLabel();

        _logger.log("Setting species to " + species);

        AddFishStorage.setSpecies(species);
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
}

class FishSizeMenu extends WatchUi.Menu2 {
    function initialize() {
        Menu2.initialize({:title=>"Size (in)"});
        for (var i = 5 as Long; i < 40; i++) {
            var int = i.format("%i");
            addItem(new WatchUi.MenuItem(int, null, int, {}));
        }
    }
}

class FishSizeInputDelegate extends WatchUi.Menu2InputDelegate {
    private var _logger = new Logger("FishSizeInputDelegate");

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        var size = item.getId();

        _logger.log("Setting size to " + size);

        AddFishStorage.setSize(item.getId());
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
}

class ConfirmFishMenu extends WatchUi.Menu2 {

    static const ID_SPECIES = "species";
    static const ID_SIZE = "size";
    static const ID_OK = "ok";

    function initialize() {
        Menu2.initialize({:title=>"Add a fish"});
        addItem(new WatchUi.MenuItem("Species", null, ID_SPECIES, {}));
        addItem(new WatchUi.MenuItem("Size", null, ID_SIZE, {}));
        addItem(new WatchUi.MenuItem("Ok", null, ID_OK, {}));
    }

    function onShow() {
        WatchUi.Menu2.onShow();
        // Update values.
        update(ID_SPECIES, AddFishStorage.getSpecies());
        update(ID_SIZE, AddFishStorage.getSize() + " in");
    }

    private function update(id, value) {
        var idx = findItemById(id);
        var menuItem = getItem(idx);
        menuItem.setSubLabel(value);
        updateItem(menuItem, idx);
    }
}

class ConfirmFishInputDelegate extends WatchUi.Menu2InputDelegate {
    
    private var _logger = new Logger("ConfirmFishInputDelegate");

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        if (item.getId().equals(ConfirmFishMenu.ID_SPECIES)) {
            _logger.log("Modifying species.");
            showSpeciesOptions();
        } else if (item.getId().equals(ConfirmFishMenu.ID_SIZE)) {
            _logger.log("Resetting size.");
            showSizeInput();
        } else if (item.getId().equals(ConfirmFishMenu.ID_OK)) {
            _logger.log("Confirming input.");
            AddFishStorage.setConfirmed(true);
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
    }
}


