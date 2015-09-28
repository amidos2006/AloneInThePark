package Prototype.Interface.Characters 
{
	import flash.geom.Point;
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
	public class BaseCharacterEntity extends Entity
	{
		public static const LEFT:int = -1;
		public static const RIGHT:int = 1;
		
		private const APPEAR:String = "appear";
		private const WAITING:String = "waiting";
		private const DISAPPEAR:String = "disappear";
		
		private var intialSpeed:int = 8;
		private var image:Image;
		private var lockCondition:Boolean;
		private var status:String;
		private var speed:int;
		
		protected var lockedText:Text;
		protected var unlockConditionText:Text;
		protected var nameText:Text;
		protected var healthText:Text;
		protected var speedText:Text;
		protected var damageText:Text;
		
		public function BaseCharacterEntity(inputY:int, charImage:Image, locked:Boolean, direction:int) 
		{
			y = inputY;
			
			Text.size = 16;
			lockedText = new Text("Locked");
			lockedText.color = 0xFFFFFF;
			lockedText.centerOO();
			
			image = charImage;
			image.scale = 4;
			image.centerOO();
			
			status = APPEAR;
			speed = direction * intialSpeed;
			
			if (direction > 0)
			{
				x = -image.scaledWidth;
			}
			else
			{
				x = GlobalData.GAME_WIDTH + image.scaledWidth;
			}
			
			lockCondition = locked;
			
			if (lockCondition)
			{
				image.color = 0x000000;
			}
			
			layer = LayerConstant.HUD_LAYER;
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
			
			x = GlobalData.GAME_WIDTH / 2;
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
				if (distanceToPoint(GlobalData.GAME_WIDTH / 2, y) < intialSpeed)
				{
					speed = 0;
					status = WAITING;
				}
			}
			
			if (status == DISAPPEAR)
			{
				if (x > GlobalData.GAME_WIDTH + image.scaledWidth / 2 || x < -image.scaledWidth)
				{
					FP.world.remove(this);
				}
			}
		}
		
		override public function render():void 
		{
			image.render(FP.buffer, new Point(x, y), FP.camera);
			
			if (lockCondition)
			{
				lockedText.render(FP.buffer, new Point(x - 2, y + 5), FP.camera);
				
				nameText.render(FP.buffer, new Point(x, y + image.scaledHeight / 2 + 15), FP.camera);
				unlockConditionText.render(FP.buffer, new Point(x, y + image.scaledHeight / 2 + 30), FP.camera);
			}
			else
			{
				nameText.render(FP.buffer, new Point(x, y + image.scaledHeight / 2 + 15), FP.camera);
				healthText.render(FP.buffer, new Point(x, y + image.scaledHeight / 2 + 30), FP.camera);
				speedText.render(FP.buffer, new Point(x, y + image.scaledHeight / 2 + 40), FP.camera);
				damageText.render(FP.buffer, new Point(x, y + image.scaledHeight / 2 + 50), FP.camera);
			}
		}
	}

}