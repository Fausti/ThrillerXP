package world;

import world.tiles.Tile;
import mini.gfx.Sprite;
import mini.gfx.SpriteBatch;
import mini.gfx.Tilemap;

class World {
    public var rules(default, null):Rules;

    public var levels:Array<Level>;
    public var levelCurrent:Level;

    public function new(rules:Rules) {
        this.rules = rules;

        Canvas.ground.resize(rules.roomWidth, rules.roomHeight);
        Canvas.ceiling.resize(rules.roomWidth, rules.roomHeight);

        levels = [new Level(this, rules.roomWidth, rules.roomHeight)];
        levelCurrent = levels[0];
    }

	public function draw() {
        if (levelCurrent.dirty) {
            levelCurrent.draw();
        }

        Canvas.ground.draw();
        Canvas.sprites.draw();
        Canvas.ceiling.draw();
    }

	public function update(deltaTime:Int) {

    }
}