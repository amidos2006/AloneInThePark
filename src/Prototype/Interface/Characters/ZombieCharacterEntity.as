package Prototype.Interface.Characters 
{
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import Prototype.GlobalData;
	/**
	 * ...
	 * @author Amidos
	 */
	public class ZombieCharacterEntity extends BaseCharacterEntity
	{
		[Embed(source = "../../../../assets/Graphics/PlayerZombie.png")]private var shapeClass:Class;
		
		public function ZombieCharacterEntity(inputY:int, direction:int) 
		{
			var image:Image = new Image(shapeClass, new Rectangle(0, 0, 16, 16));
			super(inputY, image, GlobalData.lockedCharacters[GlobalData.ZOMBIE_PLAYER], direction);
			
			Text.size = 16;
			
			nameText = new Text("Johny - The Zombie Cook");
			nameText.color = 0xFFFFFF;
			nameText.centerOO();
			
			Text.size = 8;
			
			healthText = new Text("Health: Normal");
			healthText.color = 0xFFFFFF;
			healthText.centerOO();
			
			speedText = new Text("Speed: Low");
			speedText.color = 0xFFFFFF;
			speedText.centerOO();
			
			damageText = new Text("Damage: High");
			damageText.color = 0xFFFFFF;
			damageText.centerOO();
			
			unlockConditionText = new Text("Finish the game with Sarah (Don't Upgrade Health)");
			unlockConditionText.color = 0xFFFFFF;
			unlockConditionText.centerOO();
		}
		
	}

}