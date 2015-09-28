package Prototype.World 
{
	import Prototype.Interface.GameOptionsEntity;
	import Prototype.Interface.MainMenuEntity;
	import Prototype.MapGetter;
	import Prototype.MusicPlayer;
	/**
	 * ...
	 * @author Amidos
	 */
	public class GameModesWorld extends ThemeWorld
	{
		
		public function GameModesWorld() 
		{
			super(MapGetter.GetRandomTheme());
			
			add(new GameOptionsEntity());
		}
		
	}

}