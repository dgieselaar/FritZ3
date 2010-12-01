package fritz3.base.collection {
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class ArrayItemCollection implements ItemCollection {
		
		private var _items:Array;
		private var _numItems:int;
		
		public function ArrayItemCollection ( ) {
			_items = [];
		}
		
		final public function add ( item:Object ):Object {
			_items[_numItems++] = item;
			return item;
		}
		
		final public function remove ( item:Object ):Object {
			_items.splice(_items[item], 1);
			_numItems--;
			return item;
		}
		
		final public function addItemAt ( item:Object, index:uint ):Object {
			var afterIndex:Array = _items.splice(index);
			_items[_items.length] = item;
			_items = _items.concat(afterIndex);
			return item;
		}
		
		final public function removeItemAt ( index:int ):Object {
			var item:Object = this.getItemAt(index);
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
			return item;
		}
		
		final public function hasItem ( item:Object ):Object{
			return _items.indexOf(item) != -1;
		}
		
		final public function get numItems ( ):uint {
			return _numItems;
		}
		
	}

}