class Logger {
    private var _name;

    function initialize(name as String) {
        _name = name;
    }

    function log(str) {
        System.println(_name + ": " + str);
    }
}