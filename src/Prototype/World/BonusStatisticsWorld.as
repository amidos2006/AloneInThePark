package Prototype.World 
{
	import Prototype.Interface.CreditsEntity;
	import Prototype.Interface.Statistics.BonusStatisticsEntity;
	import Prototype.Interface.Statistics.BossStatisticsEntity;
	import Prototype.Interface.Statistics.EnemyStatisticsEntity;
	import Prototype.MapGetter;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BonusStatisticsWorld extends ThemeWorld
	{
		
		public function BonusStatisticsWorld() 
		{
			super(MapGetter.GetRandomTheme());
			add(new BonusStatisticsEntity(CharacterStatisticsWorld));
		}
		
	}

}