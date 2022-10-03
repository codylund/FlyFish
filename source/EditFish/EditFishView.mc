import Toybox.WatchUi;
import Toybox.Time;

class EditFishView extends WatchUi.View {

    private static const _logger = new Logger("EditFishView");

    function initialize() {
        View.initialize();
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

        var fish = FishDb.getAll()[EditFishStorage.getIndex()];
        _logger.log("Showing fish stats for idx=" + EditFishStorage.getIndex() + ", species=" + fish.species);
        findDrawableById("edit_fish_time").setText(DateFormatter.toString(new Time.Moment(fish.time)));
        findDrawableById("edit_fish_species").setText(fish.species);
        findDrawableById("edit_fish_size").setText(fish.size);
        //findDrawableById("edit_fish_loc").setText(fish.loc);

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

    function initialize() {
        _logger.log("initialize()");
        BehaviorDelegate.initialize();
        EditFishStorage.resetAll();
    }

    function onPreviousPage() {
        _logger.log("onPreviousPage()");
        EditFishStorage.decIndex();
        WatchUi.requestUpdate();
    }

    function onNextPage() {
        _logger.log("onNextPage()");
        EditFishStorage.incIndex();
        WatchUi.requestUpdate();
    }

    function onSelect() {
        WatchUi.switchToView(new AddFishView(), new AddFishDelegate(), WatchUi.SLIDE_UP);
    }
}