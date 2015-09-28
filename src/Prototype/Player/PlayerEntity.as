package Prototype.Player 
{
	import com.newgrounds.API;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.masks.Hitbox;
	import net.flashpunk.masks.Masklist;
	import net.flashpunk.Sfx;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import Prototype.CollisionNames;
	import Prototype.GlobalData;
	import Prototype.Particles.ParticleGenerator;
	/**
	 * ...
	 * @author Amidos
	 */
	public class PlayerEntity extends Entity
	{
		[Embed(source = "../../../assets/Graphics/Player.png")]private var playerSheet:Class;
		[Embed(source = "../../../assets/Graphics/playerGirl.png")]private var girlSheet:Class;
		[Embed(source = "../../../assets/Graphics/playerZombie.png")]private var zombieSheet:Class;
		[Embed(source = "../../../assets/Graphics/playerFat.png")]private var fatSheet:Class;
		[Embed(source = "../../../assets/Graphics/playerMineCraft.png")]private var minecraftSheet:Class;
		[Embed(source = "../../../assets/Graphics/PlayerHollow.png")]private var hollowSheet:Class;
		[Embed(source = "../../../assets/Graphics/PlayerVVVVVV.png")]private var vvvvvvSheet:Class;
		
		[Embed(source = "../../../assets/Sound/playerHit.mp3")]private var playerHitClass:Class;
		[Embed(source = "../../../assets/Sound/playerDeath.mp3")]private var playerDeathClass:Class;
		[Embed(source = "../../../assets/Sound/shoot.mp3")]private var playerShootClass:Class;
		
		public static const PLAYER_MOVING:String = "Moving";
		public static const PLAYER_STANDING:String = "Standing";
		
		public static const PLAYER_ATTACKING:String = "Attacking";
		public static const PLAYER_IDLE:String = "Idle";
		
		public static const PLAYER_RIGHT:int = 0;
		public static const PLAYER_LEFT:int = 1;
		public static const PLAYER_UP:int = 2;
		public static const PLAYER_DOWN:int = 3;
		
		private const SHEET_WIDTH:int = 4;
		private const NUMBER_OF_DIRECTIONS:int = 4;
		private const FRAME_RATE:Number = 0.16;
		private const HIT_TIME:Number = 90;
		private const FLASH_INTERVAL:Number = 5;
		
		private var baseReloadTime:int = 30;
		private const RELOAD_LEVEL_DECREMENT:int = 4;
		
		private const MOVE_LEFT:String = "left";
		private const MOVE_RIGHT:String = "right";
		private const MOVE_UP:String = "up";
		private const MOVE_DOWN:String = "down";
		private const SHOOT:String = "shoot";
		
		private var spriteMap:Spritemap;
		
		public var movingStatus:String;
		public var firingStatus:String;
		public var direction:int;
		
		public var playerSpeed:Number = 1.2;
		
		private var velocityVector:Point;
		private var canShoot:Boolean = true;
		private var numberOfShots:int = 0;
		private var vibration:Number = 0;
		private var vibrationSpeed:Number = 0.3;
		
		//Player Status
		public var currentPlayerHealth:int;
		
		private var shootingAlarm:Alarm;
		
		private var isHitted:Boolean = false;
		private var shieldEnable:Boolean = false;
		private var bonusWeapon:Boolean = false;
		private var shieldAlarm:Alarm;
		private var hitAlarm:Alarm;
		private var flashAlarm:Alarm;
		private var shootingWeapon:Class;
		private var shotsText:Text;
		private var shieldText:Text;
		
		private var levelComplete:Boolean = false;
		private var playerHitSfx:Sfx;
		private var playerDeathSfx:Sfx;
		private var playerShootSfx:Sfx;
		
		public function PlayerEntity(startingX:int, startingY:int) 
		{
			IntializeGraphics();
			IntializeLogic(startingX, startingY);
			IntializeControls();
		}
		
		private function IntializeLogic(startingX:int, startingY:int):void
		{
			switch(GlobalData.characterSelected)
			{
				case GlobalData.NORMAL_PLAYER:
					playerSpeed *= 1;
					baseReloadTime *= 1;
					break;
				case GlobalData.GIRL_PLAYER:
					playerSpeed *= 1.25;
					baseReloadTime *= 1;
					break;
				case GlobalData.ZOMBIE_PLAYER:
					playerSpeed *= 0.75;
					baseReloadTime *= 1;
					break;
				case GlobalData.FAT_BOY_PLAYER:
					playerSpeed *= 0.75;
					baseReloadTime *= 1;
					break;
				case GlobalData.MINECRAFT_PLAYER:
					playerSpeed *= 1;
					baseReloadTime *= 1;
					break;
				case GlobalData.HOLLOW_PLAYER:
					playerSpeed *= 1;
					baseReloadTime *= 1;
					break;
				case GlobalData.VVVVVV_PLAYER:
					playerSpeed *= 1.25;
					baseReloadTime *= 1;
					break;
			}
			
			x = startingX;
			y = startingY;
			
			velocityVector = new Point();
			
			movingStatus = PLAYER_STANDING;
			firingStatus = PLAYER_IDLE;
			direction = PLAYER_LEFT;
			
			shootingAlarm = new Alarm(baseReloadTime - GlobalData.reloadLevel * RELOAD_LEVEL_DECREMENT, EnableShoot, Tween.PERSIST);
			addTween(shootingAlarm);
			
			hitAlarm = new Alarm(HIT_TIME, EndFlashing, Tween.PERSIST);
			flashAlarm = new Alarm(FLASH_INTERVAL, FlashPlayer, Tween.PERSIST);
			
			addTween(hitAlarm);
			addTween(flashAlarm);
			
			shieldAlarm = new Alarm(600, DisableShield, Tween.PERSIST);
			addTween(shieldAlarm);
			
			currentPlayerHealth = GlobalData.GetMaxPlayerHealth();
			
			setHitbox(spriteMap.width - 6, spriteMap.height - 10, spriteMap.originX - 2, spriteMap.originY - 10);
			
			GetPlayerIntialWeapon();
			
			type = CollisionNames.PLAYER_COLLISION_NAME;
		}
		
		private function GetPlayerIntialWeapon():void
		{
			switch(GlobalData.characterSelected)
			{
				case GlobalData.NORMAL_PLAYER:
					shootingWeapon = KnifeEntity;
					break;
				case GlobalData.GIRL_PLAYER:
					shootingWeapon = LipstickEntity;
					break;
				case GlobalData.ZOMBIE_PLAYER:
					shootingWeapon = BloodyKnifeEntity;
					break;
				case GlobalData.FAT_BOY_PLAYER:
					shootingWeapon = HotdogEntity;
					break;
				case GlobalData.MINECRAFT_PLAYER:
					shootingWeapon = AxeEntity;
					break;
				case GlobalData.HOLLOW_PLAYER:
					shootingWeapon = ToothEntity;
					break;
				case GlobalData.VVVVVV_PLAYER:
					shootingWeapon = LaserEntity;
					break;
			}
			
			RefreshFireRate();
		}
		
		private function FlashPlayer():void
		{
			if (isHitted)
			{
				spriteMap.alpha = 1 - spriteMap.alpha;
				flashAlarm.start();
			}
			else
			{
				spriteMap.alpha = 1;
			}
		}
		
		private function EndFlashing():void
		{
			isHitted = false;
			spriteMap.alpha = 1;
		}
		
		private function IntializeControls():void
		{	
			//New Controls system
			if (GlobalData.controlScheme == 0)
			{
				Input.define(MOVE_LEFT, Key.A);
				Input.define(MOVE_RIGHT, Key.D);
				Input.define(MOVE_UP, Key.W);
				Input.define(MOVE_DOWN, Key.S);
				Input.define(SHOOT + PLAYER_LEFT, Key.LEFT);
				Input.define(SHOOT + PLAYER_RIGHT, Key.RIGHT);
				Input.define(SHOOT + PLAYER_UP, Key.UP);
				Input.define(SHOOT + PLAYER_DOWN, Key.DOWN);
			}
			else if(GlobalData.controlScheme == 1)
			{
				Input.define(MOVE_LEFT, Key.LEFT);
				Input.define(MOVE_RIGHT, Key.RIGHT);
				Input.define(MOVE_UP, Key.UP);
				Input.define(MOVE_DOWN, Key.DOWN);
				Input.define(SHOOT + PLAYER_LEFT, Key.A);
				Input.define(SHOOT + PLAYER_RIGHT, Key.D);
				Input.define(SHOOT + PLAYER_UP, Key.W);
				Input.define(SHOOT + PLAYER_DOWN, Key.S);
			}
			else if (GlobalData.controlScheme == 2)
			{
				Input.define(MOVE_LEFT, Key.LEFT, Key.A);
				Input.define(MOVE_RIGHT, Key.RIGHT, Key.D);
				Input.define(MOVE_UP, Key.UP, Key.W);
				Input.define(MOVE_DOWN, Key.DOWN, Key.S);
			}
			else if (GlobalData.controlScheme == 3)
			{
				//Old Controls
				Input.define(MOVE_LEFT, Key.LEFT, Key.A);
				Input.define(MOVE_RIGHT, Key.RIGHT, Key.D);
				Input.define(MOVE_UP, Key.UP, Key.W);
				Input.define(MOVE_DOWN, Key.DOWN, Key.S);
				Input.define(SHOOT, Key.SPACE);
			}
		}
		
		public function ApplyWeapon(weaponClass:Class, weaponShots:int):void
		{
			shootingWeapon = weaponClass;
			numberOfShots = weaponShots;
			bonusWeapon = true;
			
			RefreshFireRate();
		}
		
		public function ApplyShield():void
		{
			shieldEnable = true;
			shieldAlarm.start();
		}
		
		private function DisableShield():void
		{
			shieldEnable = false;
		}
		
		public function ApplyHealth():Boolean
		{
			if (currentPlayerHealth == GlobalData.GetMaxPlayerHealth())
			{
				return false;
			}
			
			currentPlayerHealth += 1;
			return true;
		}
		
		private function IntializeGraphics():void
		{
			switch(GlobalData.characterSelected)
			{
				case GlobalData.NORMAL_PLAYER:
					spriteMap = new Spritemap(playerSheet, 16, 16);
					break;
				case GlobalData.GIRL_PLAYER:
					spriteMap = new Spritemap(girlSheet, 16, 16);
					break;
				case GlobalData.ZOMBIE_PLAYER:
					spriteMap = new Spritemap(zombieSheet, 16, 16);
					break;
				case GlobalData.FAT_BOY_PLAYER:
					spriteMap = new Spritemap(fatSheet, 16, 16);
					break;
				case GlobalData.MINECRAFT_PLAYER:
					spriteMap = new Spritemap(minecraftSheet, 16, 16);
					break;
				case GlobalData.HOLLOW_PLAYER:
					spriteMap = new Spritemap(hollowSheet, 16, 16);
					break;
				case GlobalData.VVVVVV_PLAYER:
					spriteMap = new Spritemap(vvvvvvSheet, 16, 16);
					break;
			}
			
			var i:int = 0;
			for (i = 0; i < NUMBER_OF_DIRECTIONS; i += 1)
			{
				spriteMap.add(PLAYER_STANDING + PLAYER_IDLE + i, [i * SHEET_WIDTH], FRAME_RATE);
			}
			
			for (i = 0; i < NUMBER_OF_DIRECTIONS; i += 1)
			{
				spriteMap.add(PLAYER_STANDING + PLAYER_ATTACKING + i, [i * SHEET_WIDTH], FRAME_RATE);
			}
			
			for (i = 0; i < NUMBER_OF_DIRECTIONS; i += 1)
			{
				spriteMap.add(PLAYER_MOVING + PLAYER_IDLE + i, [i * SHEET_WIDTH, i * SHEET_WIDTH + 1, i * SHEET_WIDTH + 2, i * SHEET_WIDTH + 3, i * SHEET_WIDTH + 2, i * SHEET_WIDTH + 1], FRAME_RATE);
			}
			
			for (i = 0; i < NUMBER_OF_DIRECTIONS; i += 1)
			{
				spriteMap.add(PLAYER_MOVING + PLAYER_ATTACKING + i, [i * SHEET_WIDTH, i * SHEET_WIDTH + 1, i * SHEET_WIDTH + 2, i * SHEET_WIDTH + 3, i * SHEET_WIDTH + 2, i * SHEET_WIDTH + 1], FRAME_RATE);
			}
			
			spriteMap.originX = spriteMap.width / 2;
			spriteMap.originY = spriteMap.height - 2;
			
			Text.size = 8;
			shotsText = new Text("shots: 30");
			shieldText = new Text("shield: 10");
			
			shotsText.centerOO();
			shieldText.centerOO();
			
			playerDeathSfx = new Sfx(playerDeathClass);
			playerHitSfx = new Sfx(playerHitClass);
			playerShootSfx = new Sfx(playerShootClass);
			
			graphic = spriteMap;
			layer = GlobalData.GetLayer(y);
		}
		
		private function EnableShoot():void
		{
			canShoot = true;
		}
		
		private function FireWeapon():void
		{
			firingStatus = PLAYER_ATTACKING;
			
			if (canShoot)
			{
				var tempWeapon:Entity;
				
				if (numberOfShots > 0)
				{
					numberOfShots -= 1;
				}
				
				switch(direction)
				{
					case PLAYER_RIGHT:
						tempWeapon = new shootingWeapon(x, y, 1, 0);
						break;
					case PLAYER_LEFT:
						tempWeapon = new shootingWeapon(x, y, -1, 0);
						break;
					case PLAYER_UP:
						tempWeapon = new shootingWeapon(x, y, 0, -1);
						break;
					case PLAYER_DOWN:
						tempWeapon = new shootingWeapon(x, y, 0, 1);
						break;
				}
				
				canShoot = false;
				shootingAlarm.start();
				
				playerShootSfx.play(0.25);
				
				FP.world.add(tempWeapon);
				
				GlobalData.numberOfShots[GlobalData.characterSelected] += 1;
				
				//Unlock MineCraft
				if (GlobalData.GetTotalNumberOfShots() >= 10000)
				{
					GlobalData.lockedCharacters[GlobalData.MINECRAFT_PLAYER] = false;
					API.unlockMedal("Notch - The Miner");
				}
			}
		}
		
		private function UpdateGraphics():void
		{
			spriteMap.play(movingStatus + firingStatus + direction);
			
			vibration += vibrationSpeed;
			if ((vibration > 3 && vibrationSpeed > 0) || (vibration < 0 && vibrationSpeed < 0))
			{
				vibrationSpeed *= -1;
			}
			
			shieldText.text = "shield: " + Math.ceil(shieldAlarm.remaining / 60);
			shieldText.centerOO();
			
			shotsText.text = "shots: " + numberOfShots;
			shotsText.centerOO();
			
			layer = GlobalData.GetLayer(y);
		}
		
		private function UpdateControls():void
		{
			velocityVector.x = 0;
			velocityVector.y = 0;
			firingStatus = PLAYER_IDLE;
			
			if (Input.check(MOVE_LEFT))
			{
				velocityVector.x = -playerSpeed;
			}
			
			if (Input.check(MOVE_RIGHT))
			{
				velocityVector.x = playerSpeed;
			}
			
			if (Input.check(MOVE_UP))
			{
				velocityVector.y = -playerSpeed;
			}
			
			if (Input.check(MOVE_DOWN))
			{
				velocityVector.y = playerSpeed;
			}
			
			if (velocityVector.x != 0 && velocityVector.y != 0)
			{
				velocityVector.x *= 0.7071;
				velocityVector.y *= 0.7071;
			}
			
			//New System
			if (GlobalData.controlScheme == 0 || GlobalData.controlScheme == 1)
			{
				for (var i:int = 0; i < 4; i++) 
				{
					if (Input.check(SHOOT + i))
					{
						direction = i;
						FireWeapon();
						break;
					}
				}
			}
			else if (GlobalData.controlScheme == 2)
			{
				if (Input.mouseDown)
				{
					var angle:Number = FP.angle(x, y, Input.mouseX, Input.mouseY);
					if (angle > 45 && angle <= 135)
					{
						direction = PLAYER_UP;
					}
					else if (angle > 135 && angle <= 225)
					{
						direction = PLAYER_LEFT;
					}
					else if(angle > 225 && angle <= 315)
					{
						direction = PLAYER_DOWN;
					}
					else
					{
						direction = PLAYER_RIGHT;
					}
					
					FireWeapon();
				}
			}
			else if (GlobalData.controlScheme == 3)
			{
				//Old System
				if (Input.check(SHOOT))
				{
					FireWeapon();
				}
			}
		}
		
		public function DestroyPlayer(world:World = null):void
		{
			var currentWorld:World = FP.world;
			if (world)
			{
				currentWorld = world;
			}
			
			currentWorld.remove(this);
			
			playerDeathSfx.play();
			
			ParticleGenerator.GenerateDeathParticles(x, y + 2, 0xFF000000, 2.7, world);
			
			GlobalData.playerEntity = null;
			
			if (GlobalData.playerLives > 0)
			{
				GlobalData.playerLives -= 1;
				
				GlobalData.RestartPlayerAgain();
			}
			else
			{
				GlobalData.GameOver(world);
			}
		}
		
		public function PlayerAppearAgain():void
		{
			isHitted = true;
			
			hitAlarm.start();
			flashAlarm.start();
		}
		
		public function PlayerHit(dmg:int):void
		{
			if (isHitted || shieldEnable)
			{
				return;
			}
			
			currentPlayerHealth -= dmg;
			isHitted = true;
			hitAlarm.start();
			flashAlarm.start();
			
			if (currentPlayerHealth <= 0)
			{
				DestroyPlayer();
				return;
			}
			
			playerHitSfx.play();
		}
		
		private function UpdatePhysics():void
		{
			if (x + velocityVector.x < spriteMap.width / 2 || x + velocityVector.x > GlobalData.GAME_WIDTH - 4)
			{
				velocityVector.x = 0;
			}
			
			if (y + velocityVector.y < spriteMap.height / 2 || y+velocityVector.y > GlobalData.GAME_HEIGHT - 2)
			{
				velocityVector.y = 0;
			}
			
			if (collide(CollisionNames.SOLID_COLLISION_NAME, x + velocityVector.x, y))
			{
				velocityVector.x = 0;
			}
			
			if (collide(CollisionNames.SOLID_COLLISION_NAME, x, y + velocityVector.y))
			{
				velocityVector.y = 0;
			}
			
			x += velocityVector.x;
			y += velocityVector.y;
		}
		
		public function RefreshPlayerAttributes(health:int):void
		{
			currentPlayerHealth += health * GlobalData.HEALTH_LEVEL_INCREMENT;
			
			RefreshFireRate();
		}
		
		public function RefreshFireRate():void
		{
			shootingAlarm.reset(baseReloadTime - GlobalData.reloadLevel * RELOAD_LEVEL_DECREMENT);
			shootingAlarm.start();
		}
		
		private function UpdateLogic():void
		{
			movingStatus = PLAYER_STANDING;
			if (velocityVector.x != 0 || velocityVector.y != 0)
			{
				movingStatus = PLAYER_MOVING;
			}
			
			if (firingStatus == PLAYER_IDLE)
			{
				if (velocityVector.x > 0)
				{
					direction = PLAYER_RIGHT;
				}
				if (velocityVector.x < 0)
				{
					direction = PLAYER_LEFT;
				}
				if (velocityVector.y > 0)
				{
					direction = PLAYER_DOWN;
				}
				if (velocityVector.y < 0)
				{
					direction = PLAYER_UP;
				}
			}
			
			if (numberOfShots <= 0 && bonusWeapon)
			{
				bonusWeapon = false;
				GetPlayerIntialWeapon();
			}
			
			if (!levelComplete && GlobalData.CheckWinCondition())
			{
				levelComplete = true;
				GlobalData.LevelComplete();
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			UpdateControls();
			UpdatePhysics();
			UpdateLogic();
			UpdateGraphics();
			
		}
		
		override public function render():void 
		{
			super.render();
			
			if (shieldEnable)
			{
				Draw.circle(x - spriteMap.originX + spriteMap.width / 2 - 1, y - spriteMap.originY + spriteMap.height / 2 - 1, 12 + vibration, 0xADDFFF);
				Draw.circle(x - spriteMap.originX + spriteMap.width / 2 - 1, y - spriteMap.originY + spriteMap.height / 2 - 1, 14 + vibration, 0x30AFFF);
				
				shieldText.render(FP.buffer, new Point(x + 3, y + 15), FP.camera);
			}
			
			if (numberOfShots > 0)
			{
				shotsText.render(FP.buffer, new Point(x, y + 6), FP.camera);
			}
			//Draw.hitbox(this);
		}
	}

}