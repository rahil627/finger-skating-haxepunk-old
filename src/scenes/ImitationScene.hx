package scenes;

import com.haxepunk.Entity;
import com.haxepunk.graphics.prototype.Rect;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Touch;
import entities.Ghost;
import entities.TouchEntity;
import enums.Turn;

enum ImitationState {
	observe;
	imitate;
	end;
}

/**
 * ...
 * @author Rahil Patel
 */
class ImitationScene extends Scene
{
	private var records:Array<Array<MovementData>>;
	private var recordingTime:Float;
	private var ghostRespawnTimer:Float;
	private var ghosts:Array<Ghost>; // todo: rename this to mainGhosts
	private var touchEntities:Array<TouchEntity>;
	private var state:ImitationState;
	private var startingArea:Entity;
	private var percentage:Entity;
	private var percentageText:Text;
	private var imitationTimer:Float;
	private var winThreshold:Float;
	private var currentFrameHitPercentTotal:Float;
	private var observeStateGhosts:Array<Ghost>;
	private var imitateStateAheadGhosts:Array<Ghost>;
	private var turn:Turn;
	private var reflectScene:Bool;

	public function new(records:Array<Array<MovementData>>, recordingTime:Float, turn:Turn) 
	{
		super();
		this.records = records;
		this.recordingTime = recordingTime;
		this.turn = turn;
		
		ghostRespawnTimer = 11;
		state = ImitationState.observe;
		imitationTimer = 0;
		currentFrameHitPercentTotal = 1;
		winThreshold = .90;
		reflectScene = (turn == Turn.topPlayer);
	}
	
	override public function begin():Dynamic 
	{
		super.begin();
		
		// add starting / ending area
		var startingAreaY:Int = reflectScene ? 0 : HXP.height - Std.int(HXP.height / 10);
		this.add(startingArea = new Entity(0, startingAreaY, new Rect(HXP.width, Math.round(HXP.height / 10), 0x00FF00)));
		startingArea.setHitbox(HXP.width, Math.round(HXP.height / 10));
		
		// init ghost arrays
		observeStateGhosts = new Array<Ghost>();
		imitateStateAheadGhosts = new Array<Ghost>();
		
		// add the main ghosts that will be tested against for points
		ghosts = new Array<Ghost>();
		var ghost:Ghost;
		for (i in 0...records.length) 
		{
			ghost = new Ghost(records[i], recordingTime, false, true, 0, reflectScene);
			this.add(ghost);
			ghosts.push(ghost);
		}
		
		// add same number of touch entities used in the recording
		touchEntities = new Array<TouchEntity>();
		var touchEntity:TouchEntity;
		for (i in 0...records.length) 
		{
			touchEntity = new TouchEntity();
			touchEntity.x = records[i][0].x;
			if (reflectScene)
				touchEntity.y = startingArea.y + startingArea.height / 2; // + touchEntity.height / 2; // todo: probably should use a line instead of area
			else
				touchEntity.y = startingArea.y + startingArea.height / 2 + touchEntity.height / 2;
			this.add(touchEntity);
			touchEntities.push(touchEntity);
		}
		
		// add percentage at the bottom
		percentageText = new Text("000%"); // set the width of the text
		percentageText.text = "0%";
		percentageText.scale = 4;
		if (reflectScene)
			percentageText.angle = 180;
		percentage = new Entity(0, 0, percentageText);
		percentage.x = HXP.width / 2 + 25;
		percentage.y = reflectScene ? percentageText.scaledHeight : HXP.height - percentageText.scaledHeight;
		this.add(percentage);
		
		// add score
		var scoreText:Text = new Text("0-0"); // set the width of the text
		if (reflectScene)
			scoreText.text = Std.string(Global.horse.bottomPlayerPoints) + "-" + Std.string(Global.horse.topPlayerPoints); // todo: could pass in horse reference rather than using global
		else
			scoreText.text = Std.string(Global.horse.topPlayerPoints) + "-" + Std.string(Global.horse.bottomPlayerPoints);
		scoreText.scale = 3;
		if (reflectScene)
			scoreText.scale = 180;
		var score:Entity = new Entity(0, 0, scoreText);
		score.x = reflectScene ? HXP.width - scoreText.scaledWidth : 0;
		score.y = reflectScene ? scoreText.scaledHeight : HXP.height - scoreText.scaledHeight;
		this.add(score);
	}
	
	override public function update():Dynamic 
	{
		super.update();
		
		switch (state) 
		{
		case ImitationState.observe: 
		//{ region observe state
		if (getPlayerMovedTouchEntityOut()) {
			// begin imitate state
			this.remove(startingArea); // todo: extra: fade out
			
			for (j in 0...ghosts.length) {
				(cast(ghosts[j], Ghost)).playing = true;
			}
			
			// todo: how to quickly clear an array?
			// could clear backwards
			// does setting to null work?
			for (i in 0...observeStateGhosts.length) {
				this.remove(observeStateGhosts[i]);
			}
			observeStateGhosts = null;
			
			// add ghosts a little ahead of the main ghost
			var ghost:Ghost; // todo: create a public var?
			for (i in 0...records.length) 
			{
				ghost = new Ghost(records[i], recordingTime, true, false, 0, reflectScene); // todo: create a starting position a little ahead in time
				this.add(ghost);
				imitateStateAheadGhosts.push(ghost);
			}
			
			state = ImitationState.imitate;
			return;
		}
		
		// play the recording indefinitely
		ghostRespawnTimer += HXP.elapsed;
		var ghost:Ghost;
		if (ghostRespawnTimer > recordingTime + 3) {
			ghostRespawnTimer = 0;
			for (i in 0...records.length)
			{
				ghost = new Ghost(records[i], recordingTime, true, false, 0, reflectScene);
				this.add(ghost);
				observeStateGhosts.push(ghost);
			}
		}
		//} endregion
		
		
		case ImitationState.imitate:
		//{ region imitate state
		// if time is up, go to end state
		imitationTimer += HXP.elapsed;
		
		if (imitationTimer >= recordingTime) {
			state = ImitationState.end;
			
			// a certain threshold is needed to earn a point at the end of the turn
			var successful:Bool = currentFrameHitPercentTotal > winThreshold;
			
			Global.horse.successful = true;
			
			// indicate win or lose
			var successfulText = new Text(successful ? "SUCCESS" : "FAIL");
			successfulText.scale = 5;
			successfulText.centerOrigin();
			this.add(new Entity(HXP.width / 2, HXP.height / 2));
			
			return;
		}

		
		// while the player imitates, the ghost sprite should change color to indicate success or failure
		
		currentFrameHitPercentTotal = 0;
		var currentFrameHitPercentSum:Float = 0;
		
		for (i in 0...touchEntities.length) {
			cast(ghosts[i], Ghost).touching = (cast(touchEntities[i], TouchEntity).collideWith(ghosts[i], cast(touchEntities[i], TouchEntity).x, cast(touchEntities[i], TouchEntity).y)) != null;
			
			if (ghosts[i].touching)
				HXP.log("ghost is touching");
			
			currentFrameHitPercentSum += cast(ghosts[i], Ghost).currentFrameHitPercent;
		}
		
		// a score in percentage is calculated
		
		// the current amount of time or number of frames that each touch sprite has been succesfully touching it's corresponding ghost sprite
		
		// the number of frames or time can be divided equally. When the creation state starts, assert that all of the sprites begin recording, whether it is in the starting area or not. The recording stops the total recording time is up.
		
		if (Global.debugging)
			currentFrameHitPercentTotal = currentFrameHitPercentSum;
		else
			currentFrameHitPercentTotal = currentFrameHitPercentSum / ghosts.length;
		//HXP.log(currentFrameHitPercentTotal, ghosts.length);
		
		percentageText.text = Std.string(currentFrameHitPercentTotal * 100).substr(0, 3) + "%"; // should be like Super Smash Bros. hit percent, or even better, a picture, a bar that fills up, no, something related to the design of the game
		
		// change color of text to indicate if the player is winning or not
		if (currentFrameHitPercentTotal > winThreshold) {
			percentageText.color = 0xFF00FF00;
		}
		else {
			percentageText.color = 0xFFFF0000;
		}
		//} endregion
		
		case ImitationState.end:
		//{ region end state
		
		// go to creation state on touch (or mouse click for debugging)
		if (Input.multiTouchSupported)
			Input.touchPoints(handleTouchInput);
		
		if (Input.mouseReleased)
			endScene();
			
		//} endregion
			
		
		default:
			throw "switch fail";
		}
	}
	
	private function getPlayerMovedTouchEntityOut():Bool {
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
	}
	
	private function handleTouchInput(touch:Touch):Void {
		if (touch.pressed)
			endScene();
	}
	
	private function endScene():Void {
		Global.horse.complete = true;
		HXP.scene = Global.horse;
	}
		
}