package Prototype.Interface.Story 
{
	import com.newgrounds.API;
	import com.newgrounds.APIEvent;
	import com.newgrounds.ScoreBoard;
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
	import Prototype.LayerConstant;
	import Prototype.World.EnterNameWorld;
	import Prototype.World.MainMenuWorld;
	import Prototype.World.StoryHighScoreWorld;
	/**
	 * ...
	 * @author Amidos
	 */
	public class OutroStoryEntity extends Entity
	{
		public static const MAX_PAGE_NUMBER:int = 3;
		
		[Embed(source = "../../../../assets/Graphics/RightArrow.png")]private var arrowClass:Class;
		[Embed(source = "../../../../assets/Graphics/GameEnding.png")]private var story1Class:Class;
		[Embed(source = "../../../../assets/Sound/menuSelect.mp3")]private var menuSelectClass:Class;
		
		private var arrowSpriteMap:Spritemap;
		private var currentPage:StoryPageEntity;
		
		private var images:Vector.<Vector.<Image>>;
		private var texts:Vector.<Vector.<Text>>;
		private var positions:Vector.<Vector.<int>>;
		
		private var keyPressed:Boolean = false;
		private var selector:int = 0;
		private var scoreBoard:ScoreBoard;
		
		private var menuSelectSfx:Sfx;
		private var hintText:Text;
		
		public function OutroStoryEntity() 
		{
			Text.size = 8;
			hintText = new Text("Left and Right to advance and Space to skip");
			hintText.color = 0xFFFFFF;
			hintText.centerOO();
			
			arrowSpriteMap = new Spritemap(arrowClass, 24, 24);
			arrowSpriteMap.add("default", [0, 1, 2, 3, 4, 3, 2, 1], 0.2);
			arrowSpriteMap.centerOO();
			arrowSpriteMap.play("default");
			
			menuSelectSfx = new Sfx(menuSelectClass);
			
			images = new Vector.<Vector.<Image>>();
			texts = new Vector.<Vector.<Text>>();
			positions = new Vector.<Vector.<int>>();
			
			for (var j:int = 0; j < GlobalData.MAX_CHARACTERS; j++) 
			{
				images.push(new Vector.<Image>());
				texts.push(new Vector.<Text>());
				positions.push(new Vector.<int>());
			}
			
			var options:Object = new Object();
			options["align"] = "center";
			options["size"] = 16;
			
			texts[GlobalData.NORMAL_PLAYER].push(new Text("After killing the final boss\nJohn finds a new portal...", 0, 0, options));
			texts[GlobalData.NORMAL_PLAYER].push(new Text("...the portal sends him\nback to earth dimension!!!", 0, 0, options));
			texts[GlobalData.NORMAL_PLAYER].push(new Text("....now he's safe...\nand...\nstinky!", 0, 0, options));
			
			texts[GlobalData.GIRL_PLAYER].push(new Text("After killing the final boss\nSarah finds a new portal...", 0, 0, options));
			texts[GlobalData.GIRL_PLAYER].push(new Text("...the portal sends her\nback to earth dimension!!!", 0, 0, options));
			texts[GlobalData.GIRL_PLAYER].push(new Text("....now she's safe...\nand she can hug\nher brother again!", 0, 0, options));
			
			texts[GlobalData.ZOMBIE_PLAYER].push(new Text("After killing the final boss\nJohnny finds a new portal...", 0, 0, options));
			texts[GlobalData.ZOMBIE_PLAYER].push(new Text("...now he help his zombie\nbrothers to enter\nthe mushroom dimension..", 0, 0, options));
			texts[GlobalData.ZOMBIE_PLAYER].push(new Text("...and conquer it!", 0, 0, options));
			
			texts[GlobalData.FAT_BOY_PLAYER].push(new Text("After killing the final boss\nMufy continue to\nkill mushrooms...", 0, 0, options));
			texts[GlobalData.FAT_BOY_PLAYER].push(new Text("...but he discover\nthey are so good to eat...", 0, 0, options));
			texts[GlobalData.FAT_BOY_PLAYER].push(new Text("...After eating\nthousands of them...\nhe became their King.", 0, 0, options));
			
			texts[GlobalData.MINECRAFT_PLAYER].push(new Text("After killing the final boss\nNotch finds a new portal...", 0, 0, options));
			texts[GlobalData.MINECRAFT_PLAYER].push(new Text("...he finally returns on earth..\nbut... WTF!?!", 0, 0, options));
			texts[GlobalData.MINECRAFT_PLAYER].push(new Text("...Boooooooooooom!!!", 0, 0, options));
			
			texts[GlobalData.HOLLOW_PLAYER].push(new Text("After killing the final boss\nConnor finds a new portal...", 0, 0, options));
			texts[GlobalData.HOLLOW_PLAYER].push(new Text("...he enters it and finds\na dark and strange place...", 0, 0, options));
			texts[GlobalData.HOLLOW_PLAYER].push(new Text("...And now he is...\nAlone in the Cave...", 0, 0, options));
			
			texts[GlobalData.VVVVVV_PLAYER].push(new Text("After killing the final boss\nTerry finds a new portal...", 0, 0, options));
			texts[GlobalData.VVVVVV_PLAYER].push(new Text("...he returns on earth...\nhe can reverse gravity!", 0, 0, options));
			texts[GlobalData.VVVVVV_PLAYER].push(new Text("...", 0, 0, options));
			
			positions[GlobalData.NORMAL_PLAYER].push(25);
			positions[GlobalData.NORMAL_PLAYER].push(25);
			positions[GlobalData.NORMAL_PLAYER].push(15);
			
			positions[GlobalData.GIRL_PLAYER].push(25);
			positions[GlobalData.GIRL_PLAYER].push(25);
			positions[GlobalData.GIRL_PLAYER].push(15);
			
			positions[GlobalData.ZOMBIE_PLAYER].push(25);
			positions[GlobalData.ZOMBIE_PLAYER].push(15);
			positions[GlobalData.ZOMBIE_PLAYER].push(30);
			
			positions[GlobalData.FAT_BOY_PLAYER].push(15);
			positions[GlobalData.FAT_BOY_PLAYER].push(25);
			positions[GlobalData.FAT_BOY_PLAYER].push(15);
			
			positions[GlobalData.MINECRAFT_PLAYER].push(25);
			positions[GlobalData.MINECRAFT_PLAYER].push(25);
			positions[GlobalData.MINECRAFT_PLAYER].push(30);
			
			positions[GlobalData.HOLLOW_PLAYER].push(25);
			positions[GlobalData.HOLLOW_PLAYER].push(25);
			positions[GlobalData.HOLLOW_PLAYER].push(25);
			
			positions[GlobalData.VVVVVV_PLAYER].push(25);
			positions[GlobalData.VVVVVV_PLAYER].push(25);
			positions[GlobalData.VVVVVV_PLAYER].push(30);
			
			for (var i:int = 0; i < GlobalData.MAX_CHARACTERS; i++) 
			{
				for (var k:int = 0; k < MAX_PAGE_NUMBER; k++) 
				{
					images[i].push(new Image(story1Class, new Rectangle(k*164, i * 135, 164, 135)));
					images[i][k].originX = images[i][k].width / 2;
					images[i][k].originY = images[i][k].height;
					
					texts[i][k].originX = texts[i][k].width / 2;
					texts[i][k].originY = 0;
				}
			}
			
			layer = LayerConstant.HUD_LAYER;
		}
		
		public function FirstTime():void
		{
			currentPage = new StoryPageEntity(images[GlobalData.characterSelected][selector], 
				texts[GlobalData.characterSelected][selector], positions[GlobalData.characterSelected][selector], StoryPageEntity.RIGHT);
			currentPage.ChangeToWaiting();
			FP.world.add(currentPage);
		}
		
		override public function update():void 
		{
			super.update();
			arrowSpriteMap.update();
			
			if (keyPressed)
			{
				return;
			}
			
			if ((Input.pressed(Key.LEFT) || Input.pressed(Key.A)) && currentPage.IsWaiting())
			{
				selector -= 1;
				if (selector < 0)
				{
					selector = 0;
					return;
				}
				
				currentPage.Disappear(StoryPageEntity.RIGHT);
				currentPage = new StoryPageEntity(images[GlobalData.characterSelected][selector], 
					texts[GlobalData.characterSelected][selector], positions[GlobalData.characterSelected][selector], StoryPageEntity.RIGHT);
				FP.world.add(currentPage);
				
				menuSelectSfx.play();
			}
			
			if ((Input.pressed(Key.RIGHT) || Input.pressed(Key.D)) && currentPage.IsWaiting())
			{
				selector = selector + 1;
				if (selector > MAX_PAGE_NUMBER - 1)
				{
					selector = MAX_PAGE_NUMBER - 1;
					return;
				}
				
				currentPage.Disappear(StoryPageEntity.LEFT);
				currentPage = new StoryPageEntity(images[GlobalData.characterSelected][selector], 
					texts[GlobalData.characterSelected][selector], positions[GlobalData.characterSelected][selector], StoryPageEntity.LEFT);
				FP.world.add(currentPage);
				
				menuSelectSfx.play();
			}
			
			if (Input.pressed(Key.SPACE) || Input.pressed(Key.ESCAPE))
			{
				keyPressed = true;
				API.addEventListener(APIEvent.SCORE_POSTED, ScoreSubmited);
				if (API.hasUserSession)
				{
					API.postScore("Story Scoreboard", GlobalData.playerScore);
				}
				else
				{
					ScoreSubmited(null);
				}
			}
		}
		
		public function ScoreSubmited(event:APIEvent):void
		{
			API.removeEventListener(APIEvent.SCORE_POSTED, ScoreSubmited);
			API.addEventListener(APIEvent.SCORES_LOADED, ScoresReceived);
			
			scoreBoard = API.loadScores("Story Scoreboard");
		}
		
		public function ScoresReceived(event:APIEvent):void
		{
			API.removeEventListener(APIEvent.SCORES_LOADED, ScoresReceived);
			
			if (scoreBoard != null)
			{
				var i:int = 0;
				var count:Number = Math.min(10, scoreBoard.scores.length);
				
				for (i = 0; i < count; i += 1)
				{
					GlobalData.storyHighScores[i].Name = scoreBoard.scores[i].username;
					GlobalData.storyHighScores[i].Score = scoreBoard.scores[i].score;
				}
				
				GlobalData.EndThemeWorld(new StoryHighScoreWorld());
			}
			else
			{
				GlobalData.EndThemeWorld(new MainMenuWorld());
			}
		}
		
		override public function render():void 
		{
			super.render();
			
			arrowSpriteMap.flipped = false;
			if (selector < MAX_PAGE_NUMBER - 1)
			{
				arrowSpriteMap.render(FP.buffer, new Point(GlobalData.GAME_WIDTH / 2 + 145, GlobalData.GAME_HEIGHT / 2 + 60), FP.camera);
			}
			
			arrowSpriteMap.flipped = true;
			if (selector > 0)
			{
				arrowSpriteMap.render(FP.buffer, new Point(GlobalData.GAME_WIDTH / 2 - 145, GlobalData.GAME_HEIGHT / 2 + 60), FP.camera);
			}
			
			hintText.render(FP.buffer, new Point(GlobalData.GAME_WIDTH / 2, GlobalData.GAME_HEIGHT - 6), FP.camera);
		}
		
	}

}