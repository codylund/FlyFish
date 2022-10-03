import Toybox.Lang;
import Toybox.Time;

class DateFormatter {
    static function toString(moment as Time.Moment) as String {
        var info = Time.Gregorian.utcInfo(moment, Time.FORMAT_SHORT);
        return Lang.format(
            "$1$/$2$/$3$ $4$:$5$",
            [
                info.month,
                info.day,
                info.year,
                info.hour,
                info.min.format("%02d"),
            ]
        );
    }
}