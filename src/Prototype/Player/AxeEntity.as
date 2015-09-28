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
	public class AxeEntity extends WeaponEntity
	{
		[Embed(source = "../../../assets/Graphics/Pickaxe.png")]private var axeClass:Class;
		
		public function AxeEntity(xIn:int, yIn:int, xSpeed:int, ySpeed:int) 
		{
			super(axeClass, xIn, yIn, xSpeed, ySpeed, 100, 1);
		}
	}

}