package Prototype.Interface 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.utils.Draw;
	import Prototype.GlobalData;
	import Prototype.LayerConstant;
	/**
	 * ...
	 * @author Amidos
	 */
	public class AchievementBarEntity extends Entity
	{
		private var achievementText:Text;
		private var deltaUpdate:Number;
		private var currentHieght:Number;
		private var maxHeight:int;
		private var waitAlarm:Alarm;
		
		public function AchievementBarEntity(text:String) 
		{
			y = GlobalData.GAME_HEIGHT - 30;
			
			deltaUpdate = 0.5;
			currentHieght = 0;
			maxHeight = 7;
			
			var options:Object = new Object();
			options["size"] = 8;
			achievementText = new Text(text, 0, 0, options);
			achievementText.color = 0xFFA514;
			achievementText.centerOO();
			
			waitAlarm = new Alarm(3 * FP.assignedFrameRate, function():void { deltaUpdate *= -1; }, Tween.ONESHOT);
			addTween(waitAlarm);
			
			layer = LayerConstant.OVER_HUD_LAYER;
		}
		
		override public function update():void 
		{
			super.update();
			
			currentHieght += deltaUpdate;
			if (currentHieght >= maxHeight && deltaUpdate > 0)
			{
				currentHieght = maxHeight;
				if (!waitAlarm.active)
				{
					waitAlarm.start();
				}
			}
			
			if (currentHieght <= 0 && deltaUpdate < 0)
			{
				FP.world.remove(this);
				return;
			}
			
			achievementText.scaleY = currentHieght / maxHeight;
		}
		
		override public function render():void 
		{
			super.render();
			
			Draw.rect( -10, y - currentHieght, GlobalData.GAME_WIDTH + 20, currentHieght, 0xC11000);
			Draw.rect( -10, y, GlobalData.GAME_WIDTH + 20, currentHieght, 0xC11000);
			
			Draw.line( -10, y - 0.75 * currentHieght, GlobalData.GAME_WIDTH + 20, y - 0.75 * currentHieght, 0xFFA514);
			Draw.line( -10, y + 0.75 * currentHieght, GlobalData.GAME_WIDTH + 20, y + 0.75 * currentHieght, 0xFFA514);
			
			achievementText.render(FP.buffer, new Point(GlobalData.GAME_WIDTH / 2, y), FP.camera);
		}
	}

}