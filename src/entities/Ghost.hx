package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.masks.Circle;
import com.haxepunk.tweens.motion.LinearPath;
import nme.geom.Point;
import rahil.HaxePunk;

enum LinearPathTweenState {
	stop;
	playing;
}

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
	private var currentHitTime:Float;
	private var currentPlayTime:Float;
	public var currentHitTimePercent:Float;
	private var currentFrameHits:Int;
	private var currentFrameTotal:Int;
	public var currentFrameHitPercent:Float;
	private var image:Image;
	private var path:Path;
	private var showPath:Bool;
	private var linearPathTween:LinearPath;
	private var linearPathTweenState:LinearPathTweenState;

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
		currentPlayTime = 0;
		
		this.x = record[recordIterator].x;
		this.y = record[recordIterator].y;
		recordIterator++;
		
		path = new Path(); // todo: optimize: save sprite as bitmap and draw to screen
		for (i in 0...record.length) {
			path.points.push(new Point(record[i].x, record[i].y));
		}
		
		linearPathTween = new LinearPath(onLinearPathTweenComplete);
		for (i in 0...record.length) {
			linearPathTween.addPoint(record[i].x, record[i].y);
		}
		
		linearPathTweenState = LinearPathTweenState.stop;
	}
	
	override public function added():Void 
	{
		super.added();
		if (showPath)
			HXP.scene.add(path);
			
		this.addTween(linearPathTween);
		linearPathTween.setMotion(100); // todo: ease?, need recording time
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
			currentPlayTime += HXP.elapsed;
			
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
			//iterateToNextMovementData();
			
			// calculate the point depending on time
			//var nextPoint:Point = getNextPoint();
			
			// try linearPath tween
			
			if (linearPathTweenState == LinearPathTweenState.stop) { // todo: use enumEq?
				linearPathTweenState = LinearPathTweenState.playing;
				linearPathTween.start();
			}
			
			// the tween will contain the x and y values that are desired at a particular
			// point in time during the tween, and remember, you don't want to set the x
			// and y values immediately after calling start() on the tween -- it'll give
			// you a "hiccup" where your Entity moves to the final spot, then jumps
			// back and progresses allong the LinearPath.
			this.x = linearPathTween.x;
			this.y = linearPathTween.y;
			
			// remove self when done
			//if (recordIterator == Std.int(record.length - 1)) {
				//this.scene.remove(this);
				//return;
			//}
			
			//this.x = record[recordIterator].x;
			//this.y = record[recordIterator].y;
		}
	}
	
	private function onLinearPathTweenComplete(event:Dynamic):Void {
		// set the final x/y values here since the update() method,
		// as detailed below, won't set the final variables since the IDLE
		// state is being started
		this.x = linearPathTween.x;
		this.y = linearPathTween.y;
		linearPathTweenState = LinearPathTweenState.stop;
		
		// remove self when done
		this.scene.remove(this);
	}
	
	/*
	private function iterateToNextMovementData():Void {
		// search array for the time nearest to current time
		// maybe should use list
		// maybe can use lambda function
		for (i in 0...record.length - recordIterator - 1) 
		{
			// should remove itself before this happens
			if (recordIterator + 1 == record.length)
				HXP.log("went past array length");
				break;
			
			if (record[recordIterator].time <= currentPlayTime) {
				recordIterator++;
				break;
			}
			else {
				// went too far! Go back oncee
				recordIterator--;
				break;
			}
		}
	}
	*/
	
	/*
	// todo: optimize: pull out vars
	private function getNextPoint():Point {
		// calculate the next point by getting the vector between the current point and next point and factoring in time
		var currentPoint:Point = new Point(record[recordIterator].x, record[recordIterator].y);
		var nextPoint:Point = new Point(record[recordIterator + 1].x, record[recordIterator + 1].y) // may need to add y
		var differenceVector:Point = new Point(currentPoint.subtract(nextPoint));
		HXP.distance(
		differenceVector.normalize()
		
	}
	*/
	
	private function get_touching():Bool 
	{
		return _touching;
	}
	
	private function set_touching(value:Bool):Bool 
	{
		if (value == true) {
			this.image.color = 0xFF0000;
			currentFrameHits += 1;
			//currentHitTime += HXP.elapsed;
			
		}
		else {
			this.image.color = 0xFFFFFF;
		}
		
		currentFrameHitPercent = currentFrameHits / currentFrameTotal;
		//currentTimeHitPercent = currentHitTime / currentPlayTime;
		
		return _touching = value;
	}
}