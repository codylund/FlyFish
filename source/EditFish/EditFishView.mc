import Toybox.WatchUi;
import Toybox.Time;

class EditFishView extends WatchUi.View {

    private static const _logger = new Logger("EditFishView");

    private var _vm as EditFishViewModel;

    function initialize(vm as EditFishViewModel) {
        View.initialize();
        _vm = vm;
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.EditFishLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        _logger.log("onShow()");
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        _logger.log("onUpdate()");

        var fish = _vm.getCurrentFish();
        findDrawableById("edit_fish_time").setText(DateFormatter.toString(new Time.Moment(fish.time)));
        findDrawableById("edit_fish_species").setText(fish.species);
        findDrawableById("edit_fish_size").setText(fish.size);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }
}

class EditFishDelegate extends WatchUi.BehaviorDelegate {

    private static const _logger = new Logger("EditFishDelegate");

    private var _vm as EditFishViewModel;

    function initialize(vm as EditFishViewModel) {
        BehaviorDelegate.initialize();
        _logger.log("initialize()");
        _vm = vm;
    }

    function onPreviousPage() {
        _logger.log("onPreviousPage()");
        _vm.dec();
        WatchUi.requestUpdate();
    }

    function onNextPage() {
        _logger.log("onNextPage()");
        _vm.inc();
        WatchUi.requestUpdate();
    }

    function onSelect() {
        WatchUi.switchToView(new EditMenu(), new EditMenuInputDelegate(_vm), WatchUi.SLIDE_UP);
    }
}

class EditMenu extends WatchUi.Menu2 {
    function initialize() {
        Menu2.initialize({:title=>"Options"});
        addItem(new WatchUi.MenuItem("Edit", null, "edit", {}));
        addItem(new WatchUi.MenuItem("Delete", null, "delete", {}));
    }

    function onShow() {
        Menu2.onShow();
    }
}

class EditMenuInputDelegate extends WatchUi.Menu2InputDelegate {
    private static const _logger = new Logger("EditMenuInputDelegate");

    private var _vm as EditFishViewModel;

    function initialize(vm as EditFishViewModel) {
        Menu2InputDelegate.initialize();
        _vm = vm;
    }

    function onSelect(item) {
        _logger.log("Selected menu item with id \"" + item.getId() + "\"");
        if (item.getId().equals("edit")) {
            // Init vm with the selected fish.
            var addVm = new AddFishViewModel();
            addVm.fish = _vm.getCurrentFish();
            addVm.replace_idx = _vm.getCurrentIndex();
            WatchUi.switchToView(new AddFishView(addVm), new AddFishDelegate(), WatchUi.SLIDE_UP);
        } else if (item.getId().equals("delete")) {
            FishDb.deleteFish(_vm.getCurrentIndex());
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
    }
}
