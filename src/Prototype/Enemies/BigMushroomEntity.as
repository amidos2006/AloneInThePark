package Prototype.Enemies 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Draw;
	import Prototype.GlobalData;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BigMushroomEntity extends FollowerEnemyEntity
	{
		private const FRAME_SPEED:Number = 0.2;
		
		[Embed(source = "../../../assets/Graphics/bigMushroom.png")]private var mushroomImageClass:Class;
		[Embed(source = "../../../assets/Graphics/bigMushroomDeath.png")]private var mushroonDeathClass:Class;
		
		public function BigMushroomEntity() 
		{
			super();
			
			isFlying = false;
			damage = 1;
			health = 10;
			speed = 0.2;
			bloodColor = 0xA3CE27;
			bloodSpeed = 2.6;
			score = 500;
			
			spriteMap = new Spritemap(mushroomImageClass, 16, 22, AnimationEnds);
			spriteMap.originX = spriteMap.width / 2;
			spriteMap.originY = spriteMap.height - 2;
			
			spriteMap.add(APPEARING, [4, 5, 6, 7], FRAME_SPEED, false);
			spriteMap.add(STANDING, [0], FRAME_SPEED);
			spriteMap.add(MOVING, [0, 1, 2, 3, 2, 1], FRAME_SPEED);
			
			deathAnimationEntity = new EnemyDeathAnimationEntity(mushroonDeathClass, 16, 16, spriteMap.originX, spriteMap.originY, 4);
			
			status = APPEARING;
			
			setHitbox(spriteMap.width, spriteMap.height - 4, spriteMap.originX, spriteMap.originY - 4);
			
			graphic = spriteMap;
		}
		
		private function AnimationEnds():void
		{
			status = STANDING;
		}
		
		override public function DestroyEnemy(radius:int):void 
		{
			super.DestroyEnemy(radius);
			
			var tempMushroom:NormalMushroomEntity = new NormalMushroomEntity();
			tempMushroom.x = x - 8;
			tempMushroom.y = y - 8;
			tempMushroom.status = STANDING;
					
			FP.world.add(tempMushroom);
			
			tempMushroom = new NormalMushroomEntity();
			tempMushroom.x = x + 6;
			tempMushroom.y = y - 6;
			tempMushroom.status = STANDING;
					
			FP.world.add(tempMushroom);
		}
		
		override protected function CollectStatistics():void 
		{
			super.CollectStatistics();
			
			GlobalData.enemyKills[GlobalData.BIG_MUSHROOM] += 1;
		}
		
		override public function update():void 
		{
			super.update();
			
			spriteMap.play(status);
		}
	}

}