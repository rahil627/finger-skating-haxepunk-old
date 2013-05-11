package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import nme.display.Sprite;
import nme.geom.Point;

/**
 * ...
 * @author Rahil Patel
 */
class Trail extends Entity
{

	// i don't think z-order will be correct anyway, just use HXP.sprite, well, it might, I'm not sure
	
	// utils.Draw draws a sprite to HXP.buffer (BitmapData), this may have bad performance, but it doesn't even work anyway
	
	// need to either add a Sprite to HXP.stage or HXP.engine
	
	// add a single Sprite for everything to draw to, like the effects layer in HaxeFlixel
	
	// use addChildAt to order the sprites
	
	private var sprite:Sprite;
	public var points:List<Point>;
	
	/**
	 * to use, just add points to points
	 */
	public function new()
	{
		super();
		sprite = new Sprite();
		HXP.stage.addChild(sprite);
		points = new List<Point>();
		
		sprite.graphics.lineStyle(10, 0x00FF00);
	}
	
	override public function added():Void 
	{
		super.added();
	}
	
	override public function removed():Void 
	{
		super.removed();
		HXP.stage.removeChild(sprite);
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (points.length < 2)
			return;
			
		if (points.length > 100)
			points.remove(points.last());
		
		sprite.graphics.clear();
		sprite.graphics.lineStyle(10, 0x00FF00);
		
		for (p in points) 
		{
			if (p == points.first()) { // magic?
				sprite.graphics.moveTo(p.x, p.y);
				continue;
			}
			
			sprite.graphics.lineTo(p.x, p.y);
			sprite.graphics.moveTo(p.x, p.y);
		}
	}
	
	override public function render():Void 
	{
		super.render();
	}
	
}