package Prototype.Interface.Statistics 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import Prototype.GlobalData;
	import Prototype.Interface.Statistics.Achievements.*;
	import Prototype.LayerConstant;
	/**
	 * ...
	 * @author Amidos
	 */
	public class AchievementStatisticsEntity extends BaseStatisticsEntity
	{
		[Embed(source = "../../../../assets/Graphics/RightArrow.png")]private var arrowClass:Class;
		[Embed(source = "../../../../assets/Sound/menuSelect.mp3")]private var menuSelectClass:Class;
		
		private var arrowSpriteMap:Spritemap;
		
		private var pagesClass:Vector.<Class> = new Vector.<Class>();
		private var currentPage:BaseAchievementEntity;
		
		private var xButtonPressed:Boolean = false;
		private var selector:int = 0;
		private var maxPages:int = 3;
		
		private var menuSelectSfx:Sfx;
		
		public function AchievementStatisticsEntity(nextWorld:Class) 
		{
			super(nextWorld);
			
			Text.size = 16;
			statisticName = new Text("Achievements");
			statisticName.centerOO();
			statisticName.color = 0xFFFFFF;
			
			arrowSpriteMap = new Spritemap(arrowClass, 24, 24);
			arrowSpriteMap.add("default", [0, 1, 2, 3, 4, 3, 2, 1], 0.2);
			arrowSpriteMap.centerOO();
			arrowSpriteMap.play("default");
			
			pagesClass.push(Page1AchievementEntity);
			pagesClass.push(Page2AchievementEntity);
			pagesClass.push(Page3AchievementEntity);
			
			layer = LayerConstant.HUD_LAYER;
			
			menuSelectSfx = new Sfx(menuSelectClass);
		}
		
		public function FirstTime():void
		{
			currentPage = new Page1AchievementEntity(BaseAchievementEntity.RIGHT);
			currentPage.ChangeToWaiting();
			FP.world.add(currentPage);
		}
		
		override public function update():void 
		{
			super.update();
			arrowSpriteMap.update();
			
			if (keyPressed)
			{
				return;
			}
			
			if ((Input.pressed(Key.LEFT) || Input.pressed(Key.A)) && currentPage.IsWaiting())
			{
				selector -= 1;
				if (selector < 0)
				{
					selector = maxPages - 1;
				}
				
				currentPage.Disappear(BaseAchievementEntity.RIGHT);
				currentPage = new pagesClass[selector](BaseAchievementEntity.RIGHT);
				FP.world.add(currentPage);
				
				menuSelectSfx.play();
			}
			
			if ((Input.pressed(Key.RIGHT)||Input.pressed(Key.D)) && currentPage.IsWaiting())
			{
				selector = (selector + 1) % maxPages;
				
				currentPage.Disappear(BaseAchievementEntity.LEFT);
				currentPage = new pagesClass[selector](BaseAchievementEntity.LEFT);
				FP.world.add(currentPage);
				
				menuSelectSfx.play();
			}
		}
		
		override public function render():void 
		{
			super.render();
			
			arrowSpriteMap.flipped = false;
			arrowSpriteMap.render(FP.buffer, new Point(GlobalData.GAME_WIDTH/2 + 145, GlobalData.GAME_HEIGHT/2 + 45), FP.camera);
			arrowSpriteMap.flipped = true;
			arrowSpriteMap.render(FP.buffer, new Point(GlobalData.GAME_WIDTH/2 - 145, GlobalData.GAME_HEIGHT/2 + 45), FP.camera);
		}
		
	}

}