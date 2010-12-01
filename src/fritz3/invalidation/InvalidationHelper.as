package fritz3.invalidation {
	import flash.utils.Dictionary;
	import org.osflash.signals.IDispatcher;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class InvalidationHelper implements Invalidatable {
		
		protected var _data:InvalidationData;
		protected var _methods:Dictionary;
		protected var _priority:int;
		
		public function InvalidationHelper ( ) {
			this.initialize();	
		}
		
		protected function initialize ( ):void {
			_data = new InvalidationData();
			_data.priority = _priority;
			_methods = new Dictionary();
		}
		
		protected function setPriority ( newPriority:int ):void {
			var marked:Boolean;
			if (_data.marked) {
				InvalidationManager.unmarkAsInvalidated(_data);
				marked = true;
			}
			_data.priority = _priority = newPriority;
			if (marked) {
				InvalidationManager.markAsInvalidated(_data);
			}
		}
		
		public function append ( method:Function ):void {
			var invalidatableMethod:InvalidatableMethod = this.getInvalidatableMethod(method);
			
			this.remove(method);
			var lastMethod:InvalidatableMethod = _data.lastMethod;
			
			if (!lastMethod) {
				_data.firstMethod = _data.lastMethod = invalidatableMethod;
			} else {
				lastMethod.nextNode = invalidatableMethod;
				invalidatableMethod.prevNode = lastMethod;
				_data.lastMethod = invalidatableMethod;
			}
		}
		
		public function prepend ( method:Function ):void {
			var invalidatableMethod:InvalidatableMethod = this.getInvalidatableMethod(method);
			
			this.remove(method);
			
			var firstMethod:InvalidatableMethod = _data.firstMethod;
			
			if (!firstMethod) {
				_data.firstMethod = _data.lastMethod = invalidatableMethod;
			} else {
				firstMethod.prevNode = invalidatableMethod;
				invalidatableMethod.nextNode = firstMethod;
			}
			
			_data.firstMethod = invalidatableMethod;
		}
		
		public function insertBefore ( method:Function, target:Function ):void {
			
			var invalidatableMethod:InvalidatableMethod = this.getInvalidatableMethod(method);
			var targetMethod:InvalidatableMethod = this.getInvalidatableMethod(target);
			
			this.remove(method);
			
			var prevNode:InvalidatableMethod = targetMethod.prevNode;
			if (prevNode) {
				invalidatableMethod.prevNode = prevNode;
				prevNode.nextNode = invalidatableMethod;
			} else {
				_data.firstMethod = invalidatableMethod;
			}
			
			targetMethod.prevNode = invalidatableMethod;
			invalidatableMethod.nextNode = targetMethod;
		}
		
		public function insertAfter ( method:Function, target:Function ):void {
			
			var invalidatableMethod:InvalidatableMethod = this.getInvalidatableMethod(method);
			var targetMethod:InvalidatableMethod = this.getInvalidatableMethod(target);
			
			this.remove(method);
			
			var nextNode:InvalidatableMethod = targetMethod.nextNode;
			if (nextNode) {
				nextNode.prevNode = invalidatableMethod;
				invalidatableMethod.nextNode = nextNode;
			} else {
				_data.lastMethod = invalidatableMethod;
			}
			
			targetMethod.nextNode = invalidatableMethod;
			invalidatableMethod.prevNode = targetMethod;
			
		}
		
		public function remove ( method:Function ):void {
			var invalidatableMethod:InvalidatableMethod = this.getInvalidatableMethod(method);
			var nextNode:InvalidatableMethod = invalidatableMethod.nextNode, prevNode:InvalidatableMethod = invalidatableMethod.prevNode;
			if (nextNode) {
				nextNode.prevNode = prevNode;
			} 
			
			if(_data.lastMethod == invalidatableMethod) {
				_data.lastMethod = prevNode;
			} 
			
			
			if (prevNode) {
				prevNode.nextNode = nextNode;
			} 
			
			if(_data.firstMethod == invalidatableMethod) {
				_data.firstMethod = nextNode;
			}
			
			invalidatableMethod.prevNode = invalidatableMethod.nextNode = null;
		}
		
		public function invalidateMethod ( method:Function ):void {
			this.getInvalidatableMethod(method).invalidated = true;
			if (!_data.marked) {
				InvalidationManager.markAsInvalidated(_data);
			}
		}
		
		public function executeInvalidatedMethods ( ):void {
			var method:InvalidatableMethod;
			method = _data.firstMethod;
			while (method) {
				method.execute();
				method = method.nextNode;
			}
			InvalidationManager.unmarkAsInvalidated(_data);
		}
		
		public function isInvalidated ( method:Function ):Boolean {
			return this.getInvalidatableMethod(method).invalidated;
		}		
		
		public function setMethodArguments ( method:Function, args:Array ):void{
			this.getInvalidatableMethod(method).args = args;
		}
		
		public function getMethodArguments ( method:Function ):Array{
			return this.getInvalidatableMethod(method).args;
		}
		
		protected function getInvalidatableMethod ( method:Function ):InvalidatableMethod {
			if (!_methods[method]) {
				this.createInvalidatableMethod(method);
			}
			return _methods[method];
		}
		
		protected function createInvalidatableMethod ( method:Function ):void {
			var invalidatableMethod:InvalidatableMethod = new InvalidatableMethod(method);
			_methods[method] = invalidatableMethod;
			this.append(method);
		}
		
		public function get priority ( ):int { return _priority; }
		public function set priority ( value:int ):void {
			if (_priority != value) {
				this.setPriority(value);
			}
		}
		
	}

}