package;

import kha.Color;
import kha.Framebuffer;
import kha.Image;
import kha.Scaler;
import kha.Scheduler;
import kha.System;

class Main {
	static var backbuffer: Image;
	static var x = 0.0;

	static function render(framebuffer: Framebuffer): Void {
		var g = backbuffer.g2;
		g.begin(true, Color.Black);
		g.color = Color.Red;
		g.fillRect(x, 100, 500, 500);
		g.end();

		g = framebuffer.g2;
		g.begin();
		Scaler.scale(backbuffer, framebuffer, System.screenRotation);
		g.end();
	}

	static function update(): Void {
		++x;
	}

	public static function main() {
		System.init({title: "Shader-G2", width: 1024, height: 768}, function () {
			backbuffer = Image.createRenderTarget(1024, 768);
			System.notifyOnRender(render);
			Scheduler.addTimeTask(update, 0, 1 / 60);
		});
	}
}
