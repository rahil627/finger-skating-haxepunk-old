import com.haxepunk.Engine;
import com.haxepunk.HXP;
import scenes.CreationScene;
 
class Main extends Engine {
    public function new() {
        super(640, 480, 60, true);
    }
	
    override public function init():Dynamic {
        super.init();
        HXP.console.enable();
        trace("HaxePunk is running!");
		//HXP.screen.scale = 1;
		HXP.scene = new CreationScene();
    }
	
    public static function main() {
		new Main();
	}
}