package entities;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Touch;
import nme.geom.Point;

/**
 * ...
 * @author Rahil Patel
 */
class TouchSprite extends Entity
{
	private var trail:Trail;
	private var touchID:Int;

	public function new(x:Float = 0, y:Float = 0) 
	{
		super(x, y);
		this.graphic = Image.createRect(50, 50, 0x0000FF);
		this.setHitbox(50, 50);
		trail = new Trail();
		HXP.scene.add(trail);
		touchID = 0;
	}
	
	override public function update():Void 
	{
		super.update();
		
		// check input
		if (Input.multiTouchSupported)
			Input.touchPoints(handleTouchInput);
		else
			handleMouseInput();
			
		trail.points.push(new Point(this.x, this.y));
	}
	
	public function handleTouchInput(touch:Touch):Void
	{		
		if (touch.pressed && this.collidePoint(this.x, this.y, touch.x, touch.y)) {
			
			//if (touch.id == 0)
			touchID = touch.id;
			
			this.x = touch.x - this.width / 2;
			this.y = touch.y - this.height / 2;
			return;
		}
		
		if (touch.id != touchID)
			return;
		
		// on move
		this.x = touch.x - this.width / 2;
		this.y = touch.y - this.height / 2;
		
		// on release
		// todo: need to write code for touch.released
		// if (
		// touch.id = 0;
	}
	
	private function handleMouseInput():Void
	{	
		// todo: need to associate mouse with sprite
		if (Input.mousePressed && this.collidePoint(this.x, this.y, Input.mouseX, Input.mouseY)) {
			this.x = Input.mouseX - this.width / 2;
			this.y = Input.mouseY - this.height / 2;
			return;
		}
		
		//if (Input.mouseDown) {
			//this.x = Input.mouseX - this.width / 2;
			//this.y = Input.mouseY - this.height / 2;
		//}
	}
	
}