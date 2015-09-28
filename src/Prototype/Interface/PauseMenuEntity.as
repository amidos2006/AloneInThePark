package Prototype.Interface 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import Prototype.GlobalData;
	import Prototype.LayerConstant;
	import Prototype.MusicPlayer;
	/**
	 * ...
	 * @author Amidos
	 */
	public class PauseMenuEntity extends Entity
	{
		private var gamePausedText:Text;
		private var questionText:Text;
		private var answersVector:Vector.<Text> = new Vector.<Text>();
		private var hintText:Text;
		
		private var selector:int = 0;
		private var numberOfSelections:int = 2;
		private var xPressed:Boolean = false;
		private var returnWorld:World;
		
		private var pausePoint:Point;
		private var questionPoint:Point;
		private var answerPositionsVector:Vector.<Point> = new Vector.<Point>();
		
		public function PauseMenuEntity(world:World) 
		{
			Text.size = 16;
			gamePausedText = new Text("Game Paused");
			gamePausedText.color = 0xFFFFFF;
			gamePausedText.centerOO();
			
			Text.size = 16;
			questionText = new Text("Return to Main Menu?");
			questionText.color = 0xFFFFFF;
			questionText.centerOO();
			
			Text.size = 8;
			
			answersVector.push(new Text("Yes"));
			answersVector.push(new Text("No"));
			
			for (var i:int = 0; i < answersVector.length; i++) 
			{
				answersVector[i].color = 0xFFFFFF;
				answersVector[i].centerOO();
			}
			
			pausePoint = new Point(GlobalData.GAME_WIDTH / 2, GlobalData.GAME_HEIGHT / 2 - 40);
			questionPoint = new Point(GlobalData.GAME_WIDTH / 2, GlobalData.GAME_HEIGHT / 2 - 10);
			
			answerPositionsVector.push(new Point(GlobalData.GAME_WIDTH / 2, GlobalData.GAME_HEIGHT / 2 + 10));
			answerPositionsVector.push(new Point(GlobalData.GAME_WIDTH / 2, GlobalData.GAME_HEIGHT / 2 + 20));
			
			hintText = new Text("Up and Down to choose and Space to select");
			hintText.color = 0xFFFFFF;
			hintText.centerOO();
			
			returnWorld = world;
			
			layer = LayerConstant.HUD_LAYER;
		}
		
		override public function update():void 
		{
			super.update();
			if (xPressed)
			{
				return;
			}
			
			if (Input.pressed(Key.UP) || Input.pressed(Key.W))
			{
				selector -= 1;
				if (selector < 0)
				{
					selector = answersVector.length - 1;
				}
			}
			
			if (Input.pressed(Key.DOWN) || Input.pressed(Key.S))
			{
				selector = (selector + 1) % answersVector.length;
			}
			
			if (Input.pressed(Key.SPACE))
			{
				xPressed = true;
				MusicPlayer.ChangeVolume(MusicPlayer.MAX_MUSIC);
				FP.world = returnWorld;
				
				switch(selector)
				{
					case 0:
						GlobalData.playerLives = 0;
						if (GlobalData.playerEntity != null)
						{
							GlobalData.playerEntity.DestroyPlayer(returnWorld);
						}
						else
						{
							GlobalData.GameOver(returnWorld);
						}
						break;
				}
				
				Input.clear();
			}
			
			if (Input.pressed(Key.ESCAPE))
			{
				xPressed = true;
				MusicPlayer.ChangeVolume(MusicPlayer.MAX_MUSIC);
				FP.world = returnWorld;
				Input.clear();
			}
			
			for (var i:int = 0; i < answersVector.length; i++) 
			{
				answersVector[i].color = 0xFFFFFF;
			}
			
			answersVector[selector].color = 0x000000;
		}
		
		override public function render():void 
		{
			super.render();
			
			gamePausedText.render(FP.buffer, pausePoint, FP.camera);
			questionText.render(FP.buffer, questionPoint, FP.camera);
			
			Draw.rect(-10, answerPositionsVector[selector].y - 5, GlobalData.GAME_WIDTH + 20, 10);
			
			for (var i:int = 0; i < answersVector.length; i++) 
			{
				answersVector[i].render(FP.buffer, answerPositionsVector[i], FP.camera);
			}
			
			hintText.render(FP.buffer, new Point(GlobalData.GAME_WIDTH / 2, GlobalData.GAME_HEIGHT - 6), FP.camera);
		}
	}

}