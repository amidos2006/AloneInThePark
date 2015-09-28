package Prototype.Interface.Statistics.Achievements 
{
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import Prototype.GlobalData;
	/**
	 * ...
	 * @author Amidos
	 */
	public class Page2AchievementEntity extends BaseAchievementEntity
	{
		[Embed(source = "../../../../../assets/Graphics/Achievements.png")]private var achievementClass:Class;
		private var pageNumber:int = 2;
		
		public function Page2AchievementEntity(direction:int) 
		{
			var imageVector:Vector.<Image> = new Vector.<Image>();
			var names:Vector.<Text> = new Vector.<Text>();
			var cond:Vector.<Text> = new Vector.<Text>();
			
			Text.size = 8;
			
			names.push(new Text("Winner"));
			names.push(new Text("Total Winner"));
			names.push(new Text("Game Lover"));
			names.push(new Text("Unlocker"));
			cond.push(new Text("Win the game twice"));
			cond.push(new Text("Win with all characters"));
			cond.push(new Text("Play 5 times"));
			cond.push(new Text("Unlock 2 character"));
			
			for (var i:int = 0; i < 4; i++) 
			{
				if (GlobalData.achievements[(pageNumber - 1) * 4 + i])
				{
					imageVector.push(new Image(achievementClass, new Rectangle(0, ((pageNumber - 1) * 4 + i) * 24, 24, 24)));
				}
				else
				{
					imageVector.push(new Image(achievementClass, new Rectangle(24, ((pageNumber - 1) * 4 + i) * 24, 24, 24)));
				}
				imageVector[i].centerOO();
				
				names[i].originY = names[i].height / 2;
				names[i].color = 0xFFFFFF;
				
				cond[i].originY = names[i].height / 2;
				cond[i].color = 0xFFFFFF;
			}
			
			super(GlobalData.GAME_HEIGHT / 2 + 20, imageVector, names, cond, direction);
		}
		
	}

}