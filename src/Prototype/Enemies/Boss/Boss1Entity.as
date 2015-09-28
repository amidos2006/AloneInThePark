package Prototype.Enemies.Boss 
{
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.utils.Draw;
	import Prototype.CollisionNames;
	import Prototype.Enemies.BaseEnemyEntity;
	import Prototype.Enemies.EnemyDeathAnimationEntity;
	import Prototype.Enemies.NormalMushroomEntity;
	import Prototype.GlobalData;
	import Prototype.Particles.ParticleGenerator;
	/**
	 * ...
	 * @author Amidos
	 */
	public class Boss1Entity extends BaseEnemyEntity
	{
		private const FRAME_SPEED:Number = 0.2
		
		private const ENTERANCE_MOVE:String = "enternaceMove";
		private const ENTERANCE_APPEAR:String = "enteranceAppear";
		private const ENTERANCE_STANDING:String = "entranceStand";
		private const EXTENDED_STANDING:String = "extendedStanding";
		private const ATTACK:String = "attack";
		private const DISAPPEAR:String = "disappear";
		
		[Embed(source = "../../../../assets/Graphics/boss1.png")]private var bossImageClass:Class;
		[Embed(source = "../../../../assets/Graphics/boss1Death.png")]private var bossDeathClass:Class;
		
		private var maxHealth:int;
		private var maxSpeed:int;
		private var speed:Number;
		private var direction:int;
		private var isBossLevel:Boolean;
		
		public function Boss1Entity(isBoss:Boolean) 
		{
			super();
			
			isFlying = false;
			damage = 1;
			maxHealth = 200;
			health = maxHealth;
			maxSpeed = 4;
			speed = 0.2;
			bloodColor = 0xA3CE27;
			bloodSpeed = 3;
			score = 5000;
			
			spriteMap = new Spritemap(bossImageClass, 24, 24, AnimationEnds);
			spriteMap.originX = spriteMap.width / 2;
			spriteMap.originY = spriteMap.height - 2;
			
			spriteMap.add(APPEARING, [0, 1, 2, 3], FRAME_SPEED, false);
			spriteMap.add(ENTERANCE_APPEAR, [0, 1, 2, 3], FRAME_SPEED, false);
			spriteMap.add(STANDING, [4, 5, 6, 7, 4, 5, 6, 7, 4, 5, 6, 7, 4, 5, 6, 7], FRAME_SPEED, false);
			spriteMap.add(ENTERANCE_STANDING, [4, 5, 6, 7, 4, 5, 6, 7, 4, 5, 6, 7, 4, 5, 6, 7], FRAME_SPEED, false);
			spriteMap.add(EXTENDED_STANDING, [4, 5, 6, 7, 4, 5, 6, 7, 4, 5, 6, 7], FRAME_SPEED, false);
			spriteMap.add(DISAPPEAR, [8, 9, 10, 11], FRAME_SPEED, false);
			spriteMap.add(MOVING, [12, 13, 14, 15],  1.5 * FRAME_SPEED);
			spriteMap.add(ENTERANCE_MOVE, [12, 13, 14, 15], 1.5 * FRAME_SPEED);
			spriteMap.add(ATTACK, [16, 17, 18, 19, 16, 17, 18, 19], FRAME_SPEED, false);
			
			deathAnimationEntity = new EnemyDeathAnimationEntity(bossDeathClass, 24, 24, spriteMap.originX, spriteMap.originY, 5);
			
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
			
			setHitbox(spriteMap.width - 8, spriteMap.height - 12, spriteMap.originX - 4, spriteMap.originY - 12);
			
			graphic = spriteMap;
		}
		
		private function AnimationEnds():void
		{
			switch (status) 
			{
				case ENTERANCE_APPEAR:
					status = ENTERANCE_STANDING;
					GlobalData.ShowBossData(maxHealth);
					break;
				case ENTERANCE_STANDING:
					status = ATTACK;
					GenerateMushrooms();
					break;
				case EXTENDED_STANDING:
					status = ATTACK;
					GenerateMushrooms();
					break;
				case APPEARING:
					status = EXTENDED_STANDING;
					break;
				case ATTACK:
					status = STANDING;
					break;
				case STANDING:
					status = DISAPPEAR;
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
			}
		}
		
		override protected function CollectStatistics():void 
		{
			super.CollectStatistics();
			
			GlobalData.bossKills[GlobalData.BOSS_1] += 1;
		}
		
		override public function DestroyEnemy(radius:int):void 
		{
			super.DestroyEnemy(radius);
			
			ParticleGenerator.GenerateDeathParticles(x, y + 1, bloodColor, bloodSpeed * 0.75);
			
			ParticleGenerator.GenerateDeathParticles(x, y + 1, bloodColor, bloodSpeed * 0.5);
			
			GlobalData.BossKilled();
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
			var tempMushroom:NormalMushroomEntity = new NormalMushroomEntity();
			
			if (x - 20 > 5 && !tempMushroom.collide(CollisionNames.SOLID_COLLISION_NAME, x - 20, y))
			{
				tempMushroom.x = x - 20;
				tempMushroom.y = y;
				FP.world.add(tempMushroom);
			}
			
			if (x + 20 < GlobalData.GAME_WIDTH - 5 && !tempMushroom.collide(CollisionNames.SOLID_COLLISION_NAME, x + 20, y))
			{
				tempMushroom = new NormalMushroomEntity();
				
				tempMushroom.x = x + 20;
				tempMushroom.y = y;
				FP.world.add(tempMushroom);
			}
			
			if (y - 20 > 5 && !tempMushroom.collide(CollisionNames.SOLID_COLLISION_NAME, x, y - 20))
			{
				tempMushroom = new NormalMushroomEntity();
				
				tempMushroom.x = x;
				tempMushroom.y = y - 20;
				FP.world.add(tempMushroom);
			}
			
			if (y + 20 < GlobalData.GAME_HEIGHT - 5 && !tempMushroom.collide(CollisionNames.SOLID_COLLISION_NAME, x, y + 20))
			{
				tempMushroom = new NormalMushroomEntity();
				
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
		}
		
		override public function update():void 
		{
			super.update();
			
			ApplyPhysics();
			CheckMoveEnded();
			UpdateGraphics();
			
			if (isBossLevel)
			{
				GlobalData.UpdateBossHUD(health);
			}
			
			spriteMap.play(status);
		}
	}

}