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
	import Prototype.Player.SpoonEntity;
	/**
	 * ...
	 * @author Amidos
	 */
	public class SpoonBonusEntity extends BonusGlobalEntity
	{
		[Embed(source = "../../../assets/Graphics/bonusSpoon.png")]private var bonusClass:Class;
		
		public function SpoonBonusEntity(xIn:int, yIn:int) 
		{
			super(xIn, yIn, bonusClass);
		}
		
		override protected function ApplyBonus():void 
		{
			super.ApplyBonus();
			
			var player:PlayerEntity = GlobalData.playerEntity;
			if (player)
			{
				player.ApplyWeapon(SpoonEntity, 40);
				
				GlobalData.bonusGot[GlobalData.SPOON] += 1;
			}
		}
	}

}