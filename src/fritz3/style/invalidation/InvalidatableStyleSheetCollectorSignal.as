package fritz3.style.invalidation  {
	import flash.utils.Dictionary;
	import fritz3.style.IStylable;
	import fritz3.style.IStyleSheetCollector;
	import org.osflash.signals.IDispatcher;
	/**

	/**
	 * @author Dario Gieselaar
	 * @review 
	 * @copyright Frontier Information Technologies BV
	 * @package fritz3.style.invalidation
	 * 
	 * [Description]
	*/
	
	public class InvalidatableStyleSheetCollectorSignal implements IDispatcher {
		
		protected static var _nodeObjectPool:Array = [];
		
		protected var _firstNode:StyleSheetCollectorNode;
		protected var _lastNode:StyleSheetCollectorNode;
		
		protected var _nextNode:StyleSheetCollectorNode;
		
		protected var _nodesByCollector:Dictionary;
		protected var _dispatching:Boolean;
		
		public function InvalidatableStyleSheetCollectorSignal (  )  {
			_nodesByCollector = new Dictionary();
		}
		
		public function add ( collector:IInvalidatableStyleSheetCollector ):void {
			var node:StyleSheetCollectorNode = getNodeObject();
			if (!_firstNode) {
				_firstNode = node;
			}
			if (_lastNode) {
				_lastNode.nextNode = node;
				node.prevNode = _lastNode;
			}
			
			node.styleSheetCollector = collector;
			
			_lastNode = node;
			
			_nodesByCollector[collector] = node;
		}
		
		public function remove ( collector:IInvalidatableStyleSheetCollector ):void {
			if (_dispatching) {
				StyleSheetCollectorNode(_nodesByCollector[collector]).remove = true;
				return;
			}
			
			var node:StyleSheetCollectorNode = _nodesByCollector[collector];
			var nextNode:StyleSheetCollectorNode = node.nextNode, prevNode:StyleSheetCollectorNode;
			if (nextNode) {
				nextNode.prevNode = prevNode;
			}
			if (prevNode) {
				prevNode.nextNode = nextNode;
			}
			
			if (node == _firstNode) {
				_firstNode = nextNode;
			}
			
			if (node == _lastNode) {
				_lastNode = prevNode;
			}
			
			node.prevNode = node.nextNode = null;
			node.remove = false;
			poolNodeObject(node);
		}
		
		protected static function getNodeObject ( ):StyleSheetCollectorNode {
			return _nodeObjectPool.length ? _nodeObjectPool.shift() : new StyleSheetCollectorNode();
		}
		
		protected static function poolNodeObject ( node:StyleSheetCollectorNode ):void {
			_nodeObjectPool[_nodeObjectPool.length] = node;
		}
		
		public function dispatch ( ...rest ):void {
			
		}
		
		
		
	}

}