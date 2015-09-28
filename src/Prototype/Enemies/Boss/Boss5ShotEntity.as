package Prototype.Enemies.Boss 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import Prototype.Enemies.BaseShotEntity;
	import Prototype.Enemies.EnemyDeathAnimationEntity;
	/**
	 * ...
	 * @author Amidos
	 */
	public class Boss5ShotEntity extends BaseShotEntity
	{
		private const LIFE_TIME:int = 80;
		private const FRAME_SPEED:Number = 0.1;
		
		[Embed(source = "../../../../assets/Graphics/smallShot.png")]private var smallShotClass:Class;
		[Embed(source = "../../../../assets/Graphics/smallShotDeath.png")]private var smallShotDeath:Class;
		
		private var speed:Number = 4;
		private var color:int = 0x00FFFF;
		
		public function Boss5ShotEntity(xIn:int, yIn:int, direction:int) 
		{
			speed = speed;
			
			super(xIn, yIn, direction, speed, LIFE_TIME);
			
			image = new Spritemap(smallShotClass, 6, 6);
			image.originX = image.width / 2;
			image.originY = image.height + 2;
			image.color = color;
			image.add("default", [0, 1], FRAME_SPEED);
			
			graphic = image;
			image.play("default");
			
			deathAnimationEntity = new EnemyDeathAnimationEntity(smallShotDeath, image.width, image.height, image.originX, image.originY, 3, 0.2, color);
			
			setHitbox(image.width, image.height, image.originX, image.originY);
			
			damage = 1;
		}
		
	}

}