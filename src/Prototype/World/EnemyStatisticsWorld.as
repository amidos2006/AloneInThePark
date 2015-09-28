package Prototype.World 
{
	import Prototype.Interface.CreditsEntity;
	import Prototype.Interface.Statistics.EnemyStatisticsEntity;
	import Prototype.MapGetter;
	/**
	 * ...
	 * @author Amidos
	 */
	public class EnemyStatisticsWorld extends ThemeWorld
	{
		
		public function EnemyStatisticsWorld() 
		{
			super(MapGetter.GetRandomTheme());
			add(new EnemyStatisticsEntity(BossStatisticsWorld));
		}
		
	}

}