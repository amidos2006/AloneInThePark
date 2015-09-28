package Prototype.BonusObject 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.utils.Draw;
	import Prototype.CollisionNames;
	import Prototype.GlobalData;
	import Prototype.Particles.ParticleGenerator;
	import Prototype.Player.ForkEntity;
	import Prototype.Player.KnifeEntity;
	import Prototype.Player.PizzaCutterEntity;
	import Prototype.Player.PlayerEntity;
	import Prototype.Player.SpoonEntity;
	import Prototype.Player.WeaponEntity;
	/**
	 * ...
	 * @author Amidos
	 */
	public class BoxEntity extends Entity
	{
		[Embed(source = "../../../assets/Graphics/crate.png")]private var crateClass:Class;
		[Embed(source = "../../../assets/Sound/mushroomJumpHit.mp3")]private var destroyClass:Class;
		
		private const NUMBER_OF_BONUS:int = 6;
		
		private const APPEAR:String = "appear";
		private const NORMAL:String = "normal";
		private const DISAPPEAR:String = "disappear";
		
		private var image:Image;
		private var status:String;
		private var appearingSpeed:Number = 0.1;
		private var waitingAlarm:Alarm;
		private var bonusItem:int;
		private var destroySfx:Sfx;
		
		public function BoxEntity(xIn:int, yIn:int, timeToWait:int = 400) 
		{
			x = xIn;
			y = yIn;
			
			status = APPEAR;
			
			image = new Image(crateClass);
			image.originX = image.width / 2;
			image.originY = image.height - 2;
			image.scale = 0;
			
			waitingAlarm = new Alarm(timeToWait, Disappear, Tween.PERSIST);
			addTween(waitingAlarm);
			
			var noEmpty:int = 0;
			if (GlobalData.luckLevel == GlobalData.MAX_LUCK_LEVEL)
			{
				noEmpty = 1;
			}
			
			bonusItem = FP.rand(NUMBER_OF_BONUS - noEmpty);
			
			graphic = image;
			
			layer = GlobalData.GetLayer(y);
			
			destroySfx = new Sfx(destroyClass);
			
			setHitbox(image.width, image.height - 4, image.originX, image.originY - 4);
			type = CollisionNames.BONUS_COLLISION_NAME;
		}
		
		private function Disappear():void
		{
			status = DISAPPEAR;
		}
		
		private function ApplyBonus():void
		{
			var player:PlayerEntity = GlobalData.playerEntity;
			if (!player)
			{
				return;
			}
			
			ParticleGenerator.GenerateBonusImage(bonusItem, x, y);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (status == APPEAR)
			{
				image.scale += appearingSpeed;
				if (image.scale >= 1)
				{
					image.scale = 1;
					waitingAlarm.start();
					status = NORMAL;
				}
			}
			
			if (status == DISAPPEAR)
			{
				image.scale -= appearingSpeed;
				if (image.scale <= 0)
				{
					FP.world.remove(this);
				}
			}
			
			var tempWeapon:WeaponEntity = collide(CollisionNames.WEAPON_COLLISION_NAME, x, y) as WeaponEntity;
			if (tempWeapon)
			{
				destroySfx.play();
				
				tempWeapon.DestroyWeapon();
				ParticleGenerator.GenerateDeathParticles(x, y, 0xCC9933, 2.5);
				ApplyBonus();
				FP.world.remove(this);
				
				GlobalData.cratesDestroyed += 1;
			}
		}
		
		override public function render():void 
		{
			super.render();
		}
	}

}