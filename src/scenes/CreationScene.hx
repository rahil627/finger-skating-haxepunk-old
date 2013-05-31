package scenes;

import com.haxepunk.Entity;
import com.haxepunk.graphics.prototype.Rect;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Touch;
import entities.TouchEntity;
import enums.Turn;

enum CreationState {
	begin;
	create;
	end;
}

/**
 * ...
 * @author Rahil Patel
 */
class CreationScene extends Scene
{
	private var startingArea:Entity;
	private var touchEntities:Array<TouchEntity>;
	private var debugText:Text;
	private var state:CreationState;
	private var recordingTime:Float;
	private var turn:Turn;
	private var reflectScene:Bool;

	public function new(turn:Turn) 
	{
		super();
		this.turn = turn;
		state = CreationState.begin;
		recordingTime = 0;
		reflectScene = (turn == Turn.topPlayer);
	}
	
	override public function begin():Dynamic 
	{
		super.begin();
		
		Input.enable(); // todo: unsure if needed
		
		// add iOS debug text field
		debugText = new Text("test");
		this.add(new Entity(0, 100, debugText));
		debugText.text = "HXP.width: " + HXP.width +  ", HXP.height: " + HXP.height
			+ ", HXP.screen.width: " + HXP.screen.width + "HXP.screen.height: " + HXP.screen.height;
		
		// add starting / ending area
		var startingAreaY:Int = (turn == Turn.topPlayer) ? 0 : HXP.height - Std.int(HXP.height / 10);
		this.add(startingArea = new Entity(0, startingAreaY, new Rect(HXP.width, Math.round(HXP.height / 10), 0x00FF00)));
		startingArea.setHitbox(HXP.width, Math.round(HXP.height / 10));
		
		// add a bunch of touch entities for testing purposes
		// in release, they are added dynamically
		touchEntities = new Array<TouchEntity>();
		if (Global.debugging) {
			var touchEntity:TouchEntity;
			for (i in 0...5)  {
				touchEntity = new TouchEntity((i + 1) * HXP.width / 6, startingArea.y + startingArea.height / 2, reflectScene);
				touchEntities.push(touchEntity);
				this.add(touchEntity);
			}
		}
		
		//this.getClass(TouchEntity, touchEntities); // probably does not work until the next frame
		
		// add score
		var scoreText:Text = new Text("");
		if (reflectScene)
			scoreText.text = Std.string(Global.horse.bottomPlayerPoints) + "-" + Std.string(Global.horse.topPlayerPoints); // todo: could pass in horse reference rather than using global
		else
			scoreText.text = Std.string(Global.horse.topPlayerPoints) + "-" + Std.string(Global.horse.bottomPlayerPoints);
		scoreText.scale = 3;
		if (reflectScene)
			scoreText.scale = 180;
		var score:Entity = new Entity(0, 0, scoreText);
		score.y = reflectScene ? scoreText.scaledHeight : HXP.height - scoreText.scaledHeight;
		this.add(score);
	}
	
	override public function update():Dynamic 
	{	
		switch (state) 
		{
			case CreationState.begin:
			if (Input.multiTouchSupported)
				Input.touchPoints(handleTouchInputForBeginSubScene);
			else
				handleMouseInputForBeginSubScene();
				
			if (checkPlayerMovedATouchEntityOut()) {
				// begin create state
				this.remove(startingArea);
				for (i in 0...touchEntities.length) {
					(cast(touchEntities[i], TouchEntity)).recording = true;
				}
				state = CreationState.create;
			}
			
			
			case CreationState.create:
			if (checkStartingAreaContainsAllTouchEntities())
				state = CreationState.end;
				
			recordingTime += HXP.elapsed;
			
				
			case CreationState.end:
			// pass the records of all touch entities into the next state
			for (i in 0...touchEntities.length) {
				Global.horse.records.push(cast(touchEntities[i], TouchEntity).record);
			}
			
			Global.horse.recordingTime = recordingTime;
			Global.horse.complete = true;
			HXP.scene = Global.horse;
			
			default:
				throw "switch fail";
				
		}
		
		super.update();
	}
	
	private function handleTouchInputForBeginSubScene(touch:Touch):Void
	{
		if (touch.pressed) {
			if (touch.y < startingArea.y) {
				var touchEntity:TouchEntity;
				touchEntity = new TouchEntity(touch.x, touch.y);
				touchEntities.push(touchEntity);
				this.add(touchEntity);
			}
		}
		
		// todo: on release, remove
	}
	
	
	private function handleMouseInputForBeginSubScene():Void
	{
		// todo: ?
	}
	
	private function checkPlayerMovedATouchEntityOut():Bool {
		for (i in 0...touchEntities.length) {
			if (reflectScene) {
				if ((cast(touchEntities[i], TouchEntity)).y > startingArea.y + startingArea.height) {
					return true;
				}
			}
			else {
				if ((cast(touchEntities[i], TouchEntity)).y < startingArea.y) {
					return true;
				}
			}
		}
		return false;
		
		//Lambda.exists(touchEntities, 
			//function(e) { return if (cast(e, TouchEntity).y < startingArea.y { true; } else { false; } ));
	}
	
	private function checkStartingAreaContainsAllTouchEntities():Bool {
		var numberOfTouchSpritesInStartingArea:Int = 0;
		
		for (i in 0...touchEntities.length) {
			if (reflectScene) {
				if ((cast(touchEntities[i], TouchEntity)).y < startingArea.y + startingArea.height) {
					numberOfTouchSpritesInStartingArea++;
				}
			}
			else {
				if ((cast(touchEntities[i], TouchEntity)).y > startingArea.y) {
					numberOfTouchSpritesInStartingArea++;
				}
			}
		}
		
		return (numberOfTouchSpritesInStartingArea == touchEntities.length);
	}
	
	override public function render():Dynamic 
	{
		super.render();
	}
	
}