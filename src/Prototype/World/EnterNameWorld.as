package Prototype.World 
{
	import Prototype.GlobalData;
	import Prototype.Interface.HighScoreEnterNameEntity;
	import Prototype.MapGetter;
	/**
	 * ...
	 * @author Amidos
	 */
	public class EnterNameWorld extends ThemeWorld
	{
		
		public function EnterNameWorld(isSurvival:Boolean = false) 
		{
			var map:XML;
			if (!isSurvival)
			{
				map = (MapGetter.GetMap(GlobalData.levelNumber));
			}
			else
			{
				map = (MapGetter.GetRandomTheme());
			}
			
			super(map);
			add(new HighScoreEnterNameEntity(GlobalData.playerName, GlobalData.playerScore, isSurvival));
		}
		
	}

}