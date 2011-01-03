package fritz3.tween.core {
	import fritz3.tween.plugins.FTweenPlugin;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class FTween {
		
		public var prevNode:FTween;
		public var nextNode:FTween;
		
		public var target:Object;
		public var propertyName:String;
		
		public var from:*;
		public var to:*;
		
		public var duration:Number;
		public var delay:Number;
		public var ease:Function;
		
		public var time:Number;
		
		public var plugin:FTweenPlugin;
		public var pluginData:Object;
		
		
		public function FTween ( ) {
			
		}
		
		public function invalidate ( ):void {
			this.target = null;
			this.propertyName = null;
			this.from = undefined;
			this.to = undefined;
			this.duration = NaN;
			this.delay = NaN;
			this.ease = null;
			this.time = NaN;
			this.plugin = null;
			this.pluginData = null;
		}
		
	}

}