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
	public class LaserEntity extends WeaponEntity
	{
		[Embed(source = "../../../assets/Graphics/laser.png")]private var laserClass:Class;
		
		public function LaserEntity(xIn:int, yIn:int, xSpeed:int, ySpeed:int) 
		{
			super(laserClass, xIn, yIn, xSpeed, ySpeed, 100, 1);
		}
	}

}