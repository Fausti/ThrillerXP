package world.tiles;

import mini.gfx.Sprite;

class TileBackground extends Tile {
    public function new(type:Int) {
        super(type);

        switch (type) {
            case 0x04:
                spriteGround = new Sprite(Thriller.tileset, 4, 0, 1, 1);
            case 0xBE:
                spriteGround = new Sprite(Thriller.tileset, 3, 0, 1, 1);
            case 0xB3:
                spriteGround = new Sprite(Thriller.tileset, 0, 0, 1, 1);
        }
        
    }
}