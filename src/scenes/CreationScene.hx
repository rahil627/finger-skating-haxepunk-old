package scenes;

import com.haxepunk.Entity;
import com.haxepunk.graphics.prototype.Rect;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import entities.TouchEntity;

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
	private var touchEntities:Array<TouchEntity>;
	private var debugText:Text;
	private var subScene:CreationSubScene;
	private var recordingTime:Float;

	public function new() 
	{
		super();
		subScene = CreationSubScene.begin;
		recordingTime = 0;
	}
	
	override public function begin():Dynamic 
	{
		super.begin();
		
		Input.enable(); // todo: unsure if needed
		
		// add starting / ending area
		this.add(bottomArea = new Entity(0, HXP.screen.height - HXP.screen.height / 10, new Rect(HXP.screen.width, Math.round(HXP.screen.height / 10), 0x00FF00)));
		
		// add a bunch of touch entities
		touchEntities = new Array<TouchEntity>();
		var touchEntity:TouchEntity;
		for (i in 0...5)  {
			touchEntity = new TouchEntity((i + 1) * HXP.screen.width / 6, bottomArea.y + bottomArea.height / 2);
			touchEntities.push(touchEntity);
			this.add(touchEntity);
		}
		
		//this.getClass(TouchEntity, touchEntities); // probably does not work until the next frame
		
		// add iOS debug text field
		debugText = new Text("test");
		this.add(new Entity(0, 100, debugText));
	}
	
	override public function update():Dynamic 
	{	
		// check input
		// update entities
		super.update();
		
		switch (subScene) 
		{
			case CreationSubScene.begin:
			// when the player moves an entity out of the starting area, the creation state begins
			for (i in 0...touchEntities.length) {
				if ((cast(touchEntities[i], TouchEntity)).y < bottomArea.y) {
					this.remove(bottomArea);
					for (j in 0...touchEntities.length) {
						(cast(touchEntities[j], TouchEntity)).recording = true;
					}
					subScene = CreationSubScene.create;
					break;
				}
			}
			
			
			case CreationSubScene.create:
			// when the player moves all of the entities back to the starting area, the creation state ends
			var numberOfTouchSpritesInBottomArea:Int = 0;
			
			for (i in 0...touchEntities.length) {
				if ((cast(touchEntities[i], TouchEntity)).y > bottomArea.y) {
					numberOfTouchSpritesInBottomArea++;
				}
			}
			
			if (numberOfTouchSpritesInBottomArea == touchEntities.length)
				subScene = CreationSubScene.end;
				
			recordingTime += HXP.elapsed;
			
				
			case CreationSubScene.end:
			// pass the records of all touch entities into the next state
			var records:Array<Array<MovementData>> = new Array<Array<MovementData>>();
			for (i in 0...touchEntities.length) {
				records.push(cast(touchEntities[i], TouchEntity).record);
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