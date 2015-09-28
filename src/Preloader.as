package  
{
	import com.newgrounds.API;
	import com.newgrounds.components.FlashAd;
	import com.newgrounds.components.MedalPopup;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import mochi.as3.MochiServices;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Key;
	/**
	 * ...
	 * @author Amidos
	 */
	
	[SWF(width = "640", height = "480", backgroundColor="#000000")]
	public class Preloader extends MovieClip
	{
		[Embed(source = 'net/flashpunk/graphics/04B_03__.TTF', embedAsCFF="false", fontFamily = 'PreloaderFont')]static private var gameFont:Class;
		[Embed(source="../assets/SponsorStuff/pixel_tank_ng.gif")]static private var sponsorImg:Class;
		[Embed(source="../assets/LoadingImage1.png")]static private var loadingBack1Img:Class;
		[Embed(source="../assets/LoadingImage2.png")]static private var loadingBack2Img:Class;
		[Embed(source="../assets/LoadingImage3.png")]static private var loadingBack3Img:Class;
		[Embed(source="../assets/LoadingImage4.png")]static private var loadingBack4Img:Class;
		[Embed(source="../assets/LoadingImage5.png")]static private var loadingBack5Img:Class;
		
		private var text:TextField = new TextField();
		private var loadingText:TextField = new TextField();
		private var sponsorBitmap:Bitmap = new sponsorImg;
		private var sponsorLogo:Sprite;
		private var backgroundArray:Array = [new loadingBack1Img, new loadingBack2Img, new loadingBack3Img, new loadingBack4Img, new loadingBack5Img];
		private var background:Bitmap;
		private var loadingTextFormat:TextFormat = new TextFormat();
		private var textFormat:TextFormat = new TextFormat();
		private var font:Font = new gameFont() as Font;
		private var loadedBytes:Number = 0;
		private var blackFrame:Bitmap;
		private var flashAd:FlashAd;
		private var totalBytes:Number = 5335;
		private var notLoaded:Boolean = true;
		
		public function Preloader() 
		{	
			API.connect(this, "29553:kSqJSU6X", "E5vDFoioLGeiumuo3JciPTnqhP1wh762");
			
			var medalPopup:MedalPopup = new MedalPopup();
			medalPopup.scaleX = 0.75;
			medalPopup.scaleY = 0.75;
			medalPopup.x = 320 - medalPopup.width / 2;
			medalPopup.y = 480 - medalPopup.height - 5;
			medalPopup._alwaysOnTop = true;
			addChild(medalPopup);
			
			background = backgroundArray[Math.floor(Math.random() * backgroundArray.length)];
			addChild(background);
			
			blackFrame = new Bitmap(new BitmapData(10, 10, true, 0xFF000000));
			
			flashAd = new FlashAd();
			flashAd.showBorder = false;
			flashAd.x = 320 - flashAd.width / 2;
			flashAd.y = 480 - flashAd.height - 150;
			
			blackFrame.x = flashAd.x - 5;
			blackFrame.y = flashAd.y - 5;
			blackFrame.scaleX = (flashAd.width + 10) / 10;
			blackFrame.scaleY = (flashAd.height + 10) / 10;
			
			addChild(blackFrame);
			addChild(flashAd);
			
			addChild(loadingText);
			loadingText.text = "Loading";
			loadingText.x = stage.stageWidth / 2;
			loadingText.y = flashAd.y + flashAd.height + 20;
			loadingText.x -= loadingText.width /2;
			
			addChild(text);
			text.x = 640 / 2;
			text.y = loadingText.y + 30;
			
			loadingTextFormat.font = font.fontName;
			loadingTextFormat.size = 24;
			loadingTextFormat.color = 0xFFFFFFFF;
			
			textFormat.font = font.fontName;
			textFormat.size = 16;
			textFormat.color = 0xFFFFFFFF;
			
			sponsorBitmap.smoothing = false;
			sponsorBitmap.x = -sponsorBitmap.width / 2;
			sponsorBitmap.y = -sponsorBitmap.height / 2;
			sponsorLogo = new Sprite();
			sponsorLogo.addChild(sponsorBitmap);
			sponsorLogo.x = 320;
			sponsorLogo.y = 480 - sponsorLogo.height / 2 - 5;
			sponsorLogo.buttonMode = true;
			sponsorLogo.addEventListener(MouseEvent.CLICK, GoToSponsorWebsite);
			sponsorLogo.addEventListener(MouseEvent.MOUSE_OVER, EnlargeSize);
			sponsorLogo.addEventListener(MouseEvent.MOUSE_OUT, NormalSize);
			addChild(sponsorLogo);
			
			text.autoSize = TextFieldAutoSize.CENTER;
			text.defaultTextFormat = textFormat;
			text.embedFonts = true;
			text.textColor = 0xFFFFFFFF;
			text.x = stage.stageWidth / 2 - 5;
			text.selectable = false;
			
			loadingText.autoSize = TextFieldAutoSize.CENTER;
			loadingText.defaultTextFormat = loadingTextFormat;
			loadingText.embedFonts = true;
			loadingText.textColor = 0xFFFFFFFF;
			loadingText.selectable = false;
			
			notLoaded = true;
			
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
		}
		
		private function progress(e:ProgressEvent):void 
		{
			if (e.bytesTotal != 0)
			{
				totalBytes = Math.ceil(e.bytesTotal / 1024);
			}
			
			loadingText.textColor = 0xFFFFFFFF;
			text.textColor = 0xFFFFFFFF;
			loadedBytes = Math.ceil(e.bytesLoaded / 1024);
			loadingText.text = "Loading";
			text.text = loadedBytes + " kb / " + totalBytes + " kb";
		}
		
		private function checkFrame(e:Event):void 
		{
			loadingText.textColor = 0xFFFFFFFF;
			text.textColor = 0xFFFFFFFF;
			
			if(loadedBytes < totalBytes)
			{
				loadingText.text = "Loading";
				text.text = loadedBytes + " kb / " + totalBytes + " kb";
			}
			
			if (currentFrame == totalFrames) 
			{
				notLoaded = false;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, PlayClicked);
				loadingText.text = "Press Space to continue";
				text.text = totalBytes + " kb / " + totalBytes + " kb";
			}
		}
		
		private function PlayClicked(eventObject:KeyboardEvent):void
		{
			if (eventObject.keyCode == Key.SPACE)
			{
				removeEventListener(Event.ENTER_FRAME, checkFrame);
				loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, PlayClicked);
				
				removeChild(text);
				removeChild(loadingText);
				removeChild(blackFrame);
				removeChild(flashAd);
				removeChild(sponsorLogo);
				removeChild(background);
				
				startup();
			}
		}
		
		private function startup():void 
		{
			//if (SiteLock())
			{
				var c:Class = getDefinitionByName("Main") as Class;
				addChild(new c as DisplayObject);
			}
		}
		
		private function NormalSize(mouseEvent:MouseEvent):void
		{
			sponsorLogo.scaleX = 1;
			sponsorLogo.scaleY = 1;
		}
		
		private function EnlargeSize(mouseEvent:MouseEvent):void
		{
			sponsorLogo.scaleX = 1.1;
			sponsorLogo.scaleY = 1.1;
		}
		
		private function GoToSponsorWebsite(mouseEvent:MouseEvent):void
		{
			//API.loadNewgrounds();
			navigateToURL(new URLRequest("http://www.newgrounds.com"));
		}
		
		private function SiteLock():Boolean
		{
			var url:String=stage.loaderInfo.url;
			var urlStart:Number = url.indexOf("://")+3;
			var urlEnd:Number = url.indexOf("/", urlStart);
			var domain:String = url.substring(urlStart, urlEnd);
			var LastDot:Number = domain.lastIndexOf(".")-1;
			var domEnd:Number = domain.lastIndexOf(".", LastDot)+1;
			domain = domain.substring(domEnd, domain.length);
			if (domain == "newgrounds.com" || domain == "ungrounded.net") 
			{
				return true;
			}
			
			return false;
		}
		
	}

}