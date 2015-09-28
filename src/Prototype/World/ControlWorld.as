package Prototype.World 
{
	import Prototype.Interface.ControlsEntity;
	import Prototype.Interface.GameOptionsEntity;
	import Prototype.Interface.MainMenuEntity;
	import Prototype.MapGetter;
	import Prototype.MusicPlayer;
	/**
	 * ...
	 * @author Amidos
	 */
	public class ControlWorld extends ThemeWorld
	{
		
		public function ControlWorld(worldType:Boolean) 
		{
			super(MapGetter.GetRandomTheme());
			
			add(new ControlsEntity(worldType));
		}
		
	}

}