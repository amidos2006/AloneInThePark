package Prototype.Enemies 
{
	import com.newgrounds.API;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Draw;
	import Prototype.GlobalData;
	/**
	 * ...
	 * @author Amidos
	 */
	public class FlyingMushroomEntity extends FlyingEnemyEntity
	{
		private const FRAME_SPEED:Number = 0.2;
		
		[Embed(source = "../../../assets/Graphics/flyingMushroom.png")]private var mushroomImageClass:Class;
		[Embed(source = "../../../assets/Graphics/flyingMushroomDead.png")]private var mushroonDeathClass:Class;
		
		public function FlyingMushroomEntity() 
		{
			super();
			
			damage = 1;
			health = 20;
			
			movingSpeed = 0.8;
			flyingSpeed = 6;
			fallingSpeed = 0;
			yJump = 0;
			score = 600;
			
			shadowEntity = new ShadowEntity(16);
			FP.world.add(shadowEntity);
			
			bloodColor = 0x00FFFF;
			bloodSpeed = 2.6;
			
			spriteMap = new Spritemap(mushroomImageClass, 16, 16);
			spriteMap.originX = spriteMap.width / 2;
			spriteMap.originY = spriteMap.height - 2;
			
			spriteMap.add(FLYING, [0, 1, 2, 3], FRAME_SPEED, false);
			spriteMap.add(STANDING, [3, 0, 4, 6, 4, 0], FRAME_SPEED, false);
			spriteMap.add(FALLING, [3], FRAME_SPEED);
			
			deathAnimationEntity = new EnemyDeathAnimationEntity(mushroonDeathClass, 16, 16, spriteMap.originX, spriteMap.originY, 4);
			
			status = FLYING;
			
			setHitbox(spriteMap.width, spriteMap.height - 4, spriteMap.originX, spriteMap.originY - 4);
			
			graphic = spriteMap;
		}
		
		override protected function CollectStatistics():void 
		{
			super.CollectStatistics();
			
			GlobalData.enemyKills[GlobalData.FLYING_MUSHROOM] += 1;
			
			//Unlock Hollow Character
			if (GlobalData.enemyKills[GlobalData.FLYING_MUSHROOM] >= 100)
			{
				GlobalData.lockedCharacters[GlobalData.HOLLOW_PLAYER] = false;
				API.unlockMedal("Connor - The Creature");
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			spriteMap.play(status);
		}
	}

}