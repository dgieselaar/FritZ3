package fritz3.invalidation {
	import flash.display.Stage;
	import flash.events.Event;
	import fritz3.tween.core.FTweener;
	import fritz3.utils.tween.ftween.FTweenEngine;
	import fritz3.utils.tween.Tweener;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class InvalidationManager {
		
		private static var _priorities:Array;
		private static var _firstNodeByPriority:Object;
		private static var _lastNodeByPriority:Object;
		private static var _stage:Stage;
		
		private static var _minFrameRate:Number;
		private static var _atNode:InvalidationHelper;
		
		{
			_priorities = [];
			_firstNodeByPriority = { };
			_lastNodeByPriority = { };
		}
		
		public function InvalidationManager ( ) {
			
		}
		
		public static function init ( stage:Stage ):void {
			if(!_stage) {
				_stage = stage;
				_stage.addEventListener(Event.RENDER, onRender);
				_stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, int.MAX_VALUE);
			}
		}
		
		private static function onRender ( e:Event ):void {
			executeAll();
		}
		
		private static function onEnterFrame ( e:Event ):void {
			_stage.invalidate();
		}
		
		public static function executeAll ( ):void {
			if (_minFrameRate) {
				executeWithThreading();
			} else {
				executeWithoutThreading();
			}
		}
		
		public static function executeWithThreading ( ):void {
			
		}
		
		public static function executeWithoutThreading ( first:Boolean = true ):void {
			_priorities.sort(Array.NUMERIC | Array.DESCENDING);
			var priority:int, node:InvalidationData, nextNode:InvalidationData;
			var methodNode:InvalidatableMethod, nextMethodNode:InvalidatableMethod;
			var hasExecutedNodes:Boolean;			
			
			if (first && Tweener.engine is FTweenEngine) {
				FTweener.render();
			}
			
			var i:int;
			for each(priority in _priorities) {
				node = _firstNodeByPriority[priority];
				while (node) {
					methodNode = node.firstMethod;
					while (methodNode) {
						if (methodNode.invalidated) {
							hasExecutedNodes = true;
							methodNode.execute();
						}
						methodNode = methodNode.nextNode;
					}
					node.marked = false;
					nextNode = node.nextNode;
					node.nextNode = node.prevNode = null;
					node = nextNode;
				}
				delete _firstNodeByPriority[priority];
				delete _lastNodeByPriority[priority];
			}

			
			if (hasExecutedNodes) {
				executeWithoutThreading(false);
			}
		}
		
		public static function markAsInvalidated ( data:InvalidationData ):void {
			var priority:int = data.priority;
			var lastNode:InvalidationData = _lastNodeByPriority[priority];
			if (!lastNode) {
				_firstNodeByPriority[priority] = _lastNodeByPriority[priority] = data;
				if (_priorities.indexOf(priority) == -1) {
					_priorities.push(priority);
				}
			} else {
				lastNode.nextNode = data;
				data.prevNode = lastNode;
				_lastNodeByPriority[priority] = data;
			}
			data.marked = true;
		}
		
		public static function unmarkAsInvalidated ( data:InvalidationData ):void {
			var prevNode:InvalidationData = data.prevNode, nextNode:InvalidationData = data.nextNode;
			var priority:int = data.priority;
			if (data == _firstNodeByPriority[priority]) {
				if (nextNode) {
					_firstNodeByPriority[priority] = nextNode;
				} else {
					delete _firstNodeByPriority[priority];
				}
			}
			if (data == _lastNodeByPriority[priority]) {
				if (prevNode) {
					_lastNodeByPriority[priority] = prevNode;
				} else {
					delete _lastNodeByPriority[priority];
				}
			}
			
			if (prevNode) {
				prevNode.nextNode = nextNode;
			}
			if (nextNode) {
				nextNode.prevNode = prevNode;
			}
			data.nextNode = data.prevNode = null;
			data.marked = false;
		}
		
		public static function get stage ( ):Stage { return _stage; }
		
	}

}