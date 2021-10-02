package mini.gfx;

import lime.math.Rectangle;

class Tileset {
    public var width(default, null):Int;
    public var height(default, null):Int;
    public var pixelSizeX:Int;
    public var pixelSizeY:Int;

    private var texture:Texture;

    public function new(fileName:String, tilesWidth:Int, tilesHeight:Int) {

        this.texture = Texture.fromFile(fileName);
        this.width = this.texture.width;
        this.height = this.texture.height;

        this.pixelSizeX = Math.floor(this.texture.width / tilesWidth);
        this.pixelSizeY = Math.floor(this.texture.height / tilesHeight);
    }

    public function use() {
        this.texture.use();
    }
}