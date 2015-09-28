package Prototype.Interface 
{
	import com.newgrounds.API;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import Prototype.LayerConstant;
	/**
	 * ...
	 * @author Amidos
	 */
	public class NewgroundsEntity extends Entity
	{
		[Embed(source = "../../../assets/SponsorStuff/pixel_tank.gif")]private var imageClass:Class;
		
		private var image:Image;
		
		public function NewgroundsEntity() 
		{
			x = FP.width;
			y = FP.height;
			
			image = new Image(imageClass);
			image.centerOO();
			image.scale = 0.5;
			
			x -= image.scaledWidth / 2 + 3;
			y -= image.scaledHeight / 2 + 3;
			
			graphic = image;
			layer = LayerConstant.OVER_HUD_LAYER;
			
			setHitbox(image.width - 10, image.height - 10, image.originX - 5, image.originY - 5);
		}
		
		override public function added():void 
		{
			super.added();
			
			FP.stage.addEventListener(MouseEvent.CLICK, MouseClicked);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			FP.stage.removeEventListener(MouseEvent.CLICK, MouseClicked);
		}
		
		override public function update():void 
		{
			super.update();
			
			image.scale = 0.5;
			if (collidePoint(x, y, Input.mouseX, Input.mouseY))
			{
				image.scale = 0.6;
			}
		}
		
		private function MouseClicked(mouseEvent:MouseEvent):void
		{
			if (collidePoint(x, y, Input.mouseX, Input.mouseY))
			{
				navigateToURL(new URLRequest("http://www.newgrounds.com"));
			}
		}
	}

}