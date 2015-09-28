package Prototype.World 
{
	import Prototype.GlobalData;
	import Prototype.Interface.HighscoreTable;
	import Prototype.MapGetter;
	/**
	 * ...
	 * @author Amidos
	 */
	public class SurvivalHighScoreWorld extends ThemeWorld
	{
		
		public function SurvivalHighScoreWorld() 
		{
			super(MapGetter.GetRandomTheme());
			add(new HighscoreTable(true));
		}
		
	}

}