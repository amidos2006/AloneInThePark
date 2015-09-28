package Prototype.Interface 
{
	import com.newgrounds.API;
	import com.newgrounds.APIEvent;
	import com.newgrounds.ScoreBoard;
	import flash.geom.Point;
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
	import Prototype.World.CharacterSelectWorld;
	import Prototype.World.ControlWorld;
	import Prototype.World.MainMenuStoryHighScoreWorld;
	import Prototype.World.MainMenuWorld;
	/**
	 * ...
	 * @author Amidos
	 */
	public class GameOptionsEntity extends Entity
	{
		[Embed(source = "../../../assets/Graphics/GameName.png")]private var GameName:Class;
		[Embed(source = "../../../assets/Sound/menuSelect.mp3")]private var menuSelectClass:Class;
		
		private var selector:int;
		private var gameNameImage:Image;
		private var gameNamePoint:Point;
		private var scoreBoard:ScoreBoard;
		private var listOfOptions:Vector.<Text> = new Vector.<Text>();
		private var listOfPoints:Vector.<Point> = new Vector.<Point>();
		
		private var keyPressed:Boolean = false;
		
		private var hintText:Text;
		private var menuSelectSfx:Sfx;
		
		public function GameOptionsEntity() 
		{
			selector = 0;
			
			gameNameImage = new Image(GameName);
			gameNameImage.centerOO();
			
			gameNamePoint = new Point(GlobalData.GAME_WIDTH / 2, gameNameImage.height / 2 + 10);
			
			Text.size = 16;
			
			listOfOptions.push(new Text("Story Mode"));
			listOfOptions.push(new Text("Survival Mode"));
			listOfOptions.push(new Text("Highscore Tables"));
			listOfOptions.push(new Text("Back"));
			
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
				keyPressed = true;
				
				switch(selector)
				{
					case 0:
						GlobalData.EndThemeWorld(new ControlWorld(false));
						break;
					case 1:
						GlobalData.EndThemeWorld(new ControlWorld(true));
						break;
					case 2:
						GlobalData.InitilaizeHighScoreTables();
						API.addEventListener(APIEvent.SCORES_LOADED, ScoresReceived);
						scoreBoard = API.loadScores("Story Scoreboard");
						break;
					case 3:
						GlobalData.EndThemeWorld(new MainMenuWorld());
						break;
				}
				
				Input.clear();
			}
			
			if (Input.pressed(Key.ESCAPE))
			{
				keyPressed = true;
				GlobalData.EndThemeWorld(new MainMenuWorld());
			}
		}
		
		public function ScoresReceived(args:APIEvent):void
		{
			API.removeEventListener(APIEvent.SCORES_LOADED, ScoresReceived);
			
			if (scoreBoard != null)
			{
				var count:Number = Math.min(10, scoreBoard.scores.length);
				var i:int = 0;
				
				for (i = 0; i < count; i += 1)
				{
					GlobalData.storyHighScores[i].Name = scoreBoard.scores[i].username;
					GlobalData.storyHighScores[i].Score = scoreBoard.scores[i].score;
					trace(scoreBoard.scores[i].score);
				}
				
				GlobalData.EndThemeWorld(new MainMenuStoryHighScoreWorld());
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