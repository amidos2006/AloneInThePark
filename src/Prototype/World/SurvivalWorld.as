package Prototype.World 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import Prototype.BonusObject.BoxGeneratorEntity;
	import Prototype.CollisionNames;
	import Prototype.Enemies.*;
	import Prototype.GlobalData;
	import Prototype.HUD.HUDDrawerEntity;
	import Prototype.Interface.MuteEntity;
	import Prototype.LayerConstant;
	import Prototype.MapGetter;
	import Prototype.MusicPlayer;
	import Prototype.Particles.ParticleGenerator;
	import Prototype.Player.PlayerEntity;
	/**
	 * ...
	 * @author Amidos
	 */
	public class SurvivalWorld extends World
	{
		[Embed(source = "../../../assets/Graphics/tileSet.png")]private var tileClass:Class;
		
		private const NORMAL:String = "Normal";
		private const APPEAR:String = "Appear";
		private const DISAPPEAR:String = "Disappear";
		
		private var tiles:Tilemap;
		private var grid:Grid;
		private var playerX:int;
		private var playerY:int;
		
		private var transitionHeight:int;
		private var speed:int;
		private var status:String;
		private var boxGenerator:BoxGeneratorEntity;
		private var hudDrawer:HUDDrawerEntity;
		private var upgradeAlarm:Alarm;
		private var upgradeTimes:Array = [1200, 1500, 1800, 2400, 2400, 2800, 2800, 3600, 3600, 4000, 4800, 4800, 5600, 5600, 6000, 6000, 6400, 6400, 6400, 6400];
		
		public var nextWorld:World;
		public var numberOfPoints:int = 0;
		
		public var playerAddAlarm:Alarm = new Alarm(100, AddPlayer, Tween.PERSIST);
		public var transitionAlarm:Alarm = new Alarm(200, GoToWorld, Tween.PERSIST);
		
		public function SurvivalWorld() 
		{
			var levelXml:XML = MapGetter.GetRandomTheme();
			var enemiesXml:XML = MapGetter.GetSurvivalMap();
			
			LoadTiles(levelXml);
			LoadGrid(levelXml);
			LoadObjects(enemiesXml);
			
			addTween(playerAddAlarm);
			addTween(transitionAlarm);
			
			hudDrawer = new HUDDrawerEntity();
			hudDrawer.isSurvival = true;
			add(hudDrawer);
			
			upgradeAlarm = new Alarm(upgradeTimes[GlobalData.GetCurrentUpgrades()], IncrementPoints, Tween.PERSIST);
			addTween(upgradeAlarm, true);
			
			boxGenerator = new BoxGeneratorEntity();
			add(boxGenerator);
			
			transitionHeight = GlobalData.GAME_HEIGHT / 2;
			speed = 4;
			status = APPEAR;
			
			MusicPlayer.PlayMusic(MusicPlayer.SURVIVAL_MUSIC);
		}
		
		private function LoadTiles(levelXml:XML):void
		{
			tiles = new Tilemap(tileClass, GlobalData.GAME_WIDTH, GlobalData.GAME_HEIGHT, GlobalData.GAME_TILE_SIZE, GlobalData.GAME_TILE_SIZE);
			
			var o:Object;
			
			if ("tileLayer" in levelXml)
			{
				for each(o in levelXml.tileLayer[0].tile)
				{
					var col:int = Math.round(o.@x / GlobalData.GAME_TILE_SIZE);
					var row:int = Math.round(o.@y / GlobalData.GAME_TILE_SIZE);
					
					tiles.setTile(col, row, o.@id);
				}
			}
			
			addGraphic(tiles, LayerConstant.TILE_LAYER);
		}
		
		private function LoadGrid(levelXml:XML):void
		{
			grid = new Grid(GlobalData.GAME_WIDTH, GlobalData.GAME_HEIGHT, GlobalData.GAME_TILE_SIZE, GlobalData.GAME_TILE_SIZE);
			
			if("solid" in levelXml)
			{
				grid.loadFromString(levelXml.solid[0], "", "-");
			}
			
			addMask(grid, CollisionNames.SOLID_COLLISION_NAME);
		}
		
		private function LoadObjects(levelXml:XML):void
		{
			var o:Object;
			
			if ("objectLayer" in levelXml)
			{
				o = levelXml.objectLayer[0];
				
				LoadPlayer(o);
				LoadEnemyGenerator(o);
			}
		}
		
		private function LoadEnemyGenerator(o:Object):void
		{
			var temp:Object;
			
			if ("normalMushroomGenerator" in o)
			{
				for each(temp in o.normalMushroomGenerator)
				{
					add(new EnemyGeneratorEntity(temp.@startingTime ,temp.@interGenerationTime, temp.@randomPeriod, temp.@numberOfGeneratedObjects, NormalMushroomEntity));
				}
			}
			
			if ("bigMushroomGenerator" in o)
			{
				for each(temp in o.bigMushroomGenerator)
				{
					add(new EnemyGeneratorEntity(temp.@startingTime ,temp.@interGenerationTime, temp.@randomPeriod, temp.@numberOfGeneratedObjects, BigMushroomEntity));
				}
			}
			
			if ("flyingMushroomGenerator" in o)
			{
				for each(temp in o.flyingMushroomGenerator)
				{
					add(new EnemyGeneratorEntity(temp.@startingTime ,temp.@interGenerationTime, temp.@randomPeriod, temp.@numberOfGeneratedObjects, FlyingMushroomEntity));
				}
			}
			
			if ("spitMushroomGenerator" in o)
			{
				for each(temp in o.spitMushroomGenerator)
				{
					add(new EnemyGeneratorEntity(temp.@startingTime ,temp.@interGenerationTime, temp.@randomPeriod, temp.@numberOfGeneratedObjects, SpitMushromEntity));
				}
			}
			
			if ("littleIronMushroomGenerator" in o)
			{
				for each(temp in o.littleIronMushroomGenerator)
				{
					add(new EnemyGeneratorEntity(temp.@startingTime ,temp.@interGenerationTime, temp.@randomPeriod, temp.@numberOfGeneratedObjects, LittleIronMushroomEntity));
				}
			}
			
			if ("ironMushroomGenerator" in o)
			{
				for each(temp in o.ironMushroomGenerator)
				{
					add(new EnemyGeneratorEntity(temp.@startingTime ,temp.@interGenerationTime, temp.@randomPeriod, temp.@numberOfGeneratedObjects, IronMushroomEntity));
				}
			}
			
			if ("runningMushroomGenerator" in o)
			{
				for each(temp in o.runningMushroomGenerator)
				{
					add(new EnemyGeneratorEntity(temp.@startingTime ,temp.@interGenerationTime, temp.@randomPeriod, temp.@numberOfGeneratedObjects, RunningMushroomEntity));
				}
			}
			
			if ("tallRunningMushroomGenerator" in o)
			{
				for each(temp in o.tallRunningMushroomGenerator)
				{
					add(new EnemyGeneratorEntity(temp.@startingTime ,temp.@interGenerationTime, temp.@randomPeriod, temp.@numberOfGeneratedObjects, TallRunningMushroomEntity));
				}
			}
			
			if ("bigSpitMushroomGenerator" in o)
			{
				for each(temp in o.bigSpitMushroomGenerator)
				{
					add(new EnemyGeneratorEntity(temp.@startingTime ,temp.@interGenerationTime, temp.@randomPeriod, temp.@numberOfGeneratedObjects, BigSpitMushroomEntity));
				}
			}
			
			if ("shyMushroomGenerator" in o)
			{
				for each(temp in o.shyMushroomGenerator)
				{
					add(new EnemyGeneratorEntity(temp.@startingTime ,temp.@interGenerationTime, temp.@randomPeriod, temp.@numberOfGeneratedObjects, ShyMushroomEntity));
				}
			}
		}
		
		public function RefreshAfterShop(health:int = 0):void
		{
			remove(boxGenerator);
				
			boxGenerator = new BoxGeneratorEntity();
			add(boxGenerator);
			
			GlobalData.playerEntity.RefreshPlayerAttributes(health);
		}
		
		private function AddPlayer():void
		{
			GlobalData.playerEntity = new PlayerEntity(playerX, playerY);
			
			add(GlobalData.playerEntity);
			
			GlobalData.playerEntity.PlayerAppearAgain();
		}
		
		private function LoadPlayer(o:Object):void
		{
			if ("player" in o)
			{
				playerX = o.player[0].@x;
				playerY = o.player[0].@y
				GlobalData.playerEntity = new PlayerEntity(playerX, playerY);
				add(GlobalData.playerEntity);
			}
		}
		
		private function IncrementPoints():void
		{
			var player:PlayerEntity = GlobalData.playerEntity;
			
			if (GlobalData.playerLives > 0 || (GlobalData.playerLives == 0 && player))
			{
				numberOfPoints += 1;
				ParticleGenerator.GenerateLevelWords(GlobalData.GAME_WIDTH / 2, GlobalData.GAME_HEIGHT / 2, "Upgrade points++", 16);
			}
			
			var nextAlarmTime:int = numberOfPoints + GlobalData.GetCurrentUpgrades();
			if (nextAlarmTime < upgradeTimes.length)
			{
				upgradeAlarm.reset(upgradeTimes[nextAlarmTime]);
				upgradeAlarm.start();
			}
		}
		
		override public function begin():void 
		{
			super.begin();
			
			var muteButton:MuteEntity = new MuteEntity();
			muteButton.x = FP.width;
			muteButton.y = FP.height - 6;
				
			add(muteButton);
		}
		
		private function GoToWorld():void
		{
			status = DISAPPEAR;
		}
		
		private function Appear():void
		{
			transitionHeight -= speed;
			if (transitionHeight < 0)
			{
				transitionHeight = 0;
				status = NORMAL;
			}
		}
		
		private function Disappear():void
		{
			transitionHeight += speed;
			if (transitionHeight > GlobalData.GAME_HEIGHT / 2)
			{
				transitionHeight = GlobalData.GAME_HEIGHT / 2;
				
				if (nextWorld == null)
				{
					GlobalData.StartLevel();
				}
				else
				{
					FP.world = nextWorld;
				}
			}
		}
		
		override public function update():void 
		{
			super.update();
			GlobalData.CheckAchievements();
			
			if (status == APPEAR)
			{
				Appear();
			}
			
			if(status == DISAPPEAR)
			{
				Disappear();
			}
			
			hudDrawer.showSurvival = false;
			if (numberOfPoints > 0)
			{
				hudDrawer.showSurvival = true;
			}
			
			if(numberOfPoints > 0 && GlobalData.playerEntity && Input.pressed(Key.ENTER))
			{
				FP.world = new SurvivalUpgradeWorld(new Image(FP.buffer), numberOfPoints, this);
				Input.clear();
			}
			
			if (Input.pressed(Key.ESCAPE) && !transitionAlarm.active && status == NORMAL)
			{
				FP.world = new PauseWorld(new Image(FP.buffer), this);
			}
		}
		
		override public function render():void 
		{
			super.render();
			
			FP.buffer.fillRect(new Rectangle(0, 0, GlobalData.GAME_WIDTH, transitionHeight), 0x000000);
			FP.buffer.fillRect(new Rectangle(0, GlobalData.GAME_HEIGHT - transitionHeight, GlobalData.GAME_WIDTH, transitionHeight), 0x000000);
		}
	}

}