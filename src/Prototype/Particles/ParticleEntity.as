package Prototype.Particles 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import Prototype.GlobalData;
	/**
	 * ...
	 * @author Amidos
	 */
	public class ParticleEntity extends Entity
	{	
		private var particleImage:Image;
		private var decrementSpeed:Number;
		private var directionVector:Point;
		private var intialY:int;
		private var physics:Boolean;
		
		public function ParticleEntity(particleClass:Class, xIn:int, yIn:int, color:int, speed:Number, direction:Number, decrement:Number = 0.05, applyPhysics:Boolean = false) 
		{
			x = xIn;
			y = yIn;
			intialY = y;
			
			particleImage = new Image(particleClass);
			particleImage.color = color;
			particleImage.originX = particleImage.width / 2;
			particleImage.originY = particleImage.height - 1;
			
			graphic = particleImage;
			
			decrementSpeed = decrement;
			
			physics = applyPhysics;
			
			directionVector = new Point();
			FP.angleXY(directionVector, direction, speed);
			
			layer = GlobalData.GetLayer(y);
		}
		
		override public function update():void 
		{
			super.update();
			
			x += directionVector.x;
			y += directionVector.y;
			
			if (physics)
			{
				directionVector.y += GlobalData.GRAVITY_SPEED;
				
				if (y > intialY)
				{
					y = intialY;
					directionVector.y = -0.75 * Math.abs(directionVector.y);
				}
			}
			
			if (FP.random < 0.5)
			{
				directionVector.x += 0.25 * (FP.random -0.5) * directionVector.x;
				directionVector.y += 0.25 * (FP.random -0.5) * directionVector.y;
			}
			
			particleImage.scale -= decrementSpeed;
			if (particleImage.scale < 0)
			{
				FP.world.remove(this);
			}
		}
		
	}

}