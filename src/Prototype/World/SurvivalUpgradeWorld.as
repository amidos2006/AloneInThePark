package Prototype.World 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	import Prototype.Interface.LevelUpgradesEntity;
	import Prototype.LayerConstant;
	import Prototype.MusicPlayer;
	/**
	 * ...
	 * @author Amidos
	 */
	public class SurvivalUpgradeWorld extends World
	{
		
		public function SurvivalUpgradeWorld(background:Image, numberOfPoints:int, survivalWorld:SurvivalWorld) 
		{
			addGraphic(background, LayerConstant.TILE_LAYER);
			add(new LevelUpgradesEntity(numberOfPoints, survivalWorld));
			
			MusicPlayer.ChangeVolume(MusicPlayer.MIN_MUSIC);
		}
		
	}

}