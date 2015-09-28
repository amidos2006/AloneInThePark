package Prototype.Enemies.Boss 
{
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Draw;
	import Prototype.Enemies.EnemyDeathAnimationEntity;
	import Prototype.GlobalData;
	import Prototype.Enemies.FollowerEnemyEntity;
	import Prototype.Player.WeaponEntity;
	/**
	 * ...
	 * @author Amidos
	 */
	public class LittleIronMushroomBossEntity extends FollowerEnemyEntity
	{
		private const IRON_MOVING:String = "ironMoving";
		private const FRAME_SPEED:Number = 0.2;
		
		[Embed(source = "../../../../assets/Graphics/littleIronMushroomBoss.png")]private var mushroomImageClass:Class;
		[Embed(source = "../../../../assets/Graphics/littleIronMushroomDeath.png")]private var mushroonDeathClass:Class;
		
		public function LittleIronMushroomBossEntity() 
		{
			super();
			
			isFlying = false;
			damage = 1;
			health = 10;
			speed = 0.3;
			bloodColor = 0xAEAEAE;
			bloodSpeed = 1.7;
			score = 200;
			
			spriteMap = new Spritemap(mushroomImageClass, 9, 12, AnimationEnds);
			spriteMap.originX = spriteMap.width / 2;
			spriteMap.originY = spriteMap.height - 2;
			
			spriteMap.add(APPEARING, [0, 1, 2, 3, 4], FRAME_SPEED, false);
			spriteMap.add(STANDING, [4], FRAME_SPEED);
			spriteMap.add(IRON_MOVING, [4, 5, 6, 7, 6, 5], FRAME_SPEED);
			spriteMap.add(MOVING, [8, 9, 10, 11, 10, 9], FRAME_SPEED);
			
			deathAnimationEntity = new EnemyDeathAnimationEntity(mushroonDeathClass, 9, 9, spriteMap.originX, spriteMap.originY, 4);
			
			status = APPEARING;
			
			setHitbox(spriteMap.width, spriteMap.height - 4, spriteMap.originX, spriteMap.originY - 4);
			
			graphic = spriteMap;
		}
		
		public function ChangeToMoving():void
		{
			status = MOVING;
		}
		
		private function AnimationEnds():void
		{
			if (status == APPEARING)
			{
				status = IRON_MOVING;
			}
		}
		
		override protected function HitEnemy(tempWeapon:WeaponEntity):void 
		{
			if (status != IRON_MOVING && status != APPEARING && status != STANDING)
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
			
			GlobalData.enemyKills[GlobalData.LITTLE_IRON_MUSHROOM] += 1;
		}
		
		override public function update():void 
		{
			super.update();
			
			spriteMap.play(status);
		}
	}

}