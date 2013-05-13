package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import nme.geom.Point;

/**
 * GhostSprite moves according to the record it's given
 * @author Rahil Patel
 */
class Ghost extends Entity
{
	private var record:Array<MovementData>;
	public var playing:Bool;
	private var recordIterator:Int;
	private var _touching:Bool;
	public var touching(get_touching, set_touching):Bool;
	//public var currentHitTime:Float; // todo: should use time not frames
	//public var currentHitTimeTotal:Float;
	//public var currentHitTimePercent:Float;
	private var currentFrameHits:Int;
	private var currentFrameTotal:Int;
	public var currentFrameHitPercent:Float;
	private var image:Image;
	private var trail:Trail;

	public function new(record:Array<MovementData>, playing:Bool = true) 
	{
		super();
		image = new Image(Global.GRAPHIC_WHITE_RECTANGLE_50x50);
		image.centerOrigin();
		this.graphic = image;
		this.setHitbox(50, 50);
		this.centerOrigin();
		
		this.record = record;
		this.playing = playing;
		
		currentFrameHits = 0;
		currentFrameTotal = 0;
		currentFrameHitPercent = 1;
		recordIterator = 0;
		
		this.x = record[recordIterator].x;
		this.y = record[recordIterator].y;
		recordIterator++;
		
		trail = new Trail(1000000); // todo: optimize: save sprite as bitmap and draw to screen
		for (i in 0...record.length) {
			trail.points.push(new Point(record[i].x, record[i].y));
		}
		HXP.scene.add(trail); // called when added to scene, should override added?
	}
	
	override public function update():Void 
	{
		super.update();
		
		// remove self when done
		if (recordIterator == Std.int(record.length)) {
			this.scene.remove(this);
			return;
		}
		
		if (playing) {
			this.x = record[recordIterator].x;
			this.y = record[recordIterator].y;
			recordIterator++;
			currentFrameTotal++;
		}
	}
	
	private function get_touching():Bool 
	{
		return _touching;
	}
	
	private function set_touching(value:Bool):Bool 
	{
		if (value == true) {
			this.image.color = 0xFF0000;
			currentFrameHits += 1;
			currentFrameHitPercent = currentFrameHits / currentFrameTotal;
		}
		else {
			this.image.color = 0xFFFFFF;
			currentFrameHitPercent = currentFrameHits / currentFrameTotal;
		}
		
		return _touching = value;
	}
	
}