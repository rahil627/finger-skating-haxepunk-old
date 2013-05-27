package scenes;

import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Touch;

/**
 * Game over. Play again?
 * // todo: temporary design
 * @author Rahil Patel
 */
class GameOver extends Scene
{

	private var topPlayerWon:Bool;
	
	public function new(topPlayerWon:Bool) 
	{
		super();
		this.topPlayerWon = topPlayerWon;
	}
	
	override public function begin():Dynamic 
	{
		super.begin();
		
		var gameOverText:Text = new Text("YOU WIN", HXP.width / 2, HXP.height / 2);
		//gameOverText.scale = 5;
		//text.x -= text.scaledWidth / 2;
		gameOverText.centerOrigin();
		
		if (topPlayerWon)
			gameOverText.angle += 180;

		this.addGraphic(gameOverText);
	}
	
	override public function update():Dynamic 
	{
		super.update();
		
		// check input
		if (Input.multiTouchSupported)
			Input.touchPoints(handleTouchInput);
		else
			handleMouseInput();
	}
	
	public function handleTouchInput(touch:Touch):Void {
		if (touch.pressed)
			HXP.scene = new Horse();
	}
	
	public function handleMouseInput():Void {
		if (Input.mouseReleased)
			HXP.scene = new Horse();
	}
	
}