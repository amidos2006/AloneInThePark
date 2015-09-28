package Prototype.World 
{
	import Prototype.GlobalData;
	import Prototype.Interface.HighscoreTable;
	import Prototype.MapGetter;
	/**
	 * ...
	 * @author Amidos
	 */
	public class MainMenuStoryHighScoreWorld extends ThemeWorld
	{
		
		public function MainMenuStoryHighScoreWorld() 
		{
			super(MapGetter.GetRandomTheme());
			add(new HighscoreTable(false, true));
		}
		
	}

}