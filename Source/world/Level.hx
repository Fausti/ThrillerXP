package world;

import world.tiles.Tile;
import lime.utils.Assets;
import mini.gfx.Sprite;

class Level {
    public var world(default, null):World;

    public var width(default, null):Int;
    public var height(default, null):Int;

    var tilesGround:Array<Int>;

    public var dirty(default, null):Bool = true;

    public function new(world:World, width:Int, height:Int) {
        this.world = world;

        this.width = width;
        this.height = height;

        tilesGround = [];
        for (i in 0 ... width * height) {
            tilesGround.push(0);
        }

        importLevel("assets/thriller_pd/maps/LVL_PD05.DAT");

        // world.tilemapGround.setTile(0, 0, new Sprite(Thriller.tileset, 0, 0, 1, 1));

        
    }

    public function importLevel(fileName:String) {
        var fileLevel = Assets.getBytes(fileName);

        for (index in 0 ... fileLevel.length) {
            tilesGround[index] = fileLevel.get(index);
        }
    }

    public function draw() {
        var index:Int = 0;

        for (x in 0 ... width) {
            for (y in 0 ... height) {
                var tileID:Int = tilesGround[index];
                drawTile(x, y, tileID);
                index++;
            }
        }

        dirty = false;
    }

    public function drawTile(x:Int, y:Int, tileID:Int) {
        var tile:Tile = world.rules.getTile(tileID);

        if (tile != null) {
            var spriteGround:Sprite = tile.getGround(this, x, y);
            var spriteCeiling:Sprite = tile.getCeiling(this, x, y);

            if (spriteGround != null) {
                Canvas.ground.setTile(x, y, spriteGround);
            }

            if (spriteCeiling != null) {
                Canvas.ceiling.setTile(x, y, spriteCeiling);
            }
        } else {
            // trace(StringTools.hex(tileID, 2));
        }
    }

	public function getTileID(x:Int, y:Int):Int {
		return tilesGround[x * height + y];
	}
}