package Prototype.Enemies 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import Prototype.GlobalData;
	/**
	 * ...
	 * @author Amidos
	 */
	public class EnemyDeathAnimationEntity extends Entity
	{
		protected var spriteMap:Spritemap;
		
		public function EnemyDeathAnimationEntity(imageClass:Class, width:int, height:int, oX:int, oY:int, numberOfFrames:int, animationSpeed:Number = 0.3, color:int = 0xFFFFFF) 
		{
			spriteMap = new Spritemap(imageClass, width, height, AnimationEnds);
			spriteMap.originX = oX;
			spriteMap.originY = oY;
			
			var frames:Array = new Array();
			for (var i:int = 0; i < numberOfFrames; i += 1)
			{
				frames.push(i);
			}
			
			spriteMap.add("default", frames, animationSpeed, false);
			spriteMap.color = color;
			
			layer = GlobalData.GetLayer(y);
			
			graphic = spriteMap;
			
			spriteMap.play("default");
		}
		
		private function AnimationEnds():void
		{
			FP.world.remove(this);
		}
	}

}