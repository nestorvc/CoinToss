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
import org.flixel.FlxRect;
import org.flixel.FlxObject;
import org.flixel.plugin.photonstorm.FlxVelocity;
import org.flixel.plugin.photonstorm.FlxExtendedSprite;
import org.flixel.plugin.photonstorm.FlxMouseControl;
import org.flixel.plugin.photonstorm.FlxCollision;

class PushFlick extends FlxState
{
	private var touchBox:FlxSprite;
	private var coin0:FlxExtendedSprite;
	private var coin1:FlxExtendedSprite;
	private var coin2:FlxExtendedSprite;
	private var wallsGroup:FlxGroup;
	private var coinsGroup:FlxGroup;

	override public function create():Void
	{
		#if !neko
		FlxG.bgColor = 0xff131c1b;
		#else
		FlxG.camera.bgColor = {rgb: 0x131c1b, a: 0xff};
		#end		
		FlxG.mouse.show();
		FlxG.mouse.load("assets/fakeCursor.png"); //For touch devices, to "hide" the cursor

		//	Enable the plugin - you only need do this once in your State (unless you destroy the plugin)
		if (FlxG.getPlugin(FlxMouseControl) == null) {
			FlxG.addPlugin(new FlxMouseControl());
		}

		//New objects
		touchBox = new FlxSprite();
		coin0 = new FlxExtendedSprite(100, 100, "assets/coin.png");
		coin1 = new FlxExtendedSprite(coin0.x+coin0.width, coin0.y, "assets/coin.png");
		coin2 = new FlxExtendedSprite((coin0.x+coin0.width)/1.25, coin0.y+coin0.height*2, "assets/coin.png");
		wallsGroup = new FlxGroup();
		coinsGroup = new FlxGroup();

		//Other coins
		coin0.setGravity(0, 0, 500, 500, 10, 10);
		coin0.elasticity = 0.5;
		coin1.setGravity(0, 0, 500, 500, 10, 10);
		coin1.elasticity = 0.5;

		//Player coin
		coin2.enableMouseThrow(50, 50);
		coin2.enableMouseDrag(true, true);
		coin2.elasticity = 0.5;
		coin2.color = FlxG.RED;

		//Coins group
		coinsGroup.add(coin0);
		coinsGroup.add(coin1);
		coinsGroup.add(coin2);

		//	Some walls to collide against
		var wallThickness:Int = 20;
		var wall_TH = new FlxTileblock(0,0,FlxG.width,wallThickness); //Top Horizontal
		var wall_BH = new FlxTileblock(0,FlxG.height-wallThickness,FlxG.width,wallThickness); //Bottom Horizontal
		var wall_LV = new FlxTileblock(0,0,wallThickness,FlxG.height); //Left Vertical
		var wall_RV = new FlxTileblock(FlxG.width-wallThickness,0,wallThickness,FlxG.height); //Right Vertical		
		wallsGroup.add(wall_TH);
		wallsGroup.add(wall_BH);
		wallsGroup.add(wall_LV);
		wallsGroup.add(wall_RV);

		//Adds
		add(wallsGroup);
		add(coinsGroup);
	}

	override public function update():Void
	{
		super.update();

		//Collisions
		FlxG.collide(coinsGroup, wallsGroup);
		FlxG.collide(coinsGroup, coinsGroup, rotations);
	}	

	override public function destroy():Void {
		//	Important! Clear out the plugin otherwise resources will get messed right up after a while
		FlxMouseControl.clear();
		
		super.destroy();
	}

	public function rotations(coin1:FlxObject, coin2:FlxObject):Void {
		//Just a function to enable baked rotations after collisions
		cast(coin1, FlxSprite).angularVelocity = 10; 
		cast(coin2, FlxSprite).angularVelocity = 10;
	}


}