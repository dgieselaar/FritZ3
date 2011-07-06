package fritz3.state {
	import fritz3.base.FSignal;
	import org.osflash.signals.IDispatcher;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class CollectionState implements IState {
		
		private var _id:String;
		
		private var _collection:Array;
		
		protected var _onAdd:IDispatcher;
		protected var _onRemove:IDispatcher;
		protected var _onChange:IDispatcher;
		
		public function CollectionState ( id:String ) {
			_id = id;
			_collection = [];
			_onAdd = new FSignal();
			_onRemove = new FSignal();
			_onChange = new FSignal();
		}
		
		public function add ( option:Object ):void {
			var index:int = _collection.indexOf(option);
			if (index == -1) {
				_collection.push(option);
				_onAdd.dispatch(this, option);
			}
		}
		
		public function remove ( option:Object ):void {
			var index:int = _collection.indexOf(option);
			if (index != -1) {
				_collection.splice(index,1);
				_onRemove.dispatch(this, option);
			}
		}
		
		public function has ( option:Object ):Boolean {
			return _collection.indexOf(option) != -1;
		}
		
		public function get collection ( ):Array { return _collection; }
		public function get id ( ):String { return _id;  }
		
		public function get onAdd ( ):ISignal { return ISignal(_onAdd); }
		public function get onRemove ( ):ISignal { return ISignal(_onRemove); }
		public function get onChange ( ):ISignal { return ISignal(_onChange); }
		
	}

}