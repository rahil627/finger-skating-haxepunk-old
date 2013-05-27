package ;

/**
 * ...
 * @author Rahil Patel
 */
class MovementData // could use struct, but in Haxe C++ they are slower than classes
{
	public var x:Float;
	public var y:Float;
	public var time:Float;
	public var frame:Int;
	
	public function new(x:Float, y:Float, time:Float, frame:Int = 0) 
	{
		this.x = x;
		this.y = y;
		this.time = time; // todo: currently unused
		this.frame = frame;
	}
	
	public function copy():MovementData
	{
		return new MovementData(x, y, time, frame);
	}
}