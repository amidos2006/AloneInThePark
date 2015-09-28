package Prototype.Enemies 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import Prototype.CollisionNames;
	import Prototype.GlobalData;
	import Prototype.Player.PlayerEntity;
	/**
	 * ...
	 * @author Amidos
	 */
	public class FollowerEnemyEntity extends BaseEnemyEntity
	{
		private var SCREEN_BOUND:int = 40;
		
		protected var velocityDirection:Point;
		
		protected var speed:Number;
		protected var follow:Boolean = true;
		protected var runDistance:int = 100;
		
		public function FollowerEnemyEntity() 
		{
			super();
			
			velocityDirection = new Point();
		}
		
		override public function added():void 
		{
			super.added();
			
			speed = (0.75 + 0.5 * FP.random) * speed;
		}
		
		private function ApplyFollowingAI(player:Entity):void
		{	
			velocityDirection.x = 0;
			velocityDirection.y = 0;
			
			var bestStep:int = -1;
			var bestAngle:int;
			var tempPosition:Point = new Point();
			
			for (var i:int = 0; i < 360; i += 10)
			{
				FP.angleXY(tempPosition, i, GlobalData.GAME_TILE_SIZE / 4);
				
				tempPosition.x += x;
				tempPosition.y += y;
				
				if (collide(CollisionNames.SOLID_COLLISION_NAME, tempPosition.x, tempPosition.y))
				{
					continue;
				}
				
				var ecludian:Number = FP.distance(player.x, player.y, tempPosition.x, tempPosition.y);
				
				if (bestStep < 0 || ecludian < bestStep)
				{
					bestStep = ecludian;
					bestAngle = i;
				}
			}
			
			if (bestStep != -1)
			{
				FP.angleXY(velocityDirection, bestAngle, speed);
			}
		}
		
		private function RunAwayFromPlayer(player:Entity):void
		{
			velocityDirection.x = 0;
			velocityDirection.y = 0;
			
			if (player.distanceToPoint(x, y) > runDistance)
			{
				return;
			}
			
			var bestStep:int = -1;
			var bestAngle:int;
			var tempPosition:Point = new Point();
			
			for (var i:int = 0; i < 360; i += 10)
			{
				FP.angleXY(tempPosition, i, GlobalData.GAME_TILE_SIZE / 4);
				
				tempPosition.x += x;
				tempPosition.y += y;
				
				if (collide(CollisionNames.SOLID_COLLISION_NAME, tempPosition.x, tempPosition.y))
				{
					continue;
				}
				if (tempPosition.x < SCREEN_BOUND / 2 || tempPosition.x>GlobalData.GAME_WIDTH - SCREEN_BOUND / 2||
					tempPosition.y<SCREEN_BOUND||tempPosition.y>GlobalData.GAME_HEIGHT-SCREEN_BOUND / 2)
				{
					continue;
				}
				
				var ecludian:Number = FP.distance(player.x, player.y, tempPosition.x, tempPosition.y);
				
				if (bestStep < 0 || ecludian > bestStep)
				{
					bestStep = ecludian;
					bestAngle = i;
				}
			}
			
			if (bestStep != -1)
			{
				FP.angleXY(velocityDirection, bestAngle, speed);
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			if (status != STANDING && status != MOVING)
			{
				return;
			}
			
			var tempPlayer:Entity = GlobalData.playerEntity;
			if (!tempPlayer)
			{
				status = MOVING;
				
				return;
			}
			
			if (follow)
			{
				ApplyFollowingAI(tempPlayer);
			}
			else
			{
				RunAwayFromPlayer(tempPlayer);
			}
			
			if (velocityDirection.x != 0 || velocityDirection.y != 0)
			{
				status = MOVING;
			}
			else
			{
				status = STANDING;
			}
			
			x += velocityDirection.x;
			y += velocityDirection.y;
			
			spriteMap.play(status);
		}
		
	}

}