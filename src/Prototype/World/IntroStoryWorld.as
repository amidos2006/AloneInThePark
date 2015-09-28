package Prototype.World 
{
	import Prototype.Interface.CreditsEntity;
	import Prototype.Interface.Statistics.AchievementStatisticsEntity;
	import Prototype.Interface.Statistics.BonusStatisticsEntity;
	import Prototype.Interface.Statistics.BossStatisticsEntity;
	import Prototype.Interface.Statistics.CharacterStatisticsEntity;
	import Prototype.Interface.Statistics.EnemyStatisticsEntity;
	import Prototype.Interface.Story.IntroStoryEntity;
	import Prototype.MapGetter;
	/**
	 * ...
	 * @author Amidos
	 */
	public class IntroStoryWorld extends ThemeWorld
	{
		private var storySystem:IntroStoryEntity;
		private var called:Boolean = false;
		
		public function IntroStoryWorld() 
		{
			super(MapGetter.GetRandomTheme());
			storySystem = new IntroStoryEntity();
			add(storySystem);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (!called)
			{
				called = true;
				storySystem.FirstTime();
			}
		}
		
	}

}