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
	public class LipstickEntity extends WeaponEntity
	{
		[Embed(source = "../../../assets/Graphics/lipstick.png")]private var lipstickClass:Class;
		
		public function LipstickEntity(xIn:int, yIn:int, xSpeed:int, ySpeed:int) 
		{
			super(lipstickClass, xIn, yIn, xSpeed, ySpeed, 100, 1);
		}
	}

}