package Prototype.World 
{
	import Prototype.Interface.CreditsEntity;
	import Prototype.Interface.Statistics.BossStatisticsEntity;
	import Prototype.Interface.Statistics.EnemyStatisticsEntity;
	import Prototype.MapGetter;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BossStatisticsWorld extends ThemeWorld
	{
		
		public function BossStatisticsWorld() 
		{
			super(MapGetter.GetRandomTheme());
			add(new BossStatisticsEntity(BonusStatisticsWorld));
		}
		
	}

}