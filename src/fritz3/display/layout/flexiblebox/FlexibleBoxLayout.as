package fritz3.display.layout.flexiblebox {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import fritz3.display.layout.Align;
	import fritz3.display.layout.Direction;
	import fritz3.display.layout.Layout;
	import fritz3.display.layout.Orientation;
	import fritz3.display.layout.Positionable;
	import fritz3.display.layout.Rearrangable;
	import fritz3.display.layout.RectangularLayout;
	import fritz3.display.layout.Registration;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class FlexibleBoxLayout implements RectangularLayout {
		
		protected var _rearrangable:Rearrangable;
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		protected var _autoWidth:Boolean;
		protected var _autoHeight:Boolean;
		
		protected var _orient:String = Orientation.HORIZONTAL;
		protected var _direction:String = Direction.NORMAL;
		protected var _align:String = Align.START
		protected var _pack:String = Align.START;
		
		protected var _padding:Number = 0; 
		protected var _paddingTop:Number = 0;
		protected var _paddingLeft:Number = 0;
		protected var _paddingBottom:Number = 0;
		protected var _paddingRight:Number = 0;
		
		protected var _lines:String = BoxLines.MULTIPLE;
		
		protected var _measuredWidth:Number = 0;
		protected var _measuredHeight:Number = 0;
		
		public function FlexibleBoxLayout ( ) {
			
		}
		
		protected function invalidate ( ):void {
			if (_rearrangable) {
				_rearrangable.invalidateLayout();
			}
		}
		
		protected function setRearrangable ( rearrangable:Rearrangable ):void {
			_rearrangable = rearrangable;
			if (_rearrangable) {
				_rearrangable.invalidateLayout();
			}
		}
		
		public function rearrange ( container:DisplayObjectContainer, items:Array ):void {
			var displayItems:Array = [];
			for (var i:int, l:int = items.length; i < l; ++i) {
				if (items[i] is DisplayObject) {
					displayItems[displayItems.length] = items[i];
				}
			}
			
			if (_orient == Orientation.VERTICAL) {
				this.layoutVertically(container, displayItems);
			} else {
				this.layoutHorizontally(container, displayItems);
			}
		}
		
		protected function layoutHorizontally ( container:DisplayObjectContainer, items:Array ):void {
			var positionable:Positionable, child:DisplayObject, boxElement:FlexibleBoxElement;
			var availableWidth:Number = (_autoWidth ? 0 : _width - _paddingLeft - _paddingRight);
			var availableHeight:Number = (_autoHeight ? 0 : _height - _paddingTop - _paddingBottom);
			var toPosition:Array = [], flexible:Array = [];
			var groups:Array = [], flexGroups:Array = [];
			var group:Array, flexGroup:Array;
			var ordinalGroup:int;
			var x:Number, y:Number, width:Number, height:Number;
			var isFlexible:Dictionary = new Dictionary();
			var flexTotalByGroup:Object = { };
			for (var i:int, l:int = items.length; i < l; ++i) {
				child = items[i] as DisplayObject;
				if (child is Collapsable && Collapsable(child).collapsed) {
					child.x = child.y = 0;
					continue;
				}
				
				// TODO: move this to bottom after dimensions are determined
				if (child is Positionable) {
					positionable = Positionable(child);
					if ((positionable.top || positionable.bottom) && (positionable.left || positionable.bottom)) {
						if (positionable.top) {
							y = positionable.top;
						} else {
							y = availableHeight - positionable.bottom;
						}
						if (positionable.left) {
							x = positionable.left;
						} else {
							x = availableWidth - positionable.right;
						}
						this.positionChild(child, x, y);
						continue;
					}
				}
				
				if (child is FlexibleBoxElement) {
					boxElement = FlexibleBoxElement(child);
					if (boxElement.boxFlex) {
						flexible.push(boxElement);
						isFlexible[child] = true;
						if (flexTotalByGroup[boxElement.boxFlexGroup] == null) {
							flexTotalByGroup[boxElement.boxFlexGroup] = 0;
						}
						flexTotalByGroup[boxElement.boxFlexGroup] += boxElement.boxFlex;
						flexGroup = (flexGroups[boxElement.boxFlexGroup] ||= []);
						flexGroup[flexGroup.length] = boxElement;
					}
					ordinalGroup = boxElement.boxOrdinalGroup;
				} else {
					ordinalGroup = 1;
				}
				toPosition[toPosition.length] = child;
				group = (groups[ordinalGroup] ||= []);
				group[group.length] = child;
			}
			
			var minWidth:Number = 0, childHeight:Number, maxChildIntrinsicHeight:Number = 0, maxChildBoundsHeight:Number = 0;
			for (i = 0, l = toPosition.length; i < l; ++i) {
				child = toPosition[i];
				if (!isFlexible[child]) {
					minWidth += child.width;
				} else {
					boxElement = FlexibleBoxElement(child);
					if (!isNaN(boxElement.minimumWidth)) {
						minWidth += boxElement.minimumWidth;
					}
				}
				childHeight = child.height;
				maxChildIntrinsicHeight = Math.max(maxChildIntrinsicHeight, childHeight);
				if (child is Positionable) {
					positionable = Positionable(child);
					minWidth += (positionable.marginLeft + positionable.marginRight);
					childHeight += (positionable.marginTop + positionable.marginBottom);
				}
				maxChildBoundsHeight = Math.max(maxChildBoundsHeight, childHeight);
			}
			
			if (_autoHeight) {
				availableHeight = maxChildIntrinsicHeight;
			}
			
			var spaceToDistribute:Number = Math.max(0, availableWidth - minWidth);
			var childWidth:Number, flexTotal:Number;
			
			flexloop:for (var flexGroupID:Object in flexGroups) {
				flexGroup = flexGroups[flexGroupID];
				flexTotal = flexTotalByGroup[flexGroupID];
				flexGroup.sort(this.sortByMaximumWidth);
				for (i = 0, l = flexGroup.length; i < l; ++i) {
					boxElement = flexGroup[i];
					childWidth = (boxElement.boxFlex / flexTotal) * spaceToDistribute;
					if (!isNaN(boxElement.minimumWidth)) {
						childWidth = Math.max(childWidth, boxElement.minimumWidth);
						spaceToDistribute += boxElement.minimumWidth;
					}
					if (!isNaN(boxElement.maximumWidth)) {
						childWidth = Math.min(childWidth, boxElement.maximumWidth);
					}
					boxElement.width = childWidth;
					spaceToDistribute -= childWidth;
					spaceToDistribute = Math.max(spaceToDistribute, 0);
					flexTotal -= boxElement.boxFlex;
				}
			}
			
			var reverse:Boolean = _direction == Direction.REVERSE;
			var align:String = _align;
			var pack:String = _pack;
			x = 0, y = 0;
			var gap:Number;
			switch(pack) {
				case Align.START:
				x = _paddingLeft;
				break;
				
				case Align.END:
				x = _paddingLeft + spaceToDistribute;
				break;
				
				case Align.CENTER:
				x = spaceToDistribute / 2 + _paddingLeft;
				break;
				
				case Align.JUSTIFY:
				x = _paddingLeft;
				gap = spaceToDistribute / (toPosition.length - 1);
				break;
			}
			
			for each(group in groups) {
				if (reverse) {
					group.reverse();
				}
				for (i = 0, l = group.length; i < l; ++i) {
					child = group[i]; 
					childWidth = child.width;
					childHeight = child.height;
					switch(align) {
						case Align.START:
						y = _paddingTop;
						break;
						
						case Align.END:
						y = availableHeight - child.height + _paddingTop;
						break;
						
						case Align.CENTER:
						y = availableHeight / 2 - child.height / 2 + _paddingTop;
						break;
						
						case Align.STRETCH:
						y = _paddingTop;
						childHeight = availableHeight;
						break;
					}
					
					if (child is Positionable) {
						positionable = Positionable(child);
						x += positionable.marginLeft;
						childWidth += positionable.marginRight;
						y += positionable.marginTop;
						if (align == Align.STRETCH) {
							childHeight = availableHeight - (positionable.marginTop + positionable.marginBottom);
						}
					}
					child.y = y;
					child.height = childHeight;
					if (pack == Align.JUSTIFY) {
						child.x = x;
						x += childWidth + gap; 
					} else {
						child.x = x;
						x += childWidth;
					}
				}
			}
			
			_measuredWidth = x + _paddingLeft;
			if (align == Align.STRETCH) {
				_measuredHeight = _height;
			} else {
				_measuredHeight = maxChildBoundsHeight + _paddingTop + _paddingBottom;
			}
		}
		
		protected function layoutVertically ( container:DisplayObjectContainer, items:Array ):void {
			var positionable:Positionable, child:DisplayObject, boxElement:FlexibleBoxElement;
			var availableWidth:Number = _autoWidth ? 0 : _width - _paddingLeft - _paddingRight;
			var availableHeight:Number = _autoHeight ? 0 : _height - _paddingTop - _paddingBottom;
			var toPosition:Array = [], flexible:Array = [];
			var groups:Array = [], flexGroups:Array = [];
			var group:Array, flexGroup:Array;
			var ordinalGroup:int;
			var x:Number, y:Number, width:Number, height:Number;
			var isFlexible:Dictionary = new Dictionary();
			var flexTotalByGroup:Object = { };
			for (var i:int, l:int = items.length; i < l; ++i) {
				child = items[i] as DisplayObject;
				if (child is Collapsable && Collapsable(child).collapsed) {
					child.x = child.y = 0;
					continue;
				}
				
				// TODO: move this to bottom after dimensions are determined
				
				if (child is Positionable) {
					positionable = Positionable(child);
					if ((positionable.top || positionable.bottom) && (positionable.left || positionable.bottom)) {
						if (positionable.top) {
							y = positionable.top;
						} else {
							y = availableHeight - positionable.bottom;
						}
						if (positionable.left) {
							x = positionable.left;
						} else {
							x = availableWidth - positionable.right;
						}
						this.positionChild(child, x, y);
						continue;
					}
				}
				
				if (child is FlexibleBoxElement) {
					boxElement = FlexibleBoxElement(child);
					if (boxElement.boxFlex) {
						flexible.push(boxElement);
						isFlexible[child] = true;
						if (flexTotalByGroup[boxElement.boxFlexGroup] == null) {
							flexTotalByGroup[boxElement.boxFlexGroup] = 0;
						}
						flexTotalByGroup[boxElement.boxFlexGroup] += boxElement.boxFlex;
						flexGroup = (flexGroups[boxElement.boxFlexGroup] ||= []);
						flexGroup[flexGroup.length] = boxElement;
					}
					ordinalGroup = boxElement.boxOrdinalGroup;
				} else {
					ordinalGroup = 1;
				}
				toPosition[toPosition.length] = child;
				group = (groups[ordinalGroup] ||= []);
				group[group.length] = child;
			}
			
			var minHeight:Number = 0, childWidth:Number, maxChildWidth:Number = 0;
			for (i = 0, l = toPosition.length; i < l; ++i) {
				child = toPosition[i];
				if (!isFlexible[child]) {
					minHeight += child.height;
				} else {
					boxElement = FlexibleBoxElement(child);
					if (!isNaN(boxElement.minimumHeight)) {
						minHeight += boxElement.minimumHeight;
					}
				}
				childWidth = child.width;
				if (child is Positionable) {
					positionable = Positionable(child);
					minHeight += (positionable.marginTop + positionable.marginBottom);
					childWidth += (positionable.marginLeft + positionable.marginBottom);
				}
				maxChildWidth = Math.max(child.width, childWidth);
			}
			
			if (_autoWidth) {
				availableWidth = maxChildWidth;
			}
			
			var spaceToDistribute:Number = Math.max(0, availableHeight - minHeight);
			var childHeight:Number, flexTotal:Number;
			
			flexloop:for (var flexGroupID:Object in flexGroups) {
				flexGroup = flexGroups[flexGroupID];
				flexTotal = flexTotalByGroup[flexGroupID];
				flexGroup.sort(this.sortByMaximumHeight);
				for (i = 0, l = flexGroup.length; i < l; ++i) {
					boxElement = flexGroup[i];
					childHeight = (boxElement.boxFlex / flexTotal) * spaceToDistribute;
					if (!isNaN(boxElement.minimumHeight)) {
						childHeight = Math.max(childHeight, boxElement.minimumHeight);
						spaceToDistribute += boxElement.minimumHeight;
					}
					if (!isNaN(boxElement.maximumHeight)) {
						childHeight = Math.min(childHeight, boxElement.maximumHeight);
					}
					boxElement.height = childHeight;
					spaceToDistribute -= childHeight;
					spaceToDistribute = Math.max(spaceToDistribute, 0);
					flexTotal -= boxElement.boxFlex;
				}
			}
			
			var reverse:Boolean = _direction == Direction.REVERSE;
			var align:String = _align;
			var pack:String = _pack;
			x = 0, y = 0;
			var gap:Number;
			switch(pack) {
				case Align.START:
				y = _paddingTop;
				break;
				
				case Align.END:
				y = _paddingTop + spaceToDistribute;
				break;
				
				case Align.CENTER:
				y = spaceToDistribute / 2 + _paddingTop;
				break;
				
				case Align.JUSTIFY:
				y = _paddingTop;
				gap = spaceToDistribute / (toPosition.length - 1);
				break;
			}
			
			for each(group in groups) {
				if (reverse) {
					group.reverse();
				}
				for (i = 0, l = group.length; i < l; ++i) {
					child = group[i]; 
					childWidth = child.width;
					childHeight = child.height;
					switch(align) {
						case Align.START:
						x = _paddingLeft;
						break;
						
						case Align.END:
						x = availableWidth - child.width + _paddingLeft;
						break;
						
						case Align.CENTER:
						x = availableWidth/2 - child.width / 2 + _paddingLeft;
						break;
						
						case Align.STRETCH:
						x = _paddingLeft;
						childWidth = availableWidth;
						break;
					}
					
					if (child is Positionable) {
						positionable = Positionable(child);
						x += positionable.marginLeft;
						childHeight += positionable.marginBottom;
						y += positionable.marginTop;
						if (align == Align.STRETCH) {
							childWidth = availableWidth - (positionable.marginLeft + positionable.marginRight);
						}
					}
					child.x = x;
					child.width = childWidth;
					if (pack == Align.JUSTIFY) {
						child.y = y;
						y += childHeight + gap; 
					} else {
						child.y = y;
						y += childHeight;
					}
				}
			}
		}
		
		protected var _childBounds:Rectangle = new Rectangle();
		final protected function positionChild ( child:DisplayObject, x:Number, y:Number ):Rectangle {
			var registration:String = Registration.TOP_LEFT;
			var width:Number = child.width, height:Number = child.height;
			switch(registration) {
				default:
				case Registration.TOP_LEFT:
				break;
				
				case Registration.TOP:
				x -= width / 2;
				break;
				
				case Registration.TOP_RIGHT:
				x -= width;
				break;
				
				case Registration.LEFT:
				y -= height / 2;
				break;
				
				case Registration.CENTER:
				x -= width / 2;
				y -= height / 2;
				break;
				
				case Registration.RIGHT:
				x -= width;
				y -= height / 2;
				break;
				
				case Registration.BOTTOM_LEFT:
				y -= height;
				break;
				
				case Registration.BOTTOM:
				x -= width / 2;
				y -= height;
				break;
				
				case Registration.BOTTOM_RIGHT:
				x -= width;
				y -= height;
				break;
			}
			if (child is Positionable) {
				var positionable:Positionable = Positionable(child);
				x += positionable.marginLeft;
				y += positionable.marginTop;
				width += positionable.marginRight;
				height += positionable.marginBottom;
			}
			child.x = x, child.y = y;
			_childBounds.x = x, _childBounds.y = y, _childBounds.width = width, _childBounds.height = height;
			return _childBounds;
		}
		
		protected function sortByMaximumWidth ( childA:FlexibleBoxElement, childB:FlexibleBoxElement ):int {
			var maximumWidthA:Number = childA.maximumWidth;
			var maximumWidthB:Number = childB.maximumWidth;
			if (isNaN(maximumWidthA)) {
				maximumWidthA = Number.MIN_VALUE;
			}
			if (isNaN(maximumWidthB)) {
				maximumWidthB = Number.MIN_VALUE;
			}
			var result:int;
			if (maximumWidthA > maximumWidthB) {
				result = -1;
			} else if (maximumWidthA == maximumWidthB) {
				result = 0;
			} else {
				result = 1;
			}
			return result;
		}
		
		protected function sortByMaximumHeight ( childA:FlexibleBoxElement, childB:FlexibleBoxElement ):int {
			var maximumHeightA:Number = childA.maximumWidth;
			var maximumHeightB:Number = childB.maximumWidth;
			if (isNaN(maximumHeightA)) {
				maximumHeightA = Number.MIN_VALUE;
			}
			if (isNaN(maximumHeightA)) {
				maximumHeightB = Number.MIN_VALUE;
			}
			var result:int;
			if (maximumHeightA > maximumHeightB) {
				result = -1;
			} else if (maximumHeightA == maximumHeightB) {
				result = 0;
			} else {
				result = 1;
			}
			return result;
		}
		
		public function get rearrangable ( ):Rearrangable { return _rearrangable; }
		public function set rearrangable ( value:Rearrangable ):void {
			if (_rearrangable != value) {
				this.setRearrangable(value);
			}
		}
		
		public function get width ( ):Number { return _width; }
		public function set width ( value:Number ):void {
			if (_width != value) {
				_width = value;
				this.invalidate();
			}
		}
		
		public function get height ( ):Number { return _height; }
		public function set height ( value:Number):void {
			if (_height != value) {
				_height = value;
				this.invalidate();
			}
		}
		
		public function get orient ( ):String { return _orient; }
		public function set orient ( value:String ):void {
			if (_orient) {
				_orient = value;
				this.invalidate();
			}
		}
		
		public function get direction ( ):String { return _direction; }
		public function set direction ( value:String ):void {
			if (_direction != value) {
				_direction = value;
				this.invalidate();
			}
		}
		
		public function get align ( ):String { return _align; }
		public function set align ( value:String ):void {
			if (_align != value) {
				_align = value;
				this.invalidate();
			}
		}
		
		public function get pack ( ):String { return _pack; }
		public function set pack ( value:String ):void {
			if(_pack != value) {
				_pack = value;
				this.invalidate();
			}
		}
		
		public function get padding ( ):Number { return _padding; }
		public function set padding ( value:Number ):void {
			if (_padding != value) {
				_padding = _paddingTop = _paddingLeft = _paddingBottom = _paddingRight = value;
				this.invalidate();
			}
		}
		
		public function get paddingTop ( ):Number { return _paddingTop; }
		public function set paddingTop ( value:Number ):void {
			if (_paddingTop != value) {
				_paddingTop = value;
				this.invalidate();
			}
		}
		
		public function get paddingLeft ( ):Number { return _paddingLeft; }
		public function set paddingLeft ( value:Number ):void {
			if (_paddingLeft != value) {
				_paddingLeft = value;
				this.invalidate();
			}
		}
		
		public function get paddingBottom ( ):Number { return _paddingBottom; }
		public function set paddingBottom ( value:Number ):void {
			if (_paddingBottom != value) {
				_paddingBottom = value;
				this.invalidate();
			}
		}
		
		public function get paddingRight ( ):Number { return _paddingRight; }
		public function set paddingRight ( value:Number ):void {
			if (_paddingRight != value) {
				_paddingRight = value;
				this.invalidate();
			}
		}
		
		public function get autoWidth ( ):Boolean { return _autoWidth; }
		public function set autoWidth ( value:Boolean ):void {
			if (_autoWidth != value) {
				_autoWidth = value;
				this.invalidate();
			}
		}
		
		public function get autoHeight ( ):Boolean { return _autoHeight; }
		public function set autoHeight ( value:Boolean ):void {
			if (_autoHeight != value) {
				_autoHeight = value;
				this.invalidate();
			}
		}
		
		public function get measuredWidth ( ):Number { return _measuredWidth; }
		public function get measuredHeight ( ):Number { return _measuredHeight; }
		
	}

}