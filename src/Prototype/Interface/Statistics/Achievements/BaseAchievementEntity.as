package Prototype.Interface.Statistics.Achievements 
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
	public class BaseAchievementEntity extends Entity
	{
		public static const LEFT:int = -1;
		public static const RIGHT:int = 1;
		
		private const APPEAR:String = "appear";
		private const WAITING:String = "waiting";
		private const DISAPPEAR:String = "disappear";
		
		private var intialSpeed:int = 10;
		private var image:Vector.<Image>;
		private var status:String;
		private var speed:int;
		private var unlockConditionText:Vector.<Text>;
		private var nameText:Vector.<Text>;
		
		public function BaseAchievementEntity(inputY:int, achvImage:Vector.<Image>, names:Vector.<Text>, conditions:Vector.<Text>, direction:int) 
		{
			y = inputY;
			
			Text.size = 16;
			nameText = names;
			unlockConditionText = conditions;
			
			image = achvImage;
			
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
			for (var i:int = 0; i < 2; i++) 
			{
				for (var j:int = 0; j < 2; j++) 
				{
					var xPos:int = 40 + i * 150 + x;
					var yPos:int = y + j * 50;
					
					image[i * 2 + j].render(FP.buffer, new Point(xPos, yPos), FP.camera);
					
					nameText[i * 2 + j].render(FP.buffer, new Point(xPos + 20, yPos - 6), FP.camera);
					unlockConditionText[i * 2 + j].render(FP.buffer, new Point(xPos + 20, yPos + 6), FP.camera);
				}
			}
			
		}
	}

}