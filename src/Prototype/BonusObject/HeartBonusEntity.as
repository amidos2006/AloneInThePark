package Prototype.BonusObject 
{
	import com.newgrounds.API;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import Prototype.CollisionNames;
	import Prototype.GlobalData;
	import Prototype.Particles.ParticleGenerator;
	import Prototype.Player.PlayerEntity;
	/**
	 * ...
	 * @author Amidos
	 */
	public class HeartBonusEntity extends BonusGlobalEntity
	{
		[Embed(source = "../../../assets/Graphics/bonusLife.png")]private var bonusClass:Class;
		
		public function HeartBonusEntity(xIn:int, yIn:int) 
		{
			super(xIn, yIn, bonusClass);
		}
		
		override protected function ApplyBonus():void 
		{
			super.ApplyBonus();
			
			var player:PlayerEntity = GlobalData.playerEntity;
			if (player)
			{
				player.ApplyHealth();
				
				GlobalData.bonusGot[GlobalData.HEART] += 1;
				
				//Unlock FatGuy
				if (GlobalData.bonusGot[GlobalData.HEART] >= 50)
				{
					GlobalData.lockedCharacters[GlobalData.FAT_BOY_PLAYER] = false;
					API.unlockMedal("Mufy - The Fat Boy");
				}
			}
		}
	}

}