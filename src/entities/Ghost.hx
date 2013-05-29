package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.masks.Circle;
import nme.geom.Point;
import rahil.HaxePunk;

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
	private var path:Path;
	private var showPath:Bool;
	private var currentTime:Float;

	public function new(record:Array<MovementData>, playing:Bool = true, showPath:Bool = true, startingTime:Int = 0) 
	{
		super();
		var radius:Int = 12;
		image = HaxePunk.createCircleImage(radius, 0xFFFFFF);
		//image.centerOrigin();
		image.originX += radius;
		image.originY += radius;
		//image.color = 0xFFFFFF;
		this.graphic = image;
		var mask:Circle = new Circle(radius, -radius, -radius);
		this.mask = mask;
		//this.centerOrigin();
		
		this.record = record;
		this.playing = playing;
		this.showPath = showPath;
		
		currentFrameHits = 0;
		currentFrameTotal = 0;
		currentFrameHitPercent = 1;
		recordIterator = 0;
		currentTime = 0;
		
		this.x = record[recordIterator].x;
		this.y = record[recordIterator].y;
		recordIterator++;
		
		path = new Path(); // todo: optimize: save sprite as bitmap and draw to screen
		for (i in 0...record.length) {
			path.points.push(new Point(record[i].x, record[i].y));
		}
	}
	
	override public function added():Void 
	{
		super.added();
		if (showPath)
			HXP.scene.add(path);
	}
	override public function removed():Void 
	{
		if (showPath)
			HXP.scene.remove(path);
		super.removed();
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (playing) {
			currentTime += HXP.elapsed;
			
			// old frame code
			// remove self when done
			//if (recordIterator == Std.int(record.length)) {
				//this.scene.remove(this);
				//return;
			//}
			
			//this.x = record[recordIterator].x;
			//this.y = record[recordIterator].y;
			//recordIterator++;
			//currentFrameTotal++;
			
			// compare time with data
			// todo: need to check against end of record, especially with score
			iterateToNextMovementData();
			
			// remove self when done
			if (recordIterator == Std.int(record.length)) {
				this.scene.remove(this);
				return;
			}
			
			this.x = record[recordIterator].x;
			this.y = record[recordIterator].y;
		}
	}
	
	private function iterateToNextMovementData():Void {
		// search array for the time nearest to current time
		// maybe should use list
		// maybe can use lambda function
		for (i in 0...record.length - recordIterator) 
		{
			if (record[recordIterator].time <= currentTime) {
				recordIterator++;
			}
			else {
				// went too far! Go back oncee
				recordIterator--;
				break;
			}
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