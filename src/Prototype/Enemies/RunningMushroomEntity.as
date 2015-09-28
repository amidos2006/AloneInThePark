package Prototype.Enemies 
{
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Draw;
	import Prototype.GlobalData;
	/**
	 * ...
	 * @author Amidos
	 */
	public class RunningMushroomEntity extends FollowerEnemyEntity
	{
		private const FRAME_SPEED:Number = 0.2;
		
		[Embed(source = "../../../assets/Graphics/runningMushroom.png")]private var mushroomImageClass:Class;
		[Embed(source = "../../../assets/Graphics/runningMushroomDeath.png")]private var mushroonDeathClass:Class;
		
		public function RunningMushroomEntity() 
		{
			super();
			
			isFlying = false;
			damage = 1;
			health = 6;
			speed = 0.8;
			bloodColor = 0xA5C9ED;
			bloodSpeed = 1.7;
			score = 250;
			
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
			
			GlobalData.enemyKills[GlobalData.RUNNING_MUSHROOM] += 1;
		}
		
		override public function update():void 
		{
			super.update();
			
			spriteMap.play(status);
		}
	}

}