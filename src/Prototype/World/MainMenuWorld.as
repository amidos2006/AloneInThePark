package Prototype.World 
{
	import Prototype.Interface.MainMenuEntity;
	import Prototype.MapGetter;
	import Prototype.MusicPlayer;
	/**
	 * ...
	 * @author Amidos
	 */
	public class MainMenuWorld extends ThemeWorld
	{
		
		public function MainMenuWorld() 
		{
			super(MapGetter.GetRandomTheme());
			
			MusicPlayer.PlayMusic(MusicPlayer.MAIN_MENU_MUSIC);
			
			add(new MainMenuEntity());
		}
		
	}

}