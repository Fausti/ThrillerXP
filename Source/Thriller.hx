import mini.gfx.Buffer;
import mini.gfx.Texture;
import lime.graphics.opengl.GLBuffer;
import lime.utils.Float32Array;
import mini.gfx.Shader;
import mini.MiniApplication;
import mini.Game;

class Thriller extends Game {
    var buffer:Buffer;
    var texture:Texture;
    
    override function init(app:MiniApplication) {
        Gfx.setScreenSize(640, 400);

        var data:Array<Float> = [
            640 + 320, 	400 + 200, 	1, 1,   1, 1, 1, 1,
            320, 		400 + 200, 	0, 1,   1, 1, 1, 1,
            640 + 320, 	200, 		1, 0,   1, 1, 1, 1,
            320, 		200, 		0, 0,   1, 1, 1, 1,
        ];

        buffer = new Buffer();
        buffer.setData(data);

        texture = Texture.fromFile("assets/thriller_pd/intro.png");

        super.init(app);
    }

    override function render() {
        texture.use();
        buffer.draw();
    }
}