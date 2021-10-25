package world.tiles;

class TrackLine extends Tile {
    public function new(type:Int) {
        super(type);

        switch (type) {
            case 0x06:
                spriteGround = new Sprite(Thriller.tileset, 0, 12, 1, 1);
            case 0x07:
                spriteGround = new Sprite(Thriller.tileset, 1, 12, 1, 1);
        }
        
    }
}