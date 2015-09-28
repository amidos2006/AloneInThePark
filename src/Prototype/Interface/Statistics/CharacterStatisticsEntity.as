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
	public class CharacterStatisticsEntity extends BaseStatisticsEntity
	{
		[Embed(source = "../../../../assets/Graphics/Player.png")]private var normalClass:Class;
		[Embed(source = "../../../../assets/Graphics/playerFat.png")]private var fatClass:Class;
		[Embed(source = "../../../../assets/Graphics/playerGirl.png")]private var girlClass:Class;
		[Embed(source = "../../../../assets/Graphics/playerMineCraft.png")]private var mineCraftClass:Class;
		[Embed(source = "../../../../assets/Graphics/playerZombie.png")]private var zombieClass:Class;
		[Embed(source = "../../../../assets/Graphics/PlayerHollow.png")]private var hollowClass:Class;
		[Embed(source = "../../../../assets/Graphics/PlayerVVVVVV.png")]private var vvvvvvClass:Class;
		
		private var spriteMaps:Vector.<Spritemap> = new Vector.<Spritemap>();
		private var texts:Vector.<Text> = new Vector.<Text>();
		private var texts2:Vector.<Text> = new Vector.<Text>();
		private var texts3:Vector.<Text> = new Vector.<Text>();
		
		private var positionPoints:Vector.<Point> = new Vector.<Point>();
		
		private var movingStatus:String = "moving";
		private var frameSpeed:Number = 0.16;
		
		public function CharacterStatisticsEntity(nextWorldClass:Class) 
		{
			super(nextWorldClass);
			
			Text.size = 16;
			statisticName = new Text("Characters");
			statisticName.centerOO();
			statisticName.color = 0xFFFFFF;
			
			for (var j:int = 0; j < GlobalData.MAX_CHARACTERS; j++) 
			{
				spriteMaps.push(null);
			}
			
			spriteMaps[GlobalData.NORMAL_PLAYER] = new Spritemap(normalClass, 16, 16);
			spriteMaps[GlobalData.NORMAL_PLAYER].add(movingStatus, [0, 1, 2, 3], frameSpeed);
			
			spriteMaps[GlobalData.GIRL_PLAYER] = new Spritemap(girlClass, 16, 16);
			spriteMaps[GlobalData.GIRL_PLAYER].add(movingStatus, [0, 1, 2, 3], frameSpeed);
			
			spriteMaps[GlobalData.ZOMBIE_PLAYER] = new Spritemap(zombieClass, 16, 16);
			spriteMaps[GlobalData.ZOMBIE_PLAYER].add(movingStatus, [0, 1, 2, 3], frameSpeed);
			
			spriteMaps[GlobalData.FAT_BOY_PLAYER] = new Spritemap(fatClass, 16, 16);
			spriteMaps[GlobalData.FAT_BOY_PLAYER].add(movingStatus, [0, 1, 2, 3], frameSpeed);
			
			spriteMaps[GlobalData.MINECRAFT_PLAYER] = new Spritemap(mineCraftClass, 16, 16);
			spriteMaps[GlobalData.MINECRAFT_PLAYER].add(movingStatus, [0, 1, 2, 3], frameSpeed);
			
			spriteMaps[GlobalData.HOLLOW_PLAYER] = new Spritemap(hollowClass, 16, 16);
			spriteMaps[GlobalData.HOLLOW_PLAYER].add(movingStatus, [0, 1, 2, 3], frameSpeed);
			
			spriteMaps[GlobalData.VVVVVV_PLAYER] = new Spritemap(vvvvvvClass, 16, 16);
			spriteMaps[GlobalData.VVVVVV_PLAYER].add(movingStatus, [0, 1, 2, 3], frameSpeed);
			
			var margins:int = 40;
			var margins2:int = 60;
			var startingY:int = imagePoint.y + image.height / 2 + 50;
			var distanceY:int = 50;
			
			var dividorX:int = (GlobalData.GAME_WIDTH - 2 * margins) / (GlobalData.MAX_CHARACTERS - 4);
			var dividorX2:int = (GlobalData.GAME_WIDTH - 2 * margins2) / (GlobalData.MAX_CHARACTERS - 5);
			
			Text.size = 8;
			
			for (var i:int = 0; i < GlobalData.MAX_CHARACTERS - 3; i++) 
			{
				spriteMaps[i].play(movingStatus);
				if (GlobalData.lockedCharacters[i])
				{
					spriteMaps[i].color = 0x000000;
				}
				
				spriteMaps[i].originX = spriteMaps[i].width / 2;
				spriteMaps[i].originY = spriteMaps[i].height;
				
				texts.push(new Text("Shots: " + GlobalData.numberOfShots[i]));
				texts[i].centerOO();
				texts[i].color = 0xFFFFFF;
				
				texts2.push(new Text("Wins: " + GlobalData.numberOfWins[i]));
				texts2[i].centerOO();
				texts2[i].color = 0xFFFFFF;
				
				texts3.push(new Text("Loses: " + GlobalData.numberOfLoses[i]));
				texts3[i].centerOO();
				texts3[i].color = 0xFFFFFF;
				
				var xIndex:int = i % GlobalData.MAX_CHARACTERS;
				
				positionPoints.push(new Point(margins + xIndex * dividorX, startingY));
			}
			
			for (i = GlobalData.MAX_CHARACTERS - 3; i < GlobalData.MAX_CHARACTERS; i++) 
			{
				spriteMaps[i].play(movingStatus);
				if (GlobalData.lockedCharacters[i])
				{
					spriteMaps[i].color = 0x000000;
				}
				
				spriteMaps[i].originX = spriteMaps[i].width / 2;
				spriteMaps[i].originY = spriteMaps[i].height;
				
				texts.push(new Text("Shots: " + GlobalData.numberOfShots[i]));
				texts[i].centerOO();
				texts[i].color = 0xFFFFFF;
				
				texts2.push(new Text("Wins: " + GlobalData.numberOfWins[i]));
				texts2[i].centerOO();
				texts2[i].color = 0xFFFFFF;
				
				texts3.push(new Text("Loses: " + GlobalData.numberOfLoses[i]));
				texts3[i].centerOO();
				texts3[i].color = 0xFFFFFF;
				
				var xIndex2:int = i - GlobalData.MAX_CHARACTERS + 3;
				
				positionPoints.push(new Point(margins2 + xIndex2 * dividorX2, startingY + distanceY));
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			for (var i:int = 0; i < GlobalData.MAX_CHARACTERS; i++) 
			{
				if (!GlobalData.lockedCharacters[i])
				{
					spriteMaps[i].update();
				}
			}
		}
		
		override public function render():void 
		{
			super.render();
			
			for (var i:int = 0; i < GlobalData.MAX_CHARACTERS; i++) 
			{
				spriteMaps[i].render(FP.buffer, positionPoints[i], FP.camera);
				
				texts[i].render(FP.buffer, new Point(positionPoints[i].x, positionPoints[i].y + 5), FP.camera);
				texts2[i].render(FP.buffer, new Point(positionPoints[i].x, positionPoints[i].y + 15), FP.camera);
				texts3[i].render(FP.buffer, new Point(positionPoints[i].x, positionPoints[i].y + 25), FP.camera);
			}
		}
		
	}

}