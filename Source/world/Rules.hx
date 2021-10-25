package world;

import world.tiles.TrackCurve;
import world.tiles.TrackLine;
import world.tiles.TrackCross;
import world.tiles.TileBackground;
import world.tiles.Tile;

class Rules {
    public var roomWidth(default, null):Int = 40;
    public var roomHeight(default, null):Int = 23;

    var tiles(default, null):Map<Int, Tile>;

    public function new() {
        tiles = new Map();

        tiles.set(0x04, new TileBackground(0x04));
        tiles.set(0xB3, new TileBackground(0xB3));
        tiles.set(0xBE, new TileBackground(0xBE));

        tiles.set(0x4C, new TrackCross(0x4C));
        
        tiles.set(0x06, new TrackLine(0x06));
        tiles.set(0x07, new TrackLine(0x07));

        tiles.set(0x10, new TrackCurve(0x10));
        tiles.set(0x11, new TrackCurve(0x11));

        tiles.set(0x12, new TrackCurve(0x12));
        tiles.set(0x13, new TrackCurve(0x13));
        tiles.set(0x14, new TrackCurve(0x14));
        tiles.set(0x15, new TrackCurve(0x15));
    }   

    public function getTile(id:Int):Tile {
        return tiles.get(id);
    }
}