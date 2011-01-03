package fritz3.tween.plugins.gradient {
	import fritz3.display.graphics.gradient.GraphicsGradientData;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class GradientTweenData {
		
		public var gradientStart:GraphicsGradientData;
		public var gradientEnd:GraphicsGradientData;
		public var gradientIntermediate:GraphicsGradientData;
		
		public function GradientTweenData() {
			
		}
		
		public function invalidate ( ):void {
			this.gradientStart = null;
			this.gradientEnd = null;
			this.gradientIntermediate = null;
		}
		
	}

}