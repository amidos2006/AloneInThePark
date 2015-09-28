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
	public class ToothEntity extends WeaponEntity
	{
		[Embed(source = "../../../assets/Graphics/tooth.png")]private var toothClass:Class;
		
		public function ToothEntity(xIn:int, yIn:int, xSpeed:int, ySpeed:int) 
		{
			super(toothClass, xIn, yIn, xSpeed, ySpeed, 100, 1);
		}
	}

}