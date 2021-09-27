package mini;

class Debug {
    public static function log(...args:Dynamic) {
        #if debug
        var text:StringBuf = new StringBuf();
        text.add("Log: ");

        if (args != null) {
            for (arg in args) {
                if (arg == null) {
                    text.add("null ");
                } else {
                    text.add(arg.toString());
                    text.add(" ");
                }
            }
        } else {
            text.add("null");
        }
        
        trace(text);
        #end
    }
}