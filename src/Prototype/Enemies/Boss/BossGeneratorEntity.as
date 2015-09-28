package Prototype.Enemies.Boss 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import Prototype.CollisionNames;
	import Prototype.Enemies.BaseEnemyEntity;
	import Prototype.GlobalData;
	import Prototype.Particles.ParticleGenerator;
	import Prototype.Player.PlayerEntity;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BossGeneratorEntity extends Entity
	{
		private const AVOIDANCE_DISTANCE:int = 50;
		
		private var alarm:Alarm;
		private var generatedEntityClass:Class;
		private var numberOfGeneratedObjects:int;
		private var interGenerationTime:int;
		private var randomPeriod:int;
		private var infinte:Boolean;
		private var isBossLevel:Boolean;
		
		public function BossGeneratorEntity(startingTime:int, interGenerationTime:int, randomPeriod:int, numberOfGeneratedObjects:int, generatedEntityClass:Class, isBossLevel:Boolean) 
		{
			this.generatedEntityClass = generatedEntityClass;
			this.numberOfGeneratedObjects = numberOfGeneratedObjects;
			this.randomPeriod = randomPeriod;
			this.interGenerationTime = interGenerationTime;
			this.isBossLevel = isBossLevel;
			
			infinte = true;
			if (numberOfGeneratedObjects > 0)
			{
				infinte = false;
			}
			
			alarm = new Alarm(startingTime + (FP.random - 0.5) * randomPeriod, GenerateEntity, Tween.PERSIST);
			addTween(alarm, true);
		}
		
		private function GenerateEntity():void
		{
			if (numberOfGeneratedObjects <= 0 && !infinte)
			{
				removeTween(alarm);
				FP.world.remove(this);
				return;
			}
			
			var temp:BaseEnemyEntity = new generatedEntityClass(isBossLevel) as BaseEnemyEntity;
			
			FP.world.add(temp);
			
			numberOfGeneratedObjects -= 1;
			
			alarm.reset(interGenerationTime + (FP.random - 0.5) * randomPeriod);
			alarm.start();
		}
		
	}

}