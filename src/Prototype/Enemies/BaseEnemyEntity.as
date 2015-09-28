package Prototype.Enemies 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.utils.Draw;
	import Prototype.CollisionNames;
	import Prototype.GlobalData;
	import Prototype.Particles.ParticleGenerator;
	import Prototype.Player.KnifeEntity;
	import Prototype.Player.PlayerEntity;
	import Prototype.Player.WeaponEntity;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BaseEnemyEntity extends Entity
	{	
		[Embed(source = "../../../assets/Sound/mushroomHit.mp3")]private var enemyHitClass:Class;
		[Embed(source = "../../../assets/Sound/mushroomDeath.mp3")]private var enemyDeathClass:Class;
		
		public const APPEARING:String = "appearing";
		public const STANDING:String = "standing";
		public const MOVING:String = "moving";
		
		private const FLASHING_TIME:int = 20;
		private const INTER_FLASHING_TIME:int = 5;
		
		private var isHit:Boolean = false;
		private var hitFlashingAlarm:Alarm;
		private var endFlashingAlarm:Alarm;
		
		protected var enemyHitSfx:Sfx;
		private var enemyDeathSfx:Sfx;
		
		protected var spriteMap:Spritemap;
		protected var deathAnimationEntity:EnemyDeathAnimationEntity;
		protected var bloodColor:int;
		protected var bloodSpeed:Number;
		protected var score:Number;
		
		public var isFlying:Boolean = false;
		public var damage:int = 1;
		public var health:int = 5;
		public var status:String;
		
		public function BaseEnemyEntity() 
		{
			layer = GlobalData.GetLayer(y);
			
			hitFlashingAlarm = new Alarm(INTER_FLASHING_TIME, FlashEnemy, Tween.PERSIST);
			endFlashingAlarm = new Alarm(FLASHING_TIME, EndFlashing, Tween.PERSIST);
			
			addTween(hitFlashingAlarm);
			addTween(endFlashingAlarm);
			
			enemyDeathSfx = new Sfx(enemyDeathClass);
			enemyHitSfx = new Sfx(enemyHitClass);
			
			type = CollisionNames.ENEMY_COLLISION_NAME;
			graphic = spriteMap;
		}
		
		private function FlashEnemy():void
		{
			if (isHit)
			{
				spriteMap.alpha = 1 - spriteMap.alpha;
				hitFlashingAlarm.start();
			}
			else
			{
				spriteMap.alpha = 1;
			}
		}
		
		private function EndFlashing():void
		{
			isHit = false;
		}
		
		protected function CheckCollsion():void
		{
			var player:PlayerEntity = collide(CollisionNames.PLAYER_COLLISION_NAME, x, y) as PlayerEntity;
			if (player)
			{
				player.PlayerHit(damage);
			}
			
			var tempWeapon:WeaponEntity = collide(CollisionNames.WEAPON_COLLISION_NAME, x, y) as WeaponEntity;
			if (tempWeapon)
			{
				HitEnemy(tempWeapon);
			}
		}
		
		protected function HitEnemy(tempWeapon:WeaponEntity):void
		{
			var damageInflected:int = tempWeapon.GetWeaponDamage();
			health -= damageInflected;
			tempWeapon.DestroyWeapon();
			
			if (health <= 0)
			{
				DestroyEnemy(spriteMap.width > spriteMap.height? spriteMap.width:spriteMap.height);
				return;
			}
			
			ParticleGenerator.GenerateDamageText(x, y - 5, damageInflected);
			enemyHitSfx.play();
			
			isHit = true;
			hitFlashingAlarm.start();
			endFlashingAlarm.start();
		}
		
		protected function CollectStatistics():void
		{
			
		}
		
		public function DestroyEnemy(radius:int):void
		{
			ParticleGenerator.GenerateDeathParticles(x, y + 1, bloodColor, bloodSpeed);
			
			deathAnimationEntity.x = x;
			deathAnimationEntity.y = y;
			deathAnimationEntity.layer = layer;
			FP.world.add(deathAnimationEntity);
			
			CollectStatistics();
			
			FP.world.remove(this);
			
			enemyDeathSfx.play();
			
			GlobalData.playerScore += score;
			ParticleGenerator.GenerateScoreText(x, y - 1, score);
		}
		
		override public function update():void 
		{
			super.update();
			
			layer = GlobalData.GetLayer(y);
			
			CheckCollsion();
		}
		
		override public function render():void 
		{
			super.render();
			
			//Draw.hitbox(this);
		}
	}

}