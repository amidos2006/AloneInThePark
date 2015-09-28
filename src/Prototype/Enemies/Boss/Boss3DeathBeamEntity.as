package Prototype.Enemies.Boss 
{
	import com.newgrounds.API;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.utils.Draw;
	import Prototype.CollisionNames;
	import Prototype.GlobalData;
	import Prototype.LayerConstant;
	import Prototype.Player.PlayerEntity;
	/**
	 * ...
	 * @author Amidos
	 */
	public class Boss3DeathBeamEntity extends Entity
	{
		private var damage:int = 1;
		private var alpha:Number = 0.25;
		
		public function Boss3DeathBeamEntity(xIn:int, yIn:int) 
		{
			x = xIn;
			y = yIn;
			
			layer = LayerConstant.BELOW_HUD_LAYER;
			
			setHitbox(4, GlobalData.GAME_HEIGHT + 2 - y, 0, 0);
		}
		
		override public function update():void 
		{
			super.update();
			
			var player:PlayerEntity = collide(CollisionNames.PLAYER_COLLISION_NAME, x, y) as PlayerEntity;
			if (player)
			{
				//Unlock VVVVVV
				if (player.currentPlayerHealth <= 1)
				{
					GlobalData.lockedCharacters[GlobalData.VVVVVV_PLAYER] = false;
					API.unlockMedal("Terry - The Gravity Man");
				}
				
				player.PlayerHit(damage);
			}
		}
		
			
		override public function render():void 
		{
			super.render();
			
			Draw.linePlus(x - 3, y, x - 3, GlobalData.GAME_HEIGHT + 2, 0xE5F4FF, alpha * 0.5);
			Draw.linePlus(x - 2, y, x - 2, GlobalData.GAME_HEIGHT + 2, 0xE5F4FF, alpha * 0.5);
			Draw.linePlus(x - 1, y, x - 1, GlobalData.GAME_HEIGHT + 2, 0xE5F4FF, alpha);
			Draw.line(x, y, x, GlobalData.GAME_HEIGHT + 2, 0xC1E5FF);
			Draw.line(x + 1, y, x + 1, GlobalData.GAME_HEIGHT + 2, 0xFFFFFF);
			Draw.line(x + 2, y, x + 2, GlobalData.GAME_HEIGHT + 2, 0xFFFFFF);
			Draw.line(x + 3, y, x + 3, GlobalData.GAME_HEIGHT + 2, 0xC1E5FF);
			Draw.linePlus(x + 4, y, x + 4, GlobalData.GAME_HEIGHT + 2, 0xE5F4FF, alpha);
			Draw.linePlus(x + 5, y, x + 5, GlobalData.GAME_HEIGHT + 2, 0xE5F4FF, alpha * 0.5);
			Draw.linePlus(x + 6, y, x + 6, GlobalData.GAME_HEIGHT + 2, 0xE5F4FF, alpha * 0.5);
		}
	}

}