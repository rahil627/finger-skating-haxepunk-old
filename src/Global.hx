import com.haxepunk.Scene;
import com.haxepunk.utils.Touch;
import entities.TouchEntity;
import nme.Vector;
import scenes.Horse;

/**
 * Game specific constants
 * and hackish solutions
 * @author Rahil Patel
 */
class Global
{
	// settings
	
	// global vars
	public static var mousePressedOnTouchSprite:TouchEntity;
	//public static var game:Scene; // todo: currently unused. When there are more modes, can use this, then cast to the correct game mode.
	public static var horse:Horse;
	
	// graphics
	public static var GRAPHIC_WHITE_PIXEL:String = "assets/graphics/white_pixel.png"; // static inline = const? only works within this class?
}

// old code

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