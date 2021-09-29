package mini;

import mini.gfx.Shader;
import lime.math.Matrix4;
import lime.graphics.WebGLRenderContext;

class Gfx {
    public static var gl:WebGLRenderContext;

    public static var shaderDefault:Shader;

    public static var screenWidth:Int = 0;
    public static var screenHeight:Int = 0;
    public static var screenZoom:Int = 1;

    public static var screenMatrix:Matrix4 = new Matrix4();
    public static var projMatrix:Matrix4 = new Matrix4();

    public static function init() {
        Debug.log("gfx:init");
        Gfx.shaderDefault = Shader.createDefaultShader();
    }

    public static function setScreenSize(w:Int, h:Int) {
        Gfx.screenWidth = w;
        Gfx.screenHeight = h;

        screenMatrix.createOrtho(0, w * 2, 
            0, h * 2, 
            -1000, 1000);
    }

    public static function setShader(shader:Shader) {
        Shader.current = shader;
        Shader.current.use();
    }
}