package Prototype 
{
	import com.newgrounds.API;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Data;
	import net.flashpunk.World;
	import Prototype.Enemies.BaseEnemyEntity;
	import Prototype.Enemies.Boss.BossGeneratorEntity;
	import Prototype.Enemies.Boss.LittleIronMushroomBossEntity;
	import Prototype.Enemies.EnemyGeneratorEntity;
	import Prototype.Enemies.NormalMushroomEntity;
	import Prototype.Enemies.RunningMushroomEntity;
	import Prototype.HUD.BossHUDDrawerEntity;
	import Prototype.Particles.ParticleGenerator;
	import Prototype.Player.PlayerEntity;
	import Prototype.World.EndGameWorld;
	import Prototype.World.EnterNameWorld;
	import Prototype.World.LevelWorld;
	import Prototype.World.SurvivalWorld;
	import Prototype.World.ThemeWorld;
	import Prototype.World.UpgradeLevelWorld;
	/**
	 * ...
	 * @author Amidos
	 */
	public class GlobalData 
	{
		/**
		 * Global Game Data
		 */
		public static const GAME_WIDTH:int = 320;
		public static const GAME_HEIGHT:int = 240;
		public static const GAME_SCALE:int = 2;
		public static const GAME_TILE_SIZE:int = 16;
		public static const GRAVITY_SPEED:Number = 0.2;
		public static const FRICTION_SPEED:Number = 0.05;
		public static const GAME_SAVE_FILE_NAME:String = "AloneInTheParkSaveGame";
		public static const SPONSOR_URL:String = "http://www.newgrounds.com/games/browse/genre/action-shooter-multidirectional/interval/year/sort/score#interval:all";
		public static var survivalHighScores:Vector.<PlayerData> = new Vector.<PlayerData>();
		public static var storyHighScores:Vector.<PlayerData> = new Vector.<PlayerData>();
		
		/**
		 * Music Objects
		 */
		[Embed(source = "../../assets/Sound/Sfx_Win.mp3")]private static var win:Class;
		[Embed(source = "../../assets/Sound/Sfx_Lose.mp3")]private static var lose:Class;
		private static var winSfx:Sfx = new Sfx(win);
		private static var loseSfx:Sfx = new Sfx(lose);
		
		/**
		 * Current used control scheme
		 */
		public static var controlScheme:int = 0;
		
		/**
		 * Player Object
		 */
		public static var playerEntity:PlayerEntity;
		
		/**
		 * Game Characters
		 */
		public static const NORMAL_PLAYER:int = 0;
		public static const GIRL_PLAYER:int = 1;
		public static const ZOMBIE_PLAYER:int = 2;
		public static const FAT_BOY_PLAYER:int = 3;
		public static const MINECRAFT_PLAYER:int = 4;
		public static const HOLLOW_PLAYER:int = 5;
		public static const VVVVVV_PLAYER:int = 6;
		public static const MAX_CHARACTERS:int = 7;
		
		/**
		 * Player Status
		 */
		public static var characterSelected:int = NORMAL_PLAYER;
		public static var intialPlayerHealth:int = 3;
		public static var playerLives:int = 2;
		public static var playerScore:int = 0;
		public static var playerName:String = "default";
		
		/**
		 * Player level status
		 */
		public static var playerHealthLevel:int = 0;
		public static var weaponLevel:int = 0;
		public static var luckLevel:int = 0;
		public static var reloadLevel:int = 0;
		
		/**
		 * Upgrade max levels
		 */
		public static const MAX_PLAYER_HEALTH_LEVEL:int = 5;
		public static const MAX_WEAPON_LEVEL:int = 5;
		public static const MAX_LUCK_LEVEL:int = 5;
		public static const MAX_RELOAD_LEVEL:int = 5;
		
		/**
		 * Health level
		 */
		public static const HEALTH_LEVEL_INCREMENT:int = 1;
		
		/**
		 * Unlockables
		 */
		public static var lockedCharacters:Vector.<Boolean> = new Vector.<Boolean>();
		public static var achievements:Vector.<Boolean> = new Vector.<Boolean>();
		
		/**
		 * Statistics
		 */
		public static const NORMAL_MUSHROOM:int = 0;
		public static const BIG_MUSHROOM:int = 1;
		public static const SPIT_MUSHROOM:int = 2;
		public static const BIG_SPIT_MUSHROOM:int = 3;
		public static const SHY_MUSHROOM:int = 4;
		public static const FLYING_MUSHROOM:int = 5;
		public static const RUNNING_MUSHROOM:int = 6;
		public static const TALL_RUNNING_MUSHROOM:int = 7;
		public static const LITTLE_IRON_MUSHROOM:int = 8;
		public static const IRON_MUSHROOM:int = 9;
		public static const NUMBER_TYPES_ENEMY:int = 10;
		
		public static const BOSS_1:int = 0;
		public static const BOSS_2:int = 1;
		public static const BOSS_3:int = 2;
		public static const BOSS_4:int = 3;
		public static const BOSS_5:int = 4;
		public static const NUMBER_BOSS:int = 5;
		
		public static const PIZZA_CUTTER:int = 0;
		public static const SPOON:int = 1;
		public static const FORK:int = 2;
		public static const HEART:int = 3;
		public static const SHIELD:int = 4;
		public static const NUMBER_BONUS:int = 5;
		
		public static const NUMBER_OF_ACHIEVEMENTS:int = 12;
		
		public static var enemyKills:Vector.<int> = new Vector.<int>();
		public static var bossKills:Vector.<int> = new Vector.<int>();
		public static var bonusGot:Vector.<int> = new Vector.<int>();
		
		public static var cratesDestroyed:int = 0;
		
		public static var numberOfWins:Vector.<int> = new Vector.<int>();
		public static var numberOfLoses:Vector.<int> = new Vector.<int>();
		public static var numberOfShots:Vector.<int> = new Vector.<int>();
		
		/**
		 * Level Status
		 */
		public static var levelNumber:int = 0;
		public static var FINAL_LEVEL_NUMBER:int = 15;
		
		public static function GameIntializer():void
		{
			// Intialize data before loading
			for (var i:int = 0; i < MAX_CHARACTERS; i++) 
			{
				numberOfWins.push(0);
				numberOfLoses.push(0);
				numberOfShots.push(0);
				
				lockedCharacters.push(true);
			}
			
			for (var m:int = 0; m < NUMBER_OF_ACHIEVEMENTS; m++) 
			{
				achievements.push(false);
			}
			
			for (var j:int = 0; j < NUMBER_TYPES_ENEMY; j++) 
			{
				enemyKills.push(0);
			}
			
			for (var k:int = 0; k < NUMBER_BOSS; k++) 
			{
				bossKills.push(0);
			}
			
			for (var l:int = 0; l < NUMBER_BONUS; l++) 
			{
				bonusGot.push(0);
			}
			
			LoadData();
			
			lockedCharacters[NORMAL_PLAYER] = false;
		}
		
		private static function LoadData():void
		{
			Data.load(GAME_SAVE_FILE_NAME);
			
			cratesDestroyed = Data.readInt("cratesDestroyed");
			
			for (var i:int = 0; i < MAX_CHARACTERS; i++) 
			{
				numberOfWins[i] = Data.readInt("numberOfWins" + i);
				numberOfLoses[i] = Data.readInt("numberOfLoses" + i);
				numberOfShots[i] = Data.readInt("numberOfShots" + i);
				
				lockedCharacters[i] = Data.readBool("lockedCharacters" + i);
			}
			
			for (var j:int = 0; j < NUMBER_TYPES_ENEMY; j++) 
			{
				enemyKills[j] = Data.readInt("enemyKills" + j);
			}
			
			for (var k:int = 0; k < NUMBER_BOSS; k++) 
			{
				bossKills[k] = Data.readInt("bossKills" + k);
			}
			
			for (var l:int = 0; l < NUMBER_BONUS; l++) 
			{
				bonusGot[l] = Data.readInt("bonus" + l);
			}
			
			//for (var m:int = 0; m < NUMBER_OF_ACHIEVEMENTS; m++) 
			//{
				//achievements[m] = Data.readBool("achievements" + m, false);
			//}
		}
		
		public static function SaveData():void
		{
			SaveKills();
			SaveBonuses();
			SaveBosses();
			SaveWinsAndLosesAndCharacters();
			
			Data.save(GAME_SAVE_FILE_NAME);
		}
		
		private static function SaveKills():void
		{
			for (var i:int = 0; i < NUMBER_TYPES_ENEMY; i++) 
			{
				Data.writeInt("enemyKills" + i, enemyKills[i]);
			}
		}
		
		private static function SaveBonuses():void
		{
			Data.writeInt("cratesDestroyed", cratesDestroyed);
			
			for (var i:int = 0; i < NUMBER_BONUS; i++) 
			{
				Data.writeInt("bonus" + i, bonusGot[i]);
			}
		}
		
		private static function SaveBosses():void
		{
			for (var i:int = 0; i < NUMBER_BOSS; i++) 
			{
				Data.writeInt("bossKills" + i, bossKills[i]);
			}
		}
		
		private static function SaveWinsAndLosesAndCharacters():void
		{
			for (var i:int = 0; i < MAX_CHARACTERS; i++) 
			{
				Data.writeInt("numberOfWins" + i, numberOfWins[i]);
				Data.writeInt("numberOfLoses" + i, numberOfLoses[i]);
				Data.writeInt("numberOfShots" + i, numberOfShots[i]);
				
				Data.writeBool("lockedCharacters" + i, lockedCharacters[i]);
			}
			
			for (var m:int = 0; m < NUMBER_OF_ACHIEVEMENTS; m++) 
			{
				Data.writeBool("achievements" + m, achievements[m]);
			}
		}
		
		/**
		 * This function intialize all the data to start with :)
		 */
		public static function Intialize():void
		{
			switch(characterSelected)
			{
				case NORMAL_PLAYER:
					intialPlayerHealth = 3;
					break;
				case GIRL_PLAYER:
					intialPlayerHealth = 3;
					break;
				case ZOMBIE_PLAYER:
					intialPlayerHealth = 3;
					break;
				case FAT_BOY_PLAYER:
					intialPlayerHealth = 5;
					break;
				case MINECRAFT_PLAYER:
					intialPlayerHealth = 1;
					break;
				case HOLLOW_PLAYER:
					intialPlayerHealth = 5;
					break;
				case VVVVVV_PLAYER:
					intialPlayerHealth = 1;
					break;
			}
			
			playerHealthLevel = 0;
			weaponLevel = 0;
			luckLevel = 0;
			reloadLevel = 0;
			playerLives = 2;
			
			levelNumber = 1;
			playerScore = 0;
			
			InitilaizeHighScoreTables();
			
			//Testing
			//levelNumber = 12;
			//luckLevel = 5;
			//weaponLevel = MAX_WEAPON_LEVEL;
			//playerHealthLevel = 1;
			//characterSelected = GlobalData.FAT_BOY_PLAYER;
		}
		
		public static function InitilaizeHighScoreTables():void
		{
			for (var i:int = 0; i < 10; i++) 
			{
				storyHighScores.push(new PlayerData("Noone", "0"));
				survivalHighScores.push(new PlayerData("Noone", "0"));
			}
		}
		
		public static function GetMaxPlayerHealth():int 
		{
			return intialPlayerHealth + playerHealthLevel * HEALTH_LEVEL_INCREMENT;
		}
		
		public static function CheckAchievements():void
		{
			var enemies:int = 0;
			var i:int = 0;
			for (i = 0; i < enemyKills.length; i++)
			{
				enemies += enemyKills[i];
			}
			
			if (enemies >= 50 && !achievements[0])
			{
				achievements[0] = true;
				API.unlockMedal("Mushroom Hater");
			}
			
			if (enemies >= 500 && !achievements[1])
			{
				achievements[1] = true;
				API.unlockMedal("Mushroom Killer");
			}
			
			if (enemies >= 5000 && !achievements[2])
			{
				achievements[2] = true;
				API.unlockMedal("Mushroom Apocalypse");
			}
			
			var deaths:int = 0;
			var playedTimes:int = 0;
			for (i = 0; i < numberOfLoses.length; i++) 
			{
				deaths += numberOfLoses[i];
				playedTimes += numberOfLoses[i];
			}
			
			if (deaths >= 10 && !achievements[3])
			{
				achievements[3] = true;
				API.unlockMedal("Loser");
			}
			
			var wins:int = 0;
			var allWins:Boolean = true;
			for (i = 0; i < numberOfWins.length; i++)
			{
				wins += numberOfWins[i];
				playedTimes += numberOfWins[i];
				
				if (numberOfWins[i] <= 0)
				{
					allWins = false;
				}
			}
			
			if (wins >= 2 && !achievements[4])
			{
				achievements[4] = true;
				API.unlockMedal("Winner");
			}
			
			if (allWins && !achievements[5])
			{
				achievements[5] = true;
				API.unlockMedal("Total Winner");
			}
			
			if (playedTimes >= 5 && !achievements[6])
			{
				achievements[6] = true;
				API.unlockMedal("Game Lover");
			}
			
			var unlocked:int = 0;
			for (i = 0; i < lockedCharacters.length; i++)
			{
				if (!lockedCharacters[i])
				{
					unlocked += 1;
				}
			}
			
			if (unlocked >= 3 && !achievements[7])
			{
				achievements[7] = true;
				API.unlockMedal("Unlocker");
			}
			
			if (unlocked >= lockedCharacters.length && !achievements[8])
			{
				achievements[8] = true;
				API.unlockMedal("Master Unlocker");
			}
			
			if (cratesDestroyed >= 10 && !achievements[9])
			{
				achievements[9] = true;
				API.unlockMedal("Little Collector");
			}
			
			if (cratesDestroyed >= 100 && !achievements[10])
			{
				achievements[10] = true;
				API.unlockMedal("Collector");
			}
			
			if (cratesDestroyed >= 500 && !achievements[11])
			{
				achievements[11] = true;
				API.unlockMedal("Master Collector");
			}
		}
		
		public static function CheckWinCondition():Boolean
		{
			var enemyCount:int = 0;
			
			enemyCount = FP.world.typeCount(CollisionNames.ENEMY_COLLISION_NAME) + FP.world.typeCount(CollisionNames.ENEMY_SHOT_NAME);
			enemyCount += FP.world.classCount(EnemyGeneratorEntity);
			enemyCount += FP.world.classCount(BossGeneratorEntity);
			
			if (enemyCount == 0)
			{
				return true;
			}
			
			return false;
		}
		
		public static function GameOver(world:World = null):void
		{
			ParticleGenerator.GenerateLevelWords(GAME_WIDTH / 2, GAME_HEIGHT / 2, "Game Over", 24, world);
			
			var currentWorld:World = FP.world;
			if(world)
			{
				currentWorld = world;
			}
			
			var levelWorld:LevelWorld = currentWorld as LevelWorld;
			var survivalWorld:SurvivalWorld = currentWorld as SurvivalWorld;
			
			if (levelWorld != null)
			{
				levelWorld.nextWorld = new EnterNameWorld(false);
				levelWorld.playerAddAlarm.cancel();
				levelWorld.transitionAlarm.start();
			}
			
			if (survivalWorld != null)
			{
				survivalWorld.nextWorld = new EnterNameWorld(true);
				survivalWorld.playerAddAlarm.cancel();
				survivalWorld.transitionAlarm.start();
			}
			
			MusicPlayer.StopMusic();
			loseSfx.play();
			
			numberOfLoses[characterSelected] += 1;
			CheckAchievements();
			SaveData();
		}
		
		public static function IsFinalLevel():Boolean
		{
			return levelNumber == FINAL_LEVEL_NUMBER;
		}
		
		public static function IsUpgradesFinished():Boolean
		{
			return (playerHealthLevel == MAX_PLAYER_HEALTH_LEVEL) && (weaponLevel == MAX_WEAPON_LEVEL) && 
					(reloadLevel == MAX_RELOAD_LEVEL) && (luckLevel == MAX_LUCK_LEVEL);
		}
		
		public static function LevelComplete():void
		{
			ParticleGenerator.GenerateLevelWords(GAME_WIDTH / 2, GAME_HEIGHT / 2, "Level Complete", 24);
			
			if (IsFinalLevel())
			{
				(FP.world as LevelWorld).nextWorld = new EndGameWorld();
				numberOfWins[characterSelected] += 1;
				
				//Unlock sister
				API.unlockMedal("Sarah - The Sister");
				lockedCharacters[GlobalData.GIRL_PLAYER] = false;
								
				//Unlock Zombie
				if (characterSelected == GlobalData.GIRL_PLAYER && playerHealthLevel == 0)
				{
					API.unlockMedal("Johny - The Zombie Cook");
					lockedCharacters[GlobalData.ZOMBIE_PLAYER] = false;
				}
			}
			else if (IsUpgradesFinished())
			{
				levelNumber += 1;
				(FP.world as LevelWorld).nextWorld = null;
			}
			else
			{
				(FP.world as LevelWorld).nextWorld = new UpgradeLevelWorld();
			}
			
			(FP.world as LevelWorld).transitionAlarm.start();
			
			MusicPlayer.StopMusic();
			winSfx.play();
			
			CheckAchievements();
			SaveData();
		}
		
		public static function GetCurrentUpgrades():int
		{
			return playerHealthLevel + luckLevel + weaponLevel + reloadLevel;
		}
		
		/**
		 * Restart the player again
		 */
		public static function RestartPlayerAgain():void
		{
			var levelWorld:LevelWorld = FP.world as LevelWorld;
			var survivalWorld:SurvivalWorld = FP.world as SurvivalWorld;
			
			if (levelWorld)
			{
				levelWorld.playerAddAlarm.start();
			}
			
			if (survivalWorld)
			{
				survivalWorld.playerAddAlarm.start();
			}
		}
		
		/**
		 * Start level with
		 */
		public static function StartLevel():void
		{
			ParticleGenerator.GenerateLevelWords(GAME_WIDTH / 2, GAME_HEIGHT / 2, "Level " + levelNumber + " Starts", 24);
			
			FP.world = new LevelWorld(MapGetter.GetMap(levelNumber));
			
			MusicPlayer.PlayMusic(MusicPlayer.LEVEL_MUSIC, levelNumber);
		}
		
		/**
		 * this function calculates the correct layer of entity where low value y 
		 * are on lower layer than higher ones
		 * @param	y y position of entity
		 * @return the correct layer depth
		 */
		public static function GetLayer(y:int):int
		{
			return LayerConstant.ROOM_MAX_HEIGHT - y;
		}
		
		public static function EndThemeWorld(nextWorld:World):void
		{
			if (nextWorld == null)
			{
				(FP.world as ThemeWorld).startNewGame = true;
			}
			
			(FP.world as ThemeWorld).nextWorld = nextWorld;
			(FP.world as ThemeWorld).EndWorld();
		}
		
		public static function ShowBossData(maxHealth:int):void
		{
			var bossHUD:BossHUDDrawerEntity = (FP.world as LevelWorld).bossHUD;
			
			ParticleGenerator.GenerateLevelWords(GAME_WIDTH / 2, GAME_HEIGHT / 2, "Boss Battle", 24);
			
			if (!(FP.world.classCount(PlayerEntity) <= 0 && playerLives <= 0))
			{
				MusicPlayer.PlayMusic(MusicPlayer.BOSS_MUSIC);
			}
			
			bossHUD.enabled = true;
			bossHUD.maxBossHealth = maxHealth;
		}
		
		public static function RefreshMaxHealth(maxHealth:int):void
		{
			var bossHUD:BossHUDDrawerEntity = (FP.world as LevelWorld).bossHUD;
			
			bossHUD.maxBossHealth = maxHealth;
		}
		
		public static function UpdateBossHUD(health:int):void
		{
			(FP.world as LevelWorld).bossHUD.bossHealth = health;
		}
		
		public static function BossKilled():void
		{
			(FP.world as LevelWorld).bossHUD.enabled = false;
			
			var array:Array = new Array();
			var i:int = 0;
			
			FP.world.getClass(NormalMushroomEntity, array);
			
			for (i = 0; i < array.length; i += 1)
			{
				array[i].DestroyEnemy(1);
			}
			
			FP.world.getClass(RunningMushroomEntity, array);
			
			for (i = 0; i < array.length; i += 1)
			{
				array[i].DestroyEnemy(1);
			}
			
			FP.world.getClass(LittleIronMushroomBossEntity, array);
			
			for (i = 0; i < array.length; i += 1)
			{
				array[i].DestroyEnemy(1);
			}
		}
		
		public static function GetTotalNumberOfShots():int
		{
			var totalShots:int = 0;
			for (var i:int = 0; i < numberOfShots.length; i++)
			{
				totalShots += numberOfShots[i];
			}
			
			return totalShots;
		}
	}

}