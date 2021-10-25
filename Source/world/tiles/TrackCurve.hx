package world.tiles;

class TrackCurve extends Tile {
    var style:Int;

    public function new(type:Int) {
        super(type);

        switch (type) {
            // Style 2
            // Style 3
            case 0x10:
                spriteGround = new Sprite(Thriller.tileset, 5, 12, 1, 1);
            case 0x11:
                spriteGround = new Sprite(Thriller.tileset, 7, 12, 1, 1);

            // Style 3
            case 0x12:
                spriteGround = new Sprite(Thriller.tileset, 10, 12, 1, 1);
            case 0x13:
                spriteGround = new Sprite(Thriller.tileset, 9, 12, 1, 1);
            case 0x14:
                spriteGround = new Sprite(Thriller.tileset, 11, 12, 1, 1);
            case 0x15:
                spriteGround = new Sprite(Thriller.tileset, 8, 12, 1, 1);
        }
    }
}