package Prototype.Enemies 
{
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Draw;
	import Prototype.GlobalData;
	/**
	 * ...
	 * @author Amidos
	 */
	public class ShyMushroomEntity extends FollowerEnemyEntity
	{
		private const FRAME_SPEED:Number = 0.2;
		
		[Embed(source = "../../../assets/Graphics/shyMushroom.png")]private var mushroomImageClass:Class;
		[Embed(source = "../../../assets/Graphics/shyMushroomDeath.png")]private var mushroonDeathClass:Class;
		
		public function ShyMushroomEntity() 
		{
			super();
			
			isFlying = false;
			damage = 1;
			health = 3;
			speed = 0.6;
			bloodColor = 0xFFD800;
			bloodSpeed = 1.7;
			score = 100;
			follow = false;
			runDistance = 120;
			
			spriteMap = new Spritemap(mushroomImageClass, 9, 12, AnimationEnds);
			spriteMap.originX = spriteMap.width / 2;
			spriteMap.originY = spriteMap.height - 2;
			
			spriteMap.add(APPEARING, [0, 1, 2, 3, 4], FRAME_SPEED, false);
			spriteMap.add(STANDING, [4], FRAME_SPEED);
			spriteMap.add(MOVING, [4, 5, 6, 7, 6, 5], 2 * FRAME_SPEED);
			
			deathAnimationEntity = new EnemyDeathAnimationEntity(mushroonDeathClass, 9, 9, spriteMap.originX, spriteMap.originY, 4);
			
			status = APPEARING;
			
			setHitbox(spriteMap.width, spriteMap.height - 4, spriteMap.originX, spriteMap.originY - 4);
			
			graphic = spriteMap;
		}
		
		private function AnimationEnds():void
		{
			status = STANDING;
		}
		
		override protected function CollectStatistics():void 
		{
			super.CollectStatistics();
			
			GlobalData.enemyKills[GlobalData.SHY_MUSHROOM] += 1;
		}
		
		override public function update():void 
		{
			super.update();
			
			spriteMap.play(status);
		}
	}

}