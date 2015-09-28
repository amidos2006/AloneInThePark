package Prototype.World 
{
	import com.newgrounds.API;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
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
	public class NewgroundsEntranceWorld extends ThemeWorld
	{	
		[Embed(source = "../../../assets/SponsorStuff/pixel_logo_medium.gif")]private var newgroundsLogoClass:Class;
		
		private var newgroundsImage:Image;
		
		public function NewgroundsEntranceWorld() 
		{
			super(MapGetter.GetRandomTheme());
			
			newgroundsImage = new Image(newgroundsLogoClass);
			newgroundsImage.centerOO();
			
			addGraphic(newgroundsImage, LayerConstant.HUD_LAYER, GlobalData.GAME_WIDTH / 2, GlobalData.GAME_HEIGHT / 2);
			
			addTween(new Alarm(150, GoToMainMenu, Tween.ONESHOT), true);
		}
		
		private function GoToMainMenu():void
		{
			GlobalData.EndThemeWorld(new EntranceWorld());
		}
		
		override public function begin():void 
		{
			super.begin();
			
			FP.stage.addEventListener(MouseEvent.CLICK, MouseClicked);
		}
		
		override public function end():void 
		{
			super.end();
			
			FP.stage.removeEventListener(MouseEvent.CLICK, MouseClicked);
		}
		
		private function MouseClicked(mouseEvent:MouseEvent):void
		{
			if ((Input.mouseX > FP.halfWidth - newgroundsImage.width / 2 && Input.mouseY > FP.halfHeight - newgroundsImage.height / 2 &&
				Input.mouseX < FP.halfWidth + newgroundsImage.width / 2 && Input.mouseY < FP.halfHeight + newgroundsImage.height / 2))
			{
				navigateToURL(new URLRequest("http://www.newgrounds.com"));
			}
		}
	}

}