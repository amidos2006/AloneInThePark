package Prototype.Interface 
{
	import com.newgrounds.API;
	import com.newgrounds.APIEvent;
	import com.newgrounds.ScoreBoard;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import Prototype.GlobalData;
	import Prototype.LayerConstant;
	import Prototype.World.GameModesWorld;
	import Prototype.World.MainMenuWorld;
	import Prototype.World.SurvivalHighScoreWorld;
	/**
	 * ...
	 * @author Amidos
	 */
	public class HighscoreTable extends Entity
	{
		private var TextNameDrawer:Array = new Array();
		private var TextScoreDrawer:Array = new Array();
		private var highscoreTableName:Text;
		private var pressEnterToReturn:Text;
		private var returnToMainMenu:Boolean;
		private var isPressed:Boolean = false;
		private var scoreBoard:ScoreBoard;
		
		public function HighscoreTable(isSurvival:Boolean, isMainMenu:Boolean = false) 
		{
			Text.size = 16;
			
			if (isSurvival)
			{
				highscoreTableName = new Text("Survival Highscore Table");
			}
			else
			{
				highscoreTableName = new Text("Story Highscore Table");
			}
			
			highscoreTableName.color = 0xFFFFFF;
			highscoreTableName.centerOO();
			
			Text.size = 8;
			var textName:Text;
			var textScore:Text;
				
			for (var i:Number = 0; i < 10; i += 1)
			{	
				if (isSurvival)
				{
					textName = new Text(GlobalData.survivalHighScores[i].Name);
					textScore = new Text(GlobalData.survivalHighScores[i].Score.toString());
				}
				else
				{
					textName = new Text(GlobalData.storyHighScores[i].Name);
					textScore = new Text(GlobalData.storyHighScores[i].Score.toString());
				}
				
				textName.color = 0xFFFFFF;
				textName.originY = textName.height / 2;
					
				textScore.color = 0xFFFFFF;
				textScore.originX = textScore.width;
				textScore.originY = textScore.height / 2;
				
				TextNameDrawer.push(textName);
				TextScoreDrawer.push(textScore);
			}
			
			Text.size = 8;
			
			if (isMainMenu)
			{
				pressEnterToReturn = new Text("Press Space to see Survival Highscore table");
			}
			else
			{
				pressEnterToReturn = new Text("Press Space to return to Mainmenu");
			}
			
			pressEnterToReturn.color = 0xFFFFFF;
			pressEnterToReturn.centerOO();
			
			returnToMainMenu = isMainMenu;
			
			layer = LayerConstant.HUD_LAYER;
		}
		
		override public function update():void 
		{
			super.update();
			
			if ((Input.released(Key.SPACE) || Input.released(Key.ESCAPE)) && !isPressed)
			{
				isPressed = true;
				
				if (!returnToMainMenu)
				{
					GlobalData.EndThemeWorld(new MainMenuWorld());
				}
				else
				{
					API.addEventListener(APIEvent.SCORES_LOADED, ScoresReceived);
					scoreBoard = API.loadScores("Survival Scoreboard");
				}
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
					GlobalData.survivalHighScores[i].Name = scoreBoard.scores[i].username;
					GlobalData.survivalHighScores[i].Score = scoreBoard.scores[i].score;
				}
				
				GlobalData.EndThemeWorld(new SurvivalHighScoreWorld());
			}
			else
			{
				GlobalData.EndThemeWorld(new GameModesWorld());
			}
		}
		
		override public function render():void 
		{
			super.render();
			
			highscoreTableName.render(FP.buffer, new Point(GlobalData.GAME_WIDTH / 2 , 40), FP.camera);
			
			for (var i:Number = 0; i < 10; i += 1)
			{
				TextNameDrawer[i].render(FP.buffer, new Point(75, 60 + i * 11), FP.camera);
				TextScoreDrawer[i].render(FP.buffer, new Point(GlobalData.GAME_WIDTH - 80, 60 + i * 11), FP.camera);
			}
			
			pressEnterToReturn.render(FP.buffer, new Point(GlobalData.GAME_WIDTH / 2, GlobalData.GAME_HEIGHT - 20), FP.camera);
		}
		
	}

}