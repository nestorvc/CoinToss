package;

import nme.Assets;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxPoint;
import org.flixel.FlxTileblock;
import org.flixel.FlxGroup;
import org.flixel.plugin.photonstorm.FlxVelocity;
import org.flixel.plugin.photonstorm.FlxExtendedSprite;
import org.flixel.plugin.photonstorm.FlxMouseControl;
import org.flixel.plugin.photonstorm.FlxCollision;

class TouchFlick extends FlxState
{
	private var coin:FlxExtendedSprite;
	private var wallsGroup:FlxGroup;
	
	override public function create():Void
	{
		
		#if !neko
		FlxG.bgColor = 0xff131c1b;
		#else
		FlxG.camera.bgColor = {rgb: 0x131c1b, a: 0xff};
		#end		
		FlxG.mouse.show();

		//	Enable the plugin - you only need do this once in your State (unless you destroy the plugin)
		if (FlxG.getPlugin(FlxMouseControl) == null)
		{
			FlxG.addPlugin(new FlxMouseControl());
		}
		
		coin = new FlxExtendedSprite(64, 48, "assets/coin.png");
		
		//	Just to make it visually more interesting we apply gravity pulling the coin down
		coin.setGravity(0, 100, 500, 500, 10, 10);
		
		//	For the best feeling you should enable Mouse Drag along with Mouse Throw, but it's not essential.
		//	If you don't enable Drag or Clicks then enabling Mouse Throw will automatically enable Mouse Clicks.
		coin.enableMouseDrag(true, true);
		
		//	The x/y factors depend on how fast you want the sprite to move - here we use 50, so its sprite velocity = mouse speed * 50
		coin.enableMouseThrow(50, 50);
		
		//	Allow the coin to rebound a little bit, but it will eventually slow to a halt
		coin.elasticity = 0.5;
		
		//	Some walls to collide against
		var wallThickness:Int = 20;
		var wall_TH = new FlxTileblock(0,0,FlxG.width,wallThickness); //Top Horizontal
		var wall_BH = new FlxTileblock(0,FlxG.height-wallThickness,FlxG.width,wallThickness); //Bottom Horizontal
		var wall_LV = new FlxTileblock(0,0,wallThickness,FlxG.height); //Left Vertical
		var wall_RV = new FlxTileblock(FlxG.width-wallThickness,0,wallThickness,FlxG.height); //Right Vertical
		wallsGroup = new FlxGroup();
		wallsGroup.add(wall_TH);
		wallsGroup.add(wall_BH);
		wallsGroup.add(wall_LV);
		wallsGroup.add(wall_RV);

		add(wallsGroup);
		
		add(coin);
	}
	
	override public function update():Void
	{
		super.update();
		
		FlxG.collide(coin, wallsGroup);
	}
	
	override public function destroy():Void
	{
		//	Important! Clear out the plugin otherwise resources will get messed right up after a while
		FlxMouseControl.clear();
		
		super.destroy();
	}
	
}