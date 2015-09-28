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
	public class BossStatisticsEntity extends BaseStatisticsEntity
	{
		[Embed(source = "../../../../assets/Graphics/boss1.png")]private var boss1Class:Class;
		[Embed(source = "../../../../assets/Graphics/boss2.png")]private var boss2Class:Class;
		[Embed(source = "../../../../assets/Graphics/boss3.png")]private var boss3Class:Class;
		[Embed(source = "../../../../assets/Graphics/boss4.png")]private var boss4Class:Class;
		[Embed(source = "../../../../assets/Graphics/boss5.png")]private var boss5Class:Class;
		
		private var enemySpriteMaps:Vector.<Spritemap> = new Vector.<Spritemap>();
		private var enemyKillsText:Vector.<Text> = new Vector.<Text>();
		
		private var positionPoints:Vector.<Point> = new Vector.<Point>();
		
		private var movingStatus:String = "moving";
		private var frameSpeed:Number = 0.2;
		
		public function BossStatisticsEntity(nextWorldClass:Class) 
		{
			super(nextWorldClass);
			
			Text.size = 16;
			statisticName = new Text("Boss Kills");
			statisticName.centerOO();
			statisticName.color = 0xFFFFFF;
			
			for (var j:int = 0; j < GlobalData.NUMBER_BOSS; j++) 
			{
				enemySpriteMaps.push(null);
			}
			
			enemySpriteMaps[GlobalData.BOSS_1] = new Spritemap(boss1Class, 24, 24);
			enemySpriteMaps[GlobalData.BOSS_1].add(movingStatus, [4, 5, 6, 7], frameSpeed);
			
			enemySpriteMaps[GlobalData.BOSS_2] = new Spritemap(boss2Class, 24, 24);
			enemySpriteMaps[GlobalData.BOSS_2].add(movingStatus, [4, 5, 6, 7], frameSpeed);
			
			enemySpriteMaps[GlobalData.BOSS_3] = new Spritemap(boss3Class, 24, 24);
			enemySpriteMaps[GlobalData.BOSS_3].add(movingStatus, [4, 5, 6, 7], frameSpeed);
			
			enemySpriteMaps[GlobalData.BOSS_4] = new Spritemap(boss4Class, 24, 24);
			enemySpriteMaps[GlobalData.BOSS_4].add(movingStatus, [4, 5, 6, 7], frameSpeed);
			
			enemySpriteMaps[GlobalData.BOSS_5] = new Spritemap(boss5Class, 24, 24);
			enemySpriteMaps[GlobalData.BOSS_5].add(movingStatus, [4, 5, 6, 7], frameSpeed);
			
			Text.size = 8;
			
			var margins:int = 40;
			var startingY:int = imagePoint.y + image.height / 2 + 85;
			
			var dividorX:int = (GlobalData.GAME_WIDTH - 2 * margins) / (GlobalData.NUMBER_BOSS - 1);
			
			for (var i:int = 0; i < GlobalData.NUMBER_BOSS; i++) 
			{
				enemySpriteMaps[i].play(movingStatus);
				if (GlobalData.bossKills[i] <= 0)
				{
					enemySpriteMaps[i].color = 0x000000;
				}
				
				enemySpriteMaps[i].originX = enemySpriteMaps[i].width / 2;
				enemySpriteMaps[i].originY = enemySpriteMaps[i].height;
				
				enemyKillsText.push(new Text("Kills: " + GlobalData.bossKills[i]));
				enemyKillsText[i].centerOO();
				enemyKillsText[i].color = 0xFFFFFF;
				
				var xIndex:int = i % GlobalData.NUMBER_BOSS;
				
				positionPoints.push(new Point(margins + xIndex * dividorX, startingY));
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			for (var i:int = 0; i < GlobalData.NUMBER_BOSS; i++) 
			{
				if (GlobalData.bossKills[i] > 0)
				{
					enemySpriteMaps[i].update();
				}
			}
		}
		
		override public function render():void 
		{
			super.render();
			
			for (var i:int = 0; i < GlobalData.NUMBER_BOSS; i++) 
			{
				enemySpriteMaps[i].render(FP.buffer, positionPoints[i], FP.camera);
				enemyKillsText[i].render(FP.buffer, new Point(positionPoints[i].x, positionPoints[i].y + 5), FP.camera);
			}
		}
		
	}

}