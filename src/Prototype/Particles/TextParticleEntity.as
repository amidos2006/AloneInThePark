package Prototype.Particles 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import Prototype.GlobalData;
	/**
	 * ...
	 * @author Amidos
	 */
	public class TextParticleEntity extends Entity
	{
		private var textGraphic:Text;
		private var alphaDecrement:Number;
		private var ySpeed:Number;
		
		public function TextParticleEntity(text:String, color:int, xIn:int, yIn:int, size:int = 8, floatingSpeed:Number = 0.5, alphaSpeed:Number = 0.015) 
		{
			x = xIn;
			y = yIn;
			
			Text.size = size;
			textGraphic = new Text(text);
			textGraphic.originX = textGraphic.width / 2;
			textGraphic.originY = textGraphic.height - 4;
			textGraphic.color = color;
			
			alphaDecrement = alphaSpeed;
			
			ySpeed = floatingSpeed;
			
			layer = GlobalData.GetLayer(y);
			
			graphic = textGraphic;
		}
		
		override public function update():void 
		{
			super.update();
			
			y -= ySpeed;
			
			textGraphic.alpha -= alphaDecrement;
			if (textGraphic.alpha <= 0)
			{
				FP.world.remove(this);
			}
		}
		
	}

}