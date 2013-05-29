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
	private var recordingTime:Float;
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

	public function new(record:Array<MovementData>, recordingTime:Float, playing:Bool = true, showPath:Bool = true, startingTime:Int = 0) 
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
		this.recordingTime = recordingTime; // todo: currently unused
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
		linearPathTween.setMotion(HXP.frameRate * recordingTime); // todo: ease?
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
			
			//recordIterator++;
			//currentFrameTotal++;
			
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