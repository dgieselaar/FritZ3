package fritz3.tween.plugins.gradient {
	import fritz3.display.graphics.gradient.GraphicsGradientColor;
	import fritz3.display.graphics.gradient.GraphicsGradientData;
	import fritz3.tween.core.FTween;
	import fritz3.tween.plugins.FTweenPlugin;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class GradientTweenPlugin implements FTweenPlugin {
		
		protected static var _gradientDataPool:Array;
		protected static var _instance:GradientTweenPlugin;
		
		{
			_gradientDataPool = [];
			_instance = new GradientTweenPlugin();
		}
		
		public function GradientTweenPlugin ( ) {
			
		}
		
		public function onInit ( tween:FTween ):void {
			
		}
		
		public function onStart ( tween:FTween ):void {			
			var startGradient:GraphicsGradientData = GraphicsGradientData(tween.from);
			var endGradient:GraphicsGradientData = GraphicsGradientData(tween.to);
			if (startGradient == endGradient || (startGradient && endGradient && startGradient.type != endGradient.type)) {
				tween.target[tween.propertyName] = endGradient;
				return;
			}

			var data:GradientTweenData = getGradientTweenDataObject();
			tween.pluginData = data;
			
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
		}
		
		public function render ( tween:FTween, ratio:Number ):void {
			var data:GradientTweenData = GradientTweenData(tween.pluginData);
			if (!data) {
				return;
			}
			
			var startGradient:GraphicsGradientData = data.gradientStart;
			var endGradient:GraphicsGradientData = data.gradientEnd;
			var intermediateGradient:GraphicsGradientData = data.gradientIntermediate;
			
			var startGradientColors:Array = (startGradient ? startGradient.gradientColors : []) || [];
			var endGradientColors:Array = (endGradient ? endGradient.gradientColors : []) || [];
			var intermediateGradientColors:Array = intermediateGradient.gradientColors;
			
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
					startColor = endGradientColor.color, startAlpha = 0, startPosition = endGradientColor.position;
				}
				if (endGradientColor) {
					endColor = endGradientColor.color;
					endAlpha = endGradientColor.alpha;
					endPosition = endGradientColor.position;
				} else {
					endAlpha = 0;
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
			tween.target[tween.propertyName] = intermediateGradient;
		}
		
		public function onComplete ( tween:FTween ):void {
			var gradientData:GradientTweenData = GradientTweenData(tween.pluginData);
			if (gradientData) {
				tween.target[tween.propertyName] = gradientData.gradientEnd;
			}
		}
		
		public function onRemove ( tween:FTween ):void {
			var gradientData:GradientTweenData = GradientTweenData(tween.pluginData);
			if (gradientData) {
				gradientData.invalidate();
				_gradientDataPool[_gradientDataPool.length] = gradientData;
			}
		}
		
		protected static function getGradientTweenDataObject ( ):GradientTweenData {
			return _gradientDataPool.shift() || new GradientTweenData();
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
		
		public static function get instance ( ):GradientTweenPlugin { return _instance; }
		
	}

}