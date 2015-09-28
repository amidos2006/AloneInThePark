package Prototype.World 
{
	import Prototype.Interface.CreditsEntity;
	import Prototype.Interface.Statistics.BonusStatisticsEntity;
	import Prototype.Interface.Statistics.BossStatisticsEntity;
	import Prototype.Interface.Statistics.CharacterStatisticsEntity;
	import Prototype.Interface.Statistics.EnemyStatisticsEntity;
	import Prototype.MapGetter;
	/**
	 * ...
	 * @author Amidos
	 */
	public class CharacterStatisticsWorld extends ThemeWorld
	{
		
		public function CharacterStatisticsWorld() 
		{
			super(MapGetter.GetRandomTheme());
			add(new CharacterStatisticsEntity(MainMenuWorld));
		}
		
	}

}