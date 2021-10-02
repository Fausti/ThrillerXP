package mini.gfx;

import lime.math.Rectangle;

class Sprite extends Rectangle {
    var tileset:Tileset;
    var pixelX:Int;
    var pixelY:Int;
    var pixelWidth:Int;
    var pixelHeight:Int;

    public var color(default, null):Color = new Color();

    public function new(tileset:Tileset, x:Int, y:Int, ?w:Int = 1, ?h:Int = 1) {
        this.tileset = tileset;

        this.pixelX = x * 16;
        this.pixelY = y * 16;
        this.pixelWidth = w * 16;
        this.pixelHeight = h * 16;

        super(pixelX / tileset.width , pixelY / tileset.height, pixelWidth / tileset.width, pixelHeight / tileset.height);
    }
}