package Prototype.Interface 
{
	import com.newgrounds.APIEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import Prototype.GlobalData;
	import Prototype.Interface.Characters.*;
	import Prototype.LayerConstant;
	import Prototype.MusicPlayer;
	import Prototype.World.GameModesWorld;
	import Prototype.World.SurvivalWorld;
	/**
	 * ...
	 * @author Amidos
	 */
	public class CharacterSelectEntity extends Entity
	{
		[Embed(source = "../../../assets/Graphics/characterSelect.png")]private var selectClass:Class;
		[Embed(source = "../../../assets/Graphics/RightArrow.png")]private var arrowClass:Class;
		[Embed(source = "../../../assets/Sound/menuSelect.mp3")]private var menuSelectClass:Class;
		
		private var characterSelectImage:Image;
		private var arrowSpriteMap:Spritemap;
		private var characterSelectPosition:Point;
		private var intialY:int = GlobalData.GAME_HEIGHT / 2 + 5;
		
		private var charactersClass:Vector.<Class> = new Vector.<Class>();
		private var currentCharacter:BaseCharacterEntity;
		
		private var xButtonPressed:Boolean = false;
		private var isSurvival:Boolean = false;
		private var selector:int = GlobalData.NORMAL_PLAYER;
		private var maxCharacters:int = GlobalData.MAX_CHARACTERS;
		
		private var hintText:Text;
		private var menuSelectSfx:Sfx;
		
		public function CharacterSelectEntity(isNextWorldSurvival:Boolean = false) 
		{
			characterSelectImage = new Image(selectClass);
			characterSelectImage.centerOO();
			characterSelectPosition = new Point(GlobalData.GAME_WIDTH / 2, characterSelectImage.height / 2 + 10);
			
			arrowSpriteMap = new Spritemap(arrowClass, 24, 24);
			arrowSpriteMap.add("default", [0, 1, 2, 3, 4, 3, 2, 1], 0.2);
			arrowSpriteMap.play("default");
			
			for (var i:int = 0; i < GlobalData.MAX_CHARACTERS; i++) 
			{
				charactersClass.push(null);
			}
			
			charactersClass[GlobalData.NORMAL_PLAYER] = NormalCharacterEntity;
			charactersClass[GlobalData.GIRL_PLAYER] = GirlCharacterEntity;
			charactersClass[GlobalData.ZOMBIE_PLAYER] = ZombieCharacterEntity;
			charactersClass[GlobalData.FAT_BOY_PLAYER] = FatGuyCharacterEntity;
			charactersClass[GlobalData.MINECRAFT_PLAYER] = MineCraftCharacterEntity;
			charactersClass[GlobalData.HOLLOW_PLAYER] = HollowCharacterEntity;
			charactersClass[GlobalData.VVVVVV_PLAYER] = VVVVVVCharacterEntity;
			
			isSurvival = isNextWorldSurvival;
			
			Text.size = 8;
			hintText = new Text("Left and Right to choose and Space to select");
			hintText.color = 0xFFFFFF;
			hintText.centerOO();
			
			layer = LayerConstant.HUD_LAYER;
			
			menuSelectSfx = new Sfx(menuSelectClass);
		}
		
		public function FirstTime():void
		{
			currentCharacter = new NormalCharacterEntity(intialY, BaseCharacterEntity.RIGHT);
			currentCharacter.ChangeToWaiting();
			FP.world.add(currentCharacter);
		}
		
		override public function update():void 
		{
			super.update();
			arrowSpriteMap.update();
			
			if (xButtonPressed)
			{
				return;
			}
			
			if ((Input.pressed(Key.LEFT) || Input.pressed(Key.A)) && currentCharacter.IsWaiting())
			{
				selector -= 1;
				if (selector < 0)
				{
					selector = maxCharacters - 1;
				}
				
				currentCharacter.Disappear(BaseCharacterEntity.LEFT);
				currentCharacter = new charactersClass[selector](intialY, BaseCharacterEntity.LEFT);
				FP.world.add(currentCharacter);
				
				menuSelectSfx.play();
			}
			
			if ((Input.pressed(Key.RIGHT) || Input.pressed(Key.D)) && currentCharacter.IsWaiting())
			{
				selector = (selector + 1) % maxCharacters;
				
				currentCharacter.Disappear(BaseCharacterEntity.RIGHT);
				currentCharacter = new charactersClass[selector](intialY, BaseCharacterEntity.RIGHT);
				FP.world.add(currentCharacter);
				
				menuSelectSfx.play();
			}
			
			if (Input.pressed(Key.ESCAPE) && currentCharacter.IsWaiting())
			{
				xButtonPressed = true;
				GlobalData.EndThemeWorld(new GameModesWorld());
			}
			
			if (Input.pressed(Key.SPACE) && currentCharacter.IsWaiting())
			{
				xButtonPressed = true;
				
				switch(selector)
				{
					case GlobalData.NORMAL_PLAYER:
						GlobalData.characterSelected = GlobalData.NORMAL_PLAYER;
						AdvanceToNextWorld();
						break;
					case GlobalData.GIRL_PLAYER:
						if (GlobalData.lockedCharacters[GlobalData.GIRL_PLAYER])
						{
							xButtonPressed = false;
						}
						else
						{
							GlobalData.characterSelected = GlobalData.GIRL_PLAYER;
							AdvanceToNextWorld();
						}
						break;
					case GlobalData.ZOMBIE_PLAYER:
						if (GlobalData.lockedCharacters[GlobalData.ZOMBIE_PLAYER])
						{
							xButtonPressed = false;
						}
						else
						{
							GlobalData.characterSelected = GlobalData.ZOMBIE_PLAYER;
							AdvanceToNextWorld();
						}
						break;
					case GlobalData.FAT_BOY_PLAYER:
						if (GlobalData.lockedCharacters[GlobalData.FAT_BOY_PLAYER])
						{
							xButtonPressed = false;
						}
						else
						{
							GlobalData.characterSelected = GlobalData.FAT_BOY_PLAYER;
							AdvanceToNextWorld();
						}
						break;
					case GlobalData.MINECRAFT_PLAYER:
						if (GlobalData.lockedCharacters[GlobalData.MINECRAFT_PLAYER])
						{
							xButtonPressed = false;
						}
						else
						{
							GlobalData.characterSelected = GlobalData.MINECRAFT_PLAYER;
							AdvanceToNextWorld();
						}
						break;
					case GlobalData.HOLLOW_PLAYER:
						if (GlobalData.lockedCharacters[GlobalData.HOLLOW_PLAYER])
						{
							xButtonPressed = false;
						}
						else
						{
							GlobalData.characterSelected = GlobalData.HOLLOW_PLAYER;
							AdvanceToNextWorld();
						}
						break;
					case GlobalData.VVVVVV_PLAYER:
						if (GlobalData.lockedCharacters[GlobalData.VVVVVV_PLAYER])
						{
							xButtonPressed = false;
						}
						else
						{
							GlobalData.characterSelected = GlobalData.VVVVVV_PLAYER;
							AdvanceToNextWorld();
						}
						break;
				}
				
				Input.clear();
			}
		}
		
		private function AdvanceToNextWorld():void
		{
			if (!isSurvival)
			{
				GlobalData.Intialize();
				GlobalData.EndThemeWorld(null);
			}
			else
			{
				GlobalData.Intialize();
				GlobalData.EndThemeWorld(new SurvivalWorld());
			}
		}
		
		override public function render():void 
		{
			super.render();
			
			characterSelectImage.render(FP.buffer, characterSelectPosition, FP.camera);
			
			arrowSpriteMap.flipped = false;
			arrowSpriteMap.render(FP.buffer, new Point(characterSelectPosition.x + 50, intialY - 10), FP.camera);
			arrowSpriteMap.flipped = true;
			arrowSpriteMap.render(FP.buffer, new Point(characterSelectPosition.x - 80, intialY - 10), FP.camera);
			
			hintText.render(FP.buffer, new Point(GlobalData.GAME_WIDTH / 2, GlobalData.GAME_HEIGHT - 15), FP.camera);
		}
		
	}

}