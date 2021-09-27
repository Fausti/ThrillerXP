package mini;

import lime.graphics.RenderContext;
import mini.gfx.Shader;
import lime.utils.Float32Array;
import lime.graphics.opengl.GLTexture;
import lime.graphics.opengl.GLBuffer;
import lime.utils.Assets;
import lime.app.Application;

class MiniApplication extends Application {
    var game:Game;

    var glBuffer:GLBuffer;
	var glTexture:GLTexture;

    var glBufferBG:GLBuffer;
	var glTextureBG:GLTexture;

    public function new() {
        super();
    }

    private function _init() {
        Debug.log("App:init");
        Gfx.init();

        // Background
        var image = Assets.getImage("assets/thriller_pd/background.png");

        var data = [
            640 + 320, 	400 + 200, 	1, 1,   1, 1, 1, 1,
            -320, 		400 + 200, 	0, 1,   1, 1, 1, 1,
            640 + 320, 	-200, 		1, 0,   1, 1, 1, 1,
            -320, 		-200, 		0, 0,   1, 1, 1, 1,
        ];

        glBufferBG = Gfx.gl.createBuffer();
        Gfx.gl.bindBuffer(Gfx.gl.ARRAY_BUFFER, glBufferBG);
        Gfx.gl.bufferData(Gfx.gl.ARRAY_BUFFER, new Float32Array(data), Gfx.gl.STATIC_DRAW);
        Gfx.gl.bindBuffer(Gfx.gl.ARRAY_BUFFER, null);

        glTextureBG = Gfx.gl.createTexture();
        Gfx.gl.bindTexture(Gfx.gl.TEXTURE_2D, glTextureBG);
        Gfx.gl.texParameteri(Gfx.gl.TEXTURE_2D, Gfx.gl.TEXTURE_WRAP_S, Gfx.gl.CLAMP_TO_EDGE);
        Gfx.gl.texParameteri(Gfx.gl.TEXTURE_2D, Gfx.gl.TEXTURE_WRAP_T, Gfx.gl.CLAMP_TO_EDGE);

        #if js
            Gfx.gl.texImage2D(Gfx.gl.TEXTURE_2D, 0, Gfx.gl.RGBA, Gfx.gl.RGBA, Gfx.gl.UNSIGNED_BYTE, image.src);
        #else
            Gfx.Gfx.gl.texImage2D(Gfx.gl.TEXTURE_2D, 0, Gfx.gl.RGBA, image.buffer.width, image.buffer.height, 0, Gfx.gl.RGBA, Gfx.gl.UNSIGNED_BYTE, image.data);
        #end

        Gfx.gl.texParameteri(Gfx.gl.TEXTURE_2D, Gfx.gl.TEXTURE_MAG_FILTER, Gfx.gl.NEAREST);
        Gfx.gl.texParameteri(Gfx.gl.TEXTURE_2D, Gfx.gl.TEXTURE_MIN_FILTER, Gfx.gl.NEAREST);

        Gfx.gl.bindTexture(Gfx.gl.TEXTURE_2D, null);

        // Intro

        image = Assets.getImage("assets/thriller_pd/intro.png");

        data = [
            640, 	400, 	1, 1,   1, 1, 1, 1,
            0, 		400, 	0, 1,   1, 1, 1, 1,
            640, 	0, 		1, 0,   1, 1, 1, 1,
            0, 		0, 		0, 0,   1, 1, 1, 1,
        ];

        glBuffer = Gfx.gl.createBuffer();
        Gfx.gl.bindBuffer(Gfx.gl.ARRAY_BUFFER, glBuffer);
        Gfx.gl.bufferData(Gfx.gl.ARRAY_BUFFER, new Float32Array(data), Gfx.gl.STATIC_DRAW);
        Gfx.gl.bindBuffer(Gfx.gl.ARRAY_BUFFER, null);

        glTexture = Gfx.gl.createTexture();
        Gfx.gl.bindTexture(Gfx.gl.TEXTURE_2D, glTexture);
        Gfx.gl.texParameteri(Gfx.gl.TEXTURE_2D, Gfx.gl.TEXTURE_WRAP_S, Gfx.gl.CLAMP_TO_EDGE);
        Gfx.gl.texParameteri(Gfx.gl.TEXTURE_2D, Gfx.gl.TEXTURE_WRAP_T, Gfx.gl.CLAMP_TO_EDGE);

        #if js
            Gfx.gl.texImage2D(Gfx.gl.TEXTURE_2D, 0, Gfx.gl.RGBA, Gfx.gl.RGBA, Gfx.gl.UNSIGNED_BYTE, image.src);
        #else
            Gfx.Gfx.gl.texImage2D(Gfx.gl.TEXTURE_2D, 0, Gfx.gl.RGBA, image.buffer.width, image.buffer.height, 0, Gfx.gl.RGBA, Gfx.gl.UNSIGNED_BYTE, image.data);
        #end

        Gfx.gl.texParameteri(Gfx.gl.TEXTURE_2D, Gfx.gl.TEXTURE_MAG_FILTER, Gfx.gl.NEAREST);
        Gfx.gl.texParameteri(Gfx.gl.TEXTURE_2D, Gfx.gl.TEXTURE_MIN_FILTER, Gfx.gl.NEAREST);

        Gfx.gl.bindTexture(Gfx.gl.TEXTURE_2D, null);
    }

    public function init() {

    }

    function startGame(game:Game) {
        this.game = game;
    }

    override function onWindowCreate() {
        Debug.log("onWindowCreate");

        super.onWindowCreate();

        switch (window.context.type) {
            case OPENGL, OPENGLES, WEBGL:
                    Gfx.gl = window.context.webgl;
            default:
        }
    }
    override function onPreloadComplete() {
        Debug.log("onPreloadComplete");

        super.onPreloadComplete();

        _init();

        if (game != null) {
            game.init(this);

            updateProjectionMatrix();
        }
    }

    override function update(deltaTime:Int) {
        if (isAppReady()) {
            this.game.update(deltaTime);
        }

        super.update(deltaTime);
    }

    override function render(context:RenderContext) {
        if (isAppReady()) {
            switch (context.type) {
                case OPENGL, OPENGLES, WEBGL:
                    Gfx.gl = context.webgl;

                    // Gfx.gl.depthMask(true);
                    // Gfx.gl.stencilMask(0xFF);
                    Gfx.gl.clearColor(1, 0, 0, 1);
                    Gfx.gl.clear(Gfx.gl.COLOR_BUFFER_BIT | Gfx.gl.DEPTH_BUFFER_BIT | Gfx.gl.STENCIL_BUFFER_BIT);

                    Gfx.gl.viewport(0, 0, window.width, window.height);

                    // Gfx.gl.depthMask(false);
                    //
                    Gfx.gl.enable(Gfx.gl.BLEND);
                    Gfx.gl.blendFunc(Gfx.gl.SRC_ALPHA, Gfx.gl.ONE_MINUS_SRC_ALPHA);
                    Gfx.gl.disable(Gfx.gl.CULL_FACE);

                    Gfx.setShader(Gfx.shaderDefault);

                    Gfx.gl.uniformMatrix4fv(Shader.current.u_camMatrix, false, Gfx.projMatrix);

                    #if desktop
		                Gfx.gl.enable(Gfx.gl.TEXTURE_2D);
		            #end

                    // Background

                    Gfx.gl.activeTexture(Gfx.gl.TEXTURE0);
		            Gfx.gl.bindTexture(Gfx.gl.TEXTURE_2D, glTextureBG);

                    Gfx.gl.bindBuffer(Gfx.gl.ARRAY_BUFFER, glBufferBG);

                    Gfx.gl.uniform1i(Shader.current.u_Texture0, 0);
                    
                    Shader.current.setAttribute(Shader.current.a_Position, 2, Gfx.gl.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 0);
                    Shader.current.setAttribute(Shader.current.a_TexCoord0, 2, Gfx.gl.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);
                    Shader.current.setAttribute(Shader.current.a_Color, 4, Gfx.gl.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 4 * Float32Array.BYTES_PER_ELEMENT);

		            Gfx.gl.drawArrays(Gfx.gl.TRIANGLE_STRIP, 0, 4);

                    // Intro

                    Gfx.gl.activeTexture(Gfx.gl.TEXTURE0);
		            Gfx.gl.bindTexture(Gfx.gl.TEXTURE_2D, glTexture);

                    Gfx.gl.bindBuffer(Gfx.gl.ARRAY_BUFFER, glBuffer);

                    Gfx.gl.uniform1i(Shader.current.u_Texture0, 0);
                    
                    Shader.current.setAttribute(Shader.current.a_Position, 2, Gfx.gl.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 0);
                    Shader.current.setAttribute(Shader.current.a_TexCoord0, 2, Gfx.gl.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 2 * Float32Array.BYTES_PER_ELEMENT);
                    Shader.current.setAttribute(Shader.current.a_Color, 4, Gfx.gl.FLOAT, 8 * Float32Array.BYTES_PER_ELEMENT, 4 * Float32Array.BYTES_PER_ELEMENT);

		            Gfx.gl.drawArrays(Gfx.gl.TRIANGLE_STRIP, 0, 4);

                    this.game.render();
                default:
            }
        }

        super.render(context);
    }

    override function onWindowResize(width:Int, height:Int) {
        super.onWindowResize(width, height);

        if (game != null) {
            updateProjectionMatrix();
        }
    }

    private function isAppReady():Bool {
        return preloader.complete && (this.game != null);
    }

    private function updateProjectionMatrix() {
        var ratioWidth:Float = window.width / Gfx.screenWidth;
        var ratioHeight:Float = window.height / Gfx.screenHeight;
        
        var zoom:Float = Math.floor(Math.min(ratioWidth, ratioHeight));
        if (zoom == 0) zoom = 1;

        var projWidth:Float = window.width / zoom;
        var projHeight:Float = window.height / zoom;

        var xoffset:Float = -(projWidth - Gfx.screenWidth) / 2;
        var yoffset:Float = -(projHeight - Gfx.screenHeight) / 2;

        Debug.log(Gfx.screenWidth, Gfx.screenHeight, window.width, window.height, ratioWidth, ratioHeight, zoom);
        Debug.log(projWidth, projHeight, xoffset, yoffset);

        Gfx.projMatrix.createOrtho(
            Math.round(xoffset), xoffset + projWidth, 
            yoffset + projHeight, Math.round(yoffset), 
            -1000, 1000
        );
    }
}