package Prototype.Enemies 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.utils.Draw;
	import Prototype.GlobalData;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BigSpitMushroomEntity extends FollowerEnemyEntity
	{
		[Embed(source = "../../../assets/Sound/mushroomShoot.mp3")]private var mushroomShootClass:Class;
		
		private const FRAME_SPEED:Number = 0.2;
		private const SHOOTING_FRAME_SPEED:Number = 0.1;
		private const SHOOTING_RANGE:Number = 150;
		
		private const SHOOTING:String = "Shooting";
		
		private var shotTakePlace:Boolean = false;
		private var shootingTime:int = 150;
		
		protected var shootingSeed:Class;
		protected var shootingFrame:int;
		
		private var shootingAlarm:Alarm;
		private var mushroomShootSfx:Sfx;
		
		[Embed(source = "../../../assets/Graphics/bigSpitMushroom.png")]private var mushroomImageClass:Class;
		[Embed(source = "../../../assets/Graphics/bigSpitMushroomDeath.png")]private var mushroonDeathClass:Class;
		
		public function BigSpitMushroomEntity() 
		{
			super();
			
			isFlying = false;
			damage = 1;
			health = 16;
			speed = 0.3;
			bloodColor = 0xE06F8B;
			bloodSpeed = 2.6;
			score = 1500;
			
			shootingSeed = SpitMushroomShotEntity;
			shootingFrame = 10;
			shootingAlarm = new Alarm(shootingTime, FireSeeds, Tween.LOOPING);
			addTween(shootingAlarm, true);
			
			spriteMap = new Spritemap(mushroomImageClass, 16, 22, AnimationEnds);
			spriteMap.originX = spriteMap.width / 2;
			spriteMap.originY = spriteMap.height - 2;
			
			spriteMap.add(APPEARING, [4, 5, 6, 7], FRAME_SPEED, false);
			spriteMap.add(STANDING, [0], FRAME_SPEED);
			spriteMap.add(MOVING, [0, 1, 2, 3, 2, 1], FRAME_SPEED);
			spriteMap.add(SHOOTING, [8, 9, 10, 9, 8], SHOOTING_FRAME_SPEED, false);
			
			deathAnimationEntity = new EnemyDeathAnimationEntity(mushroonDeathClass, 16, 16, spriteMap.originX, spriteMap.originY, 4);
			
			status = APPEARING;
			
			mushroomShootSfx = new Sfx(mushroomShootClass);
			
			setHitbox(spriteMap.width, spriteMap.height - 4, spriteMap.originX, spriteMap.originY - 4);
			
			graphic = spriteMap;
		}
		
		private function AnimationEnds():void
		{
			status = STANDING;
		}
		
		private function FireSeeds():void
		{
			if (!GlobalData.playerEntity)
			{
				return;
			}
			
			var tempDistance:Number = FP.distance(GlobalData.playerEntity.x, GlobalData.playerEntity.y, x, y);
			if (tempDistance > SHOOTING_RANGE)
			{
				return;
			}
			
			status = SHOOTING;
			shotTakePlace = false;
		}
		
		override public function DestroyEnemy(radius:int):void 
		{
			super.DestroyEnemy(radius);
		}
		
		override protected function CollectStatistics():void 
		{
			super.CollectStatistics();
			
			GlobalData.enemyKills[GlobalData.BIG_SPIT_MUSHROOM] += 1;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (status == SHOOTING)
			{
				if (spriteMap.frame == shootingFrame && !shotTakePlace)
				{
					shotTakePlace = true;
					
					var angle:Number = 0;
					if (GlobalData.playerEntity != null)
					{
						angle = FP.angle(x, y, GlobalData.playerEntity.x, GlobalData.playerEntity.y);
					}
					
					mushroomShootSfx.play();
					FP.world.add(new shootingSeed(x, y, angle));
					
				}
			}
			
			spriteMap.play(status);
		}
	}

}