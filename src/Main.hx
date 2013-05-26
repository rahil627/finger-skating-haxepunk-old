import com.haxepunk.Engine;
import com.haxepunk.HXP;
import scenes.CreationScene;
import scenes.Horse;
 
class Main extends Engine {
    public function new() {
        super(0, 0, 60, true);
    }
	
    override public function init():Dynamic {
        super.init();
        HXP.console.enable();
        trace("HaxePunk is running!");
		//HXP.screen.scale = 1;
		HXP.scene = new Horse();
    }
	
    public static function main() {
		new Main();
	}
}