package screens;

import mini.Game;
import world.World;
import world.Rules;
import mini.ui.Screen;

class TestScreen extends Screen {
    public function new(game:Game) {
        super(game);

        Thriller.world = new World(
            new Rules()
        );
    }

    override function update(deltaTime:Int) {
        super.update(deltaTime);

        Thriller.world.update(deltaTime);

        var thriller:Thriller = cast game;

        if (thriller.mouseDown) {
            trace(thriller.cursorX, thriller.cursorY, StringTools.hex(Thriller.world.levelCurrent.getTileID(thriller.cursorX, thriller.cursorY), 2));
        }
    }

    override function render() {
        Thriller.tileset.use();

        Thriller.world.draw();
    }
}