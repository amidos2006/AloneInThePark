package Prototype.Enemies 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.utils.Draw;
	import Prototype.CollisionNames;
	import Prototype.GlobalData;
	import Prototype.Particles.ParticleGenerator;
	import Prototype.Player.PlayerEntity;
	/**
	 * ...
	 * @author Amidos
	 */
	public class EnemyGeneratorEntity extends Entity
	{
		private const AVOIDANCE_DISTANCE:int = 30;
		
		private var alarm:Alarm;
		private var generatedEntityClass:Class;
		private var numberOfGeneratedObjects:int;
		private var interGenerationTime:int;
		private var randomPeriod:int;
		private var infinte:Boolean;
		
		public function EnemyGeneratorEntity(startingTime:int, interGenerationTime:int, randomPeriod:int, numberOfGeneratedObjects:int, generatedEntityClass:Class) 
		{
			this.generatedEntityClass = generatedEntityClass;
			this.numberOfGeneratedObjects = numberOfGeneratedObjects;
			this.randomPeriod = randomPeriod;
			this.interGenerationTime = interGenerationTime;
			
			infinte = true;
			if (numberOfGeneratedObjects > 0)
			{
				infinte = false;
			}
			
			alarm = new Alarm(startingTime + (FP.random - 0.5) * randomPeriod, GenerateEntity, Tween.PERSIST);
			addTween(alarm, true);
		}
		
		private function GenerateOnMargins(temp:BaseEnemyEntity):void
		{
			if (FP.random < 0.25)
			{
				//Left Margin
				temp.x = -2 * GlobalData.GAME_TILE_SIZE;
				temp.y = FP.random * GlobalData.GAME_HEIGHT;
			}
			else if(FP.random < 0.5)
			{
				//Up Margin
				temp.x = FP.random * GlobalData.GAME_WIDTH;
				temp.y = -2 * GlobalData.GAME_TILE_SIZE;
			}
			else if (FP.random < 0.75)
			{
				//Right Margin
				temp.x = GlobalData.GAME_WIDTH + 2 * GlobalData.GAME_TILE_SIZE;
				temp.y = FP.random * GlobalData.GAME_HEIGHT;
			}
			else
			{
				//Down Margin
				temp.x = FP.random * GlobalData.GAME_WIDTH;
				temp.y = GlobalData.GAME_HEIGHT + 2 * GlobalData.GAME_TILE_SIZE;
			}
		}
		
		private function GenerateWithSmoke(temp:BaseEnemyEntity):void
		{
			var tempPosition:Point = new Point();
			var tempPlayer:Entity = GlobalData.playerEntity;
			
			var tempTiles:Point = new Point();
			
			tempTiles.x = GlobalData.GAME_WIDTH / GlobalData.GAME_TILE_SIZE - 4;
			tempTiles.y = GlobalData.GAME_HEIGHT / GlobalData.GAME_TILE_SIZE - 4;
			
			if (!tempPlayer)
			{
				temp.x = (FP.rand(tempTiles.x) + 2)* GlobalData.GAME_TILE_SIZE + GlobalData.GAME_TILE_SIZE / 2;
				temp.y = (FP.rand(tempTiles.y) + 2) * GlobalData.GAME_TILE_SIZE + GlobalData.GAME_TILE_SIZE / 2;
				ParticleGenerator.GenerateAppearingParticles(temp.x, temp.y + 4);
				return;
			}
			
			do
			{
				tempPosition.x = (FP.rand(tempTiles.x) + 2)* GlobalData.GAME_TILE_SIZE + GlobalData.GAME_TILE_SIZE / 2;
				tempPosition.y = (FP.rand(tempTiles.y) + 2)* GlobalData.GAME_TILE_SIZE + GlobalData.GAME_TILE_SIZE / 2;
			}while (FP.distance(tempPlayer.x, tempPlayer.y, tempPosition.x, tempPosition.y) < AVOIDANCE_DISTANCE || 
					FP.world.collideRect(CollisionNames.SOLID_COLLISION_NAME, tempPosition.x - temp.width / 2, 
					tempPosition.y - temp.height / 2, temp.width, temp.height));
			
			temp.x = tempPosition.x;
			temp.y = tempPosition.y;
			
			ParticleGenerator.GenerateAppearingParticles(temp.x, temp.y + 4);
		}
		
		private function GenerateEntity():void
		{
			var temp:BaseEnemyEntity = new generatedEntityClass() as BaseEnemyEntity;
			
			if (temp.isFlying)
			{
				GenerateOnMargins(temp);
			}
			else
			{
				GenerateWithSmoke(temp);
			}
			
			FP.world.add(temp);
			
			numberOfGeneratedObjects -= 1;
			if (numberOfGeneratedObjects <= 0 && !infinte)
			{
				removeTween(alarm);
				FP.world.remove(this);
				return;
			}
			
			alarm.reset(interGenerationTime + (FP.random - 0.5) * randomPeriod);
			alarm.start();
		}
	}

}