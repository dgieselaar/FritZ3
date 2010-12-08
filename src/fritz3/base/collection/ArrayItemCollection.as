package fritz3.base.collection {
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class ArrayItemCollection implements ItemCollection {
		
		protected var _items:Array;
		protected var _numItems:int;
		protected var _indexes:Dictionary;
		
		public function ArrayItemCollection ( ) {
			_items = [];
			_indexes = new Dictionary();
		}
		
		final public function add ( item:Object ):Object {
			_indexes[item] = _numItems;
			_items[_numItems] = item;
			_numItems++;
			return item;
		}
		
		final public function remove ( item:Object ):Object {
			var index:int = _indexes[item];
			_items.splice(index, 1);
			_numItems--;
			delete _indexes[item];
			for (var i:int = index, l:int = _numItems; i < l; ++i) {
				_indexes[_items[i]]--;
			}
			return item;
		}
		
		final public function addItemAt ( item:Object, index:uint ):Object {
			var afterIndex:Array = _items.splice(index);
			_items[_items.length] = item;
			_items = _items.concat(afterIndex);
			_indexes[item] = index;
			return item;
		}
		
		final public function removeItemAt ( index:int ):Object {
			var item:Object = _items[index];
			this.remove(item);
			return item;
		}
		
		final public function getItemAt ( index:int ):Object {
			return _items[index];
		}
		
		final public function moveItemTo ( item:Object, index:uint ):Object {
			var afterIndex:Array = _items.splice(index);
			_items[index] = item;
			_items = _items.concat(afterIndex);
			_indexes[item] = index;
			return item;
		}
		
		final public function getItemIndex ( item:Object ):int {
			return _indexes[item] != undefined ? _indexes[item] : -1;
		}
		
		final public function hasItem ( item:Object ):Object{
			return _indexes[item] !== undefined;
		}
		
		final public function get numItems ( ):uint {
			return _numItems;
		}
		
		final public function getItems ( ):Array { return _items; }
		
	}

}