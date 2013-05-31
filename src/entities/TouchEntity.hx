package entities;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.masks.Circle;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Touch;
import nme.display.BitmapData;
import nme.geom.Point;
import com.haxepunk.RenderMode;
import rahil.HaxePunk;

/**
 * Contains the touch sprite, input, and recording
 * @author Rahil Patel
 */
class TouchEntity extends Entity
{
	public var recording:Bool;
	public var record:Array<MovementData>;
	
	private var trail:Trail;
	private var touchID:Int;
	private var recordingTime:Float;
	private var recordingFrame:Int;
	private var reflect:Bool;
	
	// optimization vars
	private var reflectedPoint:Point;

	public function new(x:Float = 0, y:Float = 0, reflect:Bool = false) 
	{
		//var image:Image = new Image(Global.GRAPHIC_WHITE_PIXEL);
		//image.scale = 25;
		//image.originX += .5;
		//image.originY += .5;
		//image.centerOrigin(); // todo: HaxePunk bug: should use scaledwidth and scaledheight
		//image.color = 0x0000FF;
		//super(x + image.width / 2, y + image.height / 2, image);
		//this.setHitbox(50, 50);
		//this.centerOrigin();
		
		var radius:Int = 12;
		var ringRadius:Int = 24;
		var thickness:Int = 10;
		var circleImage = HaxePunk.createCircleImage(radius, 0x0000FF);
		var ringImage = HaxePunk.createCircleOutline(ringRadius, thickness, 0x0000FF);
		//image.centerOrigin();
		circleImage.originX += radius;
		circleImage.originY += radius;
		ringImage.originX += ringRadius + thickness / 2;
		ringImage.originY += ringRadius + thickness / 2;
		var graphicList:Graphiclist = new Graphiclist([circleImage, ringImage]);
		//this.centerOrigin();
		var mask = new Circle(ringRadius, -ringRadius, -ringRadius);
		super(x, y, graphicList, mask);
		
		this.reflect = reflect;
		
		trail = new Trail();
		
		touchID = 0;
		recording = false;
		record = new Array<MovementData>();
		recordingTime = 0;
		recordingFrame = 0;
	}
	
	override public function added():Void 
	{
		super.added();
		HXP.scene.add(trail);
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
			if (reflect) {
				// points are always stored facing the bottom player
				reflectedPoint = HaxePunk.reflectPointOverCenterAxes(new Point(this.x, this.y));
				record.push(new MovementData(reflectedPoint.x, reflectedPoint.y, recordingTime, recordingFrame));
			}
			else
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