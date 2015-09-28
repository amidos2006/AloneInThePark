package Prototype.World 
{
	import Prototype.Interface.CreditsEntity;
	import Prototype.Interface.Statistics.AchievementStatisticsEntity;
	import Prototype.Interface.Statistics.BonusStatisticsEntity;
	import Prototype.Interface.Statistics.BossStatisticsEntity;
	import Prototype.Interface.Statistics.CharacterStatisticsEntity;
	import Prototype.Interface.Statistics.EnemyStatisticsEntity;
	import Prototype.MapGetter;
	/**
	 * ...
	 * @author Amidos
	 */
	public class AchievementStatisticsWorld extends ThemeWorld
	{
		private var achSystem:AchievementStatisticsEntity;
		private var called:Boolean = false;
		
		public function AchievementStatisticsWorld() 
		{
			super(MapGetter.GetRandomTheme());
			achSystem = new AchievementStatisticsEntity(MainMenuWorld);
			add(achSystem);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (!called)
			{
				called = true;
				achSystem.FirstTime();
			}
		}
		
	}

}