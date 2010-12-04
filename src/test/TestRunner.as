package test {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class TestRunner extends Sprite {
		
		public function TestRunner ( ) {
			if (this.stage) {
				this.init();
			} else {
				this.addEventListener(Event.ADDED_TO_STAGE, this.init);
			}
		}
		
		protected function init ( e:Event= null ):void {		
			setTimeout(this.startTest, 2500);
		}
			
		protected var _iteration:int;
		protected var _maxIterations:int = 5;
		
		protected function startTest ( ):void {
			function onTimeOut ( ):void {
				runDesignatedTest();
				if (_iteration < _maxIterations) {
					setTimeout(onTimeOut, 2500); 
				}
			}
			
			onTimeOut();
		}
		
		protected function runDesignatedTest ( ):void {
			
		}
		
	}

}