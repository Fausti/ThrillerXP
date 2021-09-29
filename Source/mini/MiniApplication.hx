package mini;

import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.opengl.GLFramebuffer;
import lime.math.Rectangle;
import mini.gfx.Buffer;
import mini.gfx.Texture;
import lime.graphics.RenderContext;
import mini.gfx.Shader;
import lime.utils.Float32Array;
import lime.graphics.opengl.GLTexture;
import lime.graphics.opengl.GLBuffer;
import lime.utils.Assets;
import lime.app.Application;

class MiniApplication extends Application {
    var projRect:Rectangle = new Rectangle();

    var game:Game;

    var bufferBG:Buffer;
	var textureBG:Texture;

    var textureFramebuffer:Texture;
    var bufferFramebuffer:Buffer;
    var framebuffer:GLFramebuffer;

    private var __shaders:Array<String> = ["hq2x", "hq4x"];
	private var __upscaleShader:Array<Shader>;
	private var __u_Scale:Array<GLUniformLocation>;
	private var __u_InputSize:Array<GLUniformLocation>;
	private var __u_OutputSize:Array<GLUniformLocation>;

    var upscaleShader = -1;

    var scale:Float = 1;

    public function new() {
        super();
    }

    private function _init() {
        Debug.log("App:init");
        Gfx.init();

        // Framebuffer

        textureFramebuffer = new Texture();
        textureFramebuffer.upload(640 * 2, 400 * 2, null);

        var data = [
            640 + 320, 	400 + 200, 	1, 1,   1, 1, 1, 1,
            -320, 		400 + 200, 	0, 1,   1, 1, 1, 1,
            640 + 320, 	-200, 		1, 0,   1, 1, 1, 1,
            -320, 		-200, 		0, 0,   1, 1, 1, 1,
        ];

        bufferFramebuffer = new Buffer();
        bufferFramebuffer.setData(data);

        framebuffer = Gfx.gl.createFramebuffer();
        Gfx.gl.bindFramebuffer(Gfx.gl.FRAMEBUFFER, framebuffer);
        Gfx.gl.framebufferTexture2D(Gfx.gl.FRAMEBUFFER, Gfx.gl.COLOR_ATTACHMENT0, Gfx.gl.TEXTURE_2D, textureFramebuffer.handle, 0);
        Gfx.gl.bindFramebuffer(Gfx.gl.FRAMEBUFFER, null);

        // Overlay

        data = [
            640 * 2, 	400 * 2, 	1, 1,   1, 1, 1, 1,
            0, 		400 * 2, 	0, 1,   1, 1, 1, 1,
            640 * 2, 	0, 		1, 0,   1, 1, 1, 1,
            0, 		0, 		0, 0,   1, 1, 1, 1,
        ];

        bufferBG = new Buffer();
        bufferBG.setData(data);

        textureBG = Texture.fromFile("assets/thriller_pd/background.png");

        __upscaleShader = [];
		__u_Scale = [];
		__u_InputSize = [];
		__u_OutputSize = [];
		
		var index:Int = 0;
		for (fileName in __shaders) {
			__upscaleShader[index] = Shader.createShaderFrom(Assets.getText("assets/shader/"+fileName+".vert"), Assets.getText("assets/shader/"+fileName+".frag"));
		
			__u_Scale[index] = __upscaleShader[index].getUniformLocation("u_Scale");
			__u_InputSize[index] = __upscaleShader[index].getUniformLocation("u_InputSize");
			__u_OutputSize[index] = __upscaleShader[index].getUniformLocation("u_OutputSize");
			
			index++;
		}
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

        if (!window.fullscreen) {
            trace(window.display.bounds.width, window.display.bounds.height);
            trace(window.display.dpi);

            if (window.display.bounds.height >= 800) {
                window.resize(1280, 800);
                window.move(Math.floor(window.display.bounds.width / 2 - 640), Math.floor(window.display.bounds.height / 2 - 400));
            } else {
                window.move(Math.floor(window.display.bounds.width / 2 - 320), Math.floor(window.display.bounds.height / 2 - 200));
            }
        }
    }
    override function onPreloadComplete() {
        Debug.log("onPreloadComplete");

        super.onPreloadComplete();

        _init();

        if (game != null) {
            game.init(this);

            updateMatrix();
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

                    // prepare rendering

                    Gfx.gl.enable(Gfx.gl.BLEND);
                    Gfx.gl.blendFunc(Gfx.gl.SRC_ALPHA, Gfx.gl.ONE_MINUS_SRC_ALPHA);
                    Gfx.gl.disable(Gfx.gl.CULL_FACE);

                    Gfx.setShader(Gfx.shaderDefault);

                    Gfx.gl.uniformMatrix4fv(Shader.current.u_camMatrix, false, Gfx.screenMatrix);

                    #if desktop
		                Gfx.gl.enable(Gfx.gl.TEXTURE_2D);
		            #end

                    Gfx.gl.activeTexture(Gfx.gl.TEXTURE0);


                    Gfx.gl.bindFramebuffer(Gfx.gl.FRAMEBUFFER, framebuffer);

                    Gfx.gl.clearColor(1, 0, 0, 1);
                    Gfx.gl.clear(Gfx.gl.COLOR_BUFFER_BIT | Gfx.gl.DEPTH_BUFFER_BIT | Gfx.gl.STENCIL_BUFFER_BIT);

                    Gfx.gl.viewport(0, 0, 640 * 2, 400 * 2);

                    // Gfx.gl.scissor(Math.floor(projRect.x), Math.floor(projRect.y), Math.floor(projRect.width), Math.floor(projRect.height));
                    // Gfx.gl.enable(Gfx.gl.SCISSOR_TEST);
                    this.game.render();
                    // Gfx.gl.disable(Gfx.gl.SCISSOR_TEST);

                    // draw overlay
                    
		            textureBG.use();
                    bufferBG.draw();
                    Gfx.gl.bindFramebuffer(Gfx.gl.FRAMEBUFFER, null);

                    // draw framebuffer content

                    // 

                    if (upscaleShader == -1 || scale == 1) {
                        Gfx.setShader(Gfx.shaderDefault);
                    } else {
                        __upscaleShader[upscaleShader].use();
                        Gfx.gl.uniform2f(__u_Scale[upscaleShader], scale, scale);
                        Gfx.gl.uniform2f(__u_OutputSize[upscaleShader], 640 * scale, 400 * scale);
                        Gfx.gl.uniform2f(__u_InputSize[upscaleShader], 640, 400);
                    }

                    Gfx.gl.uniformMatrix4fv(Shader.current.u_camMatrix, false, Gfx.projMatrix);

                    Gfx.gl.clearColor(0, 1, 0, 1);
                    Gfx.gl.clear(Gfx.gl.COLOR_BUFFER_BIT | Gfx.gl.DEPTH_BUFFER_BIT | Gfx.gl.STENCIL_BUFFER_BIT);

                    Gfx.gl.viewport(0, 0, window.width, window.height);
                    textureFramebuffer.use();
                    bufferFramebuffer.draw();
                    
                default:
            }
        }

        super.render(context);
    }

    override function onWindowResize(width:Int, height:Int) {
        super.onWindowResize(width, height);

        if (game != null) {
            updateMatrix();
        }
    }

    private function isAppReady():Bool {
        return preloader.complete && (this.game != null);
    }

    private function updateMatrix() {
        var screenW = Gfx.screenWidth;
        var screenH = Gfx.screenHeight;

        if (screenW > 0 && screenH > 0) {
            var ratioW:Float = window.width / screenW;
            var ratioH:Float = window.height / screenH;

            var ratio:Float = Math.min(ratioW, ratioH);
            var zoom:Int = Math.floor(ratio);
            if (zoom < 1) zoom = 1;

            var projWidth:Float = window.width / zoom;
            var projHeight:Float = window.height / zoom;

            Debug.log("Proj", projWidth, projHeight);

            var restW:Float = projWidth - screenW;
            var restH:Float = projHeight - screenH;

            Debug.log("Rest", restW, restH);

            var offsetX:Float = restW / 2;
            var offsetY:Float = restH / 2;

            var offsetFixX:Int = 0;
            var offsetFixY:Int = 0;

            

            Debug.log("Offset", offsetX, offsetY);

            Gfx.projMatrix.createOrtho(
                -offsetX, screenW + offsetX + offsetFixX, 
                screenH + offsetY + offsetFixY, -offsetY, 
                -1000, 1000
            );

            projRect.setTo(offsetX, offsetY, screenW * ratio, screenH * ratio);

            Debug.log(zoom, "New", -offsetX, screenW + offsetX + offsetFixX, screenH + offsetY + offsetFixY, -offsetY, "\n");
            Debug.log(window.width, (screenW + restW) * 2);
            Debug.log(window.height, (screenH + restH) * 2);

            scale = zoom;
        }
    }

    override function onKeyUp(keyCode:KeyCode, modifier:KeyModifier) {
        if (keyCode == KeyCode.NUMBER_1) {
            upscaleShader = -1;
        } else if (keyCode == KeyCode.NUMBER_2) {
            upscaleShader = 0;
        } else if (keyCode == KeyCode.NUMBER_3) {
            upscaleShader = 1;
        } else if (keyCode == KeyCode.NUMBER_4) {
            if (!window.fullscreen) {
                window.resize(640, 400);
                window.move(Math.floor(window.display.bounds.width / 2 - 320), Math.floor(window.display.bounds.height / 2 - 200));
            }
        } else if (keyCode == KeyCode.NUMBER_5) {
            if (!window.fullscreen) {
                window.resize(640 * 2, 400 * 2);
                window.move(Math.floor(window.display.bounds.width / 2 - 640), Math.floor(window.display.bounds.height / 2 - 400));
            }
        } else if (keyCode == KeyCode.RETURN && (modifier == KeyModifier.ALT || modifier == 1024 || modifier == 2048)) {
            window.fullscreen = !window.fullscreen;
        }
    }
}