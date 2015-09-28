package Prototype.World 
{
	import Prototype.GlobalData;
	import Prototype.Interface.LevelUpgradesEntity;
	import Prototype.MapGetter;
	import Prototype.MusicPlayer;
	/**
	 * ...
	 * @author Amidos
	 */
	public class UpgradeLevelWorld extends ThemeWorld
	{
		private var called:Boolean = false;
		
		public function UpgradeLevelWorld() 
		{
			super(MapGetter.GetMap(GlobalData.levelNumber));
			add(new LevelUpgradesEntity());
		}
		
		override public function update():void 
		{
			super.update();
			
			if (!called)
			{
				MusicPlayer.PlayMusic(MusicPlayer.SHOP_MUSIC);
				called = true;
			}
		}
		
	}

}