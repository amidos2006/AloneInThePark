package Prototype.Particles 
{
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import Prototype.BonusObject.*;
	/**
	 * ...
	 * @author Amidos
	 */
	public class ParticleGenerator 
	{
		private static const SPOON_BONUS:int = 0;
		private static const FORK_BONUS:int = 1;
		private static const PIZZA_CUTTER_BONUS:int = 2;
		private static const HEART_BONUS:int = 3;
		private static const SHIELD_BONUS:int = 4;
		private static const EMPTY:int = 5;
		
		[Embed(source = "../../../assets/Graphics/Particle.png")]private static var particleClass:Class;
		
		public static function GenerateAppearingParticles(x:int, y:int):void
		{
			var tempColor:int = 0x7F5200;
			var tempSpeed:Number = 0.5;
			
			for (var i:int = 0; i < 3; i += 1)
			{
				FP.world.add(new ParticleEntity(particleClass, x, y, tempColor, tempSpeed, 5));
				FP.world.add(new ParticleEntity(particleClass, x, y, tempColor, tempSpeed, 10));
				FP.world.add(new ParticleEntity(particleClass, x, y, tempColor, tempSpeed, 170));
				FP.world.add(new ParticleEntity(particleClass, x, y, tempColor, tempSpeed, 175));
			}
		}
		
		public static function GenerateTrailDustParticles(x:int, y:int):void
		{
			var tempColor:int = 0x7F5200;
			var tempSpeed:Number = 0.5;
			
			for (var i:int = 0; i < 3; i += 1)
			{
				FP.world.add(new ParticleEntity(particleClass, x + 2, y, tempColor, tempSpeed, 90));
				FP.world.add(new ParticleEntity(particleClass, x , y, tempColor, tempSpeed, 90));
				FP.world.add(new ParticleEntity(particleClass, x - 2, y, tempColor, tempSpeed, 90));
			}
		}
		
		public static function GenerateSmokeParticles(x:int, y:int):void
		{
			var tempColor:int = 0x999999;
			var tempSpeed:Number = 0.5;
			var tempDistance:Number = 2;
			
			for (var i:int = -1; i < 2; i += 1)
			{
				FP.world.add(new ParticleEntity(particleClass, x + i * tempDistance, y, tempColor, tempSpeed, 5));
				FP.world.add(new ParticleEntity(particleClass, x + i * tempDistance, y, tempColor, tempSpeed, 10));
				FP.world.add(new ParticleEntity(particleClass, x + i * tempDistance, y, tempColor, tempSpeed, 170));
				FP.world.add(new ParticleEntity(particleClass, x + i * tempDistance, y, tempColor, tempSpeed, 175));
			}
		}
		
		public static function GenerateDamageText(x:int, y:int, damage:int):void
		{
			var tempColor:int = 0xFFFFFF;
			
			FP.world.add(new TextParticleEntity(damage.toString(), tempColor, x, y));
		}
		
		public static function GenerateInGameText(x:int, y:int, text:String):void
		{
			var tempColor:int = 0xFFFFFF;
			
			FP.world.add(new TextParticleEntity(text, tempColor, x, y));
		}
		
		public static function GenerateScoreText(x:int, y:int, score:int):void
		{
			var tempColor:int = 0xFFFFFF;
			
			FP.world.add(new TextParticleEntity("+" + score, tempColor, x, y));
		}
		
		public static function GenerateBonusImage(bonusType:int, x:int, y:int):void
		{
			switch(bonusType)
			{
				case SPOON_BONUS:
					FP.world.add(new SpoonBonusEntity(x, y - 1));
					break;
				case FORK_BONUS:
					FP.world.add(new ForkBonusEntity(x, y - 1));
					break;
				case PIZZA_CUTTER_BONUS:
					FP.world.add(new PizzaCutterBonusEntity(x, y - 1));
					break;
				case HEART_BONUS:
					FP.world.add(new HeartBonusEntity(x, y - 1));
					break;
				case SHIELD_BONUS:
					FP.world.add(new ShieldBonusEntity(x, y - 1));
					break;
				case EMPTY:
					ParticleGenerator.GenerateInGameText(x, y - 1, "Empty!!!!");
					break;
			}
		}
		
		public static function GenerateLevelWords(x:int, y:int, text:String, size:int, world:World = null):void
		{
			var tempColor:int = 0xFFFFFF;
			
			if (!world)
			{
				FP.world.add(new TextParticleEntity(text, tempColor, x, y, size, 0.25, 0.005));
			}
			else
			{
				world.add(new TextParticleEntity(text, tempColor, x, y, size, 0.25, 0.005));
			}
		}
		
		public static function GenerateDeathParticles(x:int, y:int, color:int, bloodSpeed:Number, world:World = null):void
		{
			var tempDecrementSpeed:Number = 0.03;
			
			var currentWorld:World = FP.world;
			if (world)
			{
				currentWorld = world;
			}
			
			for (var i:int = 0; i < 6; i += 1)
			{
				currentWorld.add(new ParticleEntity(particleClass, x, y, color, bloodSpeed, 75, tempDecrementSpeed, true));
				currentWorld.add(new ParticleEntity(particleClass, x, y, color, bloodSpeed, 80, tempDecrementSpeed, true));
				currentWorld.add(new ParticleEntity(particleClass, x, y, color, bloodSpeed, 85, tempDecrementSpeed, true));
				currentWorld.add(new ParticleEntity(particleClass, x, y, color, bloodSpeed, 90, tempDecrementSpeed, true));
				currentWorld.add(new ParticleEntity(particleClass, x, y, color, bloodSpeed, 95, tempDecrementSpeed, true));
				currentWorld.add(new ParticleEntity(particleClass, x, y, color, bloodSpeed, 100, tempDecrementSpeed, true));
				currentWorld.add(new ParticleEntity(particleClass, x, y, color, bloodSpeed, 105, tempDecrementSpeed, true));
			}
		}
	}

}