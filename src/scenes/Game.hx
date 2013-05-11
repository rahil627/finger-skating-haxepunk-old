package scenes;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.prototype.Circle;
import com.haxepunk.graphics.prototype.Rect;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Draw;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Touch;
import entities.TouchSprite;
import entities.Trail;
import nme.display.Shape;
import nme.display.Sprite;
import nme.geom.Point;

/**
 * ...
 * @author Rahil Patel
 */
class Game extends Scene
{
	private var block:Entity;
	private var dancer:Entity;
	private var firstPress:Bool = false;
	private var trail:Trail;
	private var lastPointX:Int;
	private var lastPointY:Int;
	private var debugText:Text;

	public function new() 
	{
		super();
	}
	
	override public function begin():Dynamic 
	{
		super.begin();
		//block = this.addGraphic(new Image("block.png")); // todo: argh
		
		
		// performance test
		// create 500 random sprites
		//var entity:Entity;
		//for (i in 0...500) 
		//{
			//entity = this.addGraphic(new Circle(10));
			//entity.moveTo(HXP.random * HXP.screen.width, HXP.random * HXP.screen.height);
		//}
		
		
		Input.enable(); // todo: unsure if needed
		
		// add starting area
		//var startingArea:this.add(new Entity(0, HXP.screen.height - 50, new Rect(HXP.screen.width, 50, 0x00FF00)));
		
		// add dancer
		//this.add(dancer = new Entity(0, 0, new Circle(10, 0x0000FF)));
		//dancer.name = "dancer";
		
		// add a bunch of touch sprites
		this.add(new TouchSprite(50, 250));
		this.add(new TouchSprite(150, 250));
		this.add(new TouchSprite(250, 250));
		this.add(new TouchSprite(350, 250));
		this.add(new TouchSprite(450, 250));
		
		// add trail
		//this.add(trail = new Trail()); // todo: should be an entity
		//trail.name = "mouse trail";
		
		// add iOS debug text field
		debugText = new Text("test");
		this.add(new Entity(0, 100, debugText));
	}
	
	override public function update():Dynamic 
	{
		// check input
		//if (Input.multiTouchSupported)
			//Input.touchPoints(onTouch);
		//else
			//handleMouseInput();
		
		
		// update entities
		super.update();
		
		//block.moveBy(2, 1);
		//dancer.moveBy(2, 1);
		//for (i in 0...this.count) {
			//this.
		//}
		
		//Draw.setTarget(HXP.buffer, HXP.camera);
		//Draw.lin
		
		//record touches
		
	}
	
	// todo: optimize: is this called per frame or any time?
	private function onTouch(touch:Touch):Void // todo: dynamic or void?
	{		
		debugText.text = Std.string(touch.id);
			
		
		// save points
		//Global.touches.push(touch);
		
		// draw stuff
		if (touch.pressed) { // on press
			this.add(new Entity(touch.x, touch.y, new Circle(10, 0x00FF00)));
		}
		
		// how to get on release?
		// would need to update Input
		//if (touch.pressed) {
			//this.add(new Entity(touch.x, touch.y, new Circle(10, 0xFF0000)));
		//}
	}
	
	// a copy of onTouch for debugging purposes
	// todo: if debug
	private function handleMouseInput():Void
	{	 
		// move sprite with touch
		dancer.x = Input.mouseX;
		dancer.y = Input.mouseY;
		
		// save points
		//Global.touches.push(touch);
		
		// draw stuff
		if (Input.mouseDown) {
			//draw a line
			//trail.graphics.
			
			//Draw.linePlus(lastPointX, lastPointY, Input.mouseX, Input.mouseY, 0xFFFFF00, .5, 5);
			
			lastPointX = Input.mouseX;
			lastPointY = Input.mouseY;
			
			trail.points.push(new Point(Input.mouseX, Input.mouseY));
		}
		
		if (Input.mousePressed) {
			this.add(new Entity(Input.mouseX, Input.mouseY, new Circle(10, 0x00FF00)));
		}
		
		if (Input.mouseReleased) {
			this.add(new Entity(Input.mouseX, Input.mouseY, new Circle(10, 0xFF0000)));
		}
	}
	
	override public function render():Dynamic 
	{
		super.render();
		
		// draw a line (without using a bitmap) using HaxeNME
		// performance test
		//for (i in 0...5) 
		//{
			//Draw.linePlus(0, 0, 500 - i*50, 500, 0xFFFF0000, 1, 10);
		//}
	}
	
}