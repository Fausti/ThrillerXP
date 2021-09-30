package mini.gfx;

import lime.utils.Int16Array;
import lime.utils.Float32Array;
import lime.graphics.opengl.GLBuffer;

class Buffer {
    public var handle(default, null):GLBuffer;
    public var handleIndices(default, null):GLBuffer;
    
    private var data:Array<Dynamic>;
    private var dataIndices:Array<Int>;

    private var dirty:Bool = true;
    private var indexed:Bool;

    public function new(?indexed = false) {
        this.indexed = indexed;
        
        handle = Gfx.gl.createBuffer();
        if (indexed) {
            handleIndices = Gfx.gl.createBuffer();
            dataIndices = [];
        }

    }

    public function update() {
        if (dirty) {
            if (data != null) {
                Gfx.gl.bindBuffer(Gfx.gl.ARRAY_BUFFER, handle);
                Gfx.gl.bufferData(Gfx.gl.ARRAY_BUFFER, new Float32Array(data), Gfx.gl.STATIC_DRAW);
                Gfx.gl.bindBuffer(Gfx.gl.ARRAY_BUFFER, null);
            }

            if (indexed) {
                if (dataIndices != null) {
                    Gfx.gl.bindBuffer(Gfx.gl.ELEMENT_ARRAY_BUFFER, handleIndices);
                    Gfx.gl.bufferData(Gfx.gl.ELEMENT_ARRAY_BUFFER, new Int16Array(dataIndices), Gfx.gl.STATIC_DRAW);
                    Gfx.gl.bindBuffer(Gfx.gl.ELEMENT_ARRAY_BUFFER, null);
                }
            }

            dirty = false;
        }
    }

    public function setVertices(data) {
        this.data = data;
        dirty = true;
    }

    public function setIndices(data) {
        this.dataIndices = data;
        dirty = true;
    }

    public function draw() {
        update();

        Gfx.gl.bindBuffer(Gfx.gl.ARRAY_BUFFER, handle);
        if (indexed) Gfx.gl.bindBuffer(Gfx.gl.ELEMENT_ARRAY_BUFFER, handleIndices);
        
        Shader.current.setAttribute(Shader.current.a_Position, 2, Gfx.gl.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 0);
        Shader.current.setAttribute(Shader.current.a_TexCoord0, 2, Gfx.gl.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);
        Shader.current.setAttribute(Shader.current.a_Color, 4, Gfx.gl.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 4 * Float32Array.BYTES_PER_ELEMENT);

        if (!indexed) {
            Gfx.gl.drawArrays(Gfx.gl.TRIANGLE_STRIP, 0, 4);
        } else {
            Gfx.gl.drawElements(Gfx.gl.TRIANGLES, dataIndices.length, Gfx.gl.UNSIGNED_SHORT, 0);
        }

        Gfx.gl.bindBuffer(Gfx.gl.ARRAY_BUFFER, null);
        if (indexed) Gfx.gl.bindBuffer(Gfx.gl.ELEMENT_ARRAY_BUFFER, null);
    }
}