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
	public class KnifeEntity extends WeaponEntity
	{
		[Embed(source = "../../../assets/Graphics/Knife.png")]private var knifeClass:Class;
		
		public function KnifeEntity(xIn:int, yIn:int, xSpeed:int, ySpeed:int) 
		{
			super(knifeClass, xIn, yIn, xSpeed, ySpeed, 100, 1);
		}
	}

}