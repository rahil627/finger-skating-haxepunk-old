package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

/**
 * ...
 * @author Rahil Patel
 */
class Ghost extends Entity
{
	private var record:Array<MovementData>;
	private var playing:Bool;

	public function new(record:Array<MovementData>, playing:Bool) 
	{
		super();
		this.graphic = Image.createCircle(25, 0xFFFFFF);
		this.record = record;
		this.playing = playing;
	}
	
}