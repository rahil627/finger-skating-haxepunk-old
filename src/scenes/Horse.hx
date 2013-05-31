package scenes;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import enums.Turn;

enum HorseState {
	start;
	creation;
	imitation;
	recreation; // todo: confusing, runs imitation scene
}

/**
 * This mode follows the mechanics of popular basketball game HORSE
 * Well, it's a little different, more like Josh's team's game Horse Beat Off Extreme
 * To use, set successful and complete
 * @author Rahil Patel
 */
class Horse extends Scene
{

	private var turn:Turn;
	private var state:HorseState;
	public var complete:Bool;
	public var successful:Bool;
	public var bottomPlayerPoints:Int;
	public var topPlayerPoints:Int;
	public var records:Array<Array<MovementData>>; // the object belongs here and it's pointer is passed to other scenes
	public var recordingTime:Float;
	
	public function new() 
	{
		super();
		complete = false;
		successful = false;
		bottomPlayerPoints = 0;
		topPlayerPoints = 0;
		records = new Array<Array<MovementData>>();
		state = HorseState.start;
		
		//Global.game = this;
		Global.horse = this;
	}
	
	override public function begin():Dynamic 
	{
		super.begin();
	}
	
	override public function update():Dynamic 
	{
		super.update();
		
		//- player 1 creates
		//- player 2 imitates
		//- if player 2 is successful, one point is awarded to player 2, and it is player 2's turn
		//- else player 1 must repeat his own creation
		//- if player 1 is successful, one point is awarded to player 1, and either goes again or becomes player 2's turn, depending on design
		//- else player 2 is awarded one point and it becomes player 2's turn
		
		switch (state) 
		{
			case HorseState.start:
				turn = Turn.bottomPlayer;
				state = HorseState.creation;
				HXP.scene = new CreationScene(turn);
				
			case HorseState.creation:
				if (complete) {
					changeTurns();
					state = HorseState.imitation;
					complete = false;
					HXP.scene = new ImitationScene(records, recordingTime, turn);
				}
					
			case HorseState.imitation:
				if (!complete)
					return;
				
				if (successful) {
					awardPointToCurrentPlayer();
					if (checkIfGameIsOver())
						return;
					//changeTurns(); // todo: design: winning player goes again
					state = HorseState.creation;
					complete = false;
					successful = false;
					records = new Array<Array<MovementData>>(); // todo: should clear instead
					HXP.scene = new CreationScene(turn);
				}
				else {
					changeTurns();
					state = HorseState.recreation;
					complete = false;
					successful = false;
					HXP.scene = new ImitationScene(records, recordingTime, turn);
				}
				
			case HorseState.recreation:
				if (!complete)
					return;
					
				if (successful) {
					awardPointToCurrentPlayer();
					if (checkIfGameIsOver())
						return;
					//changeTurns(); // todo: design: winning player goes again
				}
				else {
					awardPointToOtherPlayer();
					if (checkIfGameIsOver())
						return;
				}
				
				state = HorseState.creation;
				complete = false;
				successful = false;
				records = new Array<Array<MovementData>>(); // todo: clear it?
				HXP.scene = new CreationScene(turn);
					
			//default:
				
		}
	}
	
	private function changeTurns():Void {
		if (turn == Turn.bottomPlayer) // todo: remember to use Type.enumEq
			turn = Turn.topPlayer;
		else
			turn = Turn.bottomPlayer;
	}
	
	private function awardPointToCurrentPlayer():Void {
		if (turn == Turn.bottomPlayer)
			bottomPlayerPoints += 1;
		else
			topPlayerPoints += 1;
	}
	
	private function awardPointToOtherPlayer():Void {
		if (turn == Turn.bottomPlayer)
			topPlayerPoints += 1;
		else
			bottomPlayerPoints += 1;
	}
	
	private function checkIfGameIsOver():Bool {
		if (bottomPlayerPoints >= 3 || topPlayerPoints >= 3) {
			var topPlayerWon:Bool = topPlayerPoints >= 3;
			Global.horse = null;
			HXP.scene = new GameOver(topPlayerWon);
			return true;
		}
		return false;
	}
	
}