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
		
		protected var _timeout:int
		protected function init ( e:Event = null ):void {
			_timeout = this.getTimeout();
			_maxIterations = this.getMaxIterations();
			setTimeout(this.startTest, _timeout);
		}
			
		protected var _iteration:int;
		protected var _maxIterations:int
		
		protected function startTest ( ):void {
			function onTimeOut ( ):void {
				runDesignatedTest();
				_iteration++;
				if (_iteration < _maxIterations) {
					setTimeout(onTimeOut, 2500); 
				}
			}
			
			onTimeOut();
		}
		
		protected function runDesignatedTest ( ):void {
			
		}
		
		protected function getTimeout ( ):int {
			return 1000;
		}
		
		protected function getMaxIterations ( ):int {
			return 5;
		}
		
	}

}