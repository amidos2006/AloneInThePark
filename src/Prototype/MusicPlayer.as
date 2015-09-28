package Prototype 
{
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	/**
	 * ...
	 * @author Amidos
	 */
	public class MusicPlayer 
	{
		[Embed(source = "../../assets/Music/ParkingTicket.mp3")]private static var mainMenu:Class;
		[Embed(source = "../../assets/Music/Shop.mp3")]private static var shop:Class;
		[Embed(source = "../../assets/Music/EndGame.mp3")]private static var endingGame:Class;
		[Embed(source = "../../assets/Music/IKillYou.mp3")]private static var area1:Class;
		[Embed(source = "../../assets/Music/Monsters.mp3")]private static var area2:Class;
		[Embed(source = "../../assets/Music/LonerJam.mp3")]private static var area3:Class;
		[Embed(source = "../../assets/Music/MushroomMayhem.mp3")]private static var area4:Class;
		[Embed(source = "../../assets/Music/ParkShooter.mp3")]private static var area5:Class;
		[Embed(source = "../../assets/Music/AttackOfThePark.mp3")]private static var boss:Class;
		
		private static var mainMenuSfx:Sfx = new Sfx(mainMenu);
		private static var shopSfx:Sfx = new Sfx(shop);
		private static var gameEndingSfx:Sfx = new Sfx(endingGame);
		private static var area1Sfx:Sfx = new Sfx(area1);
		private static var area2Sfx:Sfx = new Sfx(area2);
		private static var area3Sfx:Sfx = new Sfx(area3);
		private static var area4Sfx:Sfx = new Sfx(area4);
		private static var area5Sfx:Sfx = new Sfx(area5);
		private static var bossSfx:Sfx = new Sfx(boss);
		
		public static const MAIN_MENU_MUSIC:int = 0;
		public static const SHOP_MUSIC:int = 1;
		public static const GAME_ENDING:int = 2;
		public static const BOSS_MUSIC:int = 3;
		public static const LEVEL_MUSIC:int = 4;
		public static const SURVIVAL_MUSIC:int = 5;
		
		public static const MAX_MUSIC:Number = 0.3;
		public static const MIN_MUSIC:Number = 0.1;
		
		private static var currentRunningTrack:int = -1;
		
		private static var musicArray:Array = [mainMenuSfx, shopSfx, gameEndingSfx, bossSfx, area1Sfx, area1Sfx, area1Sfx, area2Sfx, area2Sfx, area2Sfx, area3Sfx, area3Sfx, area3Sfx, area4Sfx, area4Sfx, area4Sfx, area5Sfx, area5Sfx, area5Sfx];
		
		public static function PlayMusic(typeOfMusic:int, levelNumber:int = -1):void
		{
			var nextMusic:int = typeOfMusic;
			if (typeOfMusic == LEVEL_MUSIC)
			{
				nextMusic += levelNumber - 1;
			}
			
			if (typeOfMusic == SURVIVAL_MUSIC)
			{
				nextMusic = LEVEL_MUSIC + FP.rand(musicArray.length - LEVEL_MUSIC);
			}
			
			if (nextMusic == currentRunningTrack || nextMusic > musicArray.length)
			{
				return;
			}
			
			StopMusic();
			
			currentRunningTrack = nextMusic;
			musicArray[nextMusic].loop(MAX_MUSIC);
		}
		
		public static function ChangeVolume(newVolume:Number):void
		{
			if (currentRunningTrack != -1)
			{
				musicArray[currentRunningTrack].volume = newVolume;
			}
		}
		
		public static function MuteUnMuteMusic():void
		{
			FP.volume = 1 - FP.volume;
		}
		
		public static function StopMusic():void
		{
			if (currentRunningTrack == -1)
			{
				return;
			}
			
			musicArray[currentRunningTrack].stop();
			currentRunningTrack = -1;
		}
	}

}