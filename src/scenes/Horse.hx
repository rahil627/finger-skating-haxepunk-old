package scenes;

import com.haxepunk.HXP;
import com.haxepunk.Scene;

enum Turn {
	bottomPlayer;
	topPlayer;
}

enum HorseState {
	start;
	creation;
	imitation;
	recreation;
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
	private var bottomPlayerPoints:Int;
	private var topPlayerPoints:Int;
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
		//- if player 1 is successful, one point is awarded to player 1
		//- else player 2 is awarded one point and it becomes player 2's turn
		
		switch (state) 
		{
			case HorseState.start:
				turn = Turn.bottomPlayer;
				state = HorseState.creation;
				HXP.scene = new CreationScene();
				
			case HorseState.creation:
				if (complete) {
					state = HorseState.imitation;
					resetVars();
					HXP.scene = new ImitationScene(records, recordingTime);
				}
					
			case HorseState.imitation:
				if (!complete)
					return;
				
				if (successful) {
					awardPointToCurrentPlayer();
					checkIfGameIsOver();
					changeTurns();
					state = HorseState.creation;
					resetVars();
					records = new Array<Array<MovementData>>(); // todo: should clear instead
					HXP.scene = new CreationScene();
				}
				else {
					changeTurns();
					state = HorseState.recreation;
					resetVars();
					HXP.scene = new ImitationScene(records, recordingTime);
				}
				
			case HorseState.recreation:
				if (!complete)
					return;
					
				if (successful) {
					awardPointToCurrentPlayer();
					checkIfGameIsOver();
					//changeTurns(); // todo: design: winning player goes again
				}
				else {
					awardPointToOtherPlayer();
					checkIfGameIsOver();
				}
				
				state = HorseState.creation;
				resetVars();
				records = new Array<Array<MovementData>>();
				HXP.scene = new CreationScene();
					
			//default: // todo: learn Haxe enums
				
		}
	}
	
	private function changeTurns():Void {
		if (turn == Turn.bottomPlayer) // todo: may have to use Type.enumEq
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
	
	private function checkIfGameIsOver():Void {
		if (bottomPlayerPoints >= 3 || topPlayerPoints >= 3) {
			var topPlayerWon:Bool = topPlayerPoints >= 3;
			//Global.game = null; // todo: unsure if nulling a pointer a works
			Global.horse = null;
			HXP.scene = new GameOver(topPlayerWon);
		}
	}
	
	private function resetVars():Void {
		complete = false;
		successful = false;
	}
}