package Prototype.Interface 
{
	import com.newgrounds.API;
	import com.newgrounds.APIEvent;
	import com.newgrounds.Score;
	import com.newgrounds.ScoreBoard;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import Prototype.GlobalData;
	import Prototype.LayerConstant;
	import Prototype.Player.PlayerEntity;
	import Prototype.World.LevelWorld;
	import Prototype.World.MainMenuWorld;
	import Prototype.World.StoryHighScoreWorld;
	import Prototype.World.SurvivalHighScoreWorld;
	import Prototype.World.SurvivalWorld;
	
	/**
	 * ...
	 * @author Amidos
	 */
	public class HighScoreEnterNameEntity extends Entity
	{
		[Embed(source = "../../../assets/Sound/menuSelect.mp3")]private var menuSelectionClass:Class;
		
		private const maxPlayerName:Number = 8;
		
		private var yourScore:Text;
		private var enterYourNameText:Text;
		private var playerName:String = "";
		private var mainMenuText:Text;
		private var submitScoreText:Text;
		private var hintText:Text;
		private var overChoice:Number = 0;
		private var playerNameText:Text;
		private var playerScore:Number;
		private var enterPressed:Boolean = false;
		private var survivalMode:Boolean;
		private var menuSelectSfx:Sfx;
		private var scoreBoard:ScoreBoard;
		private var isLoggedOn:Boolean;
		
		public function HighScoreEnterNameEntity(intialPlayerName:String, playerScoreIn:Number, isSurvival:Boolean = false) 
		{
			layer = LayerConstant.HUD_LAYER;
			playerName = intialPlayerName;
			playerScore = playerScoreIn;
			survivalMode = isSurvival;
			
			Text.size = 16;
			if (API.hasUserSession)
			{
				enterYourNameText = new Text("Game Over " + API.username);
			}
			else
			{
				enterYourNameText = new Text("Game Over");
			}
			enterYourNameText.color = 0xFFFFFF;
			enterYourNameText.centerOO();
			
			Text.size = 16;
			playerNameText = new Text("");
			playerNameText.color = 0xFFFFFF;
			
			Text.size = 8;
			if (isSurvival)
			{
				submitScoreText = new Text("Restart Survival");
			}
			else
			{
				submitScoreText = new Text("Reset Score & Continue Game");
			}
			submitScoreText.color = 0xFFFFFF;
			submitScoreText.centerOO();
			
			Text.size = 8;
			mainMenuText = new Text("Submit your score & Return to Menu");
			mainMenuText.color = 0xFFFFFF;
			mainMenuText.centerOO();
			
			Text.size = 8;
			hintText = new Text("Up and down to choose and Space to select");
			hintText.color = 0xFFFFFF;
			hintText.centerOO();
			
			Text.size = 8;
			yourScore = new Text("Your Score: " + playerScoreIn.toString());
			yourScore.centerOO();
			yourScore.color = 0xFFFFFF;
			
			menuSelectSfx = new Sfx(menuSelectionClass);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (!enterPressed)
			{
				if (Input.pressed(Key.BACKSPACE))
				{
					if (playerName.length > 0)
					{
						playerName = playerName.substr(0, playerName.length - 1);
					}
				}
				else if (Input.pressed(Key.SPACE))
				{
					if (overChoice == 0)
					{
						GlobalData.Intialize();
						
						var scoreBoard:ScoreBoard;
						
						GlobalData.playerName = playerName;
						API.addEventListener(APIEvent.SCORE_POSTED, ScoreSubmited);
						
						if (survivalMode)
						{
							if (API.hasUserSession)
							{
								API.postScore("Survival Scoreboard", playerScore);
							}
							else
							{
								ScoreSubmited(null);
							}
						}
						else
						{
							if (API.hasUserSession)
							{
								API.postScore("Story Scoreboard", playerScore);
							}
							else
							{
								ScoreSubmited(null);
							}
						}
						
						enterPressed = true;
					}
					else
					{
						if (survivalMode)
						{
							GlobalData.Intialize();
							GlobalData.EndThemeWorld(new SurvivalWorld());
						}
						else
						{
							GlobalData.playerLives = 2;
							GlobalData.playerScore = 0;
							GlobalData.EndThemeWorld(null);
						}
					}
				}
				else if (Input.pressed(Key.ESCAPE))
				{
					GlobalData.EndThemeWorld(new MainMenuWorld());
				}
				else if (Input.pressed(Key.UP) || Input.pressed(Key.W))
				{
					overChoice -= 1;
					if (overChoice < 0)
					{
						overChoice = 1;
					}
					
					menuSelectSfx.play();
				}
				else if (Input.pressed(Key.DOWN) || Input.pressed(Key.S))
				{
					overChoice += 1;
					if (overChoice > 1)
					{
						overChoice = 0;
					}
					
					menuSelectSfx.play();
				}
				else
				{
					var inputKey:String = "";
					
					for (var i:Number = Key.A; i <= Key.Z; i += 1)
					{
						if (Input.released(i))
						{
							inputKey = String.fromCharCode(i);
						}
					}
					
					for (i = Key.DIGIT_0; i <= Key.DIGIT_9; i += 1)
					{
						if (Input.released(i))
						{
							inputKey = String.fromCharCode(i);
						}
					}
					
					if (playerName.length < maxPlayerName)
					{
						playerName += inputKey;
					}
				}
			}
			
			playerNameText = new Text(playerName + "_");
			playerNameText.size = 16;
			playerNameText.color = 0xFFFFFF;
			playerNameText.centerOO();
			
			if (overChoice == 0)
			{
				mainMenuText.color = 0x000000;
				submitScoreText.color = 0xFFFFFF;
			}
			else if(overChoice == 1)
			{
				mainMenuText.color = 0xFFFFFF;
				submitScoreText.color = 0x000000;
			}
		}
		
		public function ScoreSubmited(event:APIEvent):void
		{
			API.removeEventListener(APIEvent.SCORE_POSTED, ScoreSubmited);
			API.addEventListener(APIEvent.SCORES_LOADED, ScoresReceived);
			
			if (survivalMode)
			{
				scoreBoard = API.loadScores("Survival Scoreboard");
			}
			else
			{
				scoreBoard = API.loadScores("Story Scoreboard");
			}
		}
		
		public function ScoresReceived(event:APIEvent):void
		{
			API.removeEventListener(APIEvent.SCORES_LOADED, ScoresReceived);
			
			if (scoreBoard != null)
			{
				var i:int = 0;
				var count:Number = Math.min(10, scoreBoard.scores.length);
				
				if (survivalMode)
				{
					for (i = 0; i < count; i += 1)
					{
						GlobalData.survivalHighScores[i].Name = scoreBoard.scores[i].username;
						GlobalData.survivalHighScores[i].Score = scoreBoard.scores[i].score;
					}
					
					GlobalData.EndThemeWorld(new SurvivalHighScoreWorld());
				}
				else
				{
					for (i = 0; i < count; i += 1)
					{
						GlobalData.storyHighScores[i].Name = scoreBoard.scores[i].username;
						GlobalData.storyHighScores[i].Score = scoreBoard.scores[i].score;
					}
					
					GlobalData.EndThemeWorld(new StoryHighScoreWorld());
				}
			}
			else
			{
				GlobalData.EndThemeWorld(new MainMenuWorld());
			}
		}
		
		override public function render():void 
		{
			super.render();
			
			var tempPoint:Point = new Point(x + GlobalData.GAME_WIDTH / 2, y + GlobalData.GAME_HEIGHT / 2 - 20);
			
			yourScore.render(FP.buffer, new Point(tempPoint.x, tempPoint.y), FP.camera);
			
			tempPoint.y = tempPoint.y + 14;
			enterYourNameText.render(FP.buffer, new Point(tempPoint.x, tempPoint.y), FP.camera);
			
			//tempPoint.y = tempPoint.y + 18;
			//playerNameText.render(FP.buffer, new Point(tempPoint.x, tempPoint.y), FP.camera);
			
			tempPoint.y = tempPoint.y + 18;
			
			if (overChoice == 0)
			{
				Draw.rect( -10, tempPoint.y - 6, GlobalData.GAME_WIDTH + 20, 12);
			}
			else
			{
				Draw.rect( -10, tempPoint.y + 14 - 6, GlobalData.GAME_WIDTH + 20, 12);
			}
			
			mainMenuText.render(FP.buffer, new Point(tempPoint.x, tempPoint.y), FP.camera);
			submitScoreText.render(FP.buffer, new Point(tempPoint.x, tempPoint.y + 14), FP.camera);
			
			hintText.render(FP.buffer, new Point(GlobalData.GAME_WIDTH / 2, GlobalData.GAME_HEIGHT - 20), FP.camera);
		}
	}

}