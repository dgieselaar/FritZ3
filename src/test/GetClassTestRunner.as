package test {
	import flash.utils.getTimer;
	import fritz3.display.core.GraphicsComponent;
	/**
	 * ...
	 * @author Dario Gieselaar
	 * 
	 */
	public class GetClassTestRunner extends TestRunner {
		
		override protected function runDesignatedTest ( ):void {
			this.runConstructorTest();
		}

		protected var _numLoops:int = 100000;
		
		protected function runConstructorTest ( ):void {
			var t:int = getTimer();
			trace("Running test #" + Number((_iteration++) + 1));
			var isClass:Boolean;
			var component:GraphicsComponent, classObject:Class = GraphicsComponent;
			for (var i:int, l:int = _numLoops; i < l; ++i) {
				isClass = component is classObject;
			}
			trace("Finished in " + (getTimer() - t) + "ms");
		}
		
		protected function runIsClassTest ( ):void {
			var t:int = getTimer();
			trace("Running test #" + Number((_iteration++) + 1));
			var isClass:Boolean;
			var component:GraphicsComponent, classObject:Class = GraphicsComponent;
			for (var i:int, l:int = _numLoops; i < l; ++i) {
				isClass = classObject == classObject;
			}
			trace("Finished in " + (getTimer() - t) + "ms");
		}
	}

}