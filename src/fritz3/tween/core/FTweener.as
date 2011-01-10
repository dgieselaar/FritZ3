package fritz3.tween.core {
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import fritz3.base.transition.TransitionData;
	import fritz3.base.transition.TransitionType;
	import fritz3.invalidation.InvalidationData;
	import fritz3.invalidation.InvalidationHelper;
	import fritz3.tween.plugins.FTweenPlugin;
	import fritz3.tween.plugins.numeric.NumericTweenPlugin;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class FTweener {
		
		protected static var _tweenObjectPool:Array;
		
		protected static var _time:Number;
		protected static var _lastMeasure:Number;
		
		protected static var _firstNode:FTween;
		protected static var _lastNode:FTween;
		
		protected static var _tweens:Dictionary;
		
		protected static var _plugins:Object;
		
		protected static var _numericPlugin:NumericTweenPlugin;
		
		{
			_tweenObjectPool = [];
			_time = 0;
			_lastMeasure = getTimer();
			
			_tweens = new Dictionary();
			
			_plugins = { };
			
			_numericPlugin = new NumericTweenPlugin();
		}
		
		public function FTweener ( ) {
			
		}
		
		public static function render ( ):void {
			var newMeasure:Number = getTimer();
			var delta:Number = (newMeasure - _lastMeasure) / 1000;
			
			_lastMeasure = newMeasure;
			var node:FTween = _firstNode, nextNode:FTween;
			var time:Number, newTime:Number, delay:Number, duration:Number, total:Number, ratio:Number, phase:int;
			var start:Boolean, complete:Boolean;
			renderloop:while (node) {
				time = node.time;
				delay = node.delay;
				duration = node.duration;
				newTime = time + delta;
				total = delay + duration;
				phase = node.phase;
				start = phase < FTweenPhase.STARTED && time-delay >= 0;
				if (newTime >= total) {
					newTime = total;
				}
				complete = newTime == total;
				node.time = newTime;
				
				nextNode = node.nextNode;
				
				if (start) {
					if (node.from == undefined) {
						node.from = node.target[node.propertyName];
					}
					node.phase = FTweenPhase.STARTED;
					if (!node.plugin.onStart(node)) {
						removeTween(node.target, node.propertyName);
						node = nextNode;
						continue renderloop;
					}
				}
				
				if (newTime >= delay) {
					ratio = node.ease(newTime-delay, 0, 1, duration);
					node.plugin.render(node, ratio);
				}
				
				if (complete) {
					node.phase = FTweenPhase.COMPLETED;
					node.plugin.onComplete(node);
					removeTween(node.target, node.propertyName);
				}
				
				node = nextNode;
			}
		}
		
		public static function tween ( target:Object, propertyName:String, transitionData:TransitionData ):FTween {
			var tween:FTween = getTweenObject();
			(_tweens[target] ||= { } )[propertyName] = tween;
			tween.target = target;
			tween.propertyName = propertyName;
			tween.ease = transitionData.ease;
			tween.delay = transitionData.delay;
			tween.duration = transitionData.duration;
			tween.phase = FTweenPhase.INITIALIZED;
			
			if (transitionData.type == TransitionType.FROM) {
				tween.from = transitionData.value;
			} else {
				tween.to = transitionData.value;
			}
			if (_plugins[propertyName]) {
				tween.plugin = FTweenPlugin(_plugins[propertyName]);
			} else {
				tween.plugin = _numericPlugin;
			}
			tween.time = 0;
			
			if (_lastNode) {
				_lastNode.nextNode = tween;
				tween.prevNode = _lastNode;
			} else {
				_lastNode = _firstNode = tween;
			}
			
			_lastNode = tween;
			return tween;
		}
		
		protected static function getTweenObject ( ):FTween {
			return _tweenObjectPool.shift() || new FTween();
		}
		
		public static function getTween ( target:Object, propertyName:String ):FTween {
			return _tweens[target] ? _tweens[target][propertyName] : null;
		}
		
		public static function hasTween ( target:Object, propertyName:String ):Boolean {
			return Boolean(FTweener.getTween(target, propertyName));
		}
		
		public static function removeTween ( target:Object, propertyName:String ):void {
			var tween:FTween = FTweener.getTween(target, propertyName);
			tween.plugin.onRemove(tween);
			var nextNode:FTween = tween.nextNode, prevNode:FTween = tween.prevNode;
			if (prevNode) {
				prevNode.nextNode = nextNode;
			}
			if (nextNode) { 
				nextNode.prevNode = prevNode;
			}
			if (_firstNode == tween) {
				_firstNode = nextNode;
			}
			if (_lastNode == tween) {
				_lastNode = prevNode;
			}
			
			tween.prevNode = tween.nextNode = null;
			delete _tweens[target][propertyName];
			tween.invalidate();
			_tweenObjectPool[_tweenObjectPool.length] = tween;
		}
		
		public static function addPlugin ( propertyNames:Array, tweenPlugin:FTweenPlugin ):void {
			for each(var propertyName:String in propertyNames) {
				_plugins[propertyName] = tweenPlugin;
			}
		}
		
		public static function getPlugin ( propertyName:String ):FTweenPlugin {
			return _plugins[propertyName];
		}
		
		public static function removePlugin ( propertyName:String, tweenPlugin:FTweenPlugin ):void {
			delete _plugins[propertyName];
		}
		
	}

}