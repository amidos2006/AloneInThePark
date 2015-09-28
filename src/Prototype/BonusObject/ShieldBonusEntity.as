package Prototype.BonusObject 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import Prototype.CollisionNames;
	import Prototype.GlobalData;
	import Prototype.Particles.ParticleGenerator;
	import Prototype.Player.PlayerEntity;
	/**
	 * ...
	 * @author Amidos
	 */
	public class ShieldBonusEntity extends BonusGlobalEntity
	{
		[Embed(source = "../../../assets/Graphics/bonusShield.png")]private var bonusClass:Class;
		
		public function ShieldBonusEntity(xIn:int, yIn:int) 
		{
			super(xIn, yIn, bonusClass);
		}
		
		override protected function ApplyBonus():void 
		{
			super.ApplyBonus();
			
			var player:PlayerEntity = GlobalData.playerEntity;
			if (player)
			{
				player.ApplyShield();
				
				GlobalData.bonusGot[GlobalData.SHIELD] += 1;
			}
		}
	}

}