package Prototype.BonusObject 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import Prototype.CollisionNames;
	import Prototype.GlobalData;
	import Prototype.Particles.ParticleGenerator;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BoxGeneratorEntity extends Entity
	{
		private const AVOIDANCE_DISTANCE:int = 50;
		private const INTIAL_INTER_TIME:int = 20 * 60;
		private const LEVEL_DECREMENT:int = 3.5 * 60;
		private const PERCENTAGE_RANDOMNESS:Number = 0.2;
		
		private var generatingAlarm:Alarm;
		private var time:Number;
		
		public function BoxGeneratorEntity() 
		{
			time = INTIAL_INTER_TIME - GlobalData.luckLevel * LEVEL_DECREMENT;
			
			generatingAlarm = new Alarm((1 + PERCENTAGE_RANDOMNESS * FP.random) * time, GenerateBox, Tween.PERSIST);
			addTween(generatingAlarm, true);
		}
		
		private function GenerateBox():void
		{
			var tempPosition:Point = new Point();
			var tempPlayer:Entity = GlobalData.playerEntity;
			
			if (!tempPlayer)
			{
				generatingAlarm.reset((1 + PERCENTAGE_RANDOMNESS * FP.random) * time);
				generatingAlarm.start();
				return;
			}
			
			var tempTiles:Point = new Point();
			
			tempTiles.x = GlobalData.GAME_WIDTH / GlobalData.GAME_TILE_SIZE - 4;
			tempTiles.y = GlobalData.GAME_HEIGHT / GlobalData.GAME_TILE_SIZE - 4;
			
			do
			{
				tempPosition.x = (FP.rand(tempTiles.x) + 2)* GlobalData.GAME_TILE_SIZE + GlobalData.GAME_TILE_SIZE / 2;
				tempPosition.y = (FP.rand(tempTiles.y) + 2)* GlobalData.GAME_TILE_SIZE + GlobalData.GAME_TILE_SIZE / 2;
			}while (FP.distance(tempPlayer.x, tempPlayer.y, tempPosition.x, tempPosition.y) < AVOIDANCE_DISTANCE || 
					FP.world.collidePoint(CollisionNames.SOLID_COLLISION_NAME, tempPosition.x, tempPosition.y));
			
			FP.world.add(new BoxEntity(tempPosition.x, tempPosition.y));
			ParticleGenerator.GenerateAppearingParticles(tempPosition.x, tempPosition.y + 1);
			
			generatingAlarm.reset((1 + PERCENTAGE_RANDOMNESS * FP.random) * time);
			generatingAlarm.start();
		}
		
	}

}