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
	private var touchSprites:Array<TouchEntity>;
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
		
		// add bottom area
		this.add(bottomArea = new Entity(0, HXP.screen.height / 10, new Rect(HXP.screen.width, Math.round(HXP.screen.height / 10), 0x00FF00)));
		
		// add ghosts that wait until the player touches it		
		for (i in 0...records.length) 
		{
			ghosts.push(new Ghost(records[i], false));
		}
		
		// save references to the ghosts
		ghosts = new Array<Ghost>();
		this.getClass(Ghost, ghosts);
		
		// add same number of touch sprites used in the recording
		var touchSprite:TouchEntity;
		for (i in 0...records.length) 
		{
			touchSprite = new TouchEntity();
			touchSprite.x = records[i][0].x;
			touchSprite.y = bottomArea.y - bottomArea.height / 2 + touchSprite.height;
			touchSprites.push(touchSprite);
		}
		
		// save references to the touch sprites
		touchSprites = new Array<TouchEntity>();
		this.getClass(TouchEntity, touchSprites);
		
		// show percentage at the bottom
		percentageText = new Text("0%");
		percentageText.scale = 5;
		percentage = new Entity(0, 0, percentageText);
		percentage.x = HXP.width / 2 + 25;
		percentage.y = HXP.height - 50; // todo: percentageText.height = 1, send bug to HaxeFlixel, or send fix myself
		this.add(percentage);
	}
	
	override public function update():Dynamic 
	{
		super.update();
		
		// come back to this
		
	}
	
}