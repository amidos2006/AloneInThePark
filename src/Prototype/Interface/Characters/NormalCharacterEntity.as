package Prototype.Interface.Characters 
{
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	/**
	 * ...
	 * @author Amidos
	 */
	public class NormalCharacterEntity extends BaseCharacterEntity
	{
		[Embed(source = "../../../../assets/Graphics/Player.png")]private var shapeClass:Class;
		
		public function NormalCharacterEntity(inputY:int, direction:int) 
		{
			var image:Image = new Image(shapeClass, new Rectangle(0, 0, 16, 16));
			super(inputY, image, false, direction);
			
			Text.size = 16;
			
			nameText = new Text("John - The Cook");
			nameText.color = 0xFFFFFF;
			nameText.centerOO();
			
			Text.size = 8;
			
			healthText = new Text("Health: High");
			healthText.color = 0xFFFFFF;
			healthText.centerOO();
			
			speedText = new Text("Speed: Normal");
			speedText.color = 0xFFFFFF;
			speedText.centerOO();
			
			damageText = new Text("Damage: Normal");
			damageText.color = 0xFFFFFF;
			damageText.centerOO();
		}
		
	}

}