package scenes;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.prototype.Circle;
import com.haxepunk.graphics.prototype.Rect;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Draw;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Touch;
import entities.TouchEntity;
import entities.Trail;
import nme.display.Shape;
import nme.display.Sprite;
import nme.geom.Point;

enum CreationSubScene {
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
	private var bottomArea:Entity;
	private var touchSprites:Array<TouchEntity>;
	private var debugText:Text;
	private var subScene:CreationSubScene;
	private var recordingTime:Float;

	public function new() 
	{
		super();
	}
	
	override public function begin():Dynamic 
	{
		super.begin();
		
		Input.enable(); // todo: unsure if needed
		
		// add starting area
		this.add(bottomArea = new Entity(0, HXP.screen.height / 10, new Rect(HXP.screen.width, Math.round(HXP.screen.height / 10), 0x00FF00)));
		
		// add a bunch of touch sprites
		this.add(new TouchEntity(50, 250));
		this.add(new TouchEntity(150, 250));
		this.add(new TouchEntity(250, 250));
		this.add(new TouchEntity(350, 250));
		this.add(new TouchEntity(450, 250));
		
		// create a reference to the touch sprites
		touchSprites = new Array<TouchEntity>();
		this.getClass(TouchEntity, touchSprites);
		
		// add trail
		//this.add(trail = new Trail()); // todo: should be an entity
		//trail.name = "mouse trail";
		
		// add iOS debug text field
		debugText = new Text("test");
		this.add(new Entity(0, 100, debugText));
		
		subScene = CreationSubScene.begin;
		recordingTime = 0;
	}
	
	override public function update():Dynamic 
	{	
		// check input
		// update entities
		super.update();
		
		switch (subScene) 
		{
			case CreationSubScene.begin:
			// when the player moves a sprite out of the starting area, the creation state begins
			for (i in 0...touchSprites.length) {
				if ((cast(touchSprites[i], TouchEntity)).y < bottomArea.y) {
					this.remove(bottomArea); // todo: extra: fade out
					for (j in 0...touchSprites.length) {
						(cast(touchSprites[j], TouchEntity)).recording = true;
					}
					subScene = CreationSubScene.create;
					break;
				}
			}
			
			
			case CreationSubScene.create:
			//when the player moves all of the sprites back to the starting area, the creation state ends
			var numberOfTouchSpritesInBottomArea:Int = 0;
			
			for (i in 0...touchSprites.length) {
				if ((cast(touchSprites[i], TouchEntity)).y > bottomArea.y) {
					numberOfTouchSpritesInBottomArea++;
				}
			}
			
			if (numberOfTouchSpritesInBottomArea == touchSprites.length)
				subScene = CreationSubScene.end;
				
			recordingTime += HXP.elapsed;
			
				
			case CreationSubScene.end:
			// pass the records of all touchsprites into the next state
			var records:Array<Array<MovementData>> = new Array<Array<MovementData>>();
			for (i in 0...touchSprites.length) {
				records.push(cast(touchSprites[i], TouchEntity).record);
			}
			
			HXP.scene = new ImitationScene(records, recordingTime);
			
			
			default: // todo: not needed?
				trace("switch fail");
				
		}
		
	}
	
	override public function render():Dynamic 
	{
		super.render();
	}
	
}