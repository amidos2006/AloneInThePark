package Prototype.World 
{
	import Prototype.GlobalData;
	import Prototype.Interface.HighscoreTable;
	import Prototype.MapGetter;
	/**
	 * ...
	 * @author Amidos
	 */
	public class StoryHighScoreWorld extends ThemeWorld
	{
		
		public function StoryHighScoreWorld() 
		{
			super(MapGetter.GetMap(GlobalData.levelNumber));
			add(new HighscoreTable(false));
		}
		
	}

}