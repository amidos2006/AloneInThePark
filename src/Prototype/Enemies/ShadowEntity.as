package Prototype.Enemies 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import Prototype.LayerConstant;
	/**
	 * ...
	 * @author Amidos
	 */
	public class ShadowEntity extends Entity
	{
		[Embed(source = "../../../assets/Graphics/flyingShadow.png")]private var shadowClass:Class;
		
		private var image:Image;
		
		public function ShadowEntity(size:int) 
		{
			image = new Image(shadowClass);
			image.scale = size / image.width;
			image.originX = image.scaledWidth / 2;
			image.originY = image.scaledHeight - 4 * image.scale;
			image.alpha = 0.5;
			
			layer = LayerConstant.SHADOW_LAYER;
			
			graphic = image;
		}
	}

}