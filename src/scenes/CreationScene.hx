package scenes;

import com.haxepunk.Entity;
import com.haxepunk.graphics.prototype.Rect;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Touch;
import entities.TouchEntity;

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
	private var bottomArea:Entity;
	private var touchEntities:Array<TouchEntity>;
	private var debugText:Text;
	private var state:CreationState;
	private var recordingTime:Float;

	public function new() 
	{
		super();
		state = CreationState.begin;
		recordingTime = 0;
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
		this.add(bottomArea = new Entity(0, HXP.height - HXP.height / 10, new Rect(HXP.width, Math.round(HXP.height / 10), 0x00FF00)));
		bottomArea.setHitbox(HXP.width, Math.round(HXP.height / 10));
		
		// add a bunch of touch entities for testing purposes
		// in release, they are added dynamically
		touchEntities = new Array<TouchEntity>();
		if (!Input.multiTouchSupported) { // todo: if flash, check how to do compiler conditionals for NME
			var touchEntity:TouchEntity;
			for (i in 0...5)  {
				touchEntity = new TouchEntity((i + 1) * HXP.width / 6, bottomArea.y + bottomArea.height / 2);
				touchEntities.push(touchEntity);
				this.add(touchEntity);
			}
		}
		
		//this.getClass(TouchEntity, touchEntities); // probably does not work until the next frame
	}
	
	override public function update():Dynamic 
	{	
		// check input
		// update entities
		super.update();
		
		switch (state) 
		{
			case CreationState.begin:
			// check input
			if (Input.multiTouchSupported)
				Input.touchPoints(handleTouchInputForBeginSubScene);
			else
				handleMouseInputForBeginSubScene();
				
			// todo: does Haxe have regions?
			// when the player moves an entity out of the starting area, the creation state begins
			for (i in 0...touchEntities.length) {
				if ((cast(touchEntities[i], TouchEntity)).y < bottomArea.y) {
					// begin create state
					this.remove(bottomArea);
					for (j in 0...touchEntities.length) {
						(cast(touchEntities[j], TouchEntity)).recording = true;
					}
					state = CreationState.create;
					break;
				}
			}
			
			
			case CreationState.create:
			// when the player moves all of the entities back to the starting area, the creation state ends
			var numberOfTouchSpritesInBottomArea:Int = 0;
			
			for (i in 0...touchEntities.length) {
				if ((cast(touchEntities[i], TouchEntity)).y > bottomArea.y) {
					numberOfTouchSpritesInBottomArea++;
				}
			}
			
			if (numberOfTouchSpritesInBottomArea == touchEntities.length)
				state = CreationState.end;
				
			recordingTime += HXP.elapsed;
			
				
			case CreationState.end:
			// pass the records of all touch entities into the next state
			//var records:Array<Array<MovementData>> = new Array<Array<MovementData>>();
			for (i in 0...touchEntities.length) {
				//records.push(cast(touchEntities[i], TouchEntity).record);
				Global.horse.records.push(cast(touchEntities[i], TouchEntity).record);
			}
			
			//Global.horse.records = records;
			//Global.horse.records = Copy.copy(records); // fail
			Global.horse.recordingTime = recordingTime;
			Global.horse.complete = true;
			HXP.scene = Global.horse;
			
			default: // todo: not needed?
				trace("switch fail");
				
		}
		
	}
	
	// returns a new copy of records 
	//public function copyRecords(recordsToCopy:Array<Array<MovementData>>):Array<Array<MovementData>>
	//{
		//var recordsCopy:Array<Array<MovementData>> = new Array<Array<MovementData>>();
		//recordsCopy = recordsToCopy.copy;
		//
		//for (i in 0...records.length)  {
			//recordsCopy[i] = records[i].copy();
			//for (j in 0...recordsCopy[i].length) {
				//recordsCopy[i][j] = records[i].push(records[i][j].copy);
			//}
		//}
	//}
	
	private function handleTouchInputForBeginSubScene(touch:Touch):Void
	{
		if (touch.pressed) {
			if (touch.y < bottomArea.y) {
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
		
	}
	
	override public function render():Dynamic 
	{
		super.render();
	}
	
}