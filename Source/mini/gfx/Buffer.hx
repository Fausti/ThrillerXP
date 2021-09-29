package mini.gfx;

import lime.utils.Float32Array;
import lime.graphics.opengl.GLBuffer;

class Buffer {
    public var handle(default, null):GLBuffer;
    
    private var data:Array<Dynamic>;
    private var dirty:Bool = true;

    public function new() {
        handle = Gfx.gl.createBuffer();
    }

    public function update() {
        if (dirty) {
            if (data != null) {
                Gfx.gl.bindBuffer(Gfx.gl.ARRAY_BUFFER, handle);
                Gfx.gl.bufferData(Gfx.gl.ARRAY_BUFFER, new Float32Array(data), Gfx.gl.STATIC_DRAW);
                Gfx.gl.bindBuffer(Gfx.gl.ARRAY_BUFFER, null);
            }

            dirty = false;
        }
    }

    public function setData(data) {
        this.data = data;
        dirty = true;
    }

    public function draw() {
        update();

        Gfx.gl.bindBuffer(Gfx.gl.ARRAY_BUFFER, handle);
        
        Shader.current.setAttribute(Shader.current.a_Position, 2, Gfx.gl.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 0);
        Shader.current.setAttribute(Shader.current.a_TexCoord0, 2, Gfx.gl.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);
        Shader.current.setAttribute(Shader.current.a_Color, 4, Gfx.gl.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 4 * Float32Array.BYTES_PER_ELEMENT);

        Gfx.gl.drawArrays(Gfx.gl.TRIANGLE_STRIP, 0, 4);
    }
}