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
	import Prototype.Player.WeaponEntity;
	/**
	 * ...
	 * @author Amidos
	 */
	public class Boss4Entity extends BaseEnemyEntity
	{
		private const FRAME_SPEED:Number = 0.2
		
		private const ENTERANCE_MOVE:String = "enternaceMove";
		private const ENTERANCE_APPEAR:String = "enteranceAppear";
		private const EXTENDED_STANDING:String = "extendedStanding";
		private const ATTACK:String = "attack";
		private const SUMMON:String = "summon";
		private const DISAPPEAR:String = "disappear";
		private const IRON_APPEAR:String = "ironAppear";
		private const IRON_STANDING:String = "ironStanding";
		private const IRON_DISAPPEAR:String = "ironDisappear";
		
		[Embed(source = "../../../../assets/Graphics/boss4.png")]private var bossImageClass:Class;
		[Embed(source = "../../../../assets/Graphics/boss4Death.png")]private var bossDeathClass:Class;
		
		private var maxHealth:int;
		private var maxSpeed:int;
		private var speed:Number;
		private var direction:int;
		private var isBossLevel:Boolean;
		
		private var defenderMushroom:Vector.<LittleIronMushroomBossEntity> = new Vector.<LittleIronMushroomBossEntity>();
		private var rotationSpeed:Number = 2;
		private var angle:Number = 0;
		private var radius:Number = 20;
		
		public function Boss4Entity(isBoss:Boolean) 
		{
			super();
			
			isFlying = false;
			damage = 1;
			maxHealth = 750;
			health = maxHealth;
			maxSpeed = 5;
			speed = 0.2;
			bloodColor = 0xAEAEAE;
			bloodSpeed = 3;
			score = 5000;
			
			spriteMap = new Spritemap(bossImageClass, 24, 24, AnimationEnds);
			spriteMap.originX = spriteMap.width / 2;
			spriteMap.originY = spriteMap.height - 2;
			
			spriteMap.add(APPEARING, [0, 1, 2, 3], FRAME_SPEED, false);
			spriteMap.add(ENTERANCE_APPEAR, [0, 1, 2, 3], FRAME_SPEED, false);
			spriteMap.add(STANDING, [4, 5, 6, 7, 4, 5, 6, 7, 4, 5, 6, 7, 4, 5, 6, 7], FRAME_SPEED, false);
			spriteMap.add(EXTENDED_STANDING, [4, 5, 6, 7, 4, 5, 6, 7, 4, 5, 6, 7, 4, 5, 6, 7], FRAME_SPEED, false);
			spriteMap.add(DISAPPEAR, [8, 9, 10, 11], FRAME_SPEED, false);
			spriteMap.add(MOVING, [12, 13, 14, 15],  1.5 * FRAME_SPEED);
			spriteMap.add(ENTERANCE_MOVE, [12, 13, 14, 15], 1.5 * FRAME_SPEED);
			spriteMap.add(ATTACK, [16, 17, 18], FRAME_SPEED, false);
			spriteMap.add(SUMMON, [16, 17, 18], FRAME_SPEED, false);
			spriteMap.add(IRON_APPEAR, [20, 21, 22, 23], FRAME_SPEED, false);
			spriteMap.add(IRON_STANDING, [23], FRAME_SPEED);
			spriteMap.add(IRON_DISAPPEAR, [23, 22, 21, 20], FRAME_SPEED, false);
			
			deathAnimationEntity = new EnemyDeathAnimationEntity(bossDeathClass, 24, 24, spriteMap.originX, spriteMap.originY, 5);
			
			if (isBoss)
			{
				status = ENTERANCE_MOVE;
				direction = 270;
				speed = maxSpeed - 1.2;
				
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
					status = STANDING;
					GlobalData.ShowBossData(maxHealth);
					break;
				case APPEARING:
					status = IRON_APPEAR;
					break;
				case SUMMON:
					status = EXTENDED_STANDING;
					break;
				case EXTENDED_STANDING:
					status = ATTACK;
					break;
				case ATTACK:
					status = DISAPPEAR;
					GenerateBullets();
					break;
				case STANDING:
					status = SUMMON;
					GenerateMushrooms();
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
				case IRON_APPEAR:
					status = IRON_STANDING;
					for (var i:int = 0; i < defenderMushroom.length; i++) 
					{
						defenderMushroom[i].ChangeToMoving();
					}
					defenderMushroom = new Vector.<LittleIronMushroomBossEntity>();
					break;
				case IRON_DISAPPEAR:
					status = STANDING;
					break;
			}
		}
		
		private function GenerateBullets():void
		{
			var spitShot:Boss4ShotEntity;
			
			spitShot = new Boss4ShotEntity(x + 5, y, 0);
			FP.world.add(spitShot);
				
			spitShot = new Boss4ShotEntity(x - 5, y, 180);
			FP.world.add(spitShot);
				
			spitShot = new Boss4ShotEntity(x, y + 5, 270);
			FP.world.add(spitShot);
				
			spitShot = new Boss4ShotEntity(x, y - 5, 90);
			FP.world.add(spitShot);
		}
		
		override protected function HitEnemy(tempWeapon:WeaponEntity):void 
		{
			if (status != IRON_STANDING && status != IRON_APPEAR && status != IRON_DISAPPEAR)
			{
				super.HitEnemy(tempWeapon);
			}
			else
			{
				tempWeapon.DestroyWeapon();
				enemyHitSfx.play();
			}
		}
		
		override protected function CollectStatistics():void 
		{
			super.CollectStatistics();
			
			GlobalData.bossKills[GlobalData.BOSS_4] += 1;
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
		
		private function CheckMushromsKilled():void
		{
			if (status == IRON_STANDING)
			{
				if (FP.world.classCount(LittleIronMushroomBossEntity) <= 0)
				{
					status = IRON_DISAPPEAR;
				}
			}
		}
		
		private function GenerateMushrooms():void
		{
			angle = 0;
			
			var tempMushroom:LittleIronMushroomBossEntity = new LittleIronMushroomBossEntity();
			
			tempMushroom.x = x + 20;
			tempMushroom.y = y;
			FP.world.add(tempMushroom);
			defenderMushroom.push(tempMushroom);
			
			tempMushroom = new LittleIronMushroomBossEntity();
			
			tempMushroom.x = x;
			tempMushroom.y = y + 20;
			FP.world.add(tempMushroom);
			defenderMushroom.push(tempMushroom);
			
			tempMushroom = new LittleIronMushroomBossEntity();
			
			tempMushroom.x = x - 20;
			tempMushroom.y = y;
			FP.world.add(tempMushroom);
			defenderMushroom.push(tempMushroom);
			
			tempMushroom = new LittleIronMushroomBossEntity();
			
			tempMushroom.x = x;
			tempMushroom.y = y - 20;
			FP.world.add(tempMushroom);
			defenderMushroom.push(tempMushroom);
		}
		
		private function UpdateDefenderMushrooms():void
		{
			angle += rotationSpeed;
			if (angle > 360)
			{
				angle -= 360;
			}
			
			var position:Point = new Point();
			for (var i:int = 0; i < defenderMushroom.length; i++) 
			{
				FP.angleXY(position, i * 90 + angle, radius);
				defenderMushroom[i].x = x + position.x;
				defenderMushroom[i].y = y + position.y;
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
			CheckMushromsKilled();
			UpdateDefenderMushrooms();
			UpdateGraphics();
			
			if (isBossLevel)
			{
				GlobalData.UpdateBossHUD(health);
			}
			
			spriteMap.play(status);
		}
	}

}