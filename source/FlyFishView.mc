import Toybox.Graphics;
import Toybox.WatchUi;

class FlyFishView extends WatchUi.MapTrackView {

    private var _logger = new Logger("FlyFishView");

    //! Constructor
    public function initialize() {
        MapTrackView.initialize();

        // set the current mode for the map to preview
        setMapMode(WatchUi.MAP_MODE_PREVIEW);

        // create the bounding box for the map area
        var top_left = new Position.Location({:latitude => 38.85695, :longitude =>-94.80051, :format => :degrees});
        var bottom_right = new Position.Location({:latitude => 38.85391, :longitude =>-94.7963, :format => :degrees});
        MapView.setMapVisibleArea(top_left, bottom_right);

        // set the bound box for the screen area to focus the map on
        MapView.setScreenVisibleArea(0, System.getDeviceSettings().screenHeight / 2, System.getDeviceSettings().screenWidth, System.getDeviceSettings().screenHeight);
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    public function onShow() as Void {
        // var fish = FishDb.getAll();
        // for (var i = 0; i < fish.size(); i++) {
        //     _logger.log("Fish:");
        //     _logger.log("    time: " + fish[i].time);
        //     _logger.log("    species: " + fish[i].species);
        //     _logger.log("    size: " + fish[i].size);
        //     _logger.log("    lat: " + fish[i].loc[0]);
        //     _logger.log("    lon: " + fish[i].loc[1]);
        // }
    }

    //! Update the view
    //! @param dc Device context
    public function onUpdate(dc as Dc) as Void {
        // call the parent onUpdate function to redraw the layout
        MapView.onUpdate(dc);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    }
}
