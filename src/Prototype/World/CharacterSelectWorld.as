package Prototype.World 
{
	import Prototype.GlobalData;
	import Prototype.Interface.CharacterSelectEntity;
	import Prototype.MapGetter;
	/**
	 * ...
	 * @author Amidos
	 */
	public class CharacterSelectWorld extends ThemeWorld
	{
		private var charSelect:CharacterSelectEntity;
		private var called:Boolean = false;
		
		public function CharacterSelectWorld(isSurvival:Boolean) 
		{
			super(MapGetter.GetRandomTheme());
			
			charSelect = new CharacterSelectEntity(isSurvival);
			
			add(charSelect);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (!called)
			{
				called = true;
				charSelect.FirstTime();
			}
		}
		
	}

}