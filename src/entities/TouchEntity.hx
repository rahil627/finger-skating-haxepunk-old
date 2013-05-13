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
class TouchEntity extends Entity // could not use Touch because it's taken
{
	private var trail:Trail;
	private var touchID:Int;
	public var recording:Bool;
	public var record:Array<MovementData>;
	private var recordingTime:Float;
	private var recordingFrame:Int;

	public function new(x:Float = 0, y:Float = 0) 
	{
		var image:Image = new Image(Global.GRAPHIC_WHITE_RECTANGLE_50x50);
		image.centerOrigin();
		super(x + image.width / 2, y + image.height / 2, image);
		this.setHitbox(50, 50);
		this.centerOrigin();
		this.type = "TouchEntity";
		
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
		super.removed();
		HXP.scene.remove(trail);
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
	
	// handle touch input seperately
	public function handleTouchInput(touch:Touch):Void
	{		
		if (touch.pressed && this.collidePoint(this.x, this.y, touch.x, touch.y)) {
			
			// associate the sprite to the touch, emulating swallow touch
			HXP.log(touch.id);
			touchID = touch.id;
			
			this.x = touch.x;
			this.y = touch.y;
			return;
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