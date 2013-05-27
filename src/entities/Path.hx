package entities;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import nme.display.Sprite;
import nme.geom.Point;

/**
 * To use, just add points to points
 * @author Rahil Patel
 */
class Path extends Entity
{
	public var points:List<Point>;
	private var sprite:Sprite;
	private var maxPointsLength:Int;
	private var lastPointsLength:Int;
	
	public function new(/*points:List<Point> = null*/) 
	{
		super();
		sprite = new Sprite();
		HXP.stage.addChild(sprite);
		//if (points == null)
			points = new List<Point>();
		//else
			//this.points = points;
			
		lastPointsLength = 0;
		
		draw();
	}
	
	override public function added():Void 
	{
		super.added();
	}
	
	override public function removed():Void 
	{
		HXP.stage.removeChild(sprite);
		super.removed();
	}
	
	override public function update():Void 
	{
		super.update();
		
		// redraw when points are modified
		// todo: probably does not modify when a point is replaced
		if (points.length != lastPointsLength)
			draw();
	}
	
	private function draw():Void
	{
		if (points.length < 2)
			return;
		
		sprite.graphics.clear();
		sprite.graphics.lineStyle(10, 0xFFFFFF, .5);

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
	
}