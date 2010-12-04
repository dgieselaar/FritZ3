package test {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import fritz3.utils.signals.fast.FastSignal;
	import fritz3.utils.signals.fast.FastSignalListenerData;
	import fritz3.utils.signals.SignalDispatcher;
	import org.osflash.signals.IDispatcher;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class SignalTestRunner extends TestRunner {
		
		protected static const _numFunctions:int = 10000;
		
		protected function runFastSignalTest ( ):void {
			var signal:SignalDispatcher = new FastSignal();
			var t:int = getTimer();
			trace("Running test #" + Number((_iteration++)+1));
			for (var i:int, l:int = _numFunctions; i < l; ++i) {
				signal.add(function ( ):void {
					l--;
					if (l >= _numFunctions*0.1 && l <= _numFunctions*0.4) {
						signal.remove(arguments.callee);
					}
				})
			}
			trace("Populated in " + (getTimer() - t) + "ms");
			t = getTimer();
			signal.dispatch();
			trace("Dispatched in " + (getTimer() - t) + "ms (succes: " + (l == 0)+ ", "+signal.numListeners+" )");
		}
		
		protected function runDefaultSignalTest ( ):void {
			var signal:ISignal = new Signal();
			var t:int = getTimer();
			trace("Running test #" + Number((_iteration++)+1));
			for (var i:int, l:int = _numFunctions; i < l; ++i) {
				signal.add(function ( ):void {
					l--;
					if (l >= _numFunctions*0.1 && l <= _numFunctions*0.4) {
						signal.remove(arguments.callee);
					}
				})
			}
			trace("Populated in " + (getTimer() - t) + "ms");
			t = getTimer();
			IDispatcher(signal).dispatch();
			trace("Dispatched in " + (getTimer() - t) + "ms (succes: " + (l == 0)+ ", "+signal.numListeners+" )");
		}
		
		protected function runLinkedListTest ( ):void {
			var t:int = getTimer();
			var firstNode:FastSignalListenerData = new FastSignalListenerData();
			var prevNode:FastSignalListenerData = firstNode, node:FastSignalListenerData;
			for (var i:int, l:int = _numFunctions; i < l; ++i) {
				node = new FastSignalListenerData();
				node.prevNode = prevNode;
				prevNode.nextNode = node;
				prevNode = node;
			}
			trace("Populated in " + (getTimer() - t) + "ms");
			t = getTimer();
			var assign:Object;
			node = firstNode;
			while (node) {
				assign = node.method;
				node = node.nextNode;
			}
			trace("Iterated in " + (getTimer() - t) + "ms");
		}
		
		protected function runArrayTest ( ):void {
			var t:int = getTimer();
			var array:Array = new Array(_numFunctions);
			for (var i:int, l:int = _numFunctions; i < l; ++i) {
				array[i] = new FastSignalListenerData();
			}
			trace("Populated in " + (getTimer() - t) + "ms");
			t = getTimer();
			var assign:Object;
			var node:FastSignalListenerData;
			for (i = _numFunctions - 1; i >= 0; --i) {
				node = array[i];
				assign = node.method;
			}
			trace("Iterated in " + (getTimer() - t) + "ms");
		}
	}

}