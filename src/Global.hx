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
	//[Embed(source = '../assets/graphics/white_rectangle_50x50.png')]
	//public static inline GRAPHIC_WHITE_RECTANGLE_50x50:Class; // inline = const?
}

enum Turn {
	bottomPlayer;
	topPlayer;
}