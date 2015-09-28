package Prototype.Interface 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import Prototype.LayerConstant;
	/**
	 * ...
	 * @author Amidos
	 */
	public class MuteEntity extends Entity
	{
		private var text:Text;
		
		public function MuteEntity() 
		{
			var options:Object = new Object();
			options["size"] = 8;
			options["align"] = "right";
			
			text = new Text((FP.volume == 1)? "(M) Mute":"(M) UnMute", 0, 0, options);
			text.originX = text.width;
			text.originY = text.height / 2;
			
			graphic = text;
			layer = LayerConstant.HUD_LAYER;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Input.pressed(Key.M))
			{
				FP.volume = 1 - FP.volume;
			}
			
			text.text = (FP.volume == 1)? "(M) Mute":"(M) UnMute";
			text.originX = text.width;
			text.originY = text.height / 2;
		}
	}

}