package Prototype.Interface 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import Prototype.GlobalData;
	import Prototype.LayerConstant;
	import Prototype.MusicPlayer;
	import Prototype.World.SurvivalWorld;
	/**
	 * ...
	 * @author Amidos
	 */
	public class LevelUpgradesEntity extends Entity
	{
		[Embed(source = "../../../assets/Graphics/ShopImage.png")]private var shopClass:Class;
		[Embed(source = "../../../assets/Graphics/Upgrades.png")]private var upgradesClass:Class;
		[Embed(source = "../../../assets/Sound/menuSelect.mp3")]private var menuSelectClass:Class;
		
		private var shopImage:Image;
		private var shopPosition:Point;
		
		private var imageVector:Vector.<Image> = new Vector.<Image>();
		private var textVector:Vector.<Text> = new Vector.<Text>();
		private var levelVector:Vector.<Text> = new Vector.<Text>();
		
		private var yPositionsVector:Vector.<int> = new Vector.<int>();
		
		private var xButtonPressed:Boolean = false;
		private var numberPoints:int = 0;
		private var selector:int = 0;
		private var healthPoints:int = 0;
		
		private var hintText:Text;
		private var pointsText:Text;
		private var isSurvivalWorld:SurvivalWorld;
		private var menuSelectSfx:Sfx;
		
		public function LevelUpgradesEntity(numberOfPoints:int = 1, isSurvival:SurvivalWorld = null) 
		{
			shopImage = new Image(shopClass);
			shopImage.centerOO();
			shopPosition = new Point(GlobalData.GAME_WIDTH / 2, shopImage.height / 2 + 10);
			
			Text.size = 16;
			textVector.push(new Text("Health Upgrade"));
			textVector.push(new Text("Weapon Upgrade"));
			textVector.push(new Text("Reload Upgrade"));
			textVector.push(new Text("Luck Upgrade"));
			
			Text.size = 16;
			levelVector.push(new Text(GlobalData.playerHealthLevel + "/" + GlobalData.MAX_PLAYER_HEALTH_LEVEL));
			levelVector.push(new Text(GlobalData.weaponLevel + "/" + GlobalData.MAX_WEAPON_LEVEL));
			levelVector.push(new Text(GlobalData.reloadLevel + "/" + GlobalData.MAX_RELOAD_LEVEL));
			levelVector.push(new Text(GlobalData.luckLevel + "/" + GlobalData.MAX_LUCK_LEVEL));
			
			imageVector.push(new Image(upgradesClass, new Rectangle(0, 16, 16, 16)));
			imageVector.push(new Image(upgradesClass, new Rectangle(0, 0, 16, 16)));
			imageVector.push(new Image(upgradesClass, new Rectangle(0, 32, 16, 16)));
			imageVector.push(new Image(upgradesClass, new Rectangle(0, 48, 16, 16)));
			
			for (var i:int = 0; i < textVector.length; i += 1)
			{
				textVector[i].color = 0xFFFFFF;
				textVector[i].originX = 0;
				textVector[i].originY = textVector[i].height / 2;
				
				imageVector[i].originX = 0;
				imageVector[i].originY = imageVector[i].height / 2;
				
				levelVector[i].color = 0xFFFFFF;
				levelVector[i].originX = levelVector[i].width;
				levelVector[i].originY = levelVector[i].height / 2;
				
				yPositionsVector.push(2 * shopPosition.y + 30 + i * 20);
			}
			
			Text.size = 8;
			hintText = new Text("Up and Down to choose and Space to select");
			hintText.color = 0xFFFFFF;
			hintText.centerOO();
			
			numberPoints = numberOfPoints;
			
			Text.size = 8;
			pointsText = new Text("Points remaining: " + numberPoints + "pts");
			pointsText.color = 0xFFFFFF;
			pointsText.centerOO();
			
			isSurvivalWorld = isSurvival;
			
			layer = LayerConstant.HUD_LAYER;
			
			menuSelectSfx = new Sfx(menuSelectClass);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (xButtonPressed)
			{
				return;
			}
			
			for (var i:int = 0; i < textVector.length; i+= 1) 
			{
				textVector[i].color = 0xFFFFFF;
				levelVector[i].color = 0xFFFFFF;
			}
			
			textVector[selector].color = 0x000000;
			levelVector[selector].color = 0x000000;
			
			if (Input.pressed(Key.UP) || Input.pressed(Key.W))
			{
				selector -= 1;
				if (selector < 0)
				{
					selector = textVector.length - 1;
				}
				
				menuSelectSfx.play();
			}
			
			if (Input.pressed(Key.DOWN) || Input.pressed(Key.S))
			{
				selector = (selector + 1) % textVector.length;
				menuSelectSfx.play();
			}
			
			if (Input.pressed(Key.SPACE))
			{
				Text.size = 16;
				switch(selector)
				{
					case 0:
						CheckHealth();
						levelVector[0] = new Text(GlobalData.playerHealthLevel + "/" + GlobalData.MAX_PLAYER_HEALTH_LEVEL);
						break;
					case 1:
						CheckWeapon();
						levelVector[1] = new Text(GlobalData.weaponLevel + "/" + GlobalData.MAX_WEAPON_LEVEL);
						break;
					case 2:
						CheckReload();
						levelVector[2] = new Text(GlobalData.reloadLevel + "/" + GlobalData.MAX_RELOAD_LEVEL);
						break;
					case 3:
						CheckLuck();
						levelVector[3] = new Text(GlobalData.luckLevel + "/" + GlobalData.MAX_LUCK_LEVEL);
						break;
				}
				
				for (i = 0; i < textVector.length; i += 1)
				{
					levelVector[i].color = 0xFFFFFF;
					levelVector[i].originX = levelVector[i].width;
					levelVector[i].originY = levelVector[i].height / 2;
				}
				
				levelVector[selector].color = 0x000000;
				
				Input.clear();
				
				Text.size = 8;
				pointsText = new Text("Points remaining: " + numberPoints + "pts");
				pointsText.centerOO();
				pointsText.color = 0xFFFFFF;
			}
		}
		
		private function AdvanceToNextLevel():void
		{
			xButtonPressed = true;
			
			if (!isSurvivalWorld)
			{
				GlobalData.levelNumber += 1;
				GlobalData.EndThemeWorld(null);
			}
			else
			{
				isSurvivalWorld.RefreshAfterShop(healthPoints);
				
				MusicPlayer.ChangeVolume(MusicPlayer.MAX_MUSIC);
				
				FP.world = isSurvivalWorld;
				isSurvivalWorld.numberOfPoints = 0;
			}
		}
		
		private function CheckHealth():void
		{
			if (GlobalData.playerHealthLevel < GlobalData.MAX_PLAYER_HEALTH_LEVEL)
			{
				GlobalData.playerHealthLevel += 1;
				
				healthPoints += 1;
				numberPoints -= 1;
				if (numberPoints <= 0)
				{
					AdvanceToNextLevel();
				}
			}
		}
		
		private function CheckWeapon():void
		{
			if (GlobalData.weaponLevel < GlobalData.MAX_WEAPON_LEVEL)
			{
				GlobalData.weaponLevel += 1;
				
				numberPoints -= 1;
				if (numberPoints <= 0)
				{
					AdvanceToNextLevel();
				}
			}
		}
		
		private function CheckReload():void
		{
			if (GlobalData.reloadLevel < GlobalData.MAX_RELOAD_LEVEL)
			{
				GlobalData.reloadLevel += 1;
				
				numberPoints -= 1;
				if (numberPoints <= 0)
				{
					AdvanceToNextLevel();
				}
			}
		}
		
		private function CheckLuck():void
		{
			if (GlobalData.luckLevel < GlobalData.MAX_LUCK_LEVEL)
			{
				GlobalData.luckLevel += 1;
				
				numberPoints -= 1;
				if (numberPoints <= 0)
				{
					AdvanceToNextLevel();
				}
			}
		}
		
		override public function render():void 
		{
			super.render();
			
			shopImage.render(FP.buffer, shopPosition, FP.camera);
			
			Draw.rect(-10, yPositionsVector[selector] - 10, GlobalData.GAME_WIDTH + 20, 20);
			
			for (var i:int = 0; i < textVector.length; i += 1)
			{
				imageVector[i].render(FP.buffer, new Point(10, yPositionsVector[i]), FP.camera);
				textVector[i].render(FP.buffer, new Point(10 + imageVector[i].width + 10,yPositionsVector[i]), FP.camera);
				levelVector[i].render(FP.buffer, new Point(GlobalData.GAME_WIDTH - 10,yPositionsVector[i]), FP.camera);
			}
			
			pointsText.render(FP.buffer, new Point(GlobalData.GAME_WIDTH / 2, GlobalData.GAME_HEIGHT - 25), FP.camera);
			hintText.render(FP.buffer, new Point(GlobalData.GAME_WIDTH / 2, GlobalData.GAME_HEIGHT - 15), FP.camera);
		}
		
	}

}