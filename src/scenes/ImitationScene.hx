package scenes;

import com.haxepunk.Entity;
import com.haxepunk.graphics.prototype.Rect;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import entities.Ghost;
import entities.TouchEntity;

enum ImitationSubState {
	begin;
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
	private var GhostRespawnTimer:Float;
	private var ghosts:Array<Ghost>;
	private var touchEntities:Array<TouchEntity>;
	private var imitationSubState:ImitationSubState;
	private var bottomArea:Entity;
	private var percentage:Entity;
	private var percentageText:Text;
	private var imitationTimer:Float;
	private var winThreshold:Float;
	private var currentFrameHitPercentTotal:Float;

	public function new(records, recordingTime) 
	{
		super();
		this.records = records;
		this.recordingTime = recordingTime;
		
		GhostRespawnTimer = 11;
		imitationSubState = ImitationSubState.begin;
		imitationTimer = 0;
		currentFrameHitPercentTotal = 1;
		winThreshold = .90;
	}
	
	override public function begin():Dynamic 
	{
		super.begin();
		
		// add starting / ending area
		this.add(bottomArea = new Entity(0, HXP.screen.height - HXP.screen.height / 10, new Rect(HXP.screen.width, Math.round(HXP.screen.height / 10), 0x00FF00)));
		
		// add ghosts that wait until the player touches it		
		ghosts = new Array<Ghost>();
		var ghost:Ghost;
		for (i in 0...records.length) 
		{
			ghost = new Ghost(records[i], false);
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
			touchEntity.y = bottomArea.y - bottomArea.height / 2 + touchEntity.height;
			this.add(touchEntity);
			touchEntities.push(touchEntity);
		}
		
		// show percentage at the bottom
		percentageText = new Text("0%");
		percentageText.scale = 5;
		percentage = new Entity(0, 0, percentageText);
		percentage.x = HXP.width / 2 + 25;
		percentage.y = HXP.height - percentageText.scaledHeight;
		this.add(percentage);
	}
	
	override public function update():Dynamic 
	{
		super.update();
		
		switch (imitationSubState) 
		{
		case ImitationSubState.begin: 
		//start once the player moves a touch sprite out of starting area
		for (i in 0...touchEntities.length) {
			if ((cast(touchEntities[i], TouchEntity)).y < bottomArea.y) {
				this.remove(bottomArea); // todo: extra: fade out
				for (j in 0...ghosts.length) {
					(cast(ghosts[j], Ghost)).playing = true;
				}
				imitationSubState = ImitationSubState.imitate;
				break;
			}
		}
		
		case ImitationSubState.imitate:
			
		// if time is up, go to end state
		imitationTimer += HXP.elapsed;
		
		if (imitationTimer >= recordingTime) {
			imitationSubState = ImitationSubState.end;
			
			// a certain threshold is needed to earn a point at the end of the turn
			var successful:Bool = currentFrameHitPercentTotal > winThreshold;
			
			if (successful)
				Global.bottomPlayerScore += 1;
			
			// indicate win or lose
			var successfulText = new Text(successful ? "SUCCESS" : "FAIL");
			successfulText.scale = 5;
			successfulText.centerOrigin();
			this.add(new Entity(HXP.width / 2, HXP.height / 2));
			
			return;
		}

		
		// while the player imitates, the ghost sprite should change color to indicate success or failure
		
		currentFrameHitPercentTotal = 0;
		
		for (i in 0...touchEntities.length) {
			cast(ghosts[i], Ghost).touching = (cast(touchEntities[i], TouchEntity).collideWith(ghosts[i], cast(ghosts[i], Ghost).x, cast(ghosts[i], Ghost).y)) != null;
			
			currentFrameHitPercentTotal += cast(ghosts[i], Ghost).currentFrameHitPercent;
		}
		
		// a score in percentage is calculated
		
		// the current amount of time or number of frames that each touch sprite has been succesfully touching it's corresponding ghost sprite
		
		// the number of frames or time can be divided equally. When the creation state starts, assert that all of the sprites begin recording, whether it is in the starting area or not. The recording stops the total recording time is up.
		
		currentFrameHitPercentTotal = currentFrameHitPercentTotal / ghosts.length;
		
		percentageText.text = Std.string(currentFrameHitPercentTotal) + "%"; // should be like Super Smash Bros. hit percent, or even better, a picture, a bar that fills up, no, something related to the design of the game
		
		// change color of text to indicate if the player is winning or not
		if (currentFrameHitPercentTotal > winThreshold) {
			percentageText.color = 0xFF00FF00;
		}
		else {
			percentageText.color = 0xFFFF0000;
		}
		
		
		case ImitationSubState.end:
		
		// go to creation state on touch (or mouse click for debugging)
		//if (FlxG.touchManager.touches.length > 0 || FlxG.mouse.justReleased()) {
			//FlxG.switchState(new CreationState());
		//}
		
		default: // todo: not needed? Check HaXe syntax web page
			trace("switch fail");
		}
		
		// play the recording every x seconds // todo: move this, to add some ghost sprites a little ahead of the main ones
		GhostRespawnTimer += HXP.elapsed;
		
		if (GhostRespawnTimer > 5) {
			GhostRespawnTimer = 0;
			for (i in 0...records.length) 
			{
				this.add(new Ghost(records[i]));
			}
		}
	}
	
}