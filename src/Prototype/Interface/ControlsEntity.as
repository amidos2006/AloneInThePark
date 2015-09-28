package Prototype.Interface 
{
	import flash.geom.Point;
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
	import Prototype.World.CharacterSelectWorld;
	import Prototype.World.GameModesWorld;
	import Prototype.World.MainMenuStoryHighScoreWorld;
	import Prototype.World.MainMenuWorld;
	/**
	 * ...
	 * @author Amidos
	 */
	public class ControlsEntity extends Entity
	{
		[Embed(source = "../../../assets/Graphics/controlSelectionImage.png")]private var GameName:Class;
		[Embed(source = "../../../assets/Sound/menuSelect.mp3")]private var menuSelectClass:Class;
		
		private var selector:int;
		private var gameNameImage:Image;
		private var gameNamePoint:Point;
		private var listOfOptions:Vector.<Text> = new Vector.<Text>();
		private var listOfPoints:Vector.<Point> = new Vector.<Point>();
		
		private var keyPressed:Boolean = false;
		
		private var hintText:Text;
		private var menuSelectSfx:Sfx;
		
		private var worldType:Boolean;
		
		public function ControlsEntity(worldType:Boolean) 
		{
			this.worldType = worldType;
			
			selector = 0;
			
			gameNameImage = new Image(GameName);
			gameNameImage.centerOO();
			
			gameNamePoint = new Point(GlobalData.GAME_WIDTH / 2, gameNameImage.height / 2 + 10);
			
			Text.size = 16;
			
			listOfOptions.push(new Text("WASD: Move - Arrows: Shoot"));
			listOfOptions.push(new Text("Arrows: Move - WASD: Shoot"));
			listOfOptions.push(new Text("Arrows/WASD: Move - Mouse: Shoot"));
			listOfOptions.push(new Text("Arrows/WASD: Move - Space: Shoot"));
			listOfOptions.push(new Text("Back"));
			
			for (var i:int = 0; i < listOfOptions.length; i += 1)
			{
				listOfOptions[i].centerOO();
				listOfOptions[i].color = 0xFFFFFF;
				
				listOfPoints.push(new Point(GlobalData.GAME_WIDTH / 2, 2 * gameNamePoint.y + 35 + i * 20));
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
						GlobalData.controlScheme = 0;
						GlobalData.EndThemeWorld(new CharacterSelectWorld(worldType));
						break;
					case 1:
						GlobalData.controlScheme = 1;
						GlobalData.EndThemeWorld(new CharacterSelectWorld(worldType));
						break;
					case 2:
						GlobalData.controlScheme = 2;
						GlobalData.EndThemeWorld(new CharacterSelectWorld(worldType));
						break;
					case 3:
						GlobalData.controlScheme = 3;
						GlobalData.EndThemeWorld(new CharacterSelectWorld(worldType));
						break;
					case 4:
						GlobalData.EndThemeWorld(new GameModesWorld());
						break;
				}
				
				Input.clear();
			}
			
			if (Input.pressed(Key.ESCAPE))
			{
				keyPressed = true;
				GlobalData.EndThemeWorld(new GameModesWorld());
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