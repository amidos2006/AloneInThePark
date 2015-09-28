package Prototype.Interface 
{
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import mochi.as3.MochiScores;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import Prototype.GlobalData;
	import Prototype.LayerConstant;
	import flash.net.navigateToURL;
	import Prototype.World.CharacterSelectWorld;
	import Prototype.World.CreditsWorld;
	import Prototype.World.EnemyStatisticsWorld;
	import Prototype.World.GameModesWorld;
	import Prototype.World.MainMenuStoryHighScoreWorld;
	import Prototype.World.SurvivalWorld;
	/**
	 * ...
	 * @author Amidos
	 */
	public class MainMenuEntity extends Entity
	{
		[Embed(source = "../../../assets/Graphics/GameName.png")]private var GameName:Class;
		[Embed(source = "../../../assets/Sound/menuSelect.mp3")]private var menuSelectClass:Class;
		
		private var selector:int;
		private var gameNameImage:Image;
		private var gameNamePoint:Point;
		private var listOfOptions:Vector.<Text> = new Vector.<Text>();
		private var listOfPoints:Vector.<Point> = new Vector.<Point>();
		
		private var keyPressed:Boolean = false;
		
		private var hintText:Text;
		private var menuSelectSfx:Sfx;
		
		public function MainMenuEntity() 
		{
			selector = 0;
			
			gameNameImage = new Image(GameName);
			gameNameImage.centerOO();
			
			gameNamePoint = new Point(GlobalData.GAME_WIDTH / 2, gameNameImage.height / 2 + 10);
			
			Text.size = 16;
			
			listOfOptions.push(new Text("Start Game"));
			listOfOptions.push(new Text("Game Statistics"));
			listOfOptions.push(new Text("Credits"));
			listOfOptions.push(new Text("Multidirectional Shooters"));
			
			for (var i:int = 0; i < listOfOptions.length; i += 1)
			{
				listOfOptions[i].centerOO();
				listOfOptions[i].color = 0xFFFFFF;
				
				listOfPoints.push(new Point(GlobalData.GAME_WIDTH / 2, 2 * gameNamePoint.y + 45 + i * 20));
			}
			
			Text.size = 8;
			hintText = new Text("Up and Down to choose and Space to select");
			hintText.color = 0xFFFFFF;
			hintText.centerOO();
			
			menuSelectSfx = new Sfx(menuSelectClass);
			
			layer = LayerConstant.HUD_LAYER;
		}
		
		override public function added():void 
		{
			super.added();
			
			FP.stage.addEventListener(KeyboardEvent.KEY_DOWN, GoToNewgrounds);
		}
		
		override public function removed():void 
		{
			super.removed();
			
			FP.stage.removeEventListener(KeyboardEvent.KEY_DOWN, GoToNewgrounds)
		}
		
		private function GoToNewgrounds(keyEvent:KeyboardEvent):void
		{
			if (keyEvent.keyCode == Key.SPACE)
			{
				if (selector == 3)
				{
					var request:URLRequest = new URLRequest(GlobalData.SPONSOR_URL);
					navigateToURL(request); 
				}
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			if (keyPressed)
			{
				return;
			}
			
			for (var i:int = 0; i < listOfOptions.length; i+= 1) 
			{
				listOfOptions[i].color = 0xFFFFFF;
			}
			
			listOfOptions[selector].color = 0x000000;
			
			if (Input.pressed(Key.UP) || Input.pressed(Key.W))
			{
				selector -= 1;
				if (selector < 0)
				{
					selector = listOfOptions.length - 1;
				}
				
				menuSelectSfx.play();
			}
			
			if (Input.pressed(Key.DOWN) || Input.pressed(Key.S))
			{
				selector = (selector + 1) % listOfOptions.length;
				menuSelectSfx.play();
			}
			
			if (Input.pressed(Key.SPACE))
			{
				if (selector != listOfOptions.length - 1)
				{
					keyPressed = true;
				}
				
				Input.clear();
				
				switch(selector)
				{
					case 0:
						GlobalData.EndThemeWorld(new GameModesWorld());
						break;
					case 1:
						GlobalData.EndThemeWorld(new EnemyStatisticsWorld());
						break;
					case 2:
						GlobalData.EndThemeWorld(new CreditsWorld());
						break;
					case 3:
						//var request:URLRequest = new URLRequest(GlobalData.SPONSOR_URL);
						//navigateToURL(request); 
						break;
				}
			}
		}
		
		override public function render():void 
		{
			super.render();
			
			gameNameImage.render(FP.buffer, gameNamePoint, FP.camera);
			
			Draw.rect( -10, listOfPoints[selector].y - 10, GlobalData.GAME_WIDTH + 20, 20);
			
			for (var i:int = 0; i < listOfOptions.length; i += 1)
			{
				listOfOptions[i].render(FP.buffer, listOfPoints[i], FP.camera);
			}
			
			hintText.render(FP.buffer, new Point(GlobalData.GAME_WIDTH / 2, GlobalData.GAME_HEIGHT - 6), FP.camera);
		}
		
	}

}