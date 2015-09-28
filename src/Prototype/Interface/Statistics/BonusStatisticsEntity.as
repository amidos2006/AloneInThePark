package Prototype.Interface.Statistics 
{
	import adobe.utils.CustomActions;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import Prototype.GlobalData;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BonusStatisticsEntity extends BaseStatisticsEntity
	{
		[Embed(source = "../../../../assets/Graphics/crate.png")]private var crateClass:Class;
		[Embed(source = "../../../../assets/Graphics/bonusLife.png")]private var healthClass:Class;
		[Embed(source = "../../../../assets/Graphics/BonusFork.png")]private var forkClass:Class;
		[Embed(source = "../../../../assets/Graphics/BonusPizzaCutter.png")]private var pizzaCutterClass:Class;
		[Embed(source = "../../../../assets/Graphics/BonusShield.png")]private var shieldClass:Class;
		[Embed(source = "../../../../assets/Graphics/BonusSpoon.png")]private var spoonClass:Class;
		
		private var crateSpriteMap:Spritemap;
		private var crateText:Text;
		private var cratePosition:Point;
		
		private var spriteMaps:Vector.<Spritemap> = new Vector.<Spritemap>();
		private var texts:Vector.<Text> = new Vector.<Text>();
		
		private var positionPoints:Vector.<Point> = new Vector.<Point>();
		
		private var movingStatus:String = "moving";
		private var frameSpeed:Number = 0.2;
		
		public function BonusStatisticsEntity(nextWorldClass:Class) 
		{
			super(nextWorldClass);
			
			Text.size = 16;
			statisticName = new Text("Bonus Collected");
			statisticName.centerOO();
			statisticName.color = 0xFFFFFF;
			
			crateSpriteMap = new Spritemap(crateClass, 16, 16);
			crateSpriteMap.add(movingStatus, [0], frameSpeed);
			crateSpriteMap.originX = crateSpriteMap.width / 2;
			crateSpriteMap.originY = crateSpriteMap.height;
			
			Text.size = 8;
			crateText = new Text("Destroyed: " + GlobalData.cratesDestroyed);
			crateText.centerOO();
			crateText.color = 0xFFFFFF;
			
			for (var j:int = 0; j < GlobalData.NUMBER_BONUS; j++) 
			{
				spriteMaps.push(null);
			}
			
			spriteMaps[GlobalData.HEART] = new Spritemap(healthClass, 8, 9);
			spriteMaps[GlobalData.HEART].add(movingStatus, [0], frameSpeed);
			
			spriteMaps[GlobalData.SHIELD] = new Spritemap(shieldClass, 12, 12);
			spriteMaps[GlobalData.SHIELD].add(movingStatus, [0], frameSpeed);
			
			spriteMaps[GlobalData.FORK] = new Spritemap(forkClass, 12, 12);
			spriteMaps[GlobalData.FORK].add(movingStatus, [0], frameSpeed);
			
			spriteMaps[GlobalData.SPOON] = new Spritemap(spoonClass, 12, 12);
			spriteMaps[GlobalData.SPOON].add(movingStatus, [0], frameSpeed);
			
			spriteMaps[GlobalData.PIZZA_CUTTER] = new Spritemap(pizzaCutterClass, 12, 12);
			spriteMaps[GlobalData.PIZZA_CUTTER].add(movingStatus, [0], frameSpeed);
			
			var margins:int = 40;
			var startingY:int = imagePoint.y + image.height / 2 + 95;
			
			cratePosition = new Point(GlobalData.GAME_WIDTH / 2, startingY - 35);
			
			var dividorX:int = (GlobalData.GAME_WIDTH - 2 * margins) / (GlobalData.NUMBER_BONUS - 1);
			
			for (var i:int = 0; i < GlobalData.NUMBER_BONUS; i++) 
			{
				spriteMaps[i].play(movingStatus);
				if (GlobalData.bonusGot[i] <= 0)
				{
					spriteMaps[i].color = 0x000000;
				}
				
				spriteMaps[i].originX = spriteMaps[i].width / 2;
				spriteMaps[i].originY = spriteMaps[i].height;
				
				texts.push(new Text("Collected: " + GlobalData.bonusGot[i]));
				texts[i].centerOO();
				texts[i].color = 0xFFFFFF;
				
				var xIndex:int = i % GlobalData.NUMBER_BONUS;
				
				positionPoints.push(new Point(margins + xIndex * dividorX, startingY));
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			for (var i:int = 0; i < GlobalData.NUMBER_BONUS; i++) 
			{
				if (GlobalData.bonusGot[i] > 0)
				{
					spriteMaps[i].update();
				}
			}
		}
		
		override public function render():void 
		{
			super.render();
			
			crateSpriteMap.render(FP.buffer, cratePosition, FP.camera);
			crateText.render(FP.buffer, new Point(cratePosition.x, cratePosition.y + 5), FP.camera);
			
			for (var i:int = 0; i < GlobalData.NUMBER_BONUS; i++) 
			{
				spriteMaps[i].render(FP.buffer, positionPoints[i], FP.camera);
				texts[i].render(FP.buffer, new Point(positionPoints[i].x, positionPoints[i].y + 5), FP.camera);
			}
		}
		
	}

}