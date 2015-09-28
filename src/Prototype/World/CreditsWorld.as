package Prototype.World 
{
	import Prototype.Interface.CreditsEntity;
	import Prototype.MapGetter;
	/**
	 * ...
	 * @author Amidos
	 */
	public class CreditsWorld extends ThemeWorld
	{
		
		public function CreditsWorld() 
		{
			super(MapGetter.GetRandomTheme());
			add(new CreditsEntity());
		}
		
	}

}