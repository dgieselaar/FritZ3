package fritz3.display.core {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import fritz3.base.collection.ArrayItemCollection;
	import fritz3.base.collection.ItemCollection;
	import fritz3.base.parser.PropertyParser;
	import fritz3.base.transition.TransitionData;
	import fritz3.display.graphics.Background;
	import fritz3.display.graphics.BoxBackground;
	import fritz3.display.graphics.Drawable;
	import fritz3.display.graphics.RectangularBackground;
	import fritz3.display.layout.flexiblebox.FlexibleBoxLayout;
	import fritz3.display.layout.InvalidatablePositionable;
	import fritz3.display.layout.Layout;
	import fritz3.display.layout.PaddableLayout;
	import fritz3.display.layout.Rearrangable;
	import fritz3.display.layout.RectangularLayout;
	import fritz3.display.parser.side.SideData;
	import fritz3.display.parser.side.SideParser;
	import fritz3.display.parser.size.SizeParser;
	import fritz3.invalidation.Invalidatable;
	import fritz3.invalidation.InvalidationHelper;
	import fritz3.invalidation.InvalidationPriorityTreshold;
	import fritz3.utils.signals.MonoSignal;
	import org.osflash.signals.IDispatcher;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class DisplayComponentContainer extends MeasurableDisplayComponent implements ItemCollection, Drawable, Rearrangable, InvalidatablePositionable {
		
		protected var _childInvalidationHelper:InvalidationHelper;
		protected var _displayList:DisplayObjectContainer;
		protected var _collection:ItemCollection;
		protected var _background:Background;
		protected var _layout:Layout;
		
		protected var _backgroundShape:Shape;
		
		protected var _useScrollRect:Boolean;
		protected var _scrollRect:Rectangle;
		
		protected var _padding:DisplayValue = new DisplayValue(0);
		protected var _paddingLeft:DisplayValue = new DisplayValue(0);
		protected var _paddingTop:DisplayValue = new DisplayValue(0);
		protected var _paddingRight:DisplayValue = new DisplayValue(0);
		protected var _paddingBottom:DisplayValue = new DisplayValue(0);
		
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
		
		override protected function setCyclePhase ( cyclePhase:String ):void {
			super.setCyclePhase(cyclePhase);
			if (_background && _background is Cyclable) {
				Cyclable(_background).cyclePhase = cyclePhase;
			}
			if (_layout && _layout is Cyclable) {
				Cyclable(_layout).cyclePhase = cyclePhase;
			}
		}
		
		override protected function setCycle ( cycle:int ):void {
			super.setCycle(cycle);
			if (_background && _background is Cyclable) {
				Cyclable(_background).cycle = cycle;
			}
			if (_layout && _layout is Cyclable) {
				Cyclable(_layout).cycle = cycle;
			}
		}
		
		override protected function setParsers ( ):void {
			super.setParsers();
			this.addParser("padding", SideParser.parser);
			this.addParser("paddingLeft", SizeParser.parser);
			this.addParser("paddingTop", SizeParser.parser);
			this.addParser("paddingRight", SizeParser.parser);
			this.addParser("paddingBottom", SizeParser.parser);
		}
		
		override public function parseProperty ( propertyName:String, value:* ):void {
			switch(propertyName) {
				default:
				super.parseProperty(propertyName, value);
				break;
				
				case "padding":
				this.parsePadding(propertyName, value);
				break;
				
				case "paddingLeft":
				case "paddingTop":
				case "paddingRight":
				case "paddingBottom":
				this.parseSize(propertyName, value);
				break;
			}
		}
		
		protected function parsePadding ( propertyName:String, value:String ):void {
			var parser:PropertyParser = this.getParser("padding");
			if (parser) {
				var sideData:SideData = SideData(parser.parseValue(value));
				if (sideData.all) {
					var all:DisplayValue = sideData.all;
					this.cacheParsedProperty("paddingLeft", all.clone());
					this.cacheParsedProperty("paddingTop", all.clone());
					this.cacheParsedProperty("paddingRight", all.clone());
					this.cacheParsedProperty("paddingBottom", all.clone());
				} else {
					this.cacheParsedProperty("paddingLeft", sideData.first.clone());
					this.cacheParsedProperty("paddingTop", sideData.second.clone());
					this.cacheParsedProperty("paddingRight", sideData.third.clone());
					this.cacheParsedProperty("paddingBottom", sideData.fourth.clone());
				}
			}
		}
		
		override public function setTransition(propertyName:String, transitionData:TransitionData):void {
			switch(propertyName) {
				default:
				super.setTransition(propertyName, transitionData);
				break;
				
				case "padding":
				super.setTransition("padding", transitionData);
				super.setTransition("paddingLeft", transitionData);
				super.setTransition("paddingTop", transitionData);
				super.setTransition("paddingBottom", transitionData);
				super.setTransition("paddingRight", transitionData);
				break;
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
				if (_background is Cyclable) {
					Cyclable(_background).cyclePhase = _cyclePhase;
					Cyclable(_background).cycle = _cycle;
				}
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
					var autoWidth:Boolean = _preferredWidth.valueType == DisplayValueType.AUTO, autoHeight:Boolean = _preferredHeight.valueType == DisplayValueType.AUTO;
					rectLayout.autoWidth = autoWidth;
					rectLayout.autoHeight = autoHeight;
					rectLayout.width = _width;
					rectLayout.height = _height;
				}
				this.setLayoutPadding();
				if (_layout is Cyclable) {
					Cyclable(_layout).cyclePhase = _cyclePhase;
					Cyclable(_layout).cycle = _cycle;
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
		
		override protected function getMeasuredWidth ( ):Number {
			var measuredWidth:Number;
			if (_layout && _layout is FlexibleBoxLayout) {
				var layout:FlexibleBoxLayout = FlexibleBoxLayout(layout);
				measuredWidth = layout.measuredWidth;
			} else {
				if (_useScrollRect) {
					var bounds:Rectangle = this.displayList.transform.pixelBounds;
					measuredWidth = bounds.width + _paddingLeft.getComputedValue(_width) + _paddingRight.getComputedValue(_width);
				} else {
					measuredWidth = _displayList.width + _paddingLeft.getComputedValue(_width) + _paddingRight.getComputedValue(_width);
				}
			}
			return measuredWidth;
		}
		
		override protected function getMeasuredHeight ( ):Number {
			var measuredHeight:Number;
			if (_layout && _layout is FlexibleBoxLayout) {
				var layout:FlexibleBoxLayout = FlexibleBoxLayout(layout);
				measuredHeight = layout.measuredHeight;
			} else {
				if (_useScrollRect) {
					var bounds:Rectangle = this.displayList.transform.pixelBounds;
					measuredHeight = bounds.height + _paddingTop.getComputedValue(_height) + _paddingBottom.getComputedValue(_height);
				} else {
					measuredHeight = _displayList.height + _paddingTop.getComputedValue(_height) + _paddingBottom.getComputedValue(_height);
				}
			}
			return measuredHeight;
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
		
		override protected function applyWidth ( ):void {
			super.applyWidth();
			this.applyScrollRect();
			this.setDependenciesWidth();
			this.setLayoutPadding();
		}
		
		override protected function applyHeight ( ):void {
			super.applyHeight();
			this.applyScrollRect();
			this.setDependenciesHeight();
			this.setLayoutPadding();
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
			this.setLayoutPadding();
			_invalidationHelper.invalidateMethod(this.measureDimensions);
		}
		
		protected function setLayoutPadding ( ):void {
			if (_layout && _layout is PaddableLayout) {
				var layout:PaddableLayout = PaddableLayout(_layout);
				layout.paddingLeft = _paddingLeft.getComputedValue(_width);
				layout.paddingTop = _paddingTop.getComputedValue(_height);
				layout.paddingRight = _paddingRight.getComputedValue(_width);
				layout.paddingBottom = _paddingBottom.getComputedValue(_height);
			}
		}
		
		protected function setDependenciesWidth ( ):void {
			if (_layout && _layout is RectangularLayout) { 
				var layout:RectangularLayout = RectangularLayout(_layout);
				var autoWidth:Boolean = _preferredWidth.valueType == DisplayValueType.AUTO;
				layout.autoWidth = autoWidth;
				layout.width = _width;
			}
			if (_background && _background is RectangularBackground) {
				var background:RectangularBackground = RectangularBackground(_background);
				background.width = _width;
			}
		}
		
		protected function setDependenciesHeight ( ):void {
			if (_layout && _layout is RectangularLayout) { 
				var layout:RectangularLayout = RectangularLayout(_layout);
				var autoHeight:Boolean = _preferredHeight.valueType == DisplayValueType.AUTO;
				layout.height = _height;
				layout.autoHeight = autoHeight;
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
		
		public function get padding ( ):DisplayValue { return _padding; }
		public function set padding ( value:DisplayValue ):void {
			_padding = value;
			this.paddingLeft = value.clone();
			this.paddingTop = value.clone();
			this.paddingRight = value.clone();
			this.paddingBottom = value.clone();
		}
		
		public function get paddingLeft ( ):DisplayValue { return _paddingLeft; }
		public function set paddingLeft ( value:DisplayValue ):void {
			if (_paddingLeft.invalidated || !_paddingLeft.assertEquals(value)) {
				_paddingLeft = value;
				_paddingLeft.invalidated = false;
				this.applyPadding();
			}
		}
		
		public function get paddingTop ( ):DisplayValue { return _paddingTop; }
		public function set paddingTop ( value:DisplayValue ):void {
			if (_paddingTop.invalidated || !_paddingTop.assertEquals(value)) {
				_paddingTop = value;
				_paddingTop.invalidated = false;
				this.applyPadding();
			}
		}
		
		public function get paddingRight ( ):DisplayValue { return _paddingRight; }
		public function set paddingRight ( value:DisplayValue ):void {
			if (_paddingRight.invalidated || !_paddingRight.assertEquals(value)) {
				_paddingRight = value;
				_paddingRight.invalidated = false;
				this.applyPadding();
			}
		}
		
		public function get paddingBottom ( ):DisplayValue { return _paddingBottom; }
		public function set paddingBottom ( value:DisplayValue ):void {
			if (_paddingBottom.invalidated || !_paddingBottom.assertEquals(value)) {
				_paddingBottom = value;
				_paddingBottom.invalidated = false;
				this.applyPadding();
			}
		}
	}

}