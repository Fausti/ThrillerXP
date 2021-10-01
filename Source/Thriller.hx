import lime.ui.MouseButton;
import mini.gfx.Color;
import haxe.display.Display.DisplayModuleTypeParameter;
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

    var cursorX:Int = 0;
    var cursorY:Int = 0;

    var oldCursorX:Int = -1;
    var oldCursorY:Int = -1;

    var mouseDown:Bool = false;
    
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
        /*
        for (x in 0 ... 40) {
            for (y in 0 ... 23) {
                // tilemap.setTile(x, y, Std.random(10));
                tilemap.setColor(x, y, new Color(Math.random(), 0, 0));
            }
        }
        */

        if (cursorX != oldCursorX || cursorY != oldCursorY) {
            tilemap.setColor(oldCursorX, oldCursorY, new Color());
            tilemap.setColor(cursorX, cursorY, new Color(0, 1, 1));

            oldCursorX = cursorX;
            oldCursorY = cursorY;
        }
    }

    override function onMouseMove(x:Int, y:Int) {
        cursorX = Math.floor(x / 16);
        cursorY = Math.floor(y / 16);

        if (mouseDown) {
            if (tilemap.getTile(cursorX, cursorY) != 3) {
                tilemap.setTile(cursorX, cursorY, 3);
            }
        }
    }

    override function onMouseDown(x:Int, y:Int, button:MouseButton) {
        cursorX = Math.floor(x / 16);
        cursorY = Math.floor(y / 16);

        mouseDown = true;

        if (mouseDown) {
            if (tilemap.getTile(cursorX, cursorY) != 3) {
                tilemap.setTile(cursorX, cursorY, 3);
            }
        }
    }

    override function onMouseUp(x:Int, y:Int, button:MouseButton) {
        cursorX = Math.floor(x / 16);
        cursorY = Math.floor(y / 16);

        mouseDown = false;
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