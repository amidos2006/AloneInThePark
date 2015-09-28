package 
{
	import mochi.as3.MochiServices;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import Prototype.GlobalData;
	import Prototype.World.EndGameWorld;
	import Prototype.World.EnterNameWorld;
	import Prototype.World.EntranceWorld;
	import Prototype.World.LevelWorld;
	import Prototype.World.MainMenuWorld;
	import Prototype.World.NewgroundsEntranceWorld;
	
	/**
	 * ...
	 * @author Amidos
	 */
	public class Main extends Engine 
	{
		public function Main():void 
		{
			super(GlobalData.GAME_WIDTH, GlobalData.GAME_HEIGHT, 60, true);
			
			FP.screen.scale = GlobalData.GAME_SCALE;
			FP.screen.color = 0x000000;
			
			GlobalData.GameIntializer();
			FP.world = new NewgroundsEntranceWorld();
			
			//FP.console.enable();
		}
	}
	
}