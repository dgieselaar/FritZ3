package fritz3.display.core {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import fritz3.base.collection.ArrayItemCollection;
	import fritz3.base.collection.ItemCollection;
	import fritz3.display.graphics.Background;
	import fritz3.display.graphics.BoxBackground;
	import fritz3.invalidation.Invalidatable;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class DisplayComponentContainer extends InvalidatableDisplayComponent implements ItemCollection {
		
		protected var _displayList:DisplayObjectContainer;
		protected var _collection:ItemCollection;
		protected var _background:Background;
		
		public function DisplayComponentContainer ( parameters:Object = null ) {
			super();
		}
		
		override protected function initializeDependencies ( ):void {
			if (!_displayList) {
				_displayList = this.createDisplayObjectContainer();
			}
			if (!_collection) {
				_collection = this.createItemCollection();
			}
			if (!_background) {
				_background = this.createBackground();
			}
		}
		
		protected function createDisplayObjectContainer ( ):DisplayObjectContainer {
			return this;
		}
		
		protected function createItemCollection ( ):ItemCollection {
			return new ArrayItemCollection();
		}
		
		protected function createBackground ( ):Background {
			return new BoxBackground();
		}
		
		/*
		 * Implementation of Backgroun
		 */
		
		public function draw ( target:DisplayObject ):void {
			
		}
		
		/*
		 * Implementation of ItemCollection
		 */
		
		public function add ( item:Object ):Object {
			
			if (item is Invalidatable) {
				this.addInvalidatable(Invalidatable(item));
			}
			
			_collection.add(item);
			
			return item;
		}
		
		public function remove ( item:Object ):Object {
			
			if (item is Invalidatable) {
				this.removeInvalidatable(Invalidatable(item));
			}
			
			_collection.remove(item);
			
			return item;
		}
		
		public function addItemAt ( item:Object, index:uint ):Object{
			this.add(item);
			return this.moveItemTo(item, index);
		}
		
		public function removeItemAt ( index:int ):Object{
			var item:Object = this.getItemAt(index);
			return this.remove(item);
		}
		
		public function getItemAt ( index:int ):Object{
			return _collection.getItemAt(index);
		}
		
		public function moveItemTo ( item:Object, index:uint ):Object{
			return _collection.moveItemTo(item, index);
		}
		
		public function getItemIndex ( item:Object ):int {
			return _collection.getItemIndex(item);
		}
		
		public function hasItem ( item:Object ):Object{
			return _collection.hasItem(item);
		}
		
		public function get numItems ( ):uint {
			return _collection.numItems;
		}
		
		protected function addInvalidatable ( invalidatable:Invalidatable ):void { 
			
		}
		
		protected function removeInvalidatable ( invalidatable:Invalidatable ):void {
			
		}
		
		protected function addDisplayObject ( displayObject:DisplayObject ):void {
			
		}
		
		protected function removeDisplayObject ( displayObject:DisplayObject ):void {
			
		}
		
		protected function addAddable ( addable:Addable ):void {
			
		}
		
		protected function removeAddable ( addable:Addable ):void {
			
		}
		
	}

}