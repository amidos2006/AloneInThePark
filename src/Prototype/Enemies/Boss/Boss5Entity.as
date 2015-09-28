package Prototype.Enemies.Boss 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.tweens.motion.LinearMotion;
	import net.flashpunk.utils.Draw;
	import Prototype.CollisionNames;
	import Prototype.Enemies.BaseEnemyEntity;
	import Prototype.Enemies.EnemyDeathAnimationEntity;
	import Prototype.Enemies.NormalMushroomEntity;
	import Prototype.Enemies.RunningMushroomEntity;
	import Prototype.Enemies.ShadowEntity;
	import Prototype.GlobalData;
	import Prototype.Particles.ParticleGenerator;
	import Prototype.Player.LaserEntity;
	import Prototype.Player.PlayerEntity;
	/**
	 * ...
	 * @author Amidos
	 */
	public class Boss5Entity extends BaseEnemyEntity
	{
		private const FRAME_SPEED:Number = 0.2;
		private const ALLOWANCE_DISTANCE:int = 10;
		
		private const ENTERANCE_MOVING:String = "enternaceMove";
		private const ENTERANCE_FALLING:String = "enteranceFalling";
		private const EXTENDED_MOVING:String = "extendedMove";
		private const EXTENDED_FALLING:String = "extendedFalling";
		private const FALLING:String = "falling";
		
		[Embed(source = "../../../../assets/Graphics/boss5.png")]private var bossImageClass:Class;
		[Embed(source = "../../../../assets/Graphics/boss5Death.png")]private var bossDeathClass:Class;
		[Embed(source = "../../../../assets/Sound/mushroomJumpHit.mp3")]private var jumpHitClass:Class;
		
		private var maxHealth:int;
		private var maxSpeed:int;
		private var speed:Number;
		private var direction:int;
		private var isBossLevel:Boolean;
		private var jumpNumber:int;
		private var maxNumberOfJumps:int;
		private var smallJumpAlarm:Alarm;
		private var largeJumpAlarm:Alarm;
		private var entranceJumpAlarm:Alarm;
		private var yJump:Number;
		private var fallingSpeed:Number;
		private var flyingSpeed:Number;
		private var shadowEntity:ShadowEntity;
		private var jumpHitSfx:Sfx;
		
		public function Boss5Entity(isBoss:Boolean) 
		{
			super();
			
			isFlying = false;
			damage = 1;
			maxHealth = 700;
			health = maxHealth;
			maxSpeed = 1.5;
			speed = maxSpeed;
			bloodColor = 0x00FFFF;
			bloodSpeed = 3;
			score = 5000;
			
			spriteMap = new Spritemap(bossImageClass, 24, 24, AnimationEnds);
			spriteMap.originX = spriteMap.width / 2;
			spriteMap.originY = spriteMap.height - 2;
			
			spriteMap.add(ENTERANCE_MOVING, [0, 1, 2], FRAME_SPEED, false);
			spriteMap.add(ENTERANCE_FALLING, [8, 9, 10, 11], FRAME_SPEED, false);
			spriteMap.add(EXTENDED_MOVING, [0, 1, 2], FRAME_SPEED, false);
			spriteMap.add(EXTENDED_FALLING, [8, 9, 10, 11], FRAME_SPEED, false);
			spriteMap.add(STANDING, [4, 5, 6, 7, 4, 5, 6, 7, 4, 5, 6, 7, 4, 5, 6, 7, 4, 5, 6, 7], FRAME_SPEED, true);
			spriteMap.add(MOVING, [0, 1, 2], FRAME_SPEED, false);
			spriteMap.add(FALLING, [8, 9, 10, 11], FRAME_SPEED, true);
			
			deathAnimationEntity = new EnemyDeathAnimationEntity(bossDeathClass, 24, 24, spriteMap.originX, spriteMap.originY, 5);
			shadowEntity = new ShadowEntity(18);
			
			jumpHitSfx = new Sfx(jumpHitClass);
			
			if (isBoss)
			{
				status = ENTERANCE_MOVING;
				direction = 270;
				speed = maxSpeed;
				flyingSpeed = 6;
				maxNumberOfJumps = 3;
				jumpNumber = 0;
				fallingSpeed = 0;
				
				x = GlobalData.GAME_WIDTH / 2;
				y = -50;
				yJump = 0;
			}
			else
			{
				status = MOVING;
			}
			
			isBossLevel = isBoss;
			
			entranceJumpAlarm = new Alarm(2 * FP.assignedFrameRate, function():void { status = ENTERANCE_FALLING; }, Tween.ONESHOT);
			smallJumpAlarm = new Alarm(0.8 * FP.assignedFrameRate, function():void { status = EXTENDED_FALLING; }, Tween.PERSIST);
			largeJumpAlarm = new Alarm(2 * FP.assignedFrameRate, function():void { status = FALLING; }, Tween.PERSIST);
			
			addTween(entranceJumpAlarm, true);
			addTween(smallJumpAlarm, false);
			addTween(largeJumpAlarm, false);
			
			setHitbox(spriteMap.width - 8, spriteMap.height - 12, spriteMap.originX - 4, spriteMap.originY - 12);
			
			graphic = spriteMap;
		}
		
		override public function added():void 
		{
			super.added();
			
			FP.world.add(shadowEntity);
		}
		
		private function ApplyingFlyingPhysics():void
		{
			if (status == MOVING || status == EXTENDED_MOVING || status == ENTERANCE_MOVING)
			{
				if (y - yJump > -2 * spriteMap.height)
				{
					yJump += flyingSpeed;
				}
				
				var player:Entity = FP.world.classFirst(PlayerEntity);
				if (player)
				{
					direction = FP.angle(x, y, player.x, player.y);
				}
			}
			
			if (status == FALLING || status == EXTENDED_FALLING || status == ENTERANCE_FALLING)
			{
				if (yJump > fallingSpeed)
				{
					fallingSpeed += 4 * GlobalData.GRAVITY_SPEED;
					yJump -= fallingSpeed;
				}
				else
				{
					yJump = 0;
					fallingSpeed = 0;
					
					jumpHitSfx.play();
					ParticleGenerator.GenerateSmokeParticles(x, y + 2);
					
					switch(status)
					{
						case FALLING:
							Generate8Bullets();
							status = STANDING;
							break;
						case EXTENDED_FALLING:
							Generate4Bullets();
							jumpNumber += 1;
							if (jumpNumber >= maxNumberOfJumps)
							{
								status = MOVING;
								largeJumpAlarm.start();
								jumpNumber = 0;
							}
							else
							{
								status = EXTENDED_MOVING;
								smallJumpAlarm.start();
							}
							break;
						case ENTERANCE_FALLING:
							status = STANDING;
							GlobalData.ShowBossData(maxHealth);
							break;
					}
				}
			}
		}
		
		private function AnimationEnds():void
		{
			switch (status) 
			{
				case STANDING:
					status = EXTENDED_MOVING;
					smallJumpAlarm.start();
					break;
			}
		}
		
		private function Generate4Bullets():void
		{
			var spitShot:Boss5ShotEntity;
			
			spitShot = new Boss5ShotEntity(x + 5, y, 0);
			FP.world.add(spitShot);
				
			spitShot = new Boss5ShotEntity(x - 5, y, 180);
			FP.world.add(spitShot);
				
			spitShot = new Boss5ShotEntity(x, y + 5, 270);
			FP.world.add(spitShot);
				
			spitShot = new Boss5ShotEntity(x, y - 5, 90);
			FP.world.add(spitShot);
		}
		
		private function Generate8Bullets():void
		{
			Generate4Bullets();
			
			var spitShot:Boss5ShotEntity;
			
			spitShot = new Boss5ShotEntity(x + 1.5, y + 1.5, 315);
			FP.world.add(spitShot);
				
			spitShot = new Boss5ShotEntity(x + 1.5, y - 1.5, 45);
			FP.world.add(spitShot);
				
			spitShot = new Boss5ShotEntity(x - 1.5, y - 1.5, 135);
			FP.world.add(spitShot);
				
			spitShot = new Boss5ShotEntity(x - 1.5, y + 1.5, 225);
			FP.world.add(spitShot);
		}
		
		override protected function CollectStatistics():void 
		{
			super.CollectStatistics();
			
			GlobalData.bossKills[GlobalData.BOSS_5] += 1;
		}
		
		override public function DestroyEnemy(radius:int):void 
		{
			super.DestroyEnemy(radius);
			
			ParticleGenerator.GenerateDeathParticles(x, y + 1, bloodColor, bloodSpeed * 0.75);
			
			ParticleGenerator.GenerateDeathParticles(x, y + 1, bloodColor, bloodSpeed * 0.5);
			
			GlobalData.BossKilled();
			
			if (shadowEntity)
			{
				FP.world.remove(shadowEntity);
			}
		}
		
		override protected function CheckCollsion():void 
		{
			if (yJump > ALLOWANCE_DISTANCE && status != STANDING)
			{
				return;
			}
			
			super.CheckCollsion();
		}
		
		private function ApplyPhysics():void
		{
			if (speed <= 0)
			{
				speed = 0;
				return;
			}
			
			var velocityVector:Point = new Point();
			FP.angleXY(velocityVector, direction, speed);
			
			x += velocityVector.x;
			y += velocityVector.y;
		}
		
		private function UpdateGraphics():void
		{
			
		}
		
		override public function update():void 
		{
			super.update();
			
			if (status == MOVING || status == ENTERANCE_MOVING || status == EXTENDED_MOVING)
			{
				ApplyPhysics();
			}
			ApplyingFlyingPhysics();
			UpdateGraphics();
			
			if (isBossLevel)
			{
				GlobalData.UpdateBossHUD(health);
			}
			
			shadowEntity.x = x + 1;
			shadowEntity.y = y + 2;
			
			spriteMap.play(status);
		}
		
		override public function render():void 
		{
			spriteMap.render(FP.buffer, new Point(x, y - yJump), FP.camera);
		}
	}

}