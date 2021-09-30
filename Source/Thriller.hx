import mini.gfx.Tilemap;
import mini.gfx.Buffer;
import mini.gfx.Texture;
import lime.graphics.opengl.GLBuffer;
import lime.utils.Float32Array;
import mini.gfx.Shader;
import mini.MiniApplication;
import mini.Game;

class Thriller extends Game {
    public static inline var SCREEN_WIDTH:Int = 640;
    public static inline var SCREEN_HEIGHT:Int = 400;

    public static inline var HALF_WIDTH:Int = Math.floor(SCREEN_WIDTH / 2);
    public static inline var HALF_HEIGHT:Int = Math.floor(SCREEN_HEIGHT / 2);

    public static var tileset:Texture;

    var bufferOverlay:Buffer;
	var textureOverlay:Texture;

    var buffer:Buffer;
    var texture:Texture;

    var tilemap:Tilemap;
    
    override function init(app:MiniApplication) {
        Gfx.setScreenSize(SCREEN_WIDTH, SCREEN_HEIGHT);

        // Overlay

        var data:Array<Float> = [
            SCREEN_WIDTH * 2, 	SCREEN_HEIGHT * 2, 	    1, 1,   1, 1, 1, 1,
            0, 		            SCREEN_HEIGHT * 2, 	    0, 1,   1, 1, 1, 1,
            SCREEN_WIDTH * 2, 	0, 		                1, 0,   1, 1, 1, 1,
            0, 		            0, 		                0, 0,   1, 1, 1, 1,
        ];

        bufferOverlay = new Buffer();
        bufferOverlay.setVertices(data);

        textureOverlay = Texture.fromFile("assets/thriller_pd/background.png");

        // Intro Image
        
        /*
        data  = [
            SCREEN_WIDTH + HALF_WIDTH, 	SCREEN_HEIGHT + HALF_HEIGHT, 	1, 1,   1, 1, 1, 1,
            HALF_WIDTH, 		        SCREEN_HEIGHT + HALF_HEIGHT, 	0, 1,   1, 1, 1, 1,
            SCREEN_WIDTH + HALF_WIDTH, 	HALF_HEIGHT, 		            1, 0,   1, 1, 1, 1,
            HALF_WIDTH, 		        HALF_HEIGHT, 		            0, 0,   1, 1, 1, 1,
        ];
        */

        data  = [
            SCREEN_WIDTH, 	SCREEN_HEIGHT, 	1, 1,   1, 1, 1, 1,
            0, 		        SCREEN_HEIGHT, 	0, 1,   1, 1, 1, 1,
            SCREEN_WIDTH, 	0,	            1, 0,   1, 1, 1, 1,
            0, 		        0,	            0, 0,   1, 1, 1, 1,
        ];

        buffer = new Buffer();
        buffer.setVertices(data);

        texture = Texture.fromFile("assets/thriller_pd/intro.png");

        // Tileset

        Thriller.tileset = Texture.fromFile("assets/thriller_pd/tileset.png");

        // Tilemap

        tilemap = new Tilemap(40, 23);
        Debug.log(tilemap.getTile(0, 0));

        super.init(app);
    }

    override function update(deltaTime:Int) {
        for (x in 0 ... 40) {
            for (y in 0 ... 23) {
                tilemap.setTile(x, y, Std.random(10));
            }
        }
    }

    override function render() {
        // aktiven Bildschirm zeichnen
        Gfx.gl.uniformMatrix4fv(Shader.current.u_camMatrix, false, Gfx.screenMatrix);
        texture.use();
        buffer.draw();

        Thriller.tileset.use();
        tilemap.draw();

        // Overlay zeichnen
        Gfx.gl.uniformMatrix4fv(Shader.current.u_camMatrix, false, Gfx.overlayMatrix);
        textureOverlay.use();
        bufferOverlay.draw();
    }
}