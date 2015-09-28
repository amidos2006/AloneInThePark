package Prototype.HUD 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import Prototype.GlobalData;
	import Prototype.LayerConstant;
	import Prototype.World.SurvivalWorld;
	/**
	 * ...
	 * @author Amidos
	 */
	public class HUDDrawerEntity extends Entity
	{
		[Embed(source = "../../../assets/Graphics/Heart.png")]private var heartClass:Class;
		[Embed(source = "../../../assets/Graphics/HeadStatusPlayer.png")]private var normalHeadStatusClass:Class;
		[Embed(source = "../../../assets/Graphics/HeadStatusGirl.png")]private var girlHeadStatusClass:Class;
		[Embed(source = "../../../assets/Graphics/HeadStatusZombie.png")]private var zombieHeadStatusClass:Class;
		[Embed(source = "../../../assets/Graphics/headStatusFat.png")]private var fatHeadStatusClass:Class;
		[Embed(source = "../../../assets/Graphics/headStatusMineCraft.png")]private var mineCraftHeadStatusClass:Class;
		[Embed(source = "../../../assets/Graphics/headStatusHollow.png")]private var hollowHeadStatusClass:Class;
		[Embed(source = "../../../assets/Graphics/headStatusVVVVVV.png")]private var vvvvvvHeadStatusClass:Class;
		
		private const STATUS_1:String = "1";
		private const STATUS_2:String = "2";
		private const STATUS_3:String = "3";
		private const STATUS_4:String = "4";
		
		private var characterStatus:Spritemap;
		private var healthImage:Image;
		private var scoreWritingText:Text;
		private var scoreText:Text;
		private var numberOfLivesText:Text;
		private var playerHealth:int;
		private var pointsSurvivalText:Text;
		
		public var isSurvival:Boolean;
		public var showSurvival:Boolean;
		
		public function HUDDrawerEntity() 
		{
			switch(GlobalData.characterSelected)
			{
				case GlobalData.NORMAL_PLAYER:
					characterStatus = new Spritemap(normalHeadStatusClass, 25, 23);
					break;
				case GlobalData.GIRL_PLAYER:
					characterStatus = new Spritemap(girlHeadStatusClass, 25, 23);
					break;
				case GlobalData.ZOMBIE_PLAYER:
					characterStatus = new Spritemap(zombieHeadStatusClass, 25, 23);
					break;
				case GlobalData.FAT_BOY_PLAYER:
					characterStatus = new Spritemap(fatHeadStatusClass, 25, 23);
					break;
				case GlobalData.MINECRAFT_PLAYER:
					characterStatus = new Spritemap(mineCraftHeadStatusClass, 25, 23);
					break;
				case GlobalData.HOLLOW_PLAYER:
					characterStatus = new Spritemap(hollowHeadStatusClass, 25, 23);
					break;
				case GlobalData.VVVVVV_PLAYER:
					characterStatus = new Spritemap(vvvvvvHeadStatusClass, 25, 23);
					break;
			}
			
			characterStatus.add(STATUS_1, [0]);
			characterStatus.add(STATUS_2, [1]);
			characterStatus.add(STATUS_3, [2]);
			characterStatus.add(STATUS_4, [3]);
			characterStatus.play(STATUS_1);
			
			healthImage = new Image(heartClass);
			healthImage.originX = healthImage.width;
			
			Text.size = 16;
			numberOfLivesText = new Text("x " + GlobalData.playerLives);
			numberOfLivesText.color = 0xFFFFFF;
			
			Text.size = 8;
			scoreWritingText = new Text("Score");
			scoreWritingText.color = 0xFFFFFF;
			scoreWritingText.centerOO();
			
			Text.size = 16;
			scoreText = new Text(GlobalData.playerScore.toString());
			scoreText.color = 0xFFFFFF;
			scoreText.centerOO();
			
			layer = LayerConstant.HUD_LAYER;
			
			Text.size = 8;
			pointsSurvivalText = new Text("Press Enter to upgrade player");
			pointsSurvivalText.color = 0xFFFFFF;
			pointsSurvivalText.centerOO();
		}
		
		private function UpdateHeadStatus():void
		{
			if (!GlobalData.playerEntity)
			{
				characterStatus.play(STATUS_4);
				playerHealth = 0;
				return;
			}
			
			playerHealth = GlobalData.playerEntity.currentPlayerHealth;
			var percentage:Number = playerHealth / GlobalData.GetMaxPlayerHealth();
			
			if (percentage > 0.75)
			{
				characterStatus.play(STATUS_1);
			}
			else if (percentage > 0.5)
			{
				characterStatus.play(STATUS_2);
			}
			else if (percentage > 0.25)
			{
				characterStatus.play(STATUS_3);
			}
			else
			{
				characterStatus.play(STATUS_4);
			}
		}
		
		private function UpdateLivesStatus():void
		{
			if (GlobalData.playerLives <= 0)
			{
				numberOfLivesText.text = "x 0";
				return;
			}
			
			numberOfLivesText.text = "x" + GlobalData.playerLives;
		}
		
		private function UpdateScore():void
		{
			Text.size = 16;
			scoreText = new Text(GlobalData.playerScore.toString());
			scoreText.color = 0xFFFFFF;
			scoreText.centerOO();
		}
		
		override public function update():void 
		{
			UpdateHeadStatus();
			UpdateLivesStatus();
			UpdateScore();
			
			characterStatus.update();
			super.update();
		}
		
		override public function render():void 
		{
			super.render();
			
			var headPoint:Point = new Point(x + 5, y + 5);
			var livesPoint:Point = new Point(x + headPoint.x + characterStatus.width + 5, y + headPoint.y + 6);
			var heartPoint:Point = new Point(GlobalData.GAME_WIDTH + x - 5, y + 8);
			var scorePoint:Point = new Point(GlobalData.GAME_WIDTH / 2, 8);
			
			characterStatus.render(FP.buffer, headPoint, FP.camera);
			
			for (var i:int = 0; i < playerHealth; i += 1)
			{
				healthImage.render(FP.buffer, new Point(heartPoint.x -i * (healthImage.width + 2), heartPoint.y), FP.camera);
			}
			
			numberOfLivesText.render(FP.buffer, livesPoint, FP.camera);
			
			scoreWritingText.render(FP.buffer, scorePoint, FP.camera);
			scoreText.render(FP.buffer, new Point(scorePoint.x, scorePoint.y + 10), FP.camera);
			
			if (isSurvival && showSurvival)
			{
				pointsSurvivalText.render(FP.buffer, new Point(GlobalData.GAME_WIDTH / 2, GlobalData.GAME_HEIGHT - 5), FP.camera);
			}
		}
		
	}

}