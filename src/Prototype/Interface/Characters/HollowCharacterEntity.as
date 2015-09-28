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
	public class HollowCharacterEntity extends BaseCharacterEntity
	{
		[Embed(source = "../../../../assets/Graphics/PlayerHollow.png")]private var shapeClass:Class;
		
		public function HollowCharacterEntity(inputY:int, direction:int) 
		{
			var image:Image = new Image(shapeClass, new Rectangle(0, 0, 16, 16));
			super(inputY, image, GlobalData.lockedCharacters[GlobalData.HOLLOW_PLAYER], direction);
			
			Text.size = 16;
			
			nameText = new Text("Connor - The Creature");
			nameText.color = 0xFFFFFF;
			nameText.centerOO();
			
			Text.size = 8;
			
			healthText = new Text("Health: High");
			healthText.color = 0xFFFFFF;
			healthText.centerOO();
			
			speedText = new Text("Speed: Normal");
			speedText.color = 0xFFFFFF;
			speedText.centerOO();
			
			damageText = new Text("Damage: Low");
			damageText.color = 0xFFFFFF;
			damageText.centerOO();
			
			unlockConditionText = new Text("Kill 100 Flying Mushrooms");
			unlockConditionText.color = 0xFFFFFF;
			unlockConditionText.centerOO();
		}
		
	}

}