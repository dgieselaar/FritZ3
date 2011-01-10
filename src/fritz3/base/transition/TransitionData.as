package fritz3.base.transition {
	import fritz3.style.PropertyData;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class TransitionData extends PropertyData {
		
		public var type:String;
		public var ease:Function;
		public var duration:Number;
		public var delay:Number;
		public var from:*;
		public var cyclePhase:String;
		
		public function TransitionData ( ) {
			
		}
		
		override public function clone ( target:PropertyData = null ):PropertyData {
			if (!target) {
				target = new TransitionData();
			}
			super.clone(target);
			var transitionTarget:TransitionData = TransitionData(target);
			transitionTarget.type = this.type;
			transitionTarget.ease = this.ease;
			transitionTarget.duration = this.duration;
			transitionTarget.delay = this.delay;
			transitionTarget.from = this.from;
			transitionTarget.cyclePhase = this.cyclePhase;
			return target;
		}
		
		override public function clear ( ):void {
			super.clear();
			this.type = null;
			this.ease = null;
			this.duration = NaN;
			this.delay = NaN;
			this.from = undefined;
			this.cyclePhase = null;
		}
		
	}

}