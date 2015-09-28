package Prototype.HUD 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import Prototype.GlobalData;
	import Prototype.LayerConstant;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BossHUDDrawerEntity extends Entity
	{
		[Embed(source = "../../../assets/Graphics/BossHealthSkull.png")]private var healthSkull:Class;
		[Embed(source = "../../../assets/Graphics/BossHealthBar.png")]private var healthBarEmpty:Class;
		[Embed(source = "../../../assets/Graphics/BossHealthBarFull.png")]private var healthBarFull:Class;
		
		public var enabled:Boolean = false;
		public var bossHealth:int = 0;
		public var maxBossHealth:int = 0;
		
		private var skullImage:Image;
		private var emptyBarImage:Image;
		private var fullBarImage:Image;
		
		private var refrencePoint:Point;
		
		public function BossHUDDrawerEntity() 
		{
			layer = LayerConstant.HUD_LAYER;
			
			skullImage = new Image(healthSkull);
			emptyBarImage = new Image(healthBarEmpty);
			fullBarImage = new Image(healthBarFull);
			
			skullImage.centerOO();
			emptyBarImage.originY = emptyBarImage.height / 2;
			fullBarImage.originY = fullBarImage.height / 2;
			
			refrencePoint = new Point();
			refrencePoint.x = GlobalData.GAME_WIDTH / 2 - emptyBarImage.width / 2;
			refrencePoint.y = GlobalData.GAME_HEIGHT - 10;
		}
		
		override public function render():void 
		{
			if (!enabled)
			{
				return;
			}
			
			fullBarImage.scaleX = bossHealth / maxBossHealth;
			if (fullBarImage.scale < 0)
			{
				fullBarImage.scaleX = 0;
			}
			
			emptyBarImage.render(FP.buffer, refrencePoint, FP.camera);
			fullBarImage.render(FP.buffer, new Point(refrencePoint.x + 1, refrencePoint.y), FP.camera);
			skullImage.render(FP.buffer, refrencePoint, FP.camera);
		}
	}

}