package Prototype.Enemies.Boss 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Draw;
	import Prototype.CollisionNames;
	import Prototype.Enemies.EnemyDeathAnimationEntity;
	import Prototype.GlobalData;
	import Prototype.Player.PlayerEntity;
	/**
	 * ...
	 * @author Amidos
	 */
	public class ProjectileDeathAnimationEntity extends EnemyDeathAnimationEntity
	{
		private var damage:Number = 1;
		
		public function ProjectileDeathAnimationEntity(imageClass:Class, width:int, height:int, oX:int, oY:int, numberOfFrames:int, animationSpeed:Number = 0.3, color:int = 0xFFFFFF) 
		{
			super(imageClass, width, height, oX, oY, numberOfFrames, animationSpeed, color);
			
			setHitbox(spriteMap.width, spriteMap.height, spriteMap.originX, spriteMap.originY);
			type = CollisionNames.ENEMY_SHOT_NAME;
		}
		
		protected function CheckCollision():void
		{
			var player:PlayerEntity = collide(CollisionNames.PLAYER_COLLISION_NAME, x, y) as PlayerEntity;
			
			if (player)
			{
				player.PlayerHit(damage);
			}
		}
		
		override public function update():void 
		{
			super.update();
			CheckCollision();
		}
		
		override public function render():void 
		{
			super.render();
		}
	}

}