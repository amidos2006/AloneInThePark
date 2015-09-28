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
	public class PizzaCutterEntity extends WeaponEntity
	{
		[Embed(source = "../../../assets/Graphics/pizzaCutter.png")]private var pizzaCutterClass:Class;
		
		public function PizzaCutterEntity(xIn:int, yIn:int, xSpeed:int, ySpeed:int) 
		{
			super(pizzaCutterClass, xIn, yIn, xSpeed, ySpeed, 100, 2);
		}
	}

}