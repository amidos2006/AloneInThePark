package Prototype.World 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	import Prototype.CollisionNames;
	import Prototype.Enemies.*;
	import Prototype.Enemies.Boss.Boss2ProjectileShotEntity;
	import Prototype.GlobalData;
	import Prototype.HUD.HUDDrawerEntity;
	import Prototype.Interface.MuteEntity;
	import Prototype.Interface.NewgroundsEntity;
	import Prototype.LayerConstant;
	import Prototype.Player.PlayerEntity;
	/**
	 * ...
	 * @author Amidos
	 */
	public class ThemeWorld extends World
	{
		[Embed(source = "../../../assets/Graphics/tileSet.png")]private var tileClass:Class;
		
		private const NORMAL:String = "Normal";
		private const APPEAR:String = "Appear";
		private const DISAPPEAR:String = "Disappear";
		
		private var tiles:Tilemap;
		private var grid:Grid;
		private var playerX:int;
		private var playerY:int;
		
		private var transitionHeight:int;
		private var speed:int;
		private var status:String;
		private var newgroundsEntity:NewgroundsEntity;
		
		public var nextWorld:World;
		public var startNewGame:Boolean = false;
		
		public function ThemeWorld(levelXml:XML) 
		{
			LoadTiles(levelXml);
			var bitmap:BitmapData = new BitmapData(FP.width, FP.height, true, 0x44000000);
			addGraphic(new Image(bitmap), LayerConstant.SHADOW_LAYER);
			
			if (!(this is EntranceWorld || this is NewgroundsEntranceWorld))
			{
				newgroundsEntity = new NewgroundsEntity();
				add(newgroundsEntity);
			}
			
			transitionHeight = GlobalData.GAME_HEIGHT / 2;
			speed = 4;
			status = APPEAR;
		}
		
		private function LoadTiles(levelXml:XML):void
		{
			tiles = new Tilemap(tileClass, GlobalData.GAME_WIDTH, GlobalData.GAME_HEIGHT, GlobalData.GAME_TILE_SIZE, GlobalData.GAME_TILE_SIZE);
			
			var o:Object;
			
			if ("tileLayer" in levelXml)
			{
				for each(o in levelXml.tileLayer[0].tile)
				{
					var col:int = Math.round(o.@x / GlobalData.GAME_TILE_SIZE);
					var row:int = Math.round(o.@y / GlobalData.GAME_TILE_SIZE);
					
					tiles.setTile(col, row, o.@id);
				}
			}
			
			addGraphic(tiles, LayerConstant.TILE_LAYER);
		}
		
		override public function begin():void 
		{
			super.begin();
			
			if (!(this is EntranceWorld || this is EnterNameWorld || this is NewgroundsEntranceWorld || this is IntroStoryWorld))
			{
				var muteButton:MuteEntity = new MuteEntity();
				muteButton.x = FP.width;
				muteButton.y = 6;
				
				add(muteButton);
			}
		}
		
		override public function end():void 
		{
			super.end();
			
			if (newgroundsEntity != null)
			{
				remove(newgroundsEntity);
			}
		}
		
		public function EndWorld():void
		{
			status = DISAPPEAR;
		}
		
		private function Appear():void
		{
			transitionHeight -= speed;
			if (transitionHeight < 0)
			{
				transitionHeight = 0;
				status = NORMAL;
			}
		}
		
		private function Disappear():void
		{
			transitionHeight += speed;
			if (transitionHeight > GlobalData.GAME_HEIGHT / 2)
			{
				transitionHeight = GlobalData.GAME_HEIGHT / 2;
				
				if (!startNewGame)
				{
					FP.world = nextWorld;
				}
				else
				{
					GlobalData.StartLevel();
				}
			}
		}
		
		override public function update():void 
		{
			super.update();
			GlobalData.CheckAchievements();
			
			if (status == APPEAR)
			{
				Appear();
			}
			
			if (status == DISAPPEAR)
			{
				Disappear();
			}
		}
		
		override public function render():void 
		{
			super.render();
			
			FP.buffer.fillRect(new Rectangle(0, 0, GlobalData.GAME_WIDTH, transitionHeight), 0x000000);
			FP.buffer.fillRect(new Rectangle(0, GlobalData.GAME_HEIGHT - transitionHeight, GlobalData.GAME_WIDTH, transitionHeight), 0x000000);
		}
	}

}