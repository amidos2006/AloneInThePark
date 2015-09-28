package Prototype.Enemies 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.utils.Draw;
	import Prototype.CollisionNames;
	import Prototype.GlobalData;
	import Prototype.Player.PlayerEntity;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BaseShotEntity extends Entity
	{	
		private var velocityDirection:Point;
		private var timeToLiveAlarm:Alarm;
		
		protected var image:Spritemap;
		protected var deathAnimationEntity:EnemyDeathAnimationEntity;
		protected var damage:int = 1;
		
		public function BaseShotEntity(xIn:int, yIn:int, direction:int, speed:Number, timeToLive:int) 
		{
			x = xIn;
			y = yIn;
			
			velocityDirection = new Point();
			
			FP.angleXY(velocityDirection, direction, speed);
			
			timeToLiveAlarm = new Alarm(timeToLive, DestroyBullet, Tween.ONESHOT);
			addTween(timeToLiveAlarm, true);
			
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
		}
		
		protected function CheckCollision():void
		{
			var player:PlayerEntity = collide(CollisionNames.PLAYER_COLLISION_NAME, x, y) as PlayerEntity;
			
			if (player)
			{
				player.PlayerHit(damage);
				DestroyBullet();
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			x += velocityDirection.x;
			y += velocityDirection.y;
			
			CheckCollision();
			
			layer = GlobalData.GetLayer(y);
		}
		
		override public function render():void 
		{
			super.render();
			
			//Draw.hitbox(this);
		}
	}

}