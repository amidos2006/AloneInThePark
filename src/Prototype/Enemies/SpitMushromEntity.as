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
	public class SpitMushromEntity extends ShootingFourDirectionEnemyEntity
	{
		private const FRAME_SPEED:Number = 0.2;
		private const SHOOTING_FRAME_SPEED:Number = 0.1;
		
		[Embed(source = "../../../assets/Graphics/spitMushroom.png")]private var mushroomImageClass:Class;
		[Embed(source = "../../../assets/Graphics/spitMushroomDeath.png")]private var mushroonDeathClass:Class;
		
		public function SpitMushromEntity() 
		{
			super(150);
			
			isFlying = false;
			damage = 1;
			health = 8;
			bloodColor = 0xE06F8B;
			bloodSpeed = 1.7;
			shootingFrame = 10;
			score = 600;
			
			shootingSeed = SpitMushroomShotEntity;
			
			spriteMap = new Spritemap(mushroomImageClass, 9, 14, AnimationEnds);
			spriteMap.originX = spriteMap.width / 2;
			spriteMap.originY = spriteMap.height - 2;
			
			spriteMap.add(APPEARING, [0, 1, 2, 3, 4], FRAME_SPEED, false);
			spriteMap.add(STANDING, [4], FRAME_SPEED);
			spriteMap.add(SHOOTING, [8, 9, 10, 9, 8], SHOOTING_FRAME_SPEED, false);
			
			deathAnimationEntity = new EnemyDeathAnimationEntity(mushroonDeathClass, 9, 11, spriteMap.originX, spriteMap.originY, 4);
			
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
			
			GlobalData.enemyKills[GlobalData.SPIT_MUSHROOM] += 1;
		}
		
		override public function update():void 
		{
			super.update();
			
			spriteMap.play(status);
			
			//Just for protection
			if (x < 2 * GlobalData.GAME_TILE_SIZE || y < 2 * GlobalData.GAME_TILE_SIZE)
			{
				FP.world.remove(this);
			}
		}
	}

}