package demo.background  {
	import com.bit101.components.CheckBox;
	import com.bit101.components.ColorChooser;
	import com.bit101.components.HUISlider;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.RadioButton;
	import com.bit101.components.Slider;
	import com.bit101.components.Text;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.GraphicsGradientFill;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import fritz3.display.graphics.BorderPosition;
	import fritz3.display.graphics.BoxBackground;
	import fritz3.display.layout.Align;
	import fritz3.invalidation.InvalidationManager;
	/**

	/**
	 * @author Dario Gieselaar
	 * @review 
	 * @copyright Frontier Information Technologies BV
	 * @package demo.background
	 * 
	 * [Description]
	*/
	
	[SWF(backgroundColor=0xeeeeee, width=1000, height=840)]
	public class BoxBackgroundDemo extends Sprite {
		
		[Embed(source = '../../../assets/scale9gridpattern.png')]
		private var BackgroundImage:Class;
		
		private var descriptionText:Text;
		private var widthSlider:HUISlider;
		private var heightSlider:HUISlider;
		private var backgroundColorEnabled:CheckBox;
		private var backgroundColor:ColorChooser;
		private var backgroundAlpha:HUISlider;
		private var backgroundGradientEnabled:CheckBox;
		private var backgroundGradientFrom:ColorChooser;
		private var backgroundGradientTo:ColorChooser;
		private var backgroundGradientAngle:InputText;
		private var backgroundGradientFromLabel:Label;
		private var myLabel:Label;
		private var backgroundGradientAngleLabel:Label;
		private var backgroundImageEnabled:CheckBox;
		private var backgroundImageAlpha:HUISlider;
		private var backgroundImageColor:ColorChooser;
		private var backgroundImageColorEnabled:CheckBox;
		private var backgroundImageHorizontalFloat:Label;
		private var horizontalFloatLeft:RadioButton;
		private var horizontalFloatCenter:RadioButton;
		private var horizontalFloatRight:RadioButton;
		private var backgroundImageVerticalFloat:Label;
		private var verticalFloatTop:RadioButton;
		private var verticalFloatCenter:RadioButton;
		private var verticalFloatBottom:RadioButton;
		private var backgroundImageRepeatY:CheckBox;
		private var scaleGrid:InputText;
		private var scaleGridLabel:Label;
		private var borderSize:HUISlider;
		private var backgroundImageRepeatX:CheckBox;
		private var borderTop:CheckBox;
		private var borderAlpha:HUISlider;
		private var borderGradientFrom:ColorChooser;
		private var borderGradientAngleLabel:Label;
		private var borderLeft:CheckBox;
		private var borderLineStyleLabel:Label;
		private var borderGradientTo:ColorChooser;
		private var borderGradientToLabel:Label;
		private var myColorChooser:ColorChooser;
		private var borderGradientFromLabel:Label;
		private var borderGradientAngle:InputText;
		private var borderRight:CheckBox;
		private var borderBottom:CheckBox;
		private var borderColorEnabled:CheckBox;
		private var borderColor:ColorChooser;
		private var roundedCorners:HUISlider;
		private var topLeft:CheckBox;
		private var bottomLeft:CheckBox;
		private var topRight:CheckBox;
		private var bottomRight:CheckBox;
		private var borderPositionLabel:Label;
		private var backgroundLabel:Label;
		private var backgroundImageLabel:Label;
		private var backgroundImageOffsetXLabel:Label;
		private var backgroundImageOffsetX:InputText;
		private var backgroundImageOffsetYLabel:Label;
		private var backgroundImageOffsetY:InputText;
		private var borderLabel:Label;
		private var roundedCornersLabel:Label;
		private var borderGradientEnabled:CheckBox;
		private var borderPositionCenter:RadioButton;
		private var borderPositionInside:RadioButton;
		private var borderPositionOutside:RadioButton;
		private var borderLineStyle:InputText;
		
		private var _shape:Sprite;
		private var _background:BoxBackground;
		private var panel:Panel;
		
		public function BoxBackgroundDemo ( ):void {
			if (stage) {
				this.init();
			} else { 
				this.addEventListener(Event.ADDED_TO_STAGE, this.init);
			}
		}
		
		private function init ( e:Event = null ):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, this.init);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			InvalidationManager.initializeManager(stage);
			
			_shape = new Sprite();
			_background = new BoxBackground();
			_background.width = 50, _background.height = 50;
			_background.backgroundColor = 0xFFFFFF;
			_shape.filters = [ new DropShadowFilter(0, 90, 0, 0.5, 3, 3, 1, 1) ];
			
			this.addChild(_shape);
			
			_shape.x = 400;
			_shape.y = 200;
			
			descriptionText = new Text(this, stage.stageWidth - 250 - 10, 10, "This is a demo of the BoxBackground class in our FritZ3 framework. It is intended to emulate and extend css background capabilities.\n\nSome (implemented) features are missing or not fully available in this demo, such as backgroundImageAntiAliasing and individually setting borders and rounded corners.\n\nKnown issues:\n\n- border is sometimes incorrectly drawn when borderPosition is set to BorderPosition.CENTER and a linestyle other than LineStyle.SOLID is defined.\n\n- backgroundImage is incorrectly drawn when roundedCorners is equal to or greather than 1 and at least one of backgroundImageRepeatX and backgroundImageRepeatY is set to false.\n\ntwitter: <a href='http://twitter.com/plestik' target='_blank'>@plestik</a>\nemail: <a href='mailto:dario@frontier.nl'>dario@frontier.nl</a>");
			descriptionText.setSize(250, 500);
			descriptionText.html = true;
			descriptionText.editable = false;
			
			panel = new Panel(this, 10, 10);
			panel.setSize(250, stage.stageHeight - 20);

			widthSlider = new HUISlider(panel, 10, 10, "Width", onWidthChange);
			widthSlider.maximum = 500;
			widthSlider.minimum = 10;
			widthSlider.labelPrecision = 0;
			widthSlider.value = _background.width;

			heightSlider = new HUISlider(panel, 10, 30, "Height", onHeightChange);
			heightSlider.maximum = 500;
			heightSlider.minimum = 10;
			heightSlider.labelPrecision = 0;
			heightSlider.value = _background.height;
			
			roundedCornersLabel = new Label(panel, 10, 50, "Rounded Corners");

			roundedCorners = new HUISlider(panel, 10, 70, "Size", onRoundedCornersChange);
			roundedCorners.minimum = 0;
			roundedCorners.labelPrecision = 0;
			roundedCorners.maximum = 15;

			topLeft = new CheckBox(panel, 10, 90, "topLeft", onRoundedCornersChange);
			topLeft.selected = true;

			bottomLeft = new CheckBox(panel, 10, 110, "bottomLeft", onRoundedCornersChange);
			bottomLeft.selected = true;

			topRight = new CheckBox(panel, 80, 90, "topRight", onRoundedCornersChange);
			topRight.selected = true;

			bottomRight = new CheckBox(panel, 80, 110, "bottomRight", onRoundedCornersChange);
			bottomRight.selected = true;
			
			topLeft.enabled = bottomLeft.enabled = topRight.enabled = bottomRight.enabled = false;

			backgroundColorEnabled = new CheckBox(panel, 10, 150, "backgroundColor", onBackgroundColorEnabled);
			backgroundColorEnabled.selected = _background.backgroundColor != null;

			backgroundColor = new ColorChooser(panel, 110, 150, uint(_background.backgroundColor), onBackgroundColorChange);
			backgroundColor.usePopup = true;

			backgroundAlpha = new HUISlider(panel, 10, 170, "backgroundAlpha", onBackgroundAlphaChange);
			backgroundAlpha.maximum = 1;
			backgroundAlpha.tick = 0.01;
			backgroundAlpha.labelPrecision = 2;
			backgroundAlpha.value = _background.backgroundAlpha;

			backgroundGradientEnabled = new CheckBox(panel, 10, 200, "backgroundGradient", onBackgroundGradientChange);

			backgroundGradientTo = new ColorChooser(panel, 140, 220, 0xff0000, onBackgroundGradientChange);
			backgroundGradientTo.enabled = false;
			backgroundGradientTo.usePopup = true;
			
			backgroundGradientFrom = new ColorChooser(panel, 40, 220, 0xff00ff, onBackgroundGradientChange);
			backgroundGradientFrom.enabled = false;
			backgroundGradientFrom.usePopup = true;

			backgroundGradientAngle = new InputText(panel, 40, 240, "90", onBackgroundGradientChange);
			backgroundGradientAngle.width = 40;
			backgroundGradientAngle.enabled = false;

			backgroundGradientFromLabel = new Label(panel, 10, 220, "From");

			myLabel = new Label(panel, 120, 220, "To");

			backgroundGradientAngleLabel = new Label(panel, 10, 240, "Angle");

			backgroundImageEnabled = new CheckBox(panel, 10, 280, "Enable BackgroundImage", onBackgroundImageChange);
			backgroundImageEnabled.selected = false;

			backgroundImageAlpha = new HUISlider(panel, 10, 300, "backgroundImageAlpha", onBackgroundImageChange);
			backgroundImageAlpha.maximum = 1;
			backgroundImageAlpha.tick = 0.01;
			backgroundImageAlpha.labelPrecision = 2;
			backgroundImageAlpha.enabled = false;
			backgroundImageAlpha.value = 1;

			backgroundImageColorEnabled = new CheckBox(panel, 10, 320, "backgroundImageColor", onBackgroundImageChange);
			backgroundImageColorEnabled.enabled = false;

			backgroundImageColor = new ColorChooser(panel, 130, 320, 0xff0000, onBackgroundImageChange);
			backgroundImageColor.enabled = false;
			backgroundImageColor.usePopup = true;
			
			backgroundImageHorizontalFloat = new Label(panel, 10, 340, "Horizontal float");

			horizontalFloatLeft = new RadioButton(panel, 10, 360, "Left", true, onBackgroundImageChange);

			horizontalFloatCenter = new RadioButton(panel, 60, 360, "Center", false, onBackgroundImageChange);

			horizontalFloatRight = new RadioButton(panel, 110, 360, "Right", false, onBackgroundImageChange);
			
			horizontalFloatLeft.groupName = horizontalFloatCenter.groupName = horizontalFloatRight.groupName = "backgroundImageHorizontalFloat";
			horizontalFloatLeft.selected = true;
			horizontalFloatLeft.enabled = horizontalFloatCenter.enabled = horizontalFloatRight.enabled = false;

			backgroundImageVerticalFloat = new Label(panel, 10, 380, "Vertical float");

			verticalFloatTop = new RadioButton(panel, 10, 400, "Top", true, onBackgroundImageChange);

			verticalFloatCenter = new RadioButton(panel, 60, 400, "Center", false, onBackgroundImageChange);

			verticalFloatBottom = new RadioButton(panel, 120, 400, "Bottom", false, onBackgroundImageChange);
			
			verticalFloatTop.groupName = verticalFloatCenter.groupName = verticalFloatBottom.groupName = "backgroundImageVerticalFloat";
			verticalFloatTop.selected = true;
			verticalFloatTop.enabled = verticalFloatCenter.enabled = verticalFloatBottom.enabled = false;

			backgroundImageRepeatX = new CheckBox(panel, 10, 490, "RepeatX", onBackgroundImageChange);
			backgroundImageRepeatY = new CheckBox(panel, 80, 490, "RepeatY", onBackgroundImageChange);
			backgroundImageRepeatX.enabled = backgroundImageRepeatY.enabled = false;
		
			scaleGridLabel = new Label(panel, 10, 440, "ScaleGrid (empty or x,y,width,height):");
			scaleGrid = new InputText(panel, 10, 460, "", onBackgroundImageChange);
			scaleGrid.enabled = false;
			scaleGrid.text = "8,8,8,8";


			borderLabel = new Label(panel, 10, 510, "Border");

			borderSize = new HUISlider(panel, 10, 530, "borderThickness", onBorderChange);
			borderSize.maximum = 5;

			borderAlpha = new HUISlider(panel, 10, 550, "borderAlpha", onBorderChange);
			borderAlpha.maximum = 1;
			borderAlpha.tick = 0.01;
			borderAlpha.labelPrecision = 2;
			borderAlpha.enabled = false;
			borderAlpha.value = 1;

			borderLeft = new CheckBox(panel, 10, 580, "borderLeft", onBorderChange);
			borderLeft.selected = true;

			borderRight = new CheckBox(panel, 90, 580, "borderRight", onBorderChange);
			borderRight.selected = true;

			borderBottom = new CheckBox(panel, 90, 600, "borderBottom", onBorderChange);
			borderBottom.selected = true;
			
			borderTop = new CheckBox(panel, 10, 600, "borderTop", onBorderChange);
			borderTop.selected = true;
			
			borderLeft.enabled = borderRight.enabled = borderBottom.enabled = borderTop.enabled = false;

			
			borderGradientEnabled = new CheckBox(panel, 10, 660, "borderGradient", onBorderChange);
			borderGradientEnabled.enabled = false
			
			borderGradientFromLabel = new Label(panel, 10, 680, "From");
			borderGradientFrom = new ColorChooser(panel, 40, 680, 0xFFFFFF, onBorderChange);
			borderGradientFrom.enabled = false;
			borderGradientFrom.usePopup = true;

			borderGradientToLabel = new Label(panel, 120, 680, "To");
			borderGradientTo = new ColorChooser(panel, 140, 680, 0xff0000, onBorderChange);
			borderGradientTo.enabled = false;
			borderGradientTo.usePopup = true;

			borderGradientAngleLabel = new Label(panel, 10, 700, "Angle");
			borderGradientAngle = new InputText(panel, 40, 700, "90", onBorderChange);
			borderGradientAngle.width = 45;
			borderGradientAngle.enabled = false;

			borderColorEnabled = new CheckBox(panel, 10, 630, "borderColor", onBorderChange);
			borderColorEnabled.selected = true;
			borderColorEnabled.enabled = false;
			
			borderColor = new ColorChooser(panel, 90, 630, 0xff0000, onBorderChange);
			borderColor.enabled = false;
			borderColor.usePopup = true;

			backgroundLabel = new Label(panel, 10, 130, "Background");

			backgroundImageLabel = new Label(panel, 10, 260, "BackgroundImage");

			backgroundImageOffsetXLabel = new Label(panel, 10, 420, "offsetX");

			backgroundImageOffsetX = new InputText(panel, 50, 420, "0", onBackgroundImageChange);
			backgroundImageOffsetX.width = 30;

			backgroundImageOffsetYLabel = new Label(panel, 100, 420, "offsetY");

			backgroundImageOffsetY = new InputText(panel, 140, 420, "0", onBackgroundImageChange);
			backgroundImageOffsetY.width = 30;
			
			backgroundImageOffsetX.enabled = backgroundImageOffsetY.enabled = false;
			
			borderPositionLabel = new Label(panel, 10, 730, "Border position");

			borderPositionCenter = new RadioButton(panel, 10, 750, "Center", true, onBorderChange);
			borderPositionCenter.selected = true;

			borderPositionInside = new RadioButton(panel, 70, 750, "Inside", false, onBorderChange);
			borderPositionOutside = new RadioButton(panel, 120, 750, "Outside", false, onBorderChange);
			
			borderPositionCenter.enabled = borderPositionInside.enabled = borderPositionOutside.enabled = false;
			
			borderLineStyleLabel = new Label(panel, 10, 770, "Line style (separate dash-gap by commas)");
			borderLineStyle = new InputText(panel, 10, 790, "", onBorderChange);
			borderLineStyle.enabled = false;
			
			this.draw();

		}
		
		protected function draw ( ):void {
			_background.draw(_shape);
			
			var width:Number, startX:Number;
			width = stage.stageWidth - panel.width - panel.x - (stage.stageWidth - descriptionText.x);
			startX = panel.x + panel.width;
			_shape.x = width / 2 - _shape.width / 2 + startX;
			_shape.y = stage.stageHeight / 2 - _shape.height / 2;
		}
		
		protected function onBorderLineStyleChange ( e:Event ):void {
			
		}
		
		protected function onBorderGradientChange ( event:Event ):void{
			
		}

		protected function onWidthChange(event:Event):void
		{
			_background.width = widthSlider.value;
			this.draw();
		}

		protected function onHeightChange(event:Event):void
		{
			_background.height = heightSlider.value;
			this.draw();
		}

		protected function onBackgroundColorEnabled(event:Event):void {
			_background.backgroundColor = backgroundColorEnabled.selected ? uint(backgroundColor.value) : null;
			backgroundColor.enabled = backgroundColorEnabled.selected;
			backgroundAlpha.enabled = backgroundColorEnabled.selected;
			this.draw();
		}

		protected function onBackgroundColorChange(event:Event):void {
			_background.backgroundColor = uint(backgroundColor.value);
			this.draw();
		}

		protected function onBackgroundAlphaChange ( event:Event = null ):void {
			_background.backgroundAlpha = Number(backgroundAlpha.value);
			this.draw();
		}

		protected function onBackgroundGradientChange ( event:Event = null ):void {
			var enabled:Boolean = backgroundGradientEnabled.selected;
			backgroundGradientAngle.enabled = enabled;
			backgroundGradientFrom.enabled = enabled;
			backgroundGradientTo.enabled = enabled;
			
			var gradient:GraphicsGradientFill;
			if (enabled) {
				gradient = new GraphicsGradientFill(GradientType.LINEAR, [ uint(backgroundGradientFrom.value), uint(backgroundGradientTo.value) ], [ 1, 1 ], [ 0, 255 ]);
			} else {
				gradient = null;
			}
			_background.backgroundGradientAngle = Number(backgroundGradientAngle.text);
			_background.backgroundGradient = gradient;
			this.draw();
		}

		protected function onBackgroundImageChange ( event:Event = null ):void {
			var backgroundImage:DisplayObject;
			var enabled:Boolean = backgroundImageEnabled.selected;
			
			backgroundImageAlpha.enabled = enabled;
			backgroundImageColorEnabled.enabled = enabled;
			backgroundImageColor.enabled = enabled && backgroundImageColorEnabled.selected;
			
			backgroundImageRepeatX.enabled = backgroundImageRepeatY.enabled = enabled;
			
			var repeatX:Boolean = backgroundImageRepeatX.selected;
			var repeatY:Boolean = backgroundImageRepeatY.selected;
			
			horizontalFloatLeft.enabled = horizontalFloatRight.enabled = horizontalFloatCenter.enabled = enabled && !repeatX;
			verticalFloatTop.enabled = verticalFloatCenter.enabled = verticalFloatBottom.enabled = enabled && !repeatY;
			
			backgroundImageOffsetX.enabled = enabled && !repeatX;
			backgroundImageOffsetY.enabled = enabled && !repeatY;
			
			scaleGrid.enabled = enabled;
			
			var horizontalFloat:String;
			if (horizontalFloatLeft.selected) {
				horizontalFloat = Align.LEFT;
			} else if (horizontalFloatCenter.selected) {
				horizontalFloat = Align.CENTER;
			} else {
				horizontalFloat = Align.RIGHT;
			}
			var verticalFloat:String;
			if (verticalFloatTop.selected) {
				verticalFloat = Align.TOP;
			} else if (verticalFloatCenter.selected ) {
				verticalFloat = Align.CENTER;
			} else {
				verticalFloat = Align.BOTTOM;
			}
			
			var offsetX:Number = Number(backgroundImageOffsetX.text);
			var offsetY:Number = Number(backgroundImageOffsetY.text);
			
			
			var scaleGridRect:Rectangle = null;
			if (scaleGrid.text) {
				var values:Array = scaleGrid.text.split(",");
				if (values.length >= 4) {
					var x:Number = values[0], y:Number = values[1], width:Number = values[2], height:Number = values[3];
					if (!isNaN(x) && !isNaN(y) && !isNaN(width) && !isNaN(height)) {
						scaleGridRect = new Rectangle(x, y, width, height);
					}
				}
			}
			
			_background.backgroundImage = enabled ? (new BackgroundImage() as DisplayObject) : null;
			_background.backgroundImageAlpha = Number(backgroundImageAlpha.value);
			_background.backgroundImageColor = backgroundImageColorEnabled.selected ? uint(backgroundImageColor.value) : null;
			_background.backgroundImageRepeatX = repeatX, _background.backgroundImageRepeatY = repeatY;
			_background.backgroundImageHorizontalFloat = horizontalFloat, _background.backgroundImageVerticalFloat = verticalFloat;
			_background.backgroundImageOffsetX = offsetX, _background.backgroundImageOffsetY = offsetY;
			_background.backgroundImageScaleGrid = scaleGridRect;
			
			this.draw();
			
		}

		protected function onBorderChange ( event:Event = null ):void {
			var border:Number = borderSize.value;
			var enabled:Boolean = border >= 1;
			
			borderAlpha.enabled = enabled;
			borderColorEnabled.enabled = enabled;
			borderColor.enabled = borderColorEnabled.selected && enabled;
			borderLeft.enabled = borderTop.enabled = borderBottom.enabled = borderRight.enabled = enabled;
			
			
			borderGradientEnabled.enabled = enabled;
			
			_background.borderColor = borderColorEnabled.selected ? uint(borderColor.value) : null;
			_background.borderAlpha = borderAlpha.value;
			_background.borderLeft = enabled && borderLeft.selected ? border : NaN;
			_background.borderRight = enabled && borderRight.selected ? border : NaN;
			_background.borderTop = enabled && borderTop.selected ? border : NaN;
			_background.borderBottom = enabled && borderBottom.selected ? border : NaN;
			
			var gradientEnabled:Boolean = enabled && borderGradientEnabled.selected
			borderGradientAngle.enabled = gradientEnabled;
			borderGradientFrom.enabled = gradientEnabled;
			borderGradientTo.enabled = gradientEnabled;
			
			if (!gradientEnabled) {
				_background.borderGradient = null;
			} else {
				var borderGradient:GraphicsGradientFill = new GraphicsGradientFill(GradientType.LINEAR, [ borderGradientFrom.value, borderGradientTo.value ], [ 1, 1 ], [ 0, 255]);
				_background.borderGradient = borderGradient;
				_background.borderGradientAngle = Number(borderGradientAngle.text);
			}
			
			borderPositionCenter.enabled = borderPositionInside.enabled = borderPositionOutside.enabled = enabled;
			
			var borderPosition:String;
			if (borderPositionInside.selected) {
				borderPosition = BorderPosition.INSIDE;
			} else if (borderPositionOutside.selected) {
				borderPosition = BorderPosition.OUTSIDE;
			} else {
				borderPosition = BorderPosition.CENTER;
			}
			_background.borderPosition = borderPosition;
			
			borderLineStyle.enabled = enabled;
			
			var lineStyle:Array = null;
			if (borderLineStyle.text) {
				lineStyle = borderLineStyle.text.split(",");
			}
			
			_background.borderLineStyle = lineStyle;
			
			this.draw();
		} 

		protected function onRoundedCornersChange ( event:Event ):void {
			var value:Number = Number(roundedCorners.value)
			_background.roundedCorners = value;
			_background.topLeftCorner = topLeft.selected ? value : 0;
			_background.topRightCorner = topRight.selected ? value : 0;
			_background.bottomLeftCorner = bottomLeft.selected ? value : 0;
			_background.bottomRightCorner = bottomRight.selected ? value : 0;
			
			topLeft.enabled = topRight.enabled = bottomLeft.enabled = bottomRight.enabled = value >= 1;
			this.draw();
		}
		
		
	}

}