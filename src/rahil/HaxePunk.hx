package rahil;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.RenderMode;
import nme.display.BitmapData;

/**
 * My HaxePunk library
 * @author Rahil Patel
 */
class HaxePunk
{
	//public static function touchedLastFrame():Bool {
		//return FlxG.touchManager.touches.length > 0;
	//}
	//
	//public static function mouseClickedLastFrame():Bool {
		//return FlxG.mouse.justReleased();
	//}
	//
	//public static function touchedOrMouseClickedLastFrame():Bool {
		//return HaxeFlixel.touchedLastFrame() || HaxeFlixel.mouseClickedLastFrame();
	//}
	
	public static function createCircleImage(radius:Int, color:Int = 0xFFFFFF):Image
	{
		if (HXP.renderMode.has(RenderMode.BUFFER) && radius > 0) // todo: should try / catch
		{
			HXP.sprite.graphics.clear();
			HXP.sprite.graphics.beginFill(color);
			HXP.sprite.graphics.drawCircle(radius, radius, radius);
			var data:BitmapData = HXP.createBitmap(radius * 2, radius * 2, true);
			data.draw(HXP.sprite);
			var image:Image = new Image(data);
			return image;
		}
		
		return null;
	}
	
	public static function createCircleOutline(radius:Int, thickness:Int, color:Int = 0xFFFFFF):Image
	{
		if (HXP.renderMode.has(RenderMode.BUFFER) && radius > 0) // todo: should try / catch
		{
			var data:BitmapData = HXP.createBitmap(radius * 2 + thickness * 2, radius * 2 + thickness * 2, true);
			
			// draw ring
			HXP.sprite.graphics.clear();
			HXP.sprite.graphics.lineStyle(thickness, color, 1);
			HXP.sprite.graphics.drawCircle(radius + thickness / 2, radius + thickness / 2, radius);
			data.draw(HXP.sprite);
			
			// draw debug rectangle
			//HXP.sprite.graphics.clear();
			//HXP.sprite.graphics.lineStyle(1, 0xFF0000, 1);
			//HXP.sprite.graphics.drawRect(0, 0, radius * 2 + thickness * 2, radius * 2 + thickness * 2);
			//data.draw(HXP.sprite);
			
			var image:Image = new Image(data);
			return image;
		}
		
		return null;
	}
	
}

