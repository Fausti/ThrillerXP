package mini.gfx;

import lime.utils.UInt8Array;
import lime.utils.Assets;
import lime.graphics.Image;
import lime.graphics.opengl.GLTexture;

class Texture {
    public var width(default, null):Int = 0;
    public var height(default, null):Int = 0;
    
    public var handle(default, null):GLTexture;
    
    public function new() {
        handle = Gfx.gl.createTexture();
    }

    public function upload(width:Int, height:Int, data:UInt8Array) {
        this.width = width;
        this.height = height;
        
        Gfx.gl.bindTexture(Gfx.gl.TEXTURE_2D, handle);
        Gfx.gl.texParameteri(Gfx.gl.TEXTURE_2D, Gfx.gl.TEXTURE_WRAP_S, Gfx.gl.CLAMP_TO_EDGE);
        Gfx.gl.texParameteri(Gfx.gl.TEXTURE_2D, Gfx.gl.TEXTURE_WRAP_T, Gfx.gl.CLAMP_TO_EDGE);

        #if js
            Gfx.gl.texImage2D(Gfx.gl.TEXTURE_2D, 0, Gfx.gl.RGBA, Gfx.gl.RGBA, Gfx.gl.UNSIGNED_BYTE, image.src);
        #else
            Gfx.gl.texImage2D(Gfx.gl.TEXTURE_2D, 0, Gfx.gl.RGBA, width, height, 0, Gfx.gl.RGBA, Gfx.gl.UNSIGNED_BYTE, data);
        #end

        Gfx.gl.texParameteri(Gfx.gl.TEXTURE_2D, Gfx.gl.TEXTURE_MAG_FILTER, Gfx.gl.NEAREST);
        Gfx.gl.texParameteri(Gfx.gl.TEXTURE_2D, Gfx.gl.TEXTURE_MIN_FILTER, Gfx.gl.NEAREST);

        Gfx.gl.bindTexture(Gfx.gl.TEXTURE_2D, null);
    }

    public function use() {
        Gfx.gl.bindTexture(Gfx.gl.TEXTURE_2D, handle);
    }

    public static function fromArray(width:Int, height:Int, data:UInt8Array) {
        var out:Texture = new Texture();

        out.upload(width, height, data);

        return out;
    }

    public static function fromImage(image:Image):Texture {
        var out:Texture = new Texture();

        out.upload(image.buffer.width, image.buffer.height, image.data);

        return out;
    }

    public static function fromFile(fileName:String):Texture {
        return fromImage(Assets.getImage(fileName));
    }
}