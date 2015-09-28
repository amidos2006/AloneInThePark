package Prototype.Interface.Statistics 
{
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
	public class EnemyStatisticsEntity extends BaseStatisticsEntity
	{
		[Embed(source = "../../../../assets/Graphics/normalMushroom.png")]private var normalMushroomClass:Class;
		[Embed(source = "../../../../assets/Graphics/bigMushroom.png")]private var bigMushroomClass:Class;
		[Embed(source = "../../../../assets/Graphics/shyMushroom.png")]private var shyMushroomClass:Class;
		[Embed(source = "../../../../assets/Graphics/spitMushroom.png")]private var spitMushroomClass:Class;
		[Embed(source = "../../../../assets/Graphics/bigSpitMushroom.png")]private var bigSpitMushroomClass:Class;
		[Embed(source = "../../../../assets/Graphics/flyingMushroom.png")]private var flyingMushroomClass:Class;
		[Embed(source = "../../../../assets/Graphics/IronMushroom.png")]private var ironMushroomClass:Class;
		[Embed(source = "../../../../assets/Graphics/littleIronMushroom.png")]private var littleIronMushroomClass:Class;
		[Embed(source = "../../../../assets/Graphics/runningMushroom.png")]private var runningMushroomClass:Class;
		[Embed(source = "../../../../assets/Graphics/tallRunningMushroom.png")]private var tallRunningMushroomClass:Class;
		
		private var enemySpriteMaps:Vector.<Spritemap> = new Vector.<Spritemap>();
		private var enemyKillsText:Vector.<Text> = new Vector.<Text>();
		
		private var positionPoints:Vector.<Point> = new Vector.<Point>();
		
		private var movingStatus:String = "moving";
		private var frameSpeed:Number = 0.2;
		
		public function EnemyStatisticsEntity(nextWorldClass:Class) 
		{
			super(nextWorldClass);
			
			Text.size = 16;
			statisticName = new Text("Enemy Kills");
			statisticName.centerOO();
			statisticName.color = 0xFFFFFF;
			
			for (var j:int = 0; j < GlobalData.NUMBER_TYPES_ENEMY; j++) 
			{
				enemySpriteMaps.push(null);
			}
			
			enemySpriteMaps[GlobalData.NORMAL_MUSHROOM] = new Spritemap(normalMushroomClass, 9, 12);
			enemySpriteMaps[GlobalData.NORMAL_MUSHROOM].add(movingStatus, [4, 5, 6, 7, 6, 5], frameSpeed);
			
			enemySpriteMaps[GlobalData.SHY_MUSHROOM] = new Spritemap(shyMushroomClass, 9, 12);
			enemySpriteMaps[GlobalData.SHY_MUSHROOM].add(movingStatus, [4, 5, 6, 7, 6, 5], frameSpeed);
			
			enemySpriteMaps[GlobalData.SPIT_MUSHROOM] = new Spritemap(spitMushroomClass, 9, 14);
			enemySpriteMaps[GlobalData.SPIT_MUSHROOM].add(movingStatus, [4, 5, 6, 7, 6, 5], frameSpeed);
			
			enemySpriteMaps[GlobalData.LITTLE_IRON_MUSHROOM] = new Spritemap(littleIronMushroomClass, 9, 12);
			enemySpriteMaps[GlobalData.LITTLE_IRON_MUSHROOM].add(movingStatus, [4, 5, 6, 7, 6, 5], frameSpeed);
			
			enemySpriteMaps[GlobalData.RUNNING_MUSHROOM] = new Spritemap(runningMushroomClass, 9, 12);
			enemySpriteMaps[GlobalData.RUNNING_MUSHROOM].add(movingStatus, [4, 5, 6, 7, 6, 5], frameSpeed);
			
			enemySpriteMaps[GlobalData.BIG_MUSHROOM] = new Spritemap(bigMushroomClass, 16, 22);
			enemySpriteMaps[GlobalData.BIG_MUSHROOM].add(movingStatus, [0, 1, 2, 3, 2, 1], frameSpeed);
			
			enemySpriteMaps[GlobalData.BIG_SPIT_MUSHROOM] = new Spritemap(bigSpitMushroomClass, 16, 22);
			enemySpriteMaps[GlobalData.BIG_SPIT_MUSHROOM].add(movingStatus, [0, 1, 2, 3, 2, 1], frameSpeed);
			
			enemySpriteMaps[GlobalData.IRON_MUSHROOM] = new Spritemap(ironMushroomClass, 16, 22);
			enemySpriteMaps[GlobalData.IRON_MUSHROOM].add(movingStatus, [0, 1, 2, 3, 2, 1], frameSpeed);
			
			enemySpriteMaps[GlobalData.TALL_RUNNING_MUSHROOM] = new Spritemap(tallRunningMushroomClass, 9, 14);
			enemySpriteMaps[GlobalData.TALL_RUNNING_MUSHROOM].add(movingStatus, [4, 5, 6, 7, 6, 5], frameSpeed);
			
			enemySpriteMaps[GlobalData.FLYING_MUSHROOM] = new Spritemap(flyingMushroomClass, 16, 16);
			enemySpriteMaps[GlobalData.FLYING_MUSHROOM].add(movingStatus, [0, 1, 2, 3, 2, 1], frameSpeed);
			
			Text.size = 8;
			
			var modulusDividor:int = GlobalData.NUMBER_TYPES_ENEMY / 2;
			var margins:int = 40;
			var startingY:int = imagePoint.y + image.height / 2 + 60;
			var distanceY:int = 50;
			
			var dividorX:int = (GlobalData.GAME_WIDTH - 2 * margins) / (modulusDividor - 1);
			
			for (var i:int = 0; i < GlobalData.NUMBER_TYPES_ENEMY; i++) 
			{
				enemySpriteMaps[i].play(movingStatus);
				if (GlobalData.enemyKills[i] <= 0)
				{
					enemySpriteMaps[i].color = 0x000000;
				}
				
				enemySpriteMaps[i].originX = enemySpriteMaps[i].width / 2;
				enemySpriteMaps[i].originY = enemySpriteMaps[i].height;
				
				enemyKillsText.push(new Text("Kills: " + GlobalData.enemyKills[i]));
				enemyKillsText[i].centerOO();
				enemyKillsText[i].color = 0xFFFFFF;
				
				var xIndex:int = i % modulusDividor;
				var yIndex:int = i / modulusDividor;
				
				positionPoints.push(new Point(margins + xIndex * dividorX, startingY + yIndex * distanceY));
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			for (var i:int = 0; i < GlobalData.NUMBER_TYPES_ENEMY; i++) 
			{
				if (GlobalData.enemyKills[i] > 0)
				{
					enemySpriteMaps[i].update();
				}
			}
		}
		
		override public function render():void 
		{
			super.render();
			
			for (var i:int = 0; i < GlobalData.NUMBER_TYPES_ENEMY; i++) 
			{
				enemySpriteMaps[i].render(FP.buffer, positionPoints[i], FP.camera);
				enemyKillsText[i].render(FP.buffer, new Point(positionPoints[i].x, positionPoints[i].y + 5), FP.camera);
			}
		}
		
	}

}