package fritz3.display.core {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import fritz3.base.collection.ArrayItemCollection;
	import fritz3.base.collection.IItemCollection;
	import fritz3.base.parser.IPropertyParser;
	import fritz3.base.transition.TransitionData;
	import fritz3.display.graphics.IBackground;
	import fritz3.display.graphics.BoxBackground;
	import fritz3.display.graphics.IDrawable;
	import fritz3.display.graphics.IRectangularBackground;
	import fritz3.display.layout.flexiblebox.FlexibleBoxLayout;
	import fritz3.display.layout.IInvalidatablePositionable;
	import fritz3.display.layout.ILayout;
	import fritz3.display.layout.IPaddableLayout;
	import fritz3.display.layout.IRearrangable;
	import fritz3.display.layout.IRectangularLayout;
	import fritz3.display.parser.side.SideData;
	import fritz3.display.parser.side.SideParser;
	import fritz3.display.parser.size.SizeParser;
	import fritz3.invalidation.IInvalidatable;
	import fritz3.invalidation.InvalidationHelper;
	import fritz3.invalidation.InvalidationPriorityTreshold;
	import fritz3.utils.signals.MonoSignal;
	import org.osflash.signals.IDispatcher;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class DisplayComponentContainer extends MeasurableDisplayComponent implements IItemCollection, IDrawable, IRearrangable, IInvalidatablePositionable {
		
		protected var _childInvalidationHelper:InvalidationHelper;
		protected var _displayList:DisplayObjectContainer;
		protected var _collection:IItemCollection;
		protected var _background:IBackground;
		protected var _layout:ILayout;
		
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
			if (_background && _background is ICyclable) {
				ICyclable(_background).cyclePhase = cyclePhase;
			}
			if (_layout && _layout is ICyclable) {
				ICyclable(_layout).cyclePhase = cyclePhase;
			}
		}
		
		override protected function setCycle ( cycle:int ):void {
			super.setCycle(cycle);
			if (_background && _background is ICyclable) {
				ICyclable(_background).cycle = cycle;
			}
			if (_layout && _layout is ICyclable) {
				ICyclable(_layout).cycle = cycle;
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
			var parser:IPropertyParser = this.getParser("padding");
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
		
		protected function setCollection ( collection:IItemCollection ):void {
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
		
		protected function setBackground ( background:IBackground ):void {
			if (_background) {
				_background.drawable = null;
			}
			_background = background;
			if (_background) {
				_background.drawable = this;
				if (_background is ICyclable) {
					ICyclable(_background).cyclePhase = _cyclePhase;
					ICyclable(_background).cycle = _cycle;
				}
			}
		}
		
		protected function setLayout ( layout:ILayout ):void {
			if (_layout) {
				_layout.rearrangable = null;
			}
			_layout = layout;
			if (_layout) {
				_layout.rearrangable = this;
				if (_layout is IRectangularLayout) {
					var rectLayout:IRectangularLayout = IRectangularLayout(_layout);
					var autoWidth:Boolean = _preferredWidth.valueType == DisplayValueType.AUTO, autoHeight:Boolean = _preferredHeight.valueType == DisplayValueType.AUTO;
					rectLayout.autoWidth = autoWidth;
					rectLayout.autoHeight = autoHeight;
					rectLayout.width = _width;
					rectLayout.height = _height;
				}
				this.setLayoutPadding();
				if (_layout is ICyclable) {
					ICyclable(_layout).cyclePhase = _cyclePhase;
					ICyclable(_layout).cycle = _cycle;
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
			var item:IInvalidatableDisplayChild;
			for (var i:int, l:int = items.length; i < l; ++i) {
				item = items[i] as IInvalidatableDisplayChild;
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
			if (_layout && _layout is IPaddableLayout) {
				var layout:IPaddableLayout = IPaddableLayout(_layout);
				layout.paddingLeft = _paddingLeft.getComputedValue(_width);
				layout.paddingTop = _paddingTop.getComputedValue(_height);
				layout.paddingRight = _paddingRight.getComputedValue(_width);
				layout.paddingBottom = _paddingBottom.getComputedValue(_height);
			}
		}
		
		protected function setDependenciesWidth ( ):void {
			if (_layout && _layout is IRectangularLayout) { 
				var layout:IRectangularLayout = IRectangularLayout(_layout);
				var autoWidth:Boolean = _preferredWidth.valueType == DisplayValueType.AUTO;
				layout.autoWidth = autoWidth;
				layout.width = _width;
			}
			if (_background && _background is IRectangularBackground) {
				var background:IRectangularBackground = IRectangularBackground(_background);
				background.width = _width;
			}
		}
		
		protected function setDependenciesHeight ( ):void {
			if (_layout && _layout is IRectangularLayout) { 
				var layout:IRectangularLayout = IRectangularLayout(_layout);
				var autoHeight:Boolean = _preferredHeight.valueType == DisplayValueType.AUTO;
				layout.height = _height;
				layout.autoHeight = autoHeight;
			}
			if (_background && _background is IRectangularBackground) {
				var background:IRectangularBackground = IRectangularBackground(_background);
				background.height = _height;
			}
		}
		
		override protected function setPriority ( value:int ):void {
			super.setPriority(value);
			_childInvalidationHelper.priority = InvalidationPriorityTreshold.CHILD_DISPLAY_INVALIDATION - value;
		}
				
		public function add ( item:Object ):Object {
			
			if (item is IInvalidatable) {
				this.addInvalidatable(IInvalidatable(item));
			}
			
			if (item is IAddable) {
				this.addAddable(IAddable(item));
			}
			
			if (item is IInvalidatablePositionable) {
				this.addInvalidatablePositionable(IInvalidatablePositionable(item));
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
			
			if (item is IInvalidatablePositionable) {
				this.removeInvalidatablePositionable(IInvalidatablePositionable(item));
			}
			
			if (item is IAddable) {
				this.removeAddable(IAddable(item));
			}
			
			if (item is IInvalidatable) {
				this.removeInvalidatable(IInvalidatable(item));
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
		
		protected function addInvalidatable ( invalidatable:IInvalidatable ):void { 
			invalidatable.priority = this.priority + 1;
		}
		
		protected function removeInvalidatable ( invalidatable:IInvalidatable ):void {
			invalidatable.priority = 0;
		}
		
		protected function addAddable ( addable:IAddable ):void {
			addable.parentComponent = this;
			addable.onAdd();
		}
		
		protected function removeAddable ( addable:IAddable ):void {
			addable.onRemove();
			addable.parentComponent = null;
		}
		
		protected function addInvalidatablePositionable ( invalidatablePositionable:IInvalidatablePositionable ):void {
			invalidatablePositionable.onDisplayInvalidation.add(this.onChildDisplayInvalidation);
		}
		
		protected function removeInvalidatablePositionable ( invalidatablePositionable:IInvalidatablePositionable ):void {
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
		
		protected function onChildDisplayInvalidation ( child:IInvalidatablePositionable ):void {
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
		
		public function get background ( ):IBackground { return _background; }
		public function set background ( value:IBackground ):void {
			if (_background != value) {
				this.setBackground(value);
			}
		}
		
		public function get collection ( ):IItemCollection { return _collection; }
		public function set collection ( value:IItemCollection ):void {
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
		
		public function get layout ( ):ILayout { return _layout; }
		public function set layout ( value:ILayout ):void {
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