import Toybox.WatchUi;

using Toybox.Lang;
using Toybox.Position;

class AddFishGetLocationProgressBar extends WatchUi.ProgressBar {
    
    private var _logger = new Logger("AddFishGetLocationProgressBar");

    function initialize() {
        ProgressBar.initialize("Getting location...", null);
        // Start listening for position.
        Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));
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
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }

    function onPosition(info) {
        var lat = info.position.toDegrees()[0];
        var lon = info.position.toDegrees()[1];

        _logger.log("Got location: " + lat + ", " + lon);

        AddFishStorage.setLocation(lat, lon);

        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
}

class AddFishGetLocationBehaviorDelegate extends WatchUi.BehaviorDelegate {
    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onBack() {
        // Block back presses while we get the location.
        return true;
    }
}