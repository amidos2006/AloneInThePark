package Prototype.World 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	import Prototype.Interface.PauseMenuEntity;
	import Prototype.LayerConstant;
	import Prototype.MusicPlayer;
	/**
	 * ...
	 * @author Amidos
	 */
	public class PauseWorld extends World
	{
		
		public function PauseWorld(background:Image, returnWorld:World) 
		{
			addGraphic(background, LayerConstant.TILE_LAYER);
			add(new PauseMenuEntity(returnWorld));
			
			MusicPlayer.ChangeVolume(MusicPlayer.MIN_MUSIC);
		}
		
	}

}