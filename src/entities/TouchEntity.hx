package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Touch;
import nme.geom.Point;

/**
 * ...
 * @author Rahil Patel
 */
class TouchEntity extends Entity
{
	private var trail:Trail;
	private var touchID:Int;
	public var recording:Bool;
	public var record:Array<MovementData>;
	private var recordingTime:Float;
	private var recordingFrame:Int;

	public function new(x:Float = 0, y:Float = 0) 
	{
		var image:Image = new Image(Global.GRAPHIC_WHITE_PIXEL);
		image.scale = 50;
		image.originX += .5;
		image.originY += .5;
		//image.centerOrigin(); // todo: HaxePunk bug: should use scaledwidth and scaledheight
		image.color = 0x0000FF;
		super(x + image.width / 2, y + image.height / 2, image);
		this.setHitbox(50, 50);
		this.centerOrigin();
		
		trail = new Trail();
		HXP.scene.add(trail);
		
		touchID = 0;
		recording = false;
		record = new Array<MovementData>();
		recordingTime = 0;
		recordingFrame = 0;
	}
	
	override public function removed():Void 
	{
		HXP.scene.remove(trail);
		super.removed();
	}
	
	override public function update():Void 
	{
		super.update();
		
		// check input
		if (Input.multiTouchSupported)
			Input.touchPoints(handleTouchInput);
		else
			handleMouseInput();
			
		// record movement
		if (recording) {
			recordingTime += HXP.elapsed;
			recordingFrame += 1;
			record.push(new MovementData(this.x, this.y, recordingTime, recordingFrame));
		}
		
		// store trail points
		trail.points.push(new Point(this.x, this.y));
	}
	
	// handle touch input separately // todo: if not, can always move out to the scene classes
	public function handleTouchInput(touch:Touch):Void
	{	
		//if (touch.pressed)
			//HXP.log("touch pressed: " + touch.id);
			
		//HXP.log("this.x, this.y, touch.x, touch.y: " + this.x + ", " + this.y + " " + touch.x + ", " + touch.y); // this.y is wrong
			
		//if (this.collidePoint(this.x, this.y, touch.x, touch.y))
			//HXP.log("collided with touch entity: " + touch.id);
	
		if (touch.pressed && this.collidePoint(this.x, this.y, touch.x, touch.y)) {
			
			// associate the sprite to the touch, emulating swallow touch
			//HXP.log(touch.id); // not working anymore?
			touchID = touch.id; // todo: compare to HaxePunk's touch manager for touches
		}
		
		if (touch.id != touchID)
			return;
		
		// on move
		this.x = touch.x;
		this.y = touch.y;
		
		// on release
		// todo: need to write code for touch.released
	}
	
	private function handleMouseInput():Void
	{	
		if (Input.mousePressed && this.collidePoint(this.x, this.y, Input.mouseX, Input.mouseY) && Global.mousePressedOnTouchSprite == null) { // haXe magic!
			// save sprite reference in Global
			Global.mousePressedOnTouchSprite = this;
		}
		
		if (Input.mouseDown && Global.mousePressedOnTouchSprite == this) { // more haXe magic!
			this.x = Input.mouseX;
			this.y = Input.mouseY;
		}
		
		if (Input.mouseReleased) {
			Global.mousePressedOnTouchSprite = null;
		}
	}
	
}