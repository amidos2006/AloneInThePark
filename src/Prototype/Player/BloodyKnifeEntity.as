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
	public class BloodyKnifeEntity extends WeaponEntity
	{
		[Embed(source = "../../../assets/Graphics/bloodyknife.png")]private var bloodyKnifeClass:Class;
		
		public function BloodyKnifeEntity(xIn:int, yIn:int, xSpeed:int, ySpeed:int) 
		{
			super(bloodyKnifeClass, xIn, yIn, xSpeed, ySpeed, 100, 1);
		}
	}

}