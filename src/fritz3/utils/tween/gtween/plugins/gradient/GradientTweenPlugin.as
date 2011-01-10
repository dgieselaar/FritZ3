	package fritz3.utils.tween.gtween.plugins.gradient {
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.plugins.IGTweenPlugin;
	import fritz3.display.graphics.gradient.GraphicsGradientColor;
	import fritz3.display.graphics.gradient.GraphicsGradientData;
	import fritz3.utils.color.ColorUtil;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class GradientTweenPlugin implements IGTweenPlugin {
		
		public static var enabled:Boolean = true;
		public static var instance:GradientTweenPlugin;
		
		{
			instance = new GradientTweenPlugin();
		}
		
		public function GradientTweenPlugin ( ) {
			
		}
		
		public function init ( tween:GTween, name:String, value:Number ):Number {
			var startGradient:GraphicsGradientData = tween.target[name] as GraphicsGradientData;
			var endGradient:GraphicsGradientData = tween.getValues()[name] as GraphicsGradientData;
			if (startGradient == endGradient || (startGradient && endGradient && startGradient.type != endGradient.type)) {
				tween.target[name] = endGradient;
				return NaN;
			}
			var data:GradientTweenData = new GradientTweenData();
			tween.pluginData.GradientTweenPlugin = data;
			data.gradientStart = startGradient;
			data.gradientEnd = endGradient;
			var intermediateGradient:GraphicsGradientData = new GraphicsGradientData();
			intermediateGradient.type = endGradient ? endGradient.type : startGradient.type;
			
			var i:int, l:int = 0;
			if (endGradient && !startGradient) {
				intermediateGradient.angle = endGradient.angle;
				intermediateGradient.focalPointRatio = endGradient.focalPointRatio;
				intermediateGradient.focalPointRatioValueType = endGradient.focalPointRatioValueType;
				intermediateGradient.offsetX = endGradient.offsetX;
				intermediateGradient.offsetXValueType = endGradient.offsetXValueType;
				intermediateGradient.offsetY = endGradient.offsetY;
				intermediateGradient.offsetYValueType = endGradient.offsetYValueType;
			} else if(startGradient && !endGradient) {
				intermediateGradient.angle = startGradient.angle;
				intermediateGradient.focalPointRatio = startGradient.focalPointRatio;
				intermediateGradient.focalPointRatioValueType = startGradient.focalPointRatioValueType;
				intermediateGradient.offsetX = startGradient.offsetX;
				intermediateGradient.offsetXValueType = startGradient.offsetXValueType;
				intermediateGradient.offsetY = startGradient.offsetY;
				intermediateGradient.offsetYValueType = startGradient.offsetYValueType;
			} else {
				intermediateGradient.focalPointRatioValueType = endGradient.focalPointRatioValueType;
				intermediateGradient.offsetXValueType = endGradient.offsetXValueType;
				intermediateGradient.offsetYValueType = endGradient.offsetYValueType;
			}
			
			data.gradientIntermediate = intermediateGradient;
			
			l = Math.max(startGradient ? startGradient.gradientColors.length : 0, endGradient ? endGradient.gradientColors.length : 0);
			var gradientColors:Array = [];
			var gradientColor:GraphicsGradientColor;
			for (i = 0; i < l; ++i) {
				gradientColor = new GraphicsGradientColor();
				gradientColors[i] = gradientColor;
			}
			intermediateGradient.gradientColors = gradientColors;
			
			return NaN;
		}
		
		public function tween ( tween:GTween, name:String, value:Number, initValue:Number, rangeValue:Number, ratio:Number, end:Boolean ):Number {
			var data:GradientTweenData = tween.pluginData.GradientTweenPlugin as GradientTweenData;
			var startGradient:GraphicsGradientData = data.gradientStart;
			var endGradient:GraphicsGradientData = data.gradientEnd;
			var intermediateGradient:GraphicsGradientData = data.gradientIntermediate;
			
			if (end) {
				tween.target[name] = endGradient;
				tween.pluginData.GradientTweenPlugin = null;
				intermediateGradient.gradientColors = null;
				return NaN;
			}
			
			var startGradientColors:Array = (startGradient ? startGradient.gradientColors : []) || [];
			var endGradientColors:Array = (endGradient ? endGradient.gradientColors : []) || [];
			var intermediateGradientColors:Array = intermediateGradient.gradientColors;
			
			var tweenAlpha:Boolean = !(startGradient && endGradient);
			
			var i:int, l:int = intermediateGradientColors.length;
			var gradientColor:GraphicsGradientColor, startGradientColor:GraphicsGradientColor, endGradientColor:GraphicsGradientColor;
			var startColor:uint = 0, endColor:uint = 0;
			var startAlpha:Number = 0, endAlpha:Number = 1;
			var startPosition:Number = 0, endPosition:Number = 0;
			for (i = 0; i < l; ++i) {
				gradientColor = intermediateGradientColors[i];
				startGradientColor = startGradientColors[i];
				endGradientColor = endGradientColors[i];
				if (startGradientColor) {
					startColor = startGradientColor.color;
					startAlpha = startGradientColor.alpha;
					startPosition = startGradientColor.position;
				} else {
					startColor = endGradientColor.color, startAlpha = endGradientColor.alpha, startPosition = endGradientColor.position;
				}
				if (endGradientColor) {
					endColor = endGradientColor.color;
					endAlpha = endGradientColor.alpha;
					endPosition = endGradientColor.position;
				} else {
					endAlpha = tweenAlpha ? 0 : 1;
					endColor = startColor;
					endPosition = startPosition;
				}
				
				gradientColor.color = this.getIntermediateColor(startColor, endColor, ratio);
				gradientColor.alpha = (endAlpha - startAlpha) * ratio + startAlpha;
				gradientColor.position = (endPosition - startPosition) * ratio + startPosition;
				gradientColor.positionValueType = endGradientColor ? endGradientColor.positionValueType : startGradientColor.positionValueType;
			}
			
			if (startGradient && endGradient) {
				intermediateGradient.angle = (endGradient.angle - startGradient.angle) * ratio + startGradient.angle;
				intermediateGradient.focalPointRatio = (endGradient.focalPointRatio - startGradient.focalPointRatio) * ratio + startGradient.focalPointRatio;
				intermediateGradient.offsetX = (endGradient.offsetX - startGradient.offsetX) * ratio + startGradient.offsetX;
				intermediateGradient.offsetY = (endGradient.offsetY - startGradient.offsetY) * ratio + startGradient.offsetY;
			}
			intermediateGradient.invalidate();
			tween.target[name] = intermediateGradient;
			
			return NaN;
		}
		
		protected function getIntermediateColor ( start:uint, end:uint, ratio:Number ):uint {
			var startR:uint = start >> 16;
			var startG:uint = (start >> 8) & 0xff;
			var startB:uint = start & 0xff;
			
			var endR:uint = end >> 16;
			var endG:uint = (end >> 8) & 0xff;
			var endB:uint = end & 0xff;
			
			return ratio * (endR - startR) + startR << 16 ^ ratio * (endG - startG) + startG << 8 ^ ratio * (endB - startB) + startB;
		}
		
	}

}