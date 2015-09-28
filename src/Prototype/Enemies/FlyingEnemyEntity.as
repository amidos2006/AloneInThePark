package Prototype.Enemies 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import Prototype.GlobalData;
	import Prototype.Particles.ParticleGenerator;
	/**
	 * ...
	 * @author Amidos
	 */
	public class FlyingEnemyEntity extends BaseEnemyEntity
	{
		[Embed(source = "../../../assets/Sound/mushroomJumpHit.mp3")]private var jumpHitClass:Class;
		
		public const FLYING:String = "flying";
		public const FALLING:String = "falling";
		
		private const FALLING_TIME:int = FP.assignedFrameRate * 4;
		private const JUMP_TIME:int = FP.assignedFrameRate * 2;
		private const ALLOWANCE_DISTANCE:int = 10;
		
		protected var velocityDirection:Point;
		
		protected var movingSpeed:Number;
		protected var flyingSpeed:Number;
		protected var fallingSpeed:Number;
		protected var yJump:Number;
		
		protected var shadowEntity:ShadowEntity;
		
		private var fallDownAlarm:Alarm;
		private var jumpAlarm:Alarm;
		private var jumpHitSfx:Sfx;
		
		public function FlyingEnemyEntity() 
		{
			super();
			
			isFlying = true;
			yJump = 0;
			velocityDirection = new Point();
			
			fallDownAlarm = new Alarm(FALLING_TIME, ReachGround, Tween.PERSIST);
			jumpAlarm = new Alarm(JUMP_TIME, ActivateJump, Tween.PERSIST);
			
			status = FLYING;
			
			jumpHitSfx = new Sfx(jumpHitClass);
			
			addTween(fallDownAlarm, true);
			addTween(jumpAlarm);
		}
		
		override public function added():void 
		{
			super.added();
			
			movingSpeed = (0.75 + 0.5 * FP.random) * movingSpeed;
		}
		
		override public function removed():void 
		{
			super.removed();
			
			FP.world.remove(shadowEntity);
		}
		
		private function ReachGround():void
		{
			status = FALLING;
		}
		
		private function ActivateJump():void
		{
			fallDownAlarm.start();
			
			status = FLYING;
		}
		
		override protected function CheckCollsion():void 
		{
			if (yJump > ALLOWANCE_DISTANCE)
			{
				return;
			}
			
			super.CheckCollsion();
		}
		
		override public function update():void 
		{
			super.update();
			
			shadowEntity.x = x;
			shadowEntity.y = y;
			
			if (status == FLYING)
			{
				if (y - yJump > - 2 * spriteMap.height)
				{
					yJump += flyingSpeed;
				}
				
				var tempPlayer:Entity = GlobalData.playerEntity;
				
				if (!tempPlayer)
				{
					return;
				}
				
				var tempAngle:Number = FP.angle(x, y, tempPlayer.x, tempPlayer.y);
				
				FP.angleXY(velocityDirection, tempAngle, movingSpeed);
				
				x += velocityDirection.x;
				y += velocityDirection.y;
			}
			else if (status == FALLING)
			{
				if (yJump > 0)
				{
					yJump -= fallingSpeed;
					fallingSpeed += 4 * GlobalData.GRAVITY_SPEED;
				}
				else
				{
					yJump = 0;
					status = STANDING;
					fallingSpeed = 0;
					
					jumpHitSfx.play();
					
					jumpAlarm.start();
					ParticleGenerator.GenerateSmokeParticles(x, y + 2);
				}
			}
		}
		
		override public function render():void 
		{
			spriteMap.render(FP.buffer, new Point(x, y - yJump), FP.camera);
		}
		
	}

}