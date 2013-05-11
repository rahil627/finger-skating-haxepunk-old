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

enum CreationSubScene {
	begin;
	create;
	end;
}

/**
 * ...
 * @author Rahil Patel
 */
class CreationScene extends Scene
{
	private var firstPress:Bool = false;
	private var trail:Trail;
	private var lastPointX:Int;
	private var lastPointY:Int;
	
	private var bottomArea:Entity;
	private var touchSprites:Array<TouchSprite>;
	private var debugText:Text;
	private var subScene:CreationSubScene;
	private var recordingTime:Float;

	public function new() 
	{
		super();
	}
	
	override public function begin():Dynamic 
	{
		super.begin();
		
		Input.enable(); // todo: unsure if needed
		
		// add starting area
		this.add(bottomArea = new Entity(0, HXP.screen.height / 10, new Rect(HXP.screen.width, Math.round(HXP.screen.height / 10), 0x00FF00)));
		
		// add a bunch of touch sprites
		this.add(new TouchSprite(50, 250));
		this.add(new TouchSprite(150, 250));
		this.add(new TouchSprite(250, 250));
		this.add(new TouchSprite(350, 250));
		this.add(new TouchSprite(450, 250));
		
		// create a reference to the touch sprites
		touchSprites = new Array<TouchSprite>();
		this.getClass(TouchSprite, touchSprites);
		
		// add trail
		//this.add(trail = new Trail()); // todo: should be an entity
		//trail.name = "mouse trail";
		
		// add iOS debug text field
		debugText = new Text("test");
		this.add(new Entity(0, 100, debugText));
		
		subScene = CreationSubScene.begin;
		recordingTime = 0;
	}
	
	override public function update():Dynamic 
	{
		// check input
		//if (Input.multiTouchSupported)
			//Input.touchPoints(handleTouchInput);
		//else
			//handleMouseInput();
	
		// update entities
		super.update();
		
		switch (subScene) 
		{
			case CreationSubScene.begin:
			// when the player moves a sprite out of the starting area, the creation state begins
			for (i in 0...touchSprites.length) {
				if ((cast(touchSprites[i], TouchSprite)).y < bottomArea.y) {
					this.remove(bottomArea); // todo: extra: fade out
					for (j in 0...touchSprites.length) {
						(cast(touchSprites[j], TouchSprite)).recording = true;
					}
					subScene = CreationSubScene.create;
					break;
				}
			}
			
			
			case CreationSubScene.create:
			//when the player moves all of the sprites back to the starting area, the creation state ends
			var numberOfTouchSpritesInBottomArea:Int = 0;
			
			for (i in 0...touchSprites.length) {
				if ((cast(touchSprites[i], TouchSprite)).y > bottomArea.y) {
					numberOfTouchSpritesInBottomArea++;
				}
			}
			
			if (numberOfTouchSpritesInBottomArea == touchSprites.length)
				subScene = CreationSubScene.end;
				
			recordingTime += HXP.elapsed;
			
				
			case CreationSubScene.end:
			// pass the records of all touchsprites into the next state
			var records:Array<Array<MovementData>> = new Array<Array<MovementData>>();
			for (i in 0...touchSprites.length) {
				records.push(cast(touchSprites[i], TouchSprite).record);
			}
			
			HXP.scene = new ImitationScene(records, recordingTime);
			
			
			default: // todo: not needed?
				trace("switch fail");
				
		}
		
	}
	
	// todo: optimize: is this called per frame or any time?
	private function handleToucbInput(touch:Touch):Void // todo: dynamic or void?
	{		
		//debugText.text = Std.string(touch.id);
	}
	
	private function handleMouseInput():Void
	{	 
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
	}
	
}