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
	public class SpoonEntity extends WeaponEntity
	{
		[Embed(source = "../../../assets/Graphics/spoon.png")]private var spoonClass:Class;
		
		public function SpoonEntity(xIn:int, yIn:int, xSpeed:int, ySpeed:int) 
		{
			super(spoonClass, xIn, yIn, xSpeed, ySpeed, 50, 3);
		}
	}

}