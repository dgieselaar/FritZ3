package fritz3.display.core {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import fritz3.base.collection.ArrayItemCollection;
	import fritz3.base.collection.ItemCollection;
	import fritz3.display.graphics.Background;
	import fritz3.display.graphics.BoxBackground;
	import fritz3.display.graphics.Drawable;
	import fritz3.display.graphics.parser.side.SideData;
	import fritz3.display.graphics.parser.side.SideParser;
	import fritz3.display.graphics.RectangularBackground;
	import fritz3.display.layout.flexiblebox.FlexibleBoxLayout;
	import fritz3.display.layout.InvalidatablePositionable;
	import fritz3.display.layout.Layout;
	import fritz3.display.layout.Rearrangable;
	import fritz3.display.layout.RectangularLayout;
	import fritz3.invalidation.Invalidatable;
	import fritz3.invalidation.InvalidationHelper;
	import fritz3.invalidation.InvalidationPriorityTreshold;
	import fritz3.style.PropertyParser;
	import fritz3.utils.signals.MonoSignal;
	import org.osflash.signals.IDispatcher;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class DisplayComponentContainer extends PositionableDisplayComponent implements ItemCollection, Drawable, Rearrangable, InvalidatablePositionable {
		
		protected var _childInvalidationHelper:InvalidationHelper;
		protected var _displayList:DisplayObjectContainer;
		protected var _collection:ItemCollection;
		protected var _background:Background;
		protected var _layout:Layout;
		
		protected var _backgroundShape:Shape;
		
		protected var _useScrollRect:Boolean;
		protected var _scrollRect:Rectangle;
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		protected var _measuredWidth:Number = 0;
		protected var _measuredHeight:Number = 0;
		
		protected var _autoWidth:Boolean = true;
		protected var _autoHeight:Boolean = true;
		
		protected var _padding:Number = 0;
		protected var _paddingLeft:Number = 0;
		protected var _paddingTop:Number = 0;
		protected var _paddingRight:Number = 0;
		protected var _paddingBottom:Number = 0;
		
		public function DisplayComponentContainer ( parameters:Object = null ) {
			super(parameters);
		}
		
		override protected function initializeDependencies ( ):void {
			super.initializeDependencies();
			this.initializeDisplayContainer();
			this.initializeItemCollection();
			this.initializeBackground();
			this.initializeLayout();
		}
		
		override protected function setInvalidationMethodOrder ( ):void {
			super.setInvalidationMethodOrder();
			_invalidationHelper.insertBefore(this.rearrange, this.dispatchDisplayInvalidation);
			_invalidationHelper.insertAfter(this.measureDimensions, this.rearrange);
			_invalidationHelper.insertAfter(this.draw, this.measureDimensions);
			_childInvalidationHelper.append(this.invalidateChildStates);
		}
		
		override protected function initializeInvalidation():void {
			super.initializeInvalidation();
			_childInvalidationHelper = new InvalidationHelper();
			this.setPriority(InvalidationPriorityTreshold.DISPLAY_INVALIDATION);
		}
		
		protected function initializeDisplayContainer ( ):void {
			this.displayList = new Sprite();
		}
		
		protected function initializeItemCollection ( ):void {
			this.collection = new ArrayItemCollection();
		}
		
		protected function initializeBackground ( ):void {
			_backgroundShape = new Shape();
			_backgroundShape.cacheAsBitmap = true;
			this.addChildAt(_backgroundShape, 0);
			var background:BoxBackground = new BoxBackground();
			this.background = background;
		}
		
		protected function initializeLayout ( ):void {
			this.layout = new FlexibleBoxLayout();
		}
		
		override protected function setParsers():void {
			super.setParsers();
			this.addParser("padding", SideParser.parser);
		}
		
		override public function setProperty(propertyName:String, value:*, parameters:Object = null):void {
			switch(propertyName) {
				default:
				super.setProperty(propertyName, value, parameters);
				break;
				
				case "width":
				if (value == "auto") {
					this.autoWidth = true;
				} else {
					this.autoWidth = false;
					super.setProperty(propertyName, value, parameters);
				}
				break;
				
				case "height":
				if (value == "auto") {
					this.autoHeight = true;
				} else {
					this.autoHeight = false;
					super.setProperty(propertyName, value, parameters);
				}
				break;
				
				case "padding":
				this.parsePadding(propertyName, value, parameters);
				break;
			}
		}
		
		protected function parsePadding ( propertyName:String, value:String, parameters:Object = null ):void {
			var parser:PropertyParser = this.getParser("padding");
			if (parser) {
				var sideData:SideData = SideData(parser.parseValue(value));
				if (!isNaN(sideData.all)) {
					this.applyProperty("padding", sideData.all, parameters);
				} else {
					this.applyProperty("paddingLeft", sideData.first, parameters);
					this.applyProperty("paddingTop", sideData.second, parameters);
					this.applyProperty("paddingRight", sideData.third, parameters);
					this.applyProperty("paddingBottom", sideData.fourth, parameters);
				}
			}
		}
		
		protected function setDisplayList ( displayList:DisplayObjectContainer ):void {
			if (_displayList && _displayList != this) {
				this.removeChild(_displayList);
			}
			_displayList = displayList;
			if (_displayList && _displayList != this) {
				if (_backgroundShape) {
					this.addChildAt(_displayList, 1);
				} else {
					this.addChildAt(_displayList, 0);
				}
			}
		}
		
		protected function setCollection ( collection:ItemCollection ):void {
			if (_collection && collection) {
				for (var i:int, l:int = _collection.numItems; i < l; ++i) {
					collection.add(_collection.removeItemAt(0));
				}
			} else if (_collection) {
				while (_collection.numItems) { 
					_collection.removeItemAt(0);
				}
			}
			
			_collection = collection;
		}
		
		protected function setBackground ( background:Background ):void {
			if (_background) {
				_background.drawable = null;
			}
			_background = background;
			if (_background) {
				_background.drawable = this;
			}
		}
		
		protected function setLayout ( layout:Layout ):void {
			if (_layout) {
				_layout.rearrangable = null;
			}
			_layout = layout;
			if (_layout) {
				_layout.rearrangable = this;
				if (_layout is RectangularLayout) {
					var rectLayout:RectangularLayout = RectangularLayout(_layout);
					rectLayout.autoWidth = _autoWidth;
					rectLayout.autoHeight = _autoHeight;
					if (!_autoWidth) {
						rectLayout.width = _width;
					}
					if (!_autoHeight) {
						rectLayout.height = _height;
					}
				
				}
			}
		}
		
		protected function draw ( ):void {
			if (_backgroundShape) {
				_background.draw(_backgroundShape);
			} else {
				_background.draw(this);
			}
		}
		
		protected function rearrange ( ):void {
			if (_layout) {
				_layout.rearrange(this, _collection.getItems());
			}
		}
		
		protected function measureDimensions ( ):void {
			if (_layout && _layout is FlexibleBoxLayout) {
				var layout:FlexibleBoxLayout = FlexibleBoxLayout(layout);
				_measuredWidth = layout.measuredWidth, _measuredHeight = layout.measuredHeight;
			} else {
				if (_useScrollRect) {
					var bounds:Rectangle = this.displayList.transform.pixelBounds;
				_measuredWidth = bounds.width + _paddingLeft + _paddingRight, _measuredHeight = bounds.height + _paddingTop + _paddingBottom;
				} else {
					_measuredWidth = _displayList.width + _paddingLeft + _paddingRight, _measuredHeight = _displayList.height + _paddingTop + _paddingBottom;
				}
			}
			
			if (_autoWidth) {
				var width:Number = _measuredWidth;
				if (!isNaN(_minimumWidth)) {
					width = Math.max(_minimumWidth, width);
				}
				if (!isNaN(_maximumWidth)) {
					width = Math.min(_maximumWidth, width);
				}
				if (width != _width) {
					_width = width;
					this.invalidateDisplay();
					this.applyScrollRect();
					this.setDependenciesWidth();
				}
			}
			
			if (_autoHeight) {
				var height:Number = _measuredHeight;
				if (!isNaN(_minimumHeight)) {
					height = Math.max(_minimumHeight, width);
				}
				if (!isNaN(_maximumHeight)) {
					height = Math.min(_maximumHeight, height);
				}
				if (height != _height) {
					_height = height;
					this.invalidateDisplay();
					this.applyScrollRect();
					this.setDependenciesHeight();
				}
			}
		}
		
		protected function invalidateChildStates ( ):void {
			var items:Array = _collection.getItems();
			var item:InvalidatableDisplayChild;
			for (var i:int, l:int = items.length; i < l; ++i) {
				item = items[i] as InvalidatableDisplayChild;
				if (item) {
					item.invalidateChildState();
				}
			}
		}
		
		protected function applyWidth ( ):void {
			this.applyScrollRect();
			this.invalidateDisplay();
			this.setDependenciesWidth();
		}
		
		protected function applyHeight ( ):void {
			this.applyScrollRect();
			this.invalidateDisplay();
			this.setDependenciesHeight();
		}
		
		override protected function applyMinimumWidth ( ):void {
			if (!isNaN(_minimumWidth)) {
				this.width = Math.max(_minimumWidth, _width);
			}
		}
		
		override protected function applyMaximumWidth ( ):void {
			if (!isNaN(_maximumWidth)) {
				this.width = Math.min(_maximumWidth, _width);
			}
		}
		
		override protected function applyMinimumHeight ( ):void {
			if (!isNaN(_minimumHeight)) {
				this.height = Math.max(_minimumHeight, _height);
			}
		}
		
		override protected function applyMaximumHeight ( ):void {
			if (!isNaN(_maximumHeight)) {
				this.height = Math.min(_maximumHeight, _height);
			}
		}
		
		protected function applyAutoWidth ( ):void {
			if (_autoWidth) {
				var width:Number = _measuredWidth;
				if (!isNaN(_minimumWidth)) {
					width = Math.max(_minimumWidth, width);
				}
				if (!isNaN(_maximumWidth)) {
					width = Math.min(_maximumWidth, width);
				}
				this.width = width;
			}
			
			this.setDependenciesWidth();
		}
		
		protected function applyAutoHeight ( ):void {
			if (_autoHeight) {
				var height:Number = _measuredHeight;
				if (!isNaN(_minimumHeight)) {
					height = Math.max(_minimumHeight, height);
				}
				if (!isNaN(_maximumHeight)) {
					height = Math.min(_maximumHeight, height);
				}
				this.height = height;
			}
			
			this.setDependenciesHeight();
		}
		
		protected function applyScrollRect ( ):void {
			if (_useScrollRect) {
				if (_scrollRect) {
				_scrollRect = new Rectangle();
				}
				_scrollRect.width = _width, _scrollRect.height = _height;
			} else {
				_scrollRect = null;
			}
			this.displayList.scrollRect = _scrollRect;
		}
		
		protected function applyPadding ( ):void {
			if (_layout && _layout is FlexibleBoxLayout) {
				var layout:FlexibleBoxLayout = FlexibleBoxLayout(_layout);
				layout.padding = _padding;
				layout.paddingLeft = _paddingLeft;
				layout.paddingTop = _paddingTop;
				layout.paddingRight = _paddingRight;
				layout.paddingBottom = _paddingBottom;
			}
			_invalidationHelper.invalidateMethod(this.measureDimensions);
		}
		
		protected function setDependenciesWidth ( ):void {
			if (_layout && _layout is RectangularLayout) { 
				var layout:RectangularLayout = RectangularLayout(_layout);
				layout.autoWidth = _autoWidth;
				if (!_autoWidth) {
					layout.width = _width;
				}
			}
			if (_background && _background is RectangularBackground) {
				var background:RectangularBackground = RectangularBackground(_background);
				background.width = _width;
			}
		}
		
		protected function setDependenciesHeight ( ):void {
			if (_layout && _layout is RectangularLayout) { 
				var layout:RectangularLayout = RectangularLayout(_layout);
				layout.autoHeight = _autoHeight;
				if (!_autoHeight) {
					layout.height = _height;
				}
			}
			if (_background && _background is RectangularBackground) {
				var background:RectangularBackground = RectangularBackground(_background);
				background.height = _height;
			}
		}
		
		override protected function setPriority ( value:int ):void {
			super.setPriority(value);
			_childInvalidationHelper.priority = InvalidationPriorityTreshold.CHILD_DISPLAY_INVALIDATION - value;
		}
				
		public function add ( item:Object ):Object {
			
			if (item is Invalidatable) {
				this.addInvalidatable(Invalidatable(item));
			}
			
			if (item is Addable) {
				this.addAddable(Addable(item));
			}
			
			if (item is InvalidatablePositionable) {
				this.addInvalidatablePositionable(InvalidatablePositionable(item));
			}
			
			if (item is DisplayObject) {
				this.addDisplayObject(DisplayObject(item));
			}
			
			_collection.add(item);
			
			this.invalidateChildren();
			this.invalidateLayout();
			
			return item;
		}
		
		public function remove ( item:Object ):Object {
			
			if (item is DisplayObject) {
				this.removeDisplayObject(DisplayObject(item));
			}
			
			if (item is InvalidatablePositionable) {
				this.removeInvalidatablePositionable(InvalidatablePositionable(item));
			}
			
			if (item is Addable) {
				this.removeAddable(Addable(item));
			}
			
			if (item is Invalidatable) {
				this.removeInvalidatable(Invalidatable(item));
			}
			
			_collection.remove(item);
			
			this.invalidateChildren();
			this.invalidateLayout();
			
			return item;
		}
		
		public function addItemAt ( item:Object, index:uint ):Object{
			this.add(item);
			item = this.moveItemTo(item, index);
			return item;
		}
		
		public function removeItemAt ( index:int ):Object{
			var item:Object = this.getItemAt(index);
			item = this.remove(item);
			return item;
		}
		
		public function getItemAt ( index:int ):Object{
			return _collection.getItemAt(index);
		}
		
		public function moveItemTo ( item:Object, index:uint ):Object{
			var item:Object = _collection.moveItemTo(item, index);
			this.invalidateChildren();
			this.invalidateLayout();
			return item;
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
		
		public function getItems ( ):Array {
			return _collection.getItems();
		}
		
		protected function addInvalidatable ( invalidatable:Invalidatable ):void { 
			invalidatable.priority = this.priority + 1;
		}
		
		protected function removeInvalidatable ( invalidatable:Invalidatable ):void {
			invalidatable.priority = 0;
		}
		
		protected function addAddable ( addable:Addable ):void {
			addable.parentComponent = this;
			addable.onAdd();
		}
		
		protected function removeAddable ( addable:Addable ):void {
			addable.onRemove();
			addable.parentComponent = null;
		}
		
		protected function addInvalidatablePositionable ( invalidatablePositionable:InvalidatablePositionable ):void {
			invalidatablePositionable.onDisplayInvalidation.add(this.onChildDisplayInvalidation);
		}
		
		protected function removeInvalidatablePositionable ( invalidatablePositionable:InvalidatablePositionable ):void {
			invalidatablePositionable.onDisplayInvalidation.remove(this.onChildDisplayInvalidation);
		}
		
		protected function addDisplayObject ( displayObject:DisplayObject ):void {
			_displayList.addChild(displayObject);
		}
		
		protected function removeDisplayObject ( displayObject:DisplayObject ):void {
			_displayList.removeChild(displayObject);
		}
		
		protected function invalidateChildren ( ):void {
			_childInvalidationHelper.invalidateMethod(this.invalidateChildStates);
		}
		
		protected function onChildDisplayInvalidation ( child:InvalidatablePositionable ):void {
			this.invalidateLayout();
		}
		
		public function invalidateGraphics ( ):void {
			_invalidationHelper.invalidateMethod(this.draw);
		}
		
		public function invalidateLayout ( ):void {
			_invalidationHelper.invalidateMethod(this.rearrange);
			_invalidationHelper.invalidateMethod(this.measureDimensions);
		}
		
		public function get displayList ( ):DisplayObjectContainer { return _displayList; }
		public function set displayList ( value:DisplayObjectContainer ):void {
			if (_displayList != value) {
				this.setDisplayList(value);
			}
		}
		
		public function get background ( ):Background { return _background; }
		public function set background ( value:Background ):void {
			if (_background != value) {
				this.setBackground(value);
			}
		}
		
		public function get collection ( ):ItemCollection { return _collection; }
		public function set collection ( value:ItemCollection ):void {
			if (_collection != value) {
				this.setCollection(value);
			}
		}
		
		override public function get width ( ):Number { return _width; }
		override public function set width ( value:Number ):void {
			if (_width != value) {
				_width = value;
				this.applyWidth();
			}
		}
		
		override public function get height ( ):Number { return _height; }
		override public function set height ( value:Number ):void {
			if (_height != value) {
				_height = value;
				this.applyHeight();
			}
		}
		
		public function get autoWidth ( ):Boolean { return _autoWidth; }
		public function set autoWidth ( value:Boolean ):void {
			if (_autoWidth != value) {
				_autoWidth = value;
				this.applyAutoWidth();
			}
		}
		
		public function get autoHeight ( ):Boolean { return _autoHeight; }
		public function set autoHeight ( value:Boolean ):void {
			if (_autoHeight != value) {
				_autoHeight = value;
				this.applyAutoHeight();
			}
		}
		
		public function get useScrollRect ( ):Boolean { return _useScrollRect; }
		public function set useScrollRect ( value:Boolean ):void {
			if (_useScrollRect != value) {
				_useScrollRect = value;
				this.applyScrollRect();
			}
		}
		
		public function get layout ( ):Layout { return _layout; }
		public function set layout ( value:Layout ):void {
			if(_layout != value) {
				this.setLayout(value);
			}
		}
		
		public function get padding ( ):Number { return _padding; }
		public function set padding ( value:Number ):void {
			_padding = value;
			this.paddingLeft = this.paddingTop = this.paddingRight = this.paddingBottom = value;
		}
		
		public function get paddingLeft ( ):Number { return _paddingLeft; }
		public function set paddingLeft ( value:Number ):void {
			if (_paddingLeft != value) {
				_paddingLeft = value;
				this.applyPadding();
			}
		}
		
		public function get paddingTop ( ):Number { return _paddingTop; }
		public function set paddingTop ( value:Number ):void {
			if (_paddingTop != value) {
				_paddingTop = value;
				this.applyPadding();
			}
		}
		
		public function get paddingRight ( ):Number { return _paddingRight; }
		public function set paddingRight ( value:Number ):void {
			if (_paddingRight != value) {
				_paddingRight = value;
				this.applyPadding();
			}
		}
		
		public function get paddingBottom ( ):Number { return _paddingBottom; }
		public function set paddingBottom ( value:Number ):void {
			if (_paddingBottom != value) {
				_paddingBottom = value;
				this.applyPadding();
			}
		}
		
	}

}