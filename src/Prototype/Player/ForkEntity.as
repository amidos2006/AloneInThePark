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
	public class ForkEntity extends WeaponEntity
	{
		[Embed(source = "../../../assets/Graphics/Fork.png")]private var forkClass:Class;
		
		public function ForkEntity(xIn:int, yIn:int, xSpeed:int, ySpeed:int) 
		{
			super(forkClass, xIn, yIn, xSpeed, ySpeed, 200, 1);
		}
	}

}