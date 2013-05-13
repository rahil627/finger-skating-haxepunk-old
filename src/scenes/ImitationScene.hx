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
	private var ghostSpriteRespawnTimer:Float;
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
		
		ghostSpriteRespawnTimer = 11;
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
		for (i in 0...records.length) 
		{
			ghosts.push(new Ghost(records[i], false));
		}
		
		// add same number of touch sprites used in the recording
		touchEntities = new Array<TouchEntity>();
		var touchEntity:TouchEntity;
		for (i in 0...records.length) 
		{
			touchEntity = new TouchEntity();
			touchEntity.x = records[i][0].x;
			touchEntity.y = bottomArea.y - bottomArea.height / 2 + touchEntity.height;
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
		
		// come back to this
		
	}
	
}