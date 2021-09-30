package mini.gfx;

import lime.graphics.opengl.GLBuffer;

class Tilemap {
    private var buffer:Buffer;
    public var handle(get, null):GLBuffer;

    public function new() {
        buffer = new Buffer();
    }

    inline function get_handle():GLBuffer {
        return buffer.handle;
    }
}