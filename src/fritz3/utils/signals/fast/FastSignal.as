package fritz3.utils.signals.fast {
	import flash.utils.Dictionary;
	import fritz3.utils.signals.SignalDispatcher;
	import org.osflash.signals.IDispatcher;
	import org.osflash.signals.ISignal;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class FastSignal implements SignalDispatcher {
		
		protected static var _listenerObjectPool:Array = [];
		protected var _firstNode:FastSignalListenerData;
		protected var _lastNode:FastSignalListenerData;
		protected var _dataByListener:Dictionary;
		protected var _dispatching:Boolean;
		// FIXME: will not work when removing a node other than the node being dispatched
		protected var _nextNode:FastSignalListenerData;
		
		protected var _numListeners:int;
		protected var _numArguments:int;
		protected var _valueClasses:Array;
		
		public function FastSignal ( ...args ) {
			_dataByListener = new Dictionary();
			_numArguments = args.length;
		}
		
		public function dispatch ( ...args ):void {
			var node:FastSignalListenerData = _firstNode, nn:FastSignalListenerData;
			_dispatching = true;
			var argument1:Object, argument2:Object;
			if (args.length) {
				argument1 = args[0];
			}
			if (args.length == 2) {
				argument2 = args[1];
			}
			switch(args.length) {
				case 0:
				while (node) {
					node.method();
					if (node.executeOnce) {
						this.remove(node.method);
					}
					if (_nextNode) {
						node = _nextNode;
						_nextNode = null;
					} else {
						node = node.nextNode;
					}
				}
				break;
				
				case 1:
				while (node) {
					node.method(argument1);
					if (node.executeOnce) {
						this.remove(node.method);
					}
					if (_nextNode) {
						node = _nextNode;
						_nextNode = null;
					} else {
						node = node.nextNode;
					}
				}
				break;
				
				case 2:
				while (node) {
					node.method(argument1, argument2);
					if (node.executeOnce) {
						this.remove(node.method);
					}
					if (_nextNode) {
						node = _nextNode;
						_nextNode = null;
					} else {
						node = node.nextNode;
					}
				}
				break;
				
				default:
				while (node) {
					node.method.apply(null, args);
					if (node.executeOnce) {
						this.remove(node.method);
					}
					if (_nextNode) {
						node = _nextNode;
						_nextNode = null;
					} else {
						node = node.nextNode;
					}
				}
				break;
				
			}
			_dispatching = false;
		}
		
		public function add ( listener:Function ):Function {
			if (_dataByListener[listener]) {
				return listener;
			}
			
			var listenerData:FastSignalListenerData = getListenerObject();
			listenerData.method = listener;
			if (!_firstNode) {
				_firstNode = listenerData;
			}
			if (_lastNode) {
				_lastNode.nextNode = listenerData;
				listenerData.prevNode = _lastNode;
			}
			_lastNode = listenerData;
			listenerData.method = listener;
			_dataByListener[listener] = listenerData;
			_numListeners++;
			return listener;
		}
		
		public function addOnce ( listener:Function ):Function {
			this.add(listener);
			_lastNode.executeOnce = true;
			return listener;
		}
		
		public function remove ( listener:Function ):Function {
			var listenerData:FastSignalListenerData = _dataByListener[listener];
			if (!listenerData) {
				return listener;
			}
			
			var prevNode:FastSignalListenerData = listenerData.prevNode, nextNode:FastSignalListenerData = listenerData.nextNode;
			if (prevNode) {
				prevNode.nextNode = nextNode;
			}
			if (nextNode) {
				nextNode.prevNode = prevNode;
			}
			
			if (listenerData == _firstNode) {
				_firstNode = nextNode;
			}
			if (listenerData == _lastNode) {
				_lastNode = prevNode;
			}
			delete _dataByListener[listener];
			if (_dispatching) {
				_nextNode = nextNode;
			}
			poolListenerObject(listenerData);
			_numListeners--;
			return listener;
		}
		
		protected static function getListenerObject ( ):FastSignalListenerData {
			return _listenerObjectPool.length ? _listenerObjectPool.shift() : new FastSignalListenerData();
		}
		
		protected static function poolListenerObject ( listenerObject:FastSignalListenerData ):void {
			listenerObject.prevNode = listenerObject.nextNode = null;
			listenerObject.executeOnce = false;
			listenerObject.method = null;
			_listenerObjectPool[_listenerObjectPool.length] = listenerObject;
		}
		
		public function get valueClasses ( ):Array { return _valueClasses; }
		public function set valueClasses ( value:Array ):void {
			_valueClasses = value;
		}
		
		public function get numListeners ( ):uint { return _numListeners; }
		
	}

}