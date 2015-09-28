package Prototype.World 
{
	import Prototype.Interface.Story.OutroStoryEntity;
	import Prototype.MapGetter;
	import Prototype.MusicPlayer;
	/**
	 * ...
	 * @author Amidos
	 */
	public class EndGameWorld extends ThemeWorld
	{
		private var storySystem:OutroStoryEntity;
		private var called:Boolean = false;
		
		public function EndGameWorld() 
		{
			super(MapGetter.GetRandomTheme());
			storySystem = new OutroStoryEntity();
			add(storySystem);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (!called)
			{
				called = true;
				storySystem.FirstTime();
				MusicPlayer.PlayMusic(MusicPlayer.GAME_ENDING);
			}
		}
	}

}