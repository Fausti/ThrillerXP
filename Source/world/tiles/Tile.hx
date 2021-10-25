package world.tiles;

import mini.gfx.Sprite;

class Tile {
    var type:Int = 0;

    var spriteGround:Sprite;
    var spriteTrack:Sprite;
    var spriteCeiling:Sprite;

    public function new(type:Int) {
        this.type = type;
    }

    public function getGround(level:Level, x:Int, y:Int):Sprite {
        return spriteGround;
    }

    public function getTrack(level:Level, x:Int, y:Int):Sprite {
        return spriteTrack;
    }

    public function getCeiling(level:Level, x:Int, y:Int):Sprite {
        return spriteCeiling;
    }
}