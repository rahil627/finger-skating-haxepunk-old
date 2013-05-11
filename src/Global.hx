import com.haxepunk.utils.Touch;
import nme.Vector;

/**
 * Global variables
 * and hackish solutions
 * @author Rahil Patel
 */
class Global
{
	public static var bottomPlayerScore:Int = 0;
	public static var topPlayerScore:Int = 0;
	public static var turn:Turn = Turn.bottomPlayer;
}

enum Turn {
	bottomPlayer;
	topPlayer;
}