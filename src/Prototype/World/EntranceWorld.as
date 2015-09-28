package Prototype.World 
{
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.utils.Input;
	import Prototype.GlobalData;
	import Prototype.LayerConstant;
	import Prototype.MapGetter;
	/**
	 * ...
	 * @author Amidos
	 */
	public class EntranceWorld extends ThemeWorld
	{	
		[Embed(source = "../../../assets/Graphics/ataurus.ttf", embedAsCFF="false", fontFamily = 'GameFont')]private var fontClass:Class;
		
		private var amidosText:Text;
		private var andText:Text;
		private var vartaghText:Text;
		
		public function EntranceWorld() 
		{
			super(MapGetter.GetRandomTheme());
			
			Text.size = 48;
			Text.font = "GameFont";
			
			amidosText = new Text("Amidos");
			amidosText.centerOO();
			amidosText.color = 0xFFFFFF;
			
			andText = new Text("&");
			andText.centerOO();
			andText.color = 0xFFFFFF;
			
			vartaghText = new Text("Vartagh");
			vartaghText.centerOO();
			vartaghText.color = 0xFFFFFF;
			
			Text.font = "default";
			
			addGraphic(amidosText, LayerConstant.HUD_LAYER, GlobalData.GAME_WIDTH / 2, GlobalData.GAME_HEIGHT / 2 - 48);
			addGraphic(andText, LayerConstant.HUD_LAYER, GlobalData.GAME_WIDTH / 2, GlobalData.GAME_HEIGHT / 2 - 0);
			addGraphic(vartaghText, LayerConstant.HUD_LAYER, GlobalData.GAME_WIDTH / 2, GlobalData.GAME_HEIGHT / 2 + 48);
			
			addTween(new Alarm(150, GoToMainMenu, Tween.ONESHOT), true);
		}
		
		private function GoToMainMenu():void
		{
			GlobalData.EndThemeWorld(new IntroStoryWorld());
		}
		
		override public function begin():void 
		{
			super.begin();
			
			FP.stage.addEventListener(MouseEvent.CLICK, AmidosClicked);
			FP.stage.addEventListener(MouseEvent.CLICK, VartaghClicked);
		}
		
		override public function end():void 
		{
			super.end();
			
			FP.stage.removeEventListener(MouseEvent.CLICK, AmidosClicked);
			FP.stage.removeEventListener(MouseEvent.CLICK, VartaghClicked);
		}
		
		private function AmidosClicked(mouseEvent:MouseEvent):void
		{
			if ((Input.mouseX > FP.halfWidth - amidosText.width / 2 && Input.mouseY > FP.halfHeight - 48 - amidosText.height / 2 &&
				Input.mouseX < FP.halfWidth + amidosText.width / 2 && Input.mouseY < FP.halfHeight - 48 + amidosText.height / 2))
			{
				navigateToURL(new URLRequest("http://amidos-games.blogspot.com"));
			}
		}
		
		private function VartaghClicked(mouseEvent:MouseEvent):void
		{
			if ((Input.mouseX > FP.halfWidth - vartaghText.width / 2 && Input.mouseY > FP.halfHeight + 48 - vartaghText.height / 2 &&
				Input.mouseX < FP.halfWidth + vartaghText.width / 2 && Input.mouseY < FP.halfHeight + 48 + vartaghText.height / 2))
			{
				navigateToURL(new URLRequest("http://twitter.com/Vartagh"));
			}
		}
	}

}