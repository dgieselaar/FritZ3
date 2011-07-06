package fritz3.base.collection {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class DisplayContainerCollection implements IItemCollection {
		
		private var _container:DisplayObjectContainer;
		
		public function DisplayContainerCollection ( container:DisplayObjectContainer ) {
			_container = container;
		}
		
		public function add ( item:Object ):Object {
			return _container.addChild(DisplayObject(item));
		}
		
		public function remove ( item:Object ):Object{
			return _container.removeChild(DisplayObject(item));
		}
		
		public function addItemAt ( item:Object, index:uint ):Object {
			return _container.addChildAt(DisplayObject(item), index);
		}
		
		public function removeItemAt ( index:int ):Object{
			return _container.removeChildAt(index);
		}
		
		public function getItemAt ( index:int ):Object{
			return _container.getChildAt(index);
		}
		
		public function moveItemTo ( item:Object, index:uint ):Object {
			_container.setChildIndex(DisplayObject(item), index);
			return item;
		}
		
		public function hasItem(item:Object):Object{
			return DisplayObject(item).parent == _container;
		}
		
		public function get numItems ( ):uint {
			return _container.numChildren;
		}
		
		
		
	}

}