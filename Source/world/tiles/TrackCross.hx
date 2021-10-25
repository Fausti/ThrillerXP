package world.tiles;

class TrackCross extends Tile {
    public function new(type:Int) {
        super(type);

        spriteGround= new Sprite(Thriller.tileset, 12, 12, 1, 1);
    }
}