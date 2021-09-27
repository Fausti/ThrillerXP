package mini;

class Game {
    public function new() {
        Debug.log("Game:new");
    }

	public function init(app:MiniApplication) {
        Debug.log("Game:init");
    }

	public function update(deltaTime:Int) {}

	public function render() {}
}