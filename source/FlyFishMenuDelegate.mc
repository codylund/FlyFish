import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class FlyFishMenuDelegate extends WatchUi.Menu2InputDelegate {

    private static const _logger = new Logger("FlyFishMenuDelegate");

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        _logger.log("Clicked main menu item with label \"" + item.getLabel() + "\"");
        if (item.getId() == :menu_add_fish) {
            WatchUi.switchToView(new AddFishView(new AddFishViewModel()), new AddFishDelegate(), WatchUi.SLIDE_UP);
        } else if (item.getId() == :menu_edit_fish) {
            var vm = new EditFishViewModel();
            WatchUi.switchToView(new EditFishView(vm), new EditFishDelegate(vm), WatchUi.SLIDE_UP);
        }
    }
}