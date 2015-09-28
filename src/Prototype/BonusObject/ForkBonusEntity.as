package Prototype.BonusObject 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import Prototype.CollisionNames;
	import Prototype.GlobalData;
	import Prototype.Particles.ParticleGenerator;
	import Prototype.Player.ForkEntity;
	import Prototype.Player.PlayerEntity;
	/**
	 * ...
	 * @author Amidos
	 */
	public class ForkBonusEntity extends BonusGlobalEntity
	{
		[Embed(source = "../../../assets/Graphics/bonusFork.png")]private var bonusClass:Class;
		
		public function ForkBonusEntity(xIn:int, yIn:int) 
		{
			super(xIn, yIn, bonusClass);
		}
		
		override protected function ApplyBonus():void 
		{
			super.ApplyBonus();
			
			var player:PlayerEntity = GlobalData.playerEntity;
			if (player)
			{
				player.ApplyWeapon(ForkEntity, 40);
				
				GlobalData.bonusGot[GlobalData.FORK] += 1;
			}
		}
	}

}