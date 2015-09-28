package Prototype.Interface.Story 
{
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
	import Prototype.World.MainMenuWorld;
	/**
	 * ...
	 * @author Amidos
	 */
	public class IntroStoryEntity extends Entity
	{
		public static const MAX_PAGE_NUMBER:int = 8;
		
		[Embed(source = "../../../../assets/Graphics/RightArrow.png")]private var arrowClass:Class;
		[Embed(source = "../../../../assets/Graphics/IntroStory.png")]private var story1Class:Class;
		[Embed(source = "../../../../assets/Sound/menuSelect.mp3")]private var menuSelectClass:Class;
		
		private var arrowSpriteMap:Spritemap;
		private var currentPage:StoryPageEntity;
		
		private var images:Vector.<Image>;
		private var texts:Vector.<Text>;
		private var positions:Vector.<int>;
		
		private var keyPressed:Boolean = false;
		private var selector:int = 0;
		
		private var menuSelectSfx:Sfx;
		private var hintText:Text;
		
		public function IntroStoryEntity() 
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
			
			images = new Vector.<Image>();
			texts = new Vector.<Text>();
			positions = new Vector.<int>();
			
			var options:Object = new Object();
			options["align"] = "center";
			options["size"] = 16;
			
			texts.push(new Text("After a hard-work day...\nJohn the cook closes his\nrestaurant and goes home...", 0, 0, options));
			texts.push(new Text("But it’s very very late...\nNobody is around in the city,\nand home is far away...", 0, 0, options));
			texts.push(new Text("..So John decides to pass\nthrough the abandoned park\nto make his way shorter.", 0, 0, options));
			texts.push(new Text("The Park is strangely lighted\nwith a strong blue white light...\nHe enters to look for\nthe reason.", 0, 0, options));
			texts.push(new Text("A strange portal stands in\nthe center of the park...\nIt seems to call him next to it.\n", 0, 0, options));
			texts.push(new Text("He finds himself pushed into\na strange park,\nwith unnatural colors,\na starless sky with 2 moons...\nMaybe another dimension?", 0, 0, options));
			texts.push(new Text("The portal disappears...\nand now John is...", 0, 0, options));
			texts.push(new Text("...Alone in the Park", 0, 0, options));
			
			positions.push(15);
			positions.push(15);
			positions.push(15);
			positions.push(10);
			positions.push(15);
			positions.push(0);
			positions.push(25);
			positions.push(30);
			
			for (var i:int = 0; i < MAX_PAGE_NUMBER; i++) 
			{
				images.push(new Image(story1Class, new Rectangle(i*164, 0, 164, 135)));
				images[i].originX = images[i].width / 2;
				images[i].originY = images[i].height;
				
				texts[i].originX = texts[i].width / 2;
				texts[i].originY = 0;
			}
			
			layer = LayerConstant.HUD_LAYER;
		}
		
		public function FirstTime():void
		{
			currentPage = new StoryPageEntity(images[selector], texts[selector], positions[selector], StoryPageEntity.RIGHT);
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
				currentPage = new StoryPageEntity(images[selector], texts[selector], positions[selector], StoryPageEntity.RIGHT);
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
				currentPage = new StoryPageEntity(images[selector], texts[selector], positions[selector], StoryPageEntity.LEFT);
				FP.world.add(currentPage);
				
				menuSelectSfx.play();
			}
			
			if (Input.pressed(Key.SPACE) || Input.pressed(Key.ESCAPE))
			{
				keyPressed = true;
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