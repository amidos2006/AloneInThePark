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
	public class HotdogEntity extends WeaponEntity
	{
		[Embed(source = "../../../assets/Graphics/hotdog.png")]private var hotdogClass:Class;
		
		public function HotdogEntity(xIn:int, yIn:int, xSpeed:int, ySpeed:int) 
		{
			super(hotdogClass, xIn, yIn, xSpeed, ySpeed, 100, 1);
		}
	}

}