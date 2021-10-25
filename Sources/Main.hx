package;

import kha.Color;
import kha.Framebuffer;
import kha.Image;
import kha.Scaler;
import kha.Scheduler;
import kha.Shaders;
import kha.System;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexData;
import kha.graphics4.VertexStructure;

class Main {
	static var backbuffer: Image;
	static var x = 0.0;
	static var pipeline: PipelineState;

	static function render(framebuffer: Framebuffer): Void {
		var g = backbuffer.g2;
		g.begin(true, Color.Black);
		g.color = Color.Red;
		g.fillRect(x, 100, 500, 500);
		g.end();

		g = framebuffer.g2;
		g.begin();
		g.pipeline = pipeline;
		Scaler.scale(backbuffer, framebuffer, System.screenRotation);
		g.end();
	}

	static function update(): Void {
		++x;
	}

	// Copy this function for custom G2 image shaders
	static function createPipeline(): Void {
		pipeline = new PipelineState();
		var structure = new VertexStructure();
		structure.add("vertexPosition", VertexData.Float3);
		structure.add("vertexUV", VertexData.Float2);
		structure.add("vertexColor", VertexData.Float4);
		pipeline.inputLayout = [structure];
		pipeline.vertexShader = Shaders.painter_image_vert;
		pipeline.fragmentShader = Shaders.postprocess_frag; // put in your own shader here
		pipeline.compile();
	}

	public static function main() {
		System.init({title: "Shader-G2", width: 1024, height: 768}, function () {
			backbuffer = Image.createRenderTarget(1024, 768);
			createPipeline();
			System.notifyOnRender(render);
			Scheduler.addTimeTask(update, 0, 1 / 60);
		});
	}
}
