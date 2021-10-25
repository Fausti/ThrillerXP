package mini.gfx;

import mini.gfx.Sprite;
import lime.math.Rectangle;

typedef TileData = {
    sprite:Sprite,
    color:Color,
};

class Tilemap {
    public var width(default, null):Int;
    public var height(default, null):Int;

    private var buffer:Buffer;
    private var dataVertices:Array<Float> = [];
    private var dataIndices:Array<Int> = [];

    private var dirty:Bool = true;

    private var map:Array<Array<TileData>>;

    public var color(default, null):Color;

    public function new(w:Int, h:Int) {
        buffer = new Buffer(true);
        color = new Color();

        resize(w, h);
    }

    public function resize(w:Int, h:Int) {
        this.width = w;
        this.height = h;

        var len:Int = 0;

        var x0:Float, y0:Float, x1:Float, y1:Float;

        map = [];

        for (x in 0 ... w) {
            map.push([]);

            x0 = x * 16;
            x1 = (x + 1) * 16;

            for (y in 0 ... h) {
                map[x].push({sprite: null, color: new Color(1, 1, 1, 1)});

                y0 = y * 16;
                y1 = (y + 1) * 16;

                addVertex(x0, y0,     0, 0,       0, 0, 0, 0);
                addVertex(x0, y1,     0, 0,       0, 0, 0, 0);
                addVertex(x1, y1,     0, 0,       0, 0, 0, 0);
                addVertex(x1, y0,     0, 0,       0, 0, 0, 0);

                dataIndices.push(len + 0);
                dataIndices.push(len + 1);
                dataIndices.push(len + 2);

                dataIndices.push(len + 2);
                dataIndices.push(len + 3);
                dataIndices.push(len + 0);

                len = len + 4;
            }
        }
    }

    inline function addVertex(x, y, u, v, r, g, b, a) {
        dataVertices.push(x);
        dataVertices.push(y);

        dataVertices.push(u);
        dataVertices.push(v);

        dataVertices.push(r);
        dataVertices.push(g);
        dataVertices.push(b);
        dataVertices.push(a);
    }

    inline function getDataIndex(x:Int, y:Int):Int {
        return (x * height + y) * 8 * 4;
    }

    public function draw() {
        if (dirty) {
            buffer.setVertices(dataVertices);
            buffer.setIndices(dataIndices);

            dirty = false;
        }

        buffer.draw();
    }

    public function insideMap(x:Int, y:Int):Bool {
        if (x < 0 || y < 0 || x >= width || y >= height) return false;
        return true;
    }

    public function getTileData(x:Int, y:Int):TileData {
        return map[x][y];
    }

    public function getTile(x:Int, y:Int):Rectangle {
        if (!insideMap(x, y)) return null;

        return map[x][y].sprite;
    }

    public function setTile(x:Int, y:Int, sprite:Sprite) {
        if (!insideMap(x, y)) return;

        map[x][y].sprite = sprite;

        var dataIndex:Int = getDataIndex(x, y);

        dataVertices[dataIndex + 2] = sprite.left;
        dataVertices[dataIndex + 3] = sprite.top;
        
        dataVertices[dataIndex + 4] = sprite.color.r;
        dataVertices[dataIndex + 5] = sprite.color.g;
        dataVertices[dataIndex + 6] = sprite.color.b;
        dataVertices[dataIndex + 7] = sprite.color.a;

        dataIndex = dataIndex + 8;

        dataVertices[dataIndex + 2] = sprite.left;
        dataVertices[dataIndex + 3] = sprite.bottom;

        dataVertices[dataIndex + 4] = sprite.color.r;
        dataVertices[dataIndex + 5] = sprite.color.g;
        dataVertices[dataIndex + 6] = sprite.color.b;
        dataVertices[dataIndex + 7] = sprite.color.a;

        dataIndex = dataIndex + 8;

        dataVertices[dataIndex + 2] = sprite.right;
        dataVertices[dataIndex + 3] = sprite.bottom;

        dataVertices[dataIndex + 4] = sprite.color.r;
        dataVertices[dataIndex + 5] = sprite.color.g;
        dataVertices[dataIndex + 6] = sprite.color.b;
        dataVertices[dataIndex + 7] = sprite.color.a;

        dataIndex = dataIndex + 8;

        dataVertices[dataIndex + 2] = sprite.right;
        dataVertices[dataIndex + 3] = sprite.top;

        dataVertices[dataIndex + 4] = sprite.color.r;
        dataVertices[dataIndex + 5] = sprite.color.g;
        dataVertices[dataIndex + 6] = sprite.color.b;
        dataVertices[dataIndex + 7] = sprite.color.a;

        dirty = true;
    }

    public function setColor(x:Int, y:Int, c:Color) {
        if (!insideMap(x, y)) return;

        map[x][y].color.set(c);

        var dataIndex:Int = getDataIndex(x, y);

        dataVertices[dataIndex + 4] = c.r;
        dataVertices[dataIndex + 5] = c.g;
        dataVertices[dataIndex + 6] = c.b;
        dataVertices[dataIndex + 7] = c.a;

        dataIndex = dataIndex + 8;

        dataVertices[dataIndex + 4] = c.r;
        dataVertices[dataIndex + 5] = c.g;
        dataVertices[dataIndex + 6] = c.b;
        dataVertices[dataIndex + 7] = c.a;

        dataIndex = dataIndex + 8;

        dataVertices[dataIndex + 4] = c.r;
        dataVertices[dataIndex + 5] = c.g;
        dataVertices[dataIndex + 6] = c.b;
        dataVertices[dataIndex + 7] = c.a;

        dataIndex = dataIndex + 8;

        dataVertices[dataIndex + 4] = c.r;
        dataVertices[dataIndex + 5] = c.g;
        dataVertices[dataIndex + 6] = c.b;
        dataVertices[dataIndex + 7] = c.a;

        dirty = true;
    }
}