import world.Rules;
import world.World;
import screens.TestScreen;
import mini.gfx.SpriteBatch;
import mini.gfx.Tileset;
import lime.ui.MouseButton;
import mini.gfx.Tilemap;
import mini.gfx.Buffer;
import mini.gfx.Texture;
import mini.gfx.Shader;
import mini.MiniApplication;
import mini.Game;

class Thriller extends Game {
    public static inline var SCREEN_WIDTH:Int = 640;
    public static inline var SCREEN_HEIGHT:Int = 400;

    public static inline var HALF_WIDTH:Int = Math.floor(SCREEN_WIDTH / 2);
    public static inline var HALF_HEIGHT:Int = Math.floor(SCREEN_HEIGHT / 2);

    var bufferOverlay:Buffer;
	var textureOverlay:Texture;

    public var cursorX:Int = 0;
    public var cursorY:Int = 0;

    var oldCursorX:Int = -1;
    var oldCursorY:Int = -1;

    public var mouseDown:Bool = false;

    public static var tileset:Tileset;

    public static var world:World;
    
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

        super.init(app);

        Thriller.tileset = new Tileset("assets/thriller_pd/tileset.png", 32, 32);

        Canvas.setup();

        setScreen(new TestScreen(this));
    }

    override function update(deltaTime:Int) {
        if (screen != null) {
            screen.update(deltaTime);
        }
    }

    override function onMouseMove(x:Int, y:Int) {
        cursorX = Math.floor(x / 16);
        cursorY = Math.floor(y / 16);
    }

    override function onMouseDown(x:Int, y:Int, button:MouseButton) {
        cursorX = Math.floor(x / 16);
        cursorY = Math.floor(y / 16);

        mouseDown = true;
    }

    override function onMouseUp(x:Int, y:Int, button:MouseButton) {
        cursorX = Math.floor(x / 16);
        cursorY = Math.floor(y / 16);

        mouseDown = false;
    }

    override function render() {
        // aktiven Bildschirm zeichnen
        Gfx.gl.uniformMatrix4fv(Shader.current.u_camMatrix, false, Gfx.screenMatrix);

        if (screen != null) {
            screen.render();
        }

        // Overlay zeichnen
        Gfx.gl.uniformMatrix4fv(Shader.current.u_camMatrix, false, Gfx.overlayMatrix);
        textureOverlay.use();
        bufferOverlay.draw();
    }
}