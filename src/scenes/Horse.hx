package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;

enum Turn {
	bottomPlayer;
	topPlayer;
}

/**
 * This mode follows the mechanics of the game of horse
 * @author Rahil Patel
 */
class Horse extends Scene
{

	private var turn:Turn;
	public function new() 
	{
		super();
	}
	
	override public function begin():Dynamic 
	{
		super.begin();
		turn = Turn.bottomPlayer;
		HXP.scene = new CreationScene();
	}
	
	override public function update():Dynamic 
	{
		super.update();
		
		//- player 1 creates
		//HXP.scene = new CreationScene();
		//- player 2 imitates
		//- if player 2 is successful, it is his turn to create
		//- else player 1 must repeat his own creation
		//- if player 1 is successful, one point is awarded to player 1
		//- else player 2 is awarded one point and it becomes player 2's turn
		
		// player 1 turn
		
		// player 2 turn
	}
}