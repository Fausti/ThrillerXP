import mini.gfx.Tilemap;
import mini.gfx.SpriteBatch;

class Canvas {
    public static var sprites:SpriteBatch;

    public static var ground:Tilemap;
    public static var tracks:Tilemap;
    public static var ceiling:Tilemap;

    public static function setup() {
        ground = new Tilemap(40, 23);
        tracks = new Tilemap(40, 23);
        ceiling = new Tilemap(40, 23);

        sprites = new SpriteBatch();
    }
}