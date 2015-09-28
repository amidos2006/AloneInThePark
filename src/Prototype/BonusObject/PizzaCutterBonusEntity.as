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
	import Prototype.Player.PizzaCutterEntity;
	import Prototype.Player.PlayerEntity;
	import Prototype.Player.SpoonEntity;
	/**
	 * ...
	 * @author Amidos
	 */
	public class PizzaCutterBonusEntity extends BonusGlobalEntity
	{
		[Embed(source = "../../../assets/Graphics/bonusPizzaCutter.png")]private var bonusClass:Class;
		
		public function PizzaCutterBonusEntity(xIn:int, yIn:int) 
		{
			super(xIn, yIn, bonusClass);
		}
		
		override protected function ApplyBonus():void 
		{
			super.ApplyBonus();
			
			var player:PlayerEntity = GlobalData.playerEntity;
			if (player)
			{
				player.ApplyWeapon(PizzaCutterEntity, 40);
				
				GlobalData.bonusGot[GlobalData.PIZZA_CUTTER] += 1;
			}
		}		
	}

}