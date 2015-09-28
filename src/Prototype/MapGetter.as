package Prototype 
{
	import net.flashpunk.FP;
	import Prototype.World.EndGameWorld;
	/**
	 * ...
	 * @author Amidos
	 */
	public class MapGetter 
	{
		[Embed(source = "../../assets/World/level1World.oel", mimeType = "application/octet-stream")]private static var level1Map:Class;
		[Embed(source = "../../assets/World/level2World.oel", mimeType = "application/octet-stream")]private static var level2Map:Class;
		[Embed(source = "../../assets/World/level3World.oel", mimeType = "application/octet-stream")]private static var level3Map:Class;
		[Embed(source = "../../assets/World/level4World.oel", mimeType = "application/octet-stream")]private static var level4Map:Class;
		[Embed(source = "../../assets/World/level5World.oel", mimeType = "application/octet-stream")]private static var level5Map:Class;
		[Embed(source = "../../assets/World/level6World.oel", mimeType = "application/octet-stream")]private static var level6Map:Class;
		[Embed(source = "../../assets/World/level7World.oel", mimeType = "application/octet-stream")]private static var level7Map:Class;
		[Embed(source = "../../assets/World/level8World.oel", mimeType = "application/octet-stream")]private static var level8Map:Class;
		[Embed(source = "../../assets/World/level9World.oel", mimeType = "application/octet-stream")]private static var level9Map:Class;
		[Embed(source = "../../assets/World/level10World.oel", mimeType = "application/octet-stream")]private static var level10Map:Class;
		[Embed(source = "../../assets/World/level11World.oel", mimeType = "application/octet-stream")]private static var level11Map:Class;
		[Embed(source = "../../assets/World/level12World.oel", mimeType = "application/octet-stream")]private static var level12Map:Class;
		[Embed(source = "../../assets/World/level13World.oel", mimeType = "application/octet-stream")]private static var level13Map:Class;
		[Embed(source = "../../assets/World/level14World.oel", mimeType = "application/octet-stream")]private static var level14Map:Class;
		[Embed(source = "../../assets/World/level15World.oel", mimeType = "application/octet-stream")]private static var level15Map:Class;
		[Embed(source = "../../assets/World/survival1World.oel", mimeType = "application/octet-stream")]private static var survival1Map:Class;
		[Embed(source = "../../assets/World/survival2World.oel", mimeType = "application/octet-stream")]private static var survival2Map:Class;
		[Embed(source = "../../assets/World/survival3World.oel", mimeType = "application/octet-stream")]private static var survival3Map:Class;
		[Embed(source = "../../assets/World/survival4World.oel", mimeType = "application/octet-stream")]private static var survival4Map:Class;
		[Embed(source = "../../assets/World/survival5World.oel", mimeType = "application/octet-stream")]private static var survival5Map:Class;
		
		private static var array:Array = [level1Map, level2Map, level3Map, level4Map, level5Map, level6Map, level7Map, level8Map, level9Map, level10Map, level11Map, level12Map, level13Map, level14Map, level15Map];
		private static var survivalArray:Array = [survival1Map];
		
		public static function GetMap(levelNumber:int):XML
		{
			if (levelNumber <= array.length)
			{
				return FP.getXML(array[levelNumber -1]);
			}
			
			return null;
		}
		
		public static function GetRandomTheme():XML
		{
			var random:int = FP.rand(array.length);
			
			return FP.getXML(array[random]);
		}
		
		public static function GetSurvivalMap():XML
		{
			var random:int = FP.rand(survivalArray.length);
			
			return FP.getXML(survivalArray[random]);
		}
	}

}