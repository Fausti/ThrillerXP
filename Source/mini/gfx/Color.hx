package mini.gfx;

class Color {
    public var r:Float;
    public var g:Float;
    public var b:Float;
    public var a:Float;

    public function new(?r:Float = 1, ?g:Float = 1, ?b:Float = 1, ?a:Float = 1) {
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
    }

    public function set(c:Color) {
        this.r = c.r;
        this.g = c.g;
        this.b = c.b;
        this.a = c.a;
    }
}