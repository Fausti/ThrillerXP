package mini.gfx;

import lime.math.Rectangle;

class SpriteBatch {
    public var length(get, null):Int;

    private var buffer:Buffer;
    private var dataVertices:Array<Float> = [];
    private var dataIndices:Array<Int> = [];

    private var dirty:Bool = true;

    private var posVertices:Int = 0;
    private var posIndices:Int = 0;
    private var index:Int = 0;

    public function new() {
        buffer = new Buffer(true);
    }

    public function drawTexture(x:Float, y:Float, w:Float, h:Float, rect:Rectangle, ?color:Color = null) {
        if (color == null) color = new Color();

        pushVertex(x, y, rect.left, rect.top, color.r, color.g, color.b, color.a);
        pushVertex(x, y + h, rect.left, rect.bottom, color.r, color.g, color.b, color.a);
        pushVertex(x + w, y + h, rect.right, rect.bottom, color.r, color.g, color.b, color.a);
        pushVertex(x + w, y, rect.right, rect.top, color.r, color.g, color.b, color.a);

        pushIndices([0, 1, 2, 2, 3, 0]);
    }

    public function draw() {
        if (dirty) {
            buffer.setVertices(dataVertices);
            buffer.setIndices(dataIndices);

            dirty = false;
        }

        buffer.draw(length);
    }

    inline function pushVertex(x, y, u, v, r, g, b, a) {
        dataVertices[posVertices] = x;
        dataVertices[posVertices + 1] = y;

        dataVertices[posVertices + 2] = u;
        dataVertices[posVertices + 3] = v;

        dataVertices[posVertices + 4] = r;
        dataVertices[posVertices + 5] = g;
        dataVertices[posVertices + 6] = b;
        dataVertices[posVertices + 7] = a;

        posVertices = posVertices + 8;
    }

    inline function pushIndices(data:Array<Int>) {
        var num:Int = 0;

        for (i in 0 ... data.length) {
            dataIndices[posIndices] = data[i] + index;
            posIndices++;

            if ((data[i] + 1) > num) num = Std.int(data[i] + 1);
        }

        index = index + num;
    }

    public function clear() {
        posIndices = 0;
        posVertices = 0;
        index = 0;

        dirty = true;
    }

    inline function get_length():Int {
        return posIndices;
    }
}