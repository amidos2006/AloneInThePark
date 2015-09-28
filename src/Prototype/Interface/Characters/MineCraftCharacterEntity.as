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
	public class MineCraftCharacterEntity extends BaseCharacterEntity
	{
		[Embed(source = "../../../../assets/Graphics/PlayerMineCraft.png")]private var shapeClass:Class;
		
		public function MineCraftCharacterEntity(inputY:int, direction:int) 
		{
			var image:Image = new Image(shapeClass, new Rectangle(0, 0, 16, 16));
			super(inputY, image, GlobalData.lockedCharacters[GlobalData.MINECRAFT_PLAYER], direction);
			
			Text.size = 16;
			
			nameText = new Text("Notch - The Miner");
			nameText.color = 0xFFFFFF;
			nameText.centerOO();
			
			Text.size = 8;
			
			healthText = new Text("Health: Low");
			healthText.color = 0xFFFFFF;
			healthText.centerOO();
			
			speedText = new Text("Speed: Normal");
			speedText.color = 0xFFFFFF;
			speedText.centerOO();
			
			damageText = new Text("Damage: High");
			damageText.color = 0xFFFFFF;
			damageText.centerOO();
			
			unlockConditionText = new Text("Shoot 10,000 shots");
			unlockConditionText.color = 0xFFFFFF;
			unlockConditionText.centerOO();
		}
		
	}

}