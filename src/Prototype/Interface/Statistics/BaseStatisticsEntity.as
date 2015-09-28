package Prototype.Interface.Statistics 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import Prototype.GlobalData;
	import Prototype.LayerConstant;
	import Prototype.World.MainMenuWorld;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BaseStatisticsEntity extends Entity
	{
		[Embed(source = "../../../../assets/Graphics/GameStatistics.png")]private var gameStatistics:Class;
		
		protected var image:Image;
		protected var imagePoint:Point;
		
		protected var keyPressed:Boolean = false;
		private var nextWorldToGo:Class;
		
		protected var statisticName:Text;
		
		private var hintText:Text;
		
		public function BaseStatisticsEntity(nextWorld:Class) 
		{
			image = new Image(gameStatistics);
			image.centerOO();
			
			imagePoint = new Point(GlobalData.GAME_WIDTH / 2, image.height / 2 + 10);
			
			Text.size = 8;
			hintText = new Text("Press Space to advance");
			hintText.color = 0xFFFFFF;
			hintText.centerOO();
			
			nextWorldToGo = nextWorld;
			
			layer = LayerConstant.HUD_LAYER;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (keyPressed)
			{
				return;
			}
			
			if (Input.pressed(Key.SPACE))
			{
				keyPressed = true;
				GlobalData.EndThemeWorld(new nextWorldToGo());
			}
			
			if (Input.pressed(Key.ESCAPE))
			{
				keyPressed = true;
				GlobalData.EndThemeWorld(new MainMenuWorld());
			}
		}
		
		override public function render():void 
		{
			super.render();
			
			image.render(FP.buffer, imagePoint, FP.camera);
			
			statisticName.render(FP.buffer, new Point(imagePoint.x, imagePoint.y + image.height / 2 + 20), FP.camera);
			
			hintText.render(FP.buffer, new Point(GlobalData.GAME_WIDTH / 2, GlobalData.GAME_HEIGHT - 6), FP.camera);
		}
	}

}