package Prototype.Enemies.Boss 
{
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import Prototype.CollisionNames;
	import Prototype.Enemies.BaseEnemyEntity;
	import Prototype.Enemies.EnemyDeathAnimationEntity;
	import Prototype.GlobalData;
	import Prototype.Particles.ParticleGenerator;
	/**
	 * ...
	 * @author Amidos
	 */
	public class Boss2Entity extends BaseEnemyEntity
	{
		[Embed(source = "../../../../assets/Graphics/boss2.png")]private var bossImageClass:Class;
		[Embed(source = "../../../../assets/Graphics/boss2Death.png")]private var bossDeathClass:Class;
		
		private const FRAME_SPEED:Number = 0.2;
		
		private const ENTERANCE_MOVE:String = "enternaceMove";
		private const ENTERANCE_APPEAR:String = "enteranceAppear";
		private const EXTENDED_STANDING:String = "extendedStanding";
		private const ATTACK:String = "attack";
		private const EXTEND_ATTACK:String = "extendedAttack";
		private const DISAPPEAR:String = "disappear";
		
		private var maxHealth:int;
		private var maxSpeed:int;
		private var speed:Number;
		private var direction:int;
		private var isBossLevel:Boolean;
		private var numberOfShots:int = 0;
		private var maxNumberOfShots:int = 3;
		private var movingLoop:int = 0;
		private var maxMovingLoop:int = 4;
		
		public function Boss2Entity(isBoss:Boolean) 
		{
			super();
			
			isFlying = false;
			damage = 1;
			maxHealth = 400;
			health = maxHealth;
			maxSpeed = 4;
			speed = 0.2;
			bloodColor = 0xA3CE27;
			bloodSpeed = 3;
			score = 5000;
			
			spriteMap = new Spritemap(bossImageClass, 24, 24, AnimationEnds);
			spriteMap.originX = spriteMap.width / 2;
			spriteMap.originY = spriteMap.height - 2;
			
			spriteMap.add(ENTERANCE_APPEAR, [0, 1, 2, 3], FRAME_SPEED, false);
			spriteMap.add(APPEARING, [0, 1, 2, 3], FRAME_SPEED, false);
			spriteMap.add(STANDING, [4, 5, 6, 7, 4, 5, 6, 7, 4, 5, 6, 7, 4, 5, 6, 7], FRAME_SPEED, false);
			spriteMap.add(EXTENDED_STANDING, [4, 5, 6, 7, 4, 5, 6, 7, 4, 5, 6, 7], FRAME_SPEED, false);
			spriteMap.add(DISAPPEAR, [3, 2, 1, 0], FRAME_SPEED, false);
			spriteMap.add(MOVING, [16], FRAME_SPEED);
			spriteMap.add(ENTERANCE_MOVE, [16], FRAME_SPEED);
			spriteMap.add(ATTACK, [8, 9, 10, 11, 10, 11, 10, 11], FRAME_SPEED, false);
			spriteMap.add(EXTEND_ATTACK, [12, 13, 14, 15], FRAME_SPEED, false);
			
			deathAnimationEntity = new EnemyDeathAnimationEntity(bossDeathClass, 24, 24, spriteMap.originX, spriteMap.originY, 5, 0.3, spriteMap.color);
			
			if (isBoss)
			{
				status = ENTERANCE_MOVE;
				direction = 270;
				speed = maxSpeed;
				
				x = GlobalData.GAME_WIDTH / 2;
				y = -50;
			}
			else
			{
				status = MOVING;
			}
			
			isBossLevel = isBoss;
			
			setHitbox(spriteMap.width - 8, spriteMap.height - 12, spriteMap.originX - 4 , spriteMap.originY - 12);
			
			graphic = spriteMap;
		}
		
		private function AnimationEnds():void
		{
			switch (status) 
			{
				case ENTERANCE_APPEAR:
					status = STANDING;
					GlobalData.ShowBossData(maxHealth);
					break;
				case APPEARING:
					status = STANDING;
					break;
				case STANDING:
					status = ATTACK;
					break;
				case ATTACK:
					GenerateBullets();
					status = EXTENDED_STANDING;
					numberOfShots = 0;
					break;
				case EXTENDED_STANDING:
					status = DISAPPEAR;
					break;
				case EXTEND_ATTACK:
					numberOfShots += 1;
					if (numberOfShots > maxNumberOfShots)
					{
						status = MOVING;
						speed = maxSpeed;
						GenerateDirection();
						numberOfShots = 0;
					}
					else
					{
						status = EXTEND_ATTACK;
						spriteMap.play(EXTEND_ATTACK, true);
						GenerateBullets();
					}
					break;
				case DISAPPEAR:
					status = MOVING;
					speed = maxSpeed;
					GenerateDirection();
				break;
			}
		}
		
		private function GenerateDirection():void
		{
			var tempPosition:Point = new Point(FP.width / 2, FP.height / 2);
			tempPosition.x = x - tempPosition.x;
			tempPosition.y = y - tempPosition.y;
			if (tempPosition.x > 0)
			{
				if (tempPosition.y > 0)
				{
					direction = 90 + FP.rand(90);
				}
				else
				{
					direction = 180 + FP.rand(90);
				}
			}
			else
			{
				if (tempPosition.y > 0)
				{
					direction = FP.rand(90);
				}
				else
				{
					direction = 270 + FP.rand(90);
				}
			}
		}
		
		override protected function CollectStatistics():void 
		{
			super.CollectStatistics();
			GlobalData.bossKills[GlobalData.BOSS_2] += 1;
		}
		
		override protected function CheckCollsion():void 
		{
			if (status != MOVING && status != ENTERANCE_MOVE)
			{
				super.CheckCollsion();
			}
		}
		
		override public function DestroyEnemy(radius:int):void 
		{
			ParticleGenerator.GenerateDeathParticles(x, y + 1, bloodColor, bloodSpeed * 0.75);
			ParticleGenerator.GenerateDeathParticles(x, y + 1, bloodColor, bloodSpeed * 0.5);
			
			GlobalData.BossKilled();		
			super.DestroyEnemy(radius);
		}
		
		private function CheckMoveEnded():void
		{
			if (speed > 0)
			{
				return;
			}
			
			if (status == MOVING)
			{
				movingLoop += 1;
				if (movingLoop > maxMovingLoop)
				{
					status = APPEARING;
					movingLoop = 0;
				}
				else
				{
					status = EXTEND_ATTACK;
				}
				
				ParticleGenerator.GenerateAppearingParticles(x, y + 4);
			}
			
			if (status == ENTERANCE_MOVE)
			{
				status = ENTERANCE_APPEAR;
				ParticleGenerator.GenerateAppearingParticles(x, y + 4);
			}
		}
		
		private function GenerateBullets():void
		{
			var spitShot:Boss2ShotEntity;
			var projectileShot:Boss2ProjectileShotEntity;
			
			if (status == EXTEND_ATTACK)
			{
				var fallingSpeed:Number = -2 - 2 * numberOfShots;
				projectileShot = new Boss2ProjectileShotEntity(x, y, 0, fallingSpeed);
				FP.world.add(projectileShot);
				
				projectileShot = new Boss2ProjectileShotEntity(x, y, 180, fallingSpeed);
				FP.world.add(projectileShot);
				
				projectileShot = new Boss2ProjectileShotEntity(x, y, 270, fallingSpeed);
				FP.world.add(projectileShot);
				
				projectileShot = new Boss2ProjectileShotEntity(x, y, 90, fallingSpeed);
				FP.world.add(projectileShot);
			}
			else if(status == ATTACK)
			{
				spitShot = new Boss2ShotEntity(x + 5, y, 0);
				FP.world.add(spitShot);
				
				spitShot = new Boss2ShotEntity(x - 5, y, 180);
				FP.world.add(spitShot);
				
				spitShot = new Boss2ShotEntity(x, y + 5, 270);
				FP.world.add(spitShot);
				
				spitShot = new Boss2ShotEntity(x, y - 5, 90);
				FP.world.add(spitShot);
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
			
			ParticleGenerator.GenerateTrailDustParticles(x, y);
		}
		
		private function UpdateGraphics():void
		{
			
		}
		
		override public function update():void 
		{
			super.update();
			
			ApplyPhysics();
			CheckMoveEnded();
			UpdateGraphics();
			
			if (isBossLevel)
			{
				var totalHealth:int = health;
				
				GlobalData.UpdateBossHUD(totalHealth);
			}
			
			spriteMap.play(status);
		}
	}

}