package;

import sys.io.File;
import lime.utils.Assets;
import lime.math.Matrix4;
import lime.utils.Float32Array;
import lime.graphics.Image;
import lime.graphics.opengl.GLTexture;
import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLProgram;
import lime.graphics.WebGLRenderContext;
import lime.graphics.RenderContext;
import lime.app.Application;

class Main extends Application {
	var glProgram:GLProgram;

	var glBuffer:GLBuffer;
	var glMatrixUniform:GLUniformLocation;
	var glTexture:GLTexture;
	var glTextureAttribute:Int;
	var glVertexAttribute:Int;
	var image:Image;

	var ready:Bool = false;

	public function new() {
		super();
	}

	override function onWindowResize(width:Int, height:Int) {
		trace(width, height);
		super.onWindowResize(width, height);
	}

	override function render(context:RenderContext) {
		switch (context.type) {
			case OPENGL, OPENGLES, WEBGL:
				drawStuff(context);
			default:
		}
	}

	function drawStuff(gl:WebGLRenderContext) {
		if (!preloader.complete) return;

		if (!ready) {
			var origImage = Assets.getImage("assets/intro.png");

			var outFile = File.write("intro.dat", true);

			var pixelByte = 0;
			var pixelIndex = 0;

			for (y in 0 ... 400) {
				for (x in 0 ... 640) {
					var pixel = origImage.getPixel32(x, y);
					if (pixel == 0xFFFFFFFF) {
						pixelByte = pixelByte | (1 << pixelIndex);
					} else {
						// pixelByte = pixelByte | (1 << pixelIndex);
					}

					pixelIndex++;
					
					if (pixelIndex >= 8) {
						outFile.writeByte(pixelByte);

						// trace(StringTools.hex(pixelByte, 2));
						pixelByte = 0;
						pixelIndex = 0;
					}
				}
			}

			outFile.close();

			// Initkrams

			image = new Image(null, 0, 0, 640, 400, 0x000000FF, null);

			var fileData = Assets.getBytes("assets/INTRO.BLD");

			var startIndex = 32; // 20
			var endIndex = 21;

			var index = 0;
			var color = false;

			trace((640 * 400 * 8), (fileData.length - (startIndex + endIndex)) * 8);

			var count = 0;

			var byteCount = new Array<Int>();

			for (i in startIndex... fileData.length - endIndex) {
				var byte = fileData.get(i);

				// if (byte == 0xFE) continue;

				count = count + byte;				
				byteCount[byte]++;

				/*
				for (col in 0 ... byte) {
					var x = index % 640;
					var y = Math.floor(index / 640);

					image.setPixel(x, y, color ? 0xFFFFFFFF : 0x000000FF);

					index++;
				}
				*/

				color = !color;

				
				for (col in 0 ... 8) {
					var bit = (byte << col) & 0x80;
					var color = (bit != 0x80) ? 0x00ffffff : 0x000000ff;

					var x = index % 640;
					var y = Math.floor(index / 640);

					image.setPixel(x, y, color);

					index++;
				}
			}

			trace("Pixelcount: ", count);
			trace("Bytecount: ", byteCount.length);

			for (i in 0 ... byteCount.length) {
				trace(StringTools.hex(i, 2), byteCount[i]);
			}

			var vertexSource = "
				attribute vec4 aPosition;
				attribute vec2 aTexCoord;
				
				varying vec2 vTexCoord;

				uniform mat4 uMatrix;

				void main(void) {
					vTexCoord = aTexCoord;
					gl_Position = uMatrix * aPosition;
				}
			";

			var fragmentSource = 
			#if !desktop
				"precision medium float;" +
			#end
			"
				varying vec2 vTexCoord;

				uniform sampler2D uImage0;

				void main(void) {
					gl_FragColor = texture2D (uImage0, vTexCoord);
				}
			";

			glProgram = GLProgram.fromSources(gl, vertexSource, fragmentSource);
			gl.useProgram(glProgram);

			glVertexAttribute = gl.getAttribLocation(glProgram, "aPosition");
			glTextureAttribute = gl.getAttribLocation(glProgram, "aTexCoord");

			glMatrixUniform = gl.getUniformLocation(glProgram, "uMatrix");

			var imageUniform = gl.getUniformLocation(glProgram, "uImage0");

			gl.enableVertexAttribArray(glVertexAttribute);
			gl.enableVertexAttribArray(glTextureAttribute);
			gl.uniform1i(imageUniform, 0);

			gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
			gl.enable(gl.BLEND);

			var data = [
				window.width, 	window.height, 	0, 1, 1,
				0, 				window.height, 	0, 0, 1,
				window.width, 	0, 				0, 1, 0,
				0, 				0, 				0, 0, 0
			];

			glBuffer = gl.createBuffer();
			gl.bindBuffer(gl.ARRAY_BUFFER, glBuffer);
			gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(data), gl.STATIC_DRAW);
			gl.bindBuffer(gl.ARRAY_BUFFER, null);

			glTexture = gl.createTexture();
			gl.bindTexture(gl.TEXTURE_2D, glTexture);
			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);

			#if js
				gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, image.src);
			#else
				gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, image.buffer.width, image.buffer.height, 0, gl.RGBA, gl.UNSIGNED_BYTE, image.data);
			#end

			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);

			gl.bindTexture(gl.TEXTURE_2D, null);

			ready = true;
		}

		gl.viewport(0, 0, window.width, window.height);

		gl.clearColor(1, 0, 0, 1);
		gl.clear(gl.COLOR_BUFFER_BIT);

		var matrix = new Matrix4();
		matrix.createOrtho(0, window.width, window.height, 0, -1000, 1000);
		gl.uniformMatrix4fv(glMatrixUniform, false, matrix);

		gl.activeTexture(gl.TEXTURE0);
		gl.bindTexture(gl.TEXTURE_2D, glTexture);

		#if desktop
		gl.enable(gl.TEXTURE_2D);
		#end

		gl.bindBuffer(gl.ARRAY_BUFFER, glBuffer);

		var data = [
			window.width, 	window.height, 	0, 1, 1,
			0, 				window.height, 	0, 0, 1,
			window.width, 	0, 				0, 1, 0,
			0, 				0, 				0, 0, 0
		];

		gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(data), gl.STATIC_DRAW);

		gl.vertexAttribPointer(glVertexAttribute, 3, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 0);
		gl.vertexAttribPointer(glTextureAttribute, 2, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);

		gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);
	}


}
