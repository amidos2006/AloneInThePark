package Prototype.Interface.Story 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import Prototype.GlobalData;
	import Prototype.LayerConstant;
	/**
	 * ...
	 * @author Amidos
	 */
	public class StoryPageEntity extends Entity
	{
		[Embed(source = "../../../../assets/Graphics/IntroStory.png")]private var story1Class:Class;
		
		public static const LEFT:int = -1;
		public static const RIGHT:int = 1;
		
		private const APPEAR:String = "appear";
		private const WAITING:String = "waiting";
		private const DISAPPEAR:String = "disappear";
		
		private var intialSpeed:int = 10;
		private var status:String;
		private var speed:int;
		private var image:Image;
		private var text:Text;
		private var position:int;
		
		public function StoryPageEntity(image:Image, text:Text, position:int, direction:int) 
		{	
			y = GlobalData.GAME_HEIGHT / 2 + 20;
			
			status = APPEAR;
			speed = direction * intialSpeed;
			
			if (direction > 0)
			{
				x = -GlobalData.GAME_WIDTH;
			}
			else
			{
				x = GlobalData.GAME_WIDTH;
			}
			
			this.image = image;
			this.text = text;
			this.position = position;
			
			layer = LayerConstant.BELOW_HUD_LAYER;
		}
		
		public function Disappear(direction:int):void
		{
			status = DISAPPEAR;
			
			speed = direction * intialSpeed;
		}
		
		public function ChangeToWaiting():void
		{
			status = WAITING;
			
			speed = 0;
			
			x = 0;
		}
		
		public function IsWaiting():Boolean
		{
			return status == WAITING;
		}
		
		override public function update():void 
		{
			super.update();
			
			x += speed;
			
			if (status == APPEAR)
			{
				if (distanceToPoint(0, y) < intialSpeed)
				{
					speed = 0;
					status = WAITING;
				}
			}
			
			if (status == DISAPPEAR)
			{
				if (x > GlobalData.GAME_WIDTH || x < -GlobalData.GAME_WIDTH)
				{
					FP.world.remove(this);
				}
			}
		}
		
		override public function render():void 
		{
			image.render(FP.buffer, new Point(x + FP.halfWidth, y), FP.camera);
			text.render(FP.buffer, new Point(x + FP.halfWidth, y + position), FP.camera);
		}
		
	}

}