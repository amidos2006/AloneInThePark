package Prototype.Enemies.Boss 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Draw;
	import Prototype.CollisionNames;
	import Prototype.Enemies.BaseShotEntity;
	import Prototype.Enemies.EnemyDeathAnimationEntity;
	import Prototype.Enemies.ShadowEntity;
	import Prototype.GlobalData;
	import Prototype.Player.PlayerEntity;
	/**
	 * ...
	 * @author Amidos
	 */
	public class Boss2ProjectileShotEntity extends Entity
	{
		private const LIFE_TIME:int = 80;
		private const FRAME_SPEED:Number = 0.1;
		
		[Embed(source = "../../../../assets/Graphics/smallShot.png")]private var smallShotClass:Class;
		[Embed(source = "../../../../assets/Graphics/ProjectileShotDeath.png")]private var smallShotDeath:Class;
		
		private var speed:Number = 1;
		private var direction:Number = 0;
		private var color:int = 0xA3CE27;
		private var shadowEntity:ShadowEntity;
		private var fallingSpeed:Number = 0;
		private var heightFromEarth:Number = -2;
		private var velocityDirection:Point;
		private var image:Spritemap;
		private var deathAnimationEntity:EnemyDeathAnimationEntity;
		private var damage:Number;
		
		public function Boss2ProjectileShotEntity(xIn:int, yIn:int, direction:int, fallingSpeedIn:Number) 
		{
			x = xIn;
			y = yIn;
			fallingSpeed = fallingSpeedIn;
			
			velocityDirection = new Point();
			FP.angleXY(velocityDirection, direction, speed);
			
			shadowEntity = new ShadowEntity(8);
			shadowEntity.x = xIn;
			shadowEntity.y = yIn;
			FP.world.add(shadowEntity);
			
			image = new Spritemap(smallShotClass, 6, 6);
			image.originX = image.width / 2;
			image.originY = image.height + 2;
			image.color = color;
			image.add("default", [0, 1], FRAME_SPEED);
			
			image.play("default");
			
			deathAnimationEntity = new ProjectileDeathAnimationEntity(smallShotDeath, 9, 9, 4.5, image.originY, 3, 0.2, color);
			
			setHitbox(image.width, image.height, image.originX, image.originY);
			
			damage = 1;
			
			layer = GlobalData.GetLayer(y);
			
			type = CollisionNames.ENEMY_SHOT_NAME;
		}
		
		public function DestroyBullet():void
		{
			FP.world.remove(this);
			
			deathAnimationEntity.x = x;
			deathAnimationEntity.y = y;
			deathAnimationEntity.layer = layer;
			
			FP.world.add(deathAnimationEntity);
			FP.world.remove(shadowEntity);
		}
		
		private function CheckDeath():void
		{
			if (heightFromEarth >= 0)
			{
				DestroyBullet();
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			image.update();
			
			fallingSpeed += GlobalData.GRAVITY_SPEED;
			heightFromEarth += fallingSpeed;
			if (heightFromEarth > 0)
			{
				heightFromEarth = 0;
			}
			
			x += velocityDirection.x;
			y += velocityDirection.y;
			
			shadowEntity.x = x - 2;
			shadowEntity.y = y - 2;
			
			CheckDeath();
			
			layer = GlobalData.GetLayer(y);
		}
		
		override public function render():void 
		{
			super.render();
			
			image.render(renderTarget?renderTarget:FP.buffer, new Point(x, y + heightFromEarth), FP.camera);
		}
		
	}

}