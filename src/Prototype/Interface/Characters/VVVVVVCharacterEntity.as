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
	public class VVVVVVCharacterEntity extends BaseCharacterEntity
	{
		[Embed(source = "../../../../assets/Graphics/PlayerVVVVVV.png")]private var shapeClass:Class;
		
		public function VVVVVVCharacterEntity(inputY:int, direction:int) 
		{
			var image:Image = new Image(shapeClass, new Rectangle(0, 0, 16, 16));
			super(inputY, image, GlobalData.lockedCharacters[GlobalData.VVVVVV_PLAYER], direction);
			
			Text.size = 16;
			
			nameText = new Text("Terry - The Gravity Man");
			nameText.color = 0xFFFFFF;
			nameText.centerOO();
			
			Text.size = 8;
			
			healthText = new Text("Health: Low");
			healthText.color = 0xFFFFFF;
			healthText.centerOO();
			
			speedText = new Text("Speed: High");
			speedText.color = 0xFFFFFF;
			speedText.centerOO();
			
			damageText = new Text("Damage: Normal");
			damageText.color = 0xFFFFFF;
			damageText.centerOO();
			
			unlockConditionText = new Text("Die from Laser");
			unlockConditionText.color = 0xFFFFFF;
			unlockConditionText.centerOO();
		}
		
	}

}