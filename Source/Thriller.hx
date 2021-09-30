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

    var bufferTilemap:Buffer;
    
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

        bufferTilemap = new Buffer(true);

        data = [];
        var len:Int = 0;
        var dataIndices = [];

        var x0:Float, y0:Float, x1:Float, y1:Float;
        var u0:Float, v0:Float, u1:Float, v1:Float;

        var tileX:Int = 4;
        var tileY:Int = 0;

        var pixelSize:Float = 16 / 512;

        u0 = tileX * pixelSize;
        v0 = tileY * pixelSize;
        u1 = (tileX + 1) * pixelSize;
        v1 = (tileY + 1) * pixelSize;

        for (x in 0 ... 40) {
            x0 = x * 16;
            x1 = (x + 1) * 16;

            for (y in 0 ... 23) {
                y0 = y * 16;
                y1 = (y + 1) * 16;

                addVertex(data, x0, y0,     u0, v0,       1, 1, 1, 1);
                addVertex(data, x0, y1,     u0, v1,       1, 1, 1, 1);
                addVertex(data, x1, y1,     u1, v1,       1, 1, 1, 1);
                addVertex(data, x1, y0,     u1, v0,       1, 1, 1, 1);

                dataIndices.push(len + 0);
                dataIndices.push(len + 1);
                dataIndices.push(len + 2);

                dataIndices.push(len + 2);
                dataIndices.push(len + 3);
                dataIndices.push(len + 0);

                len = len + 4;
            }
        }

        bufferTilemap.setVertices(data);
        bufferTilemap.setIndices(dataIndices);

        super.init(app);
    }

    inline function addVertex(data:Array<Float>, x, y, u, v, r, g, b, a) {
        data.push(x);
        data.push(y);

        data.push(u);
        data.push(v);

        data.push(r);
        data.push(g);
        data.push(b);
        data.push(a);
    }

    override function render() {
        // aktiven Bildschirm zeichnen
        Gfx.gl.uniformMatrix4fv(Shader.current.u_camMatrix, false, Gfx.screenMatrix);
        texture.use();
        buffer.draw();

        Thriller.tileset.use();
        bufferTilemap.draw();

        // Overlay zeichnen
        Gfx.gl.uniformMatrix4fv(Shader.current.u_camMatrix, false, Gfx.overlayMatrix);
        textureOverlay.use();
        bufferOverlay.draw();
    }
}