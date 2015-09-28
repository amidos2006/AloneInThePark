package Prototype.Player 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Draw;
	import Prototype.CollisionNames;
	import Prototype.Enemies.EnemyDeathAnimationEntity;
	import Prototype.GlobalData;
	/**
	 * ...
	 * @author Amidos
	 */
	public class WeaponEntity extends Entity
	{
		[Embed(source = "../../../assets/Graphics/smallShotDeath.png")]private var smallShotDeath:Class;
		
		protected const WEAPON_LEFT:String = "left";
		private const WEAPON_RIGHT:String = "right";
		private const WEAPON_UP:String = "up";
		private const WEAPON_DOWN:String = "down";
		
		private const LEVEL_DAMAGE:int = 1;
		
		private var intialWeaponDamage:int = 3;
		private var spriteMap:Spritemap;
		private var velocityVector:Point;
		private var weaponSpeed:int = 3;
		private var weaponDamage:int = 1;
		private var weaponRange:int;
		
		public function WeaponEntity(weaponClass:Class, xIn:int, yIn:int, xSpeed:int, ySpeed:int, rangeShoot:int = 100, damageFactor:Number = 1) 
		{
			switch(GlobalData.characterSelected)
			{
				case GlobalData.NORMAL_PLAYER:
					intialWeaponDamage += 0;
					break;
				case GlobalData.GIRL_PLAYER:
					intialWeaponDamage -= 2;
					break;
				case GlobalData.ZOMBIE_PLAYER:
					intialWeaponDamage += 2;
					break;
				case GlobalData.FAT_BOY_PLAYER:
					intialWeaponDamage += 0;
					break;
				case GlobalData.MINECRAFT_PLAYER:
					intialWeaponDamage += 2;
					break;
				case GlobalData.HOLLOW_PLAYER:
					intialWeaponDamage -= 2;
					break;
				case GlobalData.VVVVVV_PLAYER:
					intialWeaponDamage += 0;
					break;
			}
			
			x = xIn;
			y = yIn;
			
			weaponDamage = damageFactor * (intialWeaponDamage + GlobalData.weaponLevel * LEVEL_DAMAGE);
			weaponRange = rangeShoot;
			
			velocityVector = new Point(xSpeed * weaponSpeed, ySpeed * weaponSpeed);
			spriteMap = new Spritemap(weaponClass, 12, 12);
			
			spriteMap.add(WEAPON_RIGHT, [0]);
			spriteMap.add(WEAPON_LEFT, [1]);
			spriteMap.add(WEAPON_UP, [2]);
			spriteMap.add(WEAPON_DOWN, [3]);
			
			spriteMap.originX = spriteMap.width / 2;
			spriteMap.originY = spriteMap.height - 4;
			
			graphic = spriteMap;
			
			if (xSpeed < 0)
			{
				spriteMap.play(WEAPON_LEFT);
				y -= 1;
				x -= weaponSpeed;
				setHitbox(spriteMap.width, spriteMap.height - 6, spriteMap.originX, spriteMap.originY - 3);
			}
			if (xSpeed > 0)
			{
				spriteMap.play(WEAPON_RIGHT);
				y -= 1;
				x += weaponSpeed;
				setHitbox(spriteMap.width, spriteMap.height - 6, spriteMap.originX, spriteMap.originY - 3);
			}
			if (ySpeed < 0)
			{
				spriteMap.play(WEAPON_UP);
				y -= weaponSpeed;
				setHitbox(spriteMap.width - 8, spriteMap.height, spriteMap.originX - 4, spriteMap.originY);
			}
			if (ySpeed > 0)
			{
				spriteMap.play(WEAPON_DOWN);
				y += weaponSpeed;
				setHitbox(spriteMap.width - 8, spriteMap.height, spriteMap.originX - 4, spriteMap.originY);
			}
			
			layer = GlobalData.GetLayer(y);
			
			type = CollisionNames.WEAPON_COLLISION_NAME;
		}
		
		private function CheckCollisions():void
		{
			if (collide(CollisionNames.SOLID_COLLISION_NAME, x, y))
			{
				DestroyWeapon();
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			x += velocityVector.x;
			y += velocityVector.y;
			
			layer = GlobalData.GetLayer(y);
			
			CheckCollisions();
			
			weaponRange -= weaponSpeed;
			if (weaponRange <= 0)
			{
				DestroyWeapon();
			}
			
			if (x > GlobalData.GAME_WIDTH + spriteMap.width || x < -spriteMap.width || 
				y < -spriteMap.height || y > GlobalData.GAME_HEIGHT + spriteMap.height)
			{
				FP.world.remove(this);
			}
		}
		
		public function DestroyWeapon():void
		{
			FP.world.remove(this);
			
			var deathAnimationEntity:EnemyDeathAnimationEntity = new EnemyDeathAnimationEntity(smallShotDeath, 6, 6, 3, 4, 3, 0.2);
			deathAnimationEntity.x = x;
			deathAnimationEntity.y = y;
			deathAnimationEntity.layer = layer;
			
			FP.world.add(deathAnimationEntity);
		}
		
		public function GetWeaponDamage():int
		{
			return weaponDamage;
		}
		
		override public function render():void 
		{
			super.render();
			
			//Draw.hitbox(this);
		}
	}

}