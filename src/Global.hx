import com.haxepunk.utils.Touch;
import entities.TouchEntity;
import nme.Vector;

/**
 * Game specific constants
 * and hackish solutions
 * @author Rahil Patel
 */
class Global
{
	public static var bottomPlayerScore:Int = 0;
	public static var topPlayerScore:Int = 0;
	public static var turn:Turn = Turn.bottomPlayer;
	
	public static var mousePressedOnTouchSprite:TouchEntity;
	
	// graphics
	public static var GRAPHIC_WHITE_RECTANGLE_50x50:String = "assets/graphics/white_rectangle_50x50.png"; // inline = const?
}

enum Turn {
	bottomPlayer;
	topPlayer;
}