package Prototype.Enemies.Boss 
{
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.tweens.motion.LinearMotion;
	import net.flashpunk.utils.Draw;
	import Prototype.CollisionNames;
	import Prototype.Enemies.BaseEnemyEntity;
	import Prototype.Enemies.EnemyDeathAnimationEntity;
	import Prototype.Enemies.NormalMushroomEntity;
	import Prototype.Enemies.RunningMushroomEntity;
	import Prototype.GlobalData;
	import Prototype.Particles.ParticleGenerator;
	import Prototype.Player.LaserEntity;
	/**
	 * ...
	 * @author Amidos
	 */
	public class Boss3Entity extends BaseEnemyEntity
	{
		private const FRAME_SPEED:Number = 0.2
		
		private const ENTERANCE_MOVE:String = "enternaceMove";
		private const ENTERANCE_APPEAR:String = "enteranceAppear";
		private const SUMMONING:String = "summoning";
		private const BULLET_ATTACK:String = "bulletAttack";
		private const COMPLETE_APPEAR:String = "completeAppear";
		private const UNDERGROUND_MOVE:String = "undergroundMove";
		private const COMPLETE_DISAPPEAR:String = "completeDisappear";
		private const ATTACK:String = "attack";
		private const ATTACK_STANDING:String = "attackStanding";
		private const DISAPPEAR:String = "disappear";
		
		[Embed(source = "../../../../assets/Graphics/boss3.png")]private var bossImageClass:Class;
		[Embed(source = "../../../../assets/Graphics/boss3Death.png")]private var bossDeathClass:Class;
		
		private var maxHealth:int;
		private var maxSpeed:int;
		private var speed:Number;
		private var direction:int;
		private var isBossLevel:Boolean;
		private var laserBeam:Boss3DeathBeamEntity;
		private var shotNumber:int = 0;
		private var maxNumberOfShots:int = 1;
		private var isNextSummon:Boolean = true;
		private var laserPosition:Point = new Point();
		private var motionTween:LinearMotion;
		
		public function Boss3Entity(isBoss:Boolean) 
		{
			super();
			
			isFlying = false;
			damage = 1;
			maxHealth = 500;
			health = maxHealth;
			maxSpeed = 5;
			speed = 0.2;
			bloodColor = 0xA5C9ED;
			bloodSpeed = 3;
			score = 5000;
			
			spriteMap = new Spritemap(bossImageClass, 24, 24, AnimationEnds);
			spriteMap.originX = spriteMap.width / 2;
			spriteMap.originY = spriteMap.height - 2;
			
			spriteMap.add(ENTERANCE_MOVE, [8, 9, 10, 11], FRAME_SPEED, true);
			spriteMap.add(ENTERANCE_APPEAR, [0, 1, 2, 3], FRAME_SPEED, false);
			spriteMap.add(SUMMONING, [16, 17, 18], FRAME_SPEED, false);
			spriteMap.add(BULLET_ATTACK, [16, 17, 18], FRAME_SPEED, false);
			spriteMap.add(STANDING, [4, 5, 6, 7, 4, 5, 6, 7, 4, 5, 6, 7], FRAME_SPEED, false);
			spriteMap.add(COMPLETE_DISAPPEAR, [3, 2, 1, 0, 19], FRAME_SPEED, false);
			spriteMap.add(UNDERGROUND_MOVE, [19], FRAME_SPEED, true);
			spriteMap.add(COMPLETE_APPEAR, [0, 1, 2, 3], FRAME_SPEED, false);
			spriteMap.add(ATTACK, [12, 13, 14, 15, 15, 15, 15, 15, 15, 15, 14, 13, 12],  FRAME_SPEED, false);
			spriteMap.add(ATTACK_STANDING, [4, 5, 6, 7, 4, 5, 6, 7, 4, 5, 6, 7], FRAME_SPEED, false);
			spriteMap.add(DISAPPEAR, [3, 2, 1, 0], FRAME_SPEED, false);
			spriteMap.add(MOVING, [8, 9, 10, 11], FRAME_SPEED, true);
			spriteMap.add(APPEARING, [0, 1, 2, 3], FRAME_SPEED, false);
			
			deathAnimationEntity = new EnemyDeathAnimationEntity(bossDeathClass, 24, 24, spriteMap.originX, spriteMap.originY, 5);
			
			if (isBoss)
			{
				status = ENTERANCE_MOVE;
				direction = 270;
				speed = maxSpeed - 1.5;
				
				x = GlobalData.GAME_WIDTH / 2;
				y = -50;
			}
			else
			{
				status = MOVING;
			}
			
			isBossLevel = isBoss;
			
			motionTween = new LinearMotion(EndUnderGroundMove, Tween.PERSIST);
			addTween(motionTween);
			
			setHitbox(spriteMap.width - 8, spriteMap.height - 12, spriteMap.originX - 4, spriteMap.originY - 12);
			
			graphic = spriteMap;
		}
		
		private function EndUnderGroundMove():void
		{
			x = laserPosition.x;
			y = laserPosition.y;
			status = COMPLETE_APPEAR;
		}
		
		private function AnimationEnds():void
		{
			switch (status) 
			{
				case ENTERANCE_APPEAR:
					status = SUMMONING;
					GlobalData.ShowBossData(maxHealth);
					GenerateMushrooms();
					break;
				case SUMMONING:
					status = STANDING;
					break;
				case BULLET_ATTACK:
					status = STANDING;
					break;
				case STANDING:
					ParticleGenerator.GenerateAppearingParticles(x, y + 4);
					if (isNextSummon)
					{
						isNextSummon = false;
						status = DISAPPEAR;
					}
					else
					{
						isNextSummon = true;
						status = COMPLETE_DISAPPEAR;
					}
					break;
				case COMPLETE_DISAPPEAR:
					laserPosition.y = 30;
					if (GlobalData.playerEntity)
					{
						laserPosition.x = GlobalData.playerEntity.x;
					}
					else
					{
						laserPosition.x = FP.rand(GlobalData.GAME_WIDTH - 60) + 30;
					}
					motionTween.setMotionSpeed(x, y, laserPosition.x, laserPosition.y, maxSpeed);
					motionTween.start();
					status = UNDERGROUND_MOVE;
					ParticleGenerator.GenerateAppearingParticles(x, y + 4);
					break;
				case COMPLETE_APPEAR:
					status = ATTACK;
					break;
				case ATTACK:
					status = ATTACK_STANDING;
					break;
				case ATTACK_STANDING:
					if (shotNumber >= maxNumberOfShots)
					{
						shotNumber = 0;
						ParticleGenerator.GenerateAppearingParticles(x, y + 4);
						status = DISAPPEAR;
					}
					else
					{
						shotNumber += 1;
						status = COMPLETE_DISAPPEAR;
					}
					break;
				case DISAPPEAR:
					status = MOVING;
					speed = maxSpeed;
					if (GlobalData.playerEntity)
					{
						direction = FP.angle(x, y, GlobalData.playerEntity.x, GlobalData.playerEntity.y);
					}
					else
					{
						direction = FP.rand(360);
					}
					break;
				case APPEARING:
					if (isNextSummon)
					{
						status = SUMMONING;
						GenerateMushrooms();
					}
					else
					{
						status = BULLET_ATTACK;
						GenerateBullets();
					}
					break;
			}
		}
		
		private function GenerateBullets():void
		{
			var spitShot:Boss3ShotEntity;
			
			spitShot = new Boss3ShotEntity(x + 5, y, 0);
			FP.world.add(spitShot);
				
			spitShot = new Boss3ShotEntity(x - 5, y, 180);
			FP.world.add(spitShot);
				
			spitShot = new Boss3ShotEntity(x, y + 5, 270);
			FP.world.add(spitShot);
				
			spitShot = new Boss3ShotEntity(x, y - 5, 90);
			FP.world.add(spitShot);
		}
		
		override protected function CollectStatistics():void 
		{
			super.CollectStatistics();
			
			GlobalData.bossKills[GlobalData.BOSS_3] += 1;
		}
		
		override public function DestroyEnemy(radius:int):void 
		{
			super.DestroyEnemy(radius);
			
			ParticleGenerator.GenerateDeathParticles(x, y + 1, bloodColor, bloodSpeed * 0.75);
			
			ParticleGenerator.GenerateDeathParticles(x, y + 1, bloodColor, bloodSpeed * 0.5);
			
			GlobalData.BossKilled();
			
			if (laserBeam)
			{
				FP.world.remove(laserBeam);
			}
		}
		
		override protected function CheckCollsion():void 
		{
			if (status == UNDERGROUND_MOVE)
			{
				return;
			}
			
			super.CheckCollsion();
		}
		
		private function CheckMoveEnded():void
		{
			if (speed > 0)
			{
				return;
			}
			
			if (status == MOVING)
			{
				status = APPEARING;
				ParticleGenerator.GenerateAppearingParticles(x, y + 4);
			}
			
			if (status == ENTERANCE_MOVE)
			{
				status = ENTERANCE_APPEAR;
				ParticleGenerator.GenerateAppearingParticles(x, y + 4);
			}
		}
		
		private function GenerateMushrooms():void
		{
			var tempMushroom:RunningMushroomEntity = new RunningMushroomEntity();
			
			if (x - 20 > 5 && !tempMushroom.collide(CollisionNames.SOLID_COLLISION_NAME, x - 20, y))
			{
				tempMushroom.x = x - 20;
				tempMushroom.y = y;
				FP.world.add(tempMushroom);
			}
			
			if (x + 20 < GlobalData.GAME_WIDTH - 5 && !tempMushroom.collide(CollisionNames.SOLID_COLLISION_NAME, x + 20, y))
			{
				tempMushroom = new RunningMushroomEntity();
				
				tempMushroom.x = x + 20;
				tempMushroom.y = y;
				FP.world.add(tempMushroom);
			}
			
			if (y - 20 > 5 && !tempMushroom.collide(CollisionNames.SOLID_COLLISION_NAME, x, y - 20))
			{
				tempMushroom = new RunningMushroomEntity();
				
				tempMushroom.x = x;
				tempMushroom.y = y - 20;
				FP.world.add(tempMushroom);
			}
			
			if (y + 20 < GlobalData.GAME_HEIGHT - 5 && !tempMushroom.collide(CollisionNames.SOLID_COLLISION_NAME, x, y + 20))
			{
				tempMushroom = new RunningMushroomEntity();
				
				tempMushroom.x = x;
				tempMushroom.y = y + 20;
				FP.world.add(tempMushroom);
			}
		}
		
		private function ApplyPhysics():void
		{
			if (speed <= 0)
			{
				return;
			}
			
			speed -= GlobalData.FRICTION_SPEED;
			if (speed <= 0)
			{
				speed = 0;
				return;
			}
			
			var velocityVector:Point = new Point();
			FP.angleXY(velocityVector, direction, speed);
			
			var alterDirection:Boolean = false;
			if (status == MOVING)
			{
				if (x + velocityVector.x < 5 || x + velocityVector.x > GlobalData.GAME_WIDTH - 5
					|| collide(CollisionNames.SOLID_COLLISION_NAME, x + velocityVector.x, y))
				{
					velocityVector.x *= -0.75;
					alterDirection = true;
				}
				
				if (y + velocityVector.y < 5 || y + velocityVector.y > GlobalData.GAME_HEIGHT - 5 
					|| collide(CollisionNames.SOLID_COLLISION_NAME, x, y + velocityVector.y))
				{
					velocityVector.y *= -0.75;
					alterDirection = true;
				}
			}
			
			if (alterDirection)
			{
				direction = FP.angle(x, y, x + velocityVector.x, y + velocityVector.y);
			}
			
			x += velocityVector.x;
			y += velocityVector.y;
			
			if (speed > 0.75)
			{
				ParticleGenerator.GenerateTrailDustParticles(x - velocityVector.x / maxSpeed * 12, y - velocityVector.y * 2 - FP.sign(velocityVector.y));
			}
		}
		
		private function UpdateGraphics():void
		{
			spriteMap.rate = 1;
			if (status == MOVING || status == ENTERANCE_MOVE)
			{
				spriteMap.rate = 0.5 + 0.5 * (speed / maxSpeed);
			}
			
			if (status == UNDERGROUND_MOVE)
			{
				if (motionTween.active)
				{
					x = motionTween.x;
					y = motionTween.y;
					ParticleGenerator.GenerateTrailDustParticles(x, y);
				}
				else
				{
					EndUnderGroundMove();
				}
			}
		}
		
		private function CheckLaserBeam():void
		{
			if (status == ATTACK && spriteMap.frame == 14)
			{
				if (!laserBeam)
				{
					laserBeam = new Boss3DeathBeamEntity(x - 2, y - 6);
					FP.world.add(laserBeam);
				}
				else
				{
					FP.world.remove(laserBeam);
					laserBeam = null;
				}
			}
			
		}
		
		override public function update():void 
		{
			super.update();
			
			ApplyPhysics();
			CheckMoveEnded();
			UpdateGraphics();
			CheckLaserBeam();
			
			if (isBossLevel)
			{
				GlobalData.UpdateBossHUD(health);
			}
			
			spriteMap.play(status);
		}
	}

}