package fritz3.state {
	import org.osflash.signals.IDispatcher;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	/**
	 * [Description]
	 * 
	 * @author Dario Gieselaar
	 * @review 
	 * @copyright Frontier Information Technologies BV
	 * @package casper.system
	 */
	
	public class SingleState implements IValueState {
		
		protected var _id:String;
		protected var _value:*;
		protected var _ignoreEqualValue:Boolean = true;
		
		protected var _onChange:IDispatcher;
		
		public var data:Object;
		
		public function SingleState ( id:String ) {
			_id = id;
			_onChange = new Signal();
			super();
		}
		
		public function get value ( ):* { return _value; }
		public function set value ( value:* ):void {
			if (_ignoreEqualValue && value == _value) return;
			var oldValue:* = _value;
			_value = value;
			_onChange.dispatch(this, oldValue, value);
		}
		
		public function get id ( ):String { return _id; }
		
		public function get ignoreEqualValue ( ):Boolean { return _ignoreEqualValue; }
		public function set ignoreEqualValue ( value:Boolean ):void { 
			_ignoreEqualValue = value;
		}
		
		public function get onChange ( ):ISignal { return ISignal(_onChange); }
		
	}
	
}