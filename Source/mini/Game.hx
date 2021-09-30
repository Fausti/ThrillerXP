package mini;

import lime.ui.MouseButton;

class Game {
    public function new() {
        Debug.log("Game:new");
    }

	public function init(app:MiniApplication) {
        Debug.log("Game:init");
    }

	public function update(deltaTime:Int) {}

	public function render() {}

	public function onMouseDown(x:Int, y:Int, button:MouseButton) {}
	public function onMouseUp(x:Int, y:Int, button:MouseButton) {}
	public function onMouseMove(x:Int, y:Int) {}
}