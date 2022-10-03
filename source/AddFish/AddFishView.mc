import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.WatchUi;

using Toybox.Time;

class AddFishView extends WatchUi.View {

    private var _logger = new Logger("AddFishView");
    private var _vm as AddFishViewmodel;

    function initialize(vm as AddFishViewModel) {
        View.initialize();
        _vm = vm;
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

        if (_vm.fish.species == null) {
            _logger.log("Showing species options.");
            showSpeciesOptions(_vm);
            return;
        }

        if (_vm.fish.size == null) {
            _logger.log("showing size input.");
            showSizeInput(_vm);
            return;
        }

        if (_vm.confirmed != true) {
            _logger.log("showing confirmation.");
            showConfirmation(_vm);
            return;
        }

        if (_vm.fish.loc == null) {
            _logger.log("fetching location");
            fetchLoc(_vm);
            return;
        }

        _vm.commit();

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

function showSpeciesOptions(vm as AddFishViewModel) {
    WatchUi.pushView(new FishSpeciesMenu(), new FishSpeciesInputDelegate(vm), WatchUi.SLIDE_IMMEDIATE);
}

function showSizeInput(vm as AddFishViewModel) {
    WatchUi.pushView(new FishSizeMenu(), new FishSizeInputDelegate(vm), WatchUi.SLIDE_IMMEDIATE);
}

function showConfirmation(vm as AddFishViewModel) {
    WatchUi.pushView(new ConfirmFishMenu(vm), new ConfirmFishInputDelegate(vm), WatchUi.SLIDE_IMMEDIATE);
}

function fetchLoc(vm as AddFishViewModel) {
    WatchUi.pushView(new AddFishGetLocationProgressBar(vm), new AddFishGetLocationBehaviorDelegate(), WatchUi.SLIDE_IMMEDIATE);
}

class AddFishDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onBack() {
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
    }
}

class FishSpeciesInputDelegate extends WatchUi.Menu2InputDelegate {
    private var _logger = new Logger("FishSpeciesInputDelegate");

    private var _vm as AddFishViewmodel;

    function initialize(vm as AddFishViewModel) {
        Menu2InputDelegate.initialize();
        _vm = vm;
    }

    function onSelect(item) {
        var species = item.getLabel();

        _logger.log("Setting species to " + species);

        _vm.fish.species = species;
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

    private var _vm as AddFishViewmodel;

    function initialize(vm as AddFishViewModel) {
        Menu2InputDelegate.initialize();
        _vm = vm;
    }

    function onSelect(item) {
        var size = item.getId();

        _logger.log("Setting size to " + size);

        _vm.fish.size = item.getId();
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
}

class ConfirmFishMenu extends WatchUi.Menu2 {

    static const ID_SPECIES = "species";
    static const ID_SIZE = "size";
    static const ID_OK = "ok";

    private var _vm as AddFishViewmodel;

    function initialize(vm as AddFishViewModel) {
        Menu2.initialize({:title=>"Add a fish"});
        _vm = vm;
        addItem(new WatchUi.MenuItem("Species", null, ID_SPECIES, {}));
        addItem(new WatchUi.MenuItem("Size", null, ID_SIZE, {}));
        addItem(new WatchUi.MenuItem("Ok", null, ID_OK, {}));
    }

    function onShow() {
        WatchUi.Menu2.onShow();
        // Update values.
        update(ID_SPECIES, _vm.fish.species);
        update(ID_SIZE, _vm.fish.size + " in");
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

    private var _vm as AddFishViewmodel;

    function initialize(vm as AddFishViewModel) {
        Menu2InputDelegate.initialize();
        _vm = vm;
    }

    function onSelect(item) {
        if (item.getId().equals(ConfirmFishMenu.ID_SPECIES)) {
            _logger.log("Modifying species.");
            showSpeciesOptions(_vm);
        } else if (item.getId().equals(ConfirmFishMenu.ID_SIZE)) {
            _logger.log("Resetting size.");
            showSizeInput(_vm);
        } else if (item.getId().equals(ConfirmFishMenu.ID_OK)) {
            _logger.log("Confirming input.");
            _vm.confirmed = true;
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
    }
}


