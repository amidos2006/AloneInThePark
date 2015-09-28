package Prototype.BonusObject 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import Prototype.GlobalData;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BonusGlobalEntity extends Entity
	{
		[Embed(source = "../../../assets/Sound/bonus.MP3")]private var bonusSound:Class;
		
		private var image:Image;
		private var bonusSfx:Sfx;
		private var alphaDecrement:Number;
		private var ySpeed:Number;
		
		public function BonusGlobalEntity(xIn:int, yIn:int, bonusClass:Class, floatingSpeed:Number = 0.4, alphaSpeed:Number = 0.015) 
		{
			x = xIn;
			y = yIn;
			
			alphaDecrement = alphaSpeed;
			ySpeed = floatingSpeed;
			
			image = new Image(bonusClass);
			image.originX = image.width / 2;
			image.originY = image.height - 2;
			
			graphic = image;
			
			bonusSfx = new Sfx(bonusSound);
			
			layer = GlobalData.GetLayer(y);
		}
		
		protected function ApplyBonus():void
		{
			//bonusSfx.play();
		}
		
		override public function added():void 
		{
			super.added();
			
			ApplyBonus();
		}
		
		override public function update():void 
		{
			super.update();
			
			y -= ySpeed;
			
			image.alpha -= alphaDecrement;
			if (image.alpha <= 0)
			{
				FP.world.remove(this);
			}
		}
		
	}

}