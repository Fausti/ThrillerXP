package mini.gfx;

typedef TileData = {
    tileIndex:Int,
    userData:Dynamic,
};

class Tilemap {
    public var width(default, null):Int;
    public var height(default, null):Int;

    private var buffer:Buffer;
    private var dataVertices:Array<Float> = [];
    private var dataIndices:Array<Int> = [];

    private var dirty:Bool = true;

    private var map:Array<Array<TileData>>;

    public function new(w:Int, h:Int) {
        this.width = w;
        this.height = h;

        buffer = new Buffer(true);

        var len:Int = 0;

        var x0:Float, y0:Float, x1:Float, y1:Float;
        var u0:Float, v0:Float, u1:Float, v1:Float;

        var tileX:Int = 4;
        var tileY:Int = 0;

        var pixelSize:Float = 16 / 512;

        u0 = tileX * pixelSize;
        v0 = tileY * pixelSize;
        u1 = (tileX + 1) * pixelSize;
        v1 = (tileY + 1) * pixelSize;

        map = [];

        for (x in 0 ... w) {
            map.push([]);

            x0 = x * 16;
            x1 = (x + 1) * 16;

            for (y in 0 ... h) {
                map[x].push({tileIndex: 0, userData: {}});

                y0 = y * 16;
                y1 = (y + 1) * 16;

                addVertex(x0, y0,     u0, v0,       1, 1, 1, 1);
                addVertex(x0, y1,     u0, v1,       1, 1, 1, 1);
                addVertex(x1, y1,     u1, v1,       1, 1, 1, 1);
                addVertex(x1, y0,     u1, v0,       1, 1, 1, 1);

                dataIndices.push(len + 0);
                dataIndices.push(len + 1);
                dataIndices.push(len + 2);

                dataIndices.push(len + 2);
                dataIndices.push(len + 3);
                dataIndices.push(len + 0);

                len = len + 4;
            }
        }

        // buffer.setVertices(dataVertices);
        // buffer.setIndices(dataIndices);
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

    public function draw() {
        if (dirty) {
            buffer.setVertices(dataVertices);
            buffer.setIndices(dataIndices);

            dirty = false;
        }

        buffer.draw();
    }

    public function getTileData(x:Int, y:Int):TileData {
        return map[x][y];
    }

    public function getTile(x:Int, y:Int):Int {
        return map[x][y].tileIndex;
    }

    public function setTile(x:Int, y:Int, tileIndex:Int) {
        map[x][y].tileIndex = tileIndex;
        
        var x0:Float, y0:Float, x1:Float, y1:Float;
        var u0:Float, v0:Float, u1:Float, v1:Float;

        var tileX:Int = tileIndex;
        var tileY:Int = 0;

        var pixelSize:Float = 16 / 512;

        u0 = tileX * pixelSize;
        v0 = tileY * pixelSize;
        u1 = (tileX + 1) * pixelSize;
        v1 = (tileY + 1) * pixelSize;

        var dataIndex:Int = (y * width + x) * 8 * 4;
        dataVertices[dataIndex + 2] = u0;
        dataVertices[dataIndex + 3] = v0;

        dataIndex = dataIndex + 8;

        dataVertices[dataIndex + 2] = u0;
        dataVertices[dataIndex + 3] = v1;

        dataIndex = dataIndex + 8;

        dataVertices[dataIndex + 2] = u1;
        dataVertices[dataIndex + 3] = v1;

        dataIndex = dataIndex + 8;

        dataVertices[dataIndex + 2] = u1;
        dataVertices[dataIndex + 3] = v0;

        // addVertex(x0, y0,     u0, v0,       1, 1, 1, 1);
        // addVertex(x0, y1,     u0, v1,       1, 1, 1, 1);
        // addVertex(x1, y1,     u1, v1,       1, 1, 1, 1);
        // addVertex(x1, y0,     u1, v0,       1, 1, 1, 1);

        dirty = true;
    }
}