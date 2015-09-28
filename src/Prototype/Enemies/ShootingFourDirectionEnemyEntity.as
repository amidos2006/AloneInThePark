package Prototype.Enemies 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import Prototype.GlobalData;
	/**
	 * ...
	 * @author Amidos
	 */
	public class ShootingFourDirectionEnemyEntity extends BaseEnemyEntity
	{
		[Embed(source = "../../../assets/Sound/mushroomShoot.mp3")]private var mushroomShootClass:Class;
		
		private const SHOOTING_RANGE:int = 150;
		public const SHOOTING:String = "shooting";
		
		private var shotTakePlace:Boolean = false;
		
		protected var shootingSeed:Class;
		protected var shootingFrame:int;
		
		private var shootingAlarm:Alarm;
		private var mushroomShootSfx:Sfx;
		
		public function ShootingFourDirectionEnemyEntity(shootingTime:int) 
		{
			super();
			
			shootingAlarm = new Alarm(shootingTime, FireSeeds, Tween.LOOPING);
			addTween(shootingAlarm, true);
			mushroomShootSfx = new Sfx(mushroomShootClass);
		}
		
		private function FireSeeds():void
		{	
			if (!CheckToFire())
			{
				return;
			}
			
			status = SHOOTING;
			shotTakePlace = false;
		}
		
		private function CheckToFire():Boolean
		{
			if (GlobalData.playerEntity)
			{
				var tempDistance:Number = FP.distance(GlobalData.playerEntity.x, GlobalData.playerEntity.y, x, y);
				if (tempDistance > SHOOTING_RANGE)
				{
					return false;
				}
			}
			
			return true;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (status == SHOOTING)
			{
				if (spriteMap.frame == shootingFrame && !shotTakePlace)
				{
					shotTakePlace = true;
					mushroomShootSfx.play();
					
					for (var i:int = 0; i < 360; i += 90)
					{
						FP.world.add(new shootingSeed(x, y, i));
					}
				}
			}
		}
		
	}

}