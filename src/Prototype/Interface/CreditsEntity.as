package Prototype.Interface 
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
	public class CreditsEntity extends Entity
	{
		[Embed(source = "../../../assets/Graphics/GameName.png")]private var GameName:Class;
		
		private var gameNameImage:Image;
		private var gameNamePoint:Point;
		
		private var listOfText:Vector.<Text> = new Vector.<Text>();
		private var listOfPoints:Vector.<Point> = new Vector.<Point>();
		
		private var hintText:Text;
		private var xPressed:Boolean = false;
		
		public function CreditsEntity() 
		{
			gameNameImage = new Image(GameName);
			gameNameImage.centerOO();
			gameNamePoint = new Point(GlobalData.GAME_WIDTH / 2, gameNameImage.height / 2 + 10);
			
			Text.size = 8;
			listOfText.push(new Text("Game by"));
			Text.size = 16;
			listOfText.push(new Text("Amidos & Vartagh"));
			Text.size = 8;
			listOfText.push(new Text("Music by"));
			Text.size = 16;
			listOfText.push(new Text("BauAir Studios"));
			Text.size = 8;
			listOfText.push(new Text("Powered by"));
			Text.size = 16;
			listOfText.push(new Text("FlashPunk"));
			Text.size = 8;
			listOfText.push(new Text("Sponsored by"));
			Text.size = 16;
			listOfText.push(new Text("Newgrounds.com"));
			
			listOfPoints.push(new Point(gameNamePoint.x, gameNamePoint.y + gameNameImage.height / 2 + 15));
			listOfPoints.push(new Point(listOfPoints[listOfPoints.length - 1].x, listOfPoints[listOfPoints.length - 1].y + 12));
			listOfPoints.push(new Point(listOfPoints[listOfPoints.length - 1].x, listOfPoints[listOfPoints.length - 1].y + 20));
			listOfPoints.push(new Point(listOfPoints[listOfPoints.length - 1].x, listOfPoints[listOfPoints.length - 1].y + 12));
			listOfPoints.push(new Point(listOfPoints[listOfPoints.length - 1].x, listOfPoints[listOfPoints.length - 1].y + 20));
			listOfPoints.push(new Point(listOfPoints[listOfPoints.length - 1].x, listOfPoints[listOfPoints.length - 1].y + 12));
			listOfPoints.push(new Point(listOfPoints[listOfPoints.length - 1].x, listOfPoints[listOfPoints.length - 1].y + 20));
			listOfPoints.push(new Point(listOfPoints[listOfPoints.length - 1].x, listOfPoints[listOfPoints.length - 1].y + 12));
			
			Text.size = 8;
			hintText = new Text("Press Space to return");
			hintText.color = 0xFFFFFF;
			hintText.centerOO();
			
			for (var i:int = 0; i < listOfText.length; i += 1)
			{
				listOfText[i].centerOO();
				listOfText[i].color = 0xFFFFFF;
			}
			
			layer = LayerConstant.HUD_LAYER;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (xPressed)
			{
				return;
			}
			
			if (Input.pressed(Key.SPACE) || Input.pressed(Key.ESCAPE))
			{
				GlobalData.EndThemeWorld(new MainMenuWorld());
				xPressed = false;
			}
		}
		
		override public function render():void 
		{
			super.render();
			
			gameNameImage.render(FP.buffer, gameNamePoint, FP.camera);
			
			for (var i:int = 0; i < listOfText.length; i += 1)
			{
				listOfText[i].render(FP.buffer, listOfPoints[i], FP.camera);
			}
			
			hintText.render(FP.buffer, new Point(GlobalData.GAME_WIDTH / 2, GlobalData.GAME_HEIGHT - 6), FP.camera);
		}
	}

}