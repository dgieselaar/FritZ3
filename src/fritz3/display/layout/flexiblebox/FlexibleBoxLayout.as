package fritz3.display.layout.flexiblebox {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import fritz3.base.injection.Injectable;
	import fritz3.display.core.DisplayValueType;
	import fritz3.display.layout.Align;
	import fritz3.display.layout.Direction;
	import fritz3.display.layout.Layout;
	import fritz3.display.layout.Orientation;
	import fritz3.display.layout.PaddableLayout;
	import fritz3.display.layout.Positionable;
	import fritz3.display.layout.Rearrangable;
	import fritz3.display.layout.RectangularLayout;
	import fritz3.display.layout.Registration;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class FlexibleBoxLayout implements PaddableLayout {
		
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
		
		protected var _availableWidth:Number = 0;
		protected var _availableHeight:Number = 0;
		
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
			var availableWidth:Number = Math.max(0, _width - _paddingLeft - _paddingRight);
			var availableHeight:Number = Math.max(0, _height - _paddingTop - _paddingBottom);
			
			var i:int, l:int, child:DisplayObject, positionable:Positionable, boxElement:FlexibleBoxElement;
			var x:Number, y:Number, width:Number, height:Number;
			
			
			var preferredWidth:Number, preferredHeight:Number, minWidth:Number, maxWidth:Number, minHeight:Number, maxHeight:Number;
			
			var inlineChildren:Array = [], fixedChildren:Array = [], toPosition:Array = [], childDimension:Rectangle, childDimensions:Dictionary = new Dictionary();
			var isFlexible:Dictionary = new Dictionary(), groups:Array = [], flexGroups:Array = [], flexTotalByGroup:Object = {};
			var group:Array, flexGroup:Array, ordinalGroup:int;
			
			for (i = 0, l = items.length; i < l; ++i) {
				child = items[i] as DisplayObject;
				if (child is Collapsable && Collapsable(child).collapsed) {
					child.x = 0, child.y = 0;
					continue;
				}
				
				childDimensions[child] = childDimension = new Rectangle(NaN, NaN, NaN, NaN);
				toPosition[toPosition.length] = child;
				positionable = child as Positionable;
				if (positionable) {
					if (positionable.left.value || positionable.top.value || positionable.right.value || positionable.bottom.value) {
						fixedChildren[fixedChildren.length] = child;
						continue;
					} 
				}
				
				boxElement = child as FlexibleBoxElement;
				inlineChildren[inlineChildren.length] = child;
				if (boxElement) {
					if (boxElement.boxFlex) {
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
				group = (groups[ordinalGroup] ||= []);
				group[group.length] = child;
			}
			
			var minTotalWidth:Number = 0, horizontalMargin:Number;
			var maxChildIntrinsicHeight:Number = 0, maxChildBoundsHeight:Number = 0;
			for (i = 0, l = inlineChildren.length; i < l; ++i) {
				child = inlineChildren[i];
				positionable = child as Positionable;
				if (positionable) {
					horizontalMargin = positionable.marginLeft.getComputedValue(availableWidth) + positionable.marginRight.getComputedValue(availableWidth); 
					preferredWidth = positionable.preferredWidth.getComputedValue(availableWidth);
					if (!isNaN(positionable.minimumWidth.value)) {
						preferredWidth = Math.max(positionable.minimumWidth.getComputedValue(availableWidth), preferredWidth);
					}
					if (!isNaN(positionable.maximumWidth.value)) {
						preferredWidth = Math.min(positionable.maximumWidth.getComputedValue(availableWidth), preferredWidth);
					}
					preferredWidth = int(horizontalMargin + preferredWidth);
					// TODO: subtract margin from availableWidth
					preferredHeight = positionable.preferredHeight.getComputedValue(availableHeight);
					maxChildIntrinsicHeight = Math.max(maxChildIntrinsicHeight, preferredHeight);
					maxChildBoundsHeight = Math.max(maxChildBoundsHeight, preferredHeight + positionable.marginTop.getComputedValue(availableHeight) + positionable.marginBottom.getComputedValue(availableHeight));
				} else {
					preferredWidth = child.width;
					preferredHeight = child.height;
					maxChildIntrinsicHeight = Math.max(maxChildIntrinsicHeight, preferredHeight);
					maxChildBoundsHeight = Math.max(maxChildBoundsHeight, preferredHeight);
				}
				
				minTotalWidth += preferredWidth;
			}
			
			if (_autoWidth) {
				availableWidth = minTotalWidth;
			}
			
			if (_autoHeight) {
				availableHeight = maxChildBoundsHeight;
			}
			
			_availableWidth = availableWidth, _availableHeight = availableHeight;
			
			var spaceToDistribute:Number = availableWidth - minTotalWidth;
			
			var childWidth:Number, childHeight:Number;
			
			if (spaceToDistribute) {
				var diffWidth:Number, flexTotal:Number;
				flexloop:for (var flexGroupID:Object in flexGroups) {
					flexGroup = flexGroups[flexGroupID];
					flexTotal = flexTotalByGroup[flexGroupID];
					if (spaceToDistribute > 0) {
						flexGroup.sort(this.sortByMaximumWidth);
					} else {
						flexGroup.sort(this.sortByMinimumWidth);
					}
					for (i = 0, l = flexGroup.length; i < l; ++i) {
						boxElement = flexGroup[i];
						preferredWidth = boxElement.preferredWidth.getComputedValue(availableWidth);
						minWidth = isNaN(boxElement.minimumWidth.value) ? 0 : int(boxElement.minimumWidth.getComputedValue(availableWidth));
						maxWidth = isNaN(boxElement.maximumWidth.value) ? Number.MAX_VALUE : int(boxElement.maximumWidth.getComputedValue(availableWidth));
						diffWidth = int((boxElement.boxFlex / flexTotal) * spaceToDistribute);
						childWidth = preferredWidth + diffWidth;
						if (childWidth < minWidth) {
							diffWidth = minWidth - preferredWidth;
							childWidth = minWidth;
						}
						if (childWidth > maxWidth) {
							diffWidth = maxWidth - preferredWidth;
							childWidth = maxWidth;
						}
						Rectangle(childDimensions[boxElement]).width = childWidth;
						spaceToDistribute -= diffWidth;
						flexTotal -= boxElement.boxFlex;
					}
					
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
				gap = Math.max(0, spaceToDistribute) / (inlineChildren.length - 1) || 0;
				break;
			}
			
			var marginLeft:Number, marginTop:Number, marginRight:Number, marginBottom:Number;
			
			for each(group in groups) {
				if (reverse) {
					group.reverse();
				}
				for (i = 0, l = group.length; i < l; ++i) {
					child = group[i];
					childDimension = childDimensions[child];
					positionable = child as Positionable;
					if (positionable) {
						marginLeft = positionable.marginLeft.getComputedValue(availableWidth);
						marginTop = positionable.marginTop.getComputedValue(availableHeight);
						marginRight = positionable.marginRight.getComputedValue(availableWidth);
						marginBottom = positionable.marginBottom.getComputedValue(availableHeight);
						if (isNaN(childDimension.width)) {
							preferredWidth = positionable.preferredWidth.getComputedValue(availableWidth);
							minWidth = isNaN(positionable.minimumWidth.value) ? 0 : positionable.minimumWidth.getComputedValue(availableWidth);
							maxWidth = isNaN(positionable.maximumWidth.value) ? Number.MAX_VALUE : positionable.maximumWidth.getComputedValue(availableWidth);
							childDimension.width = Math.max(minWidth, Math.min(maxWidth, preferredWidth)); 
						}
						childWidth = childDimension.width;
						minHeight = isNaN(positionable.minimumHeight.value) ? 0 : positionable.minimumHeight.getComputedValue(availableHeight);
						maxHeight = isNaN(positionable.maximumHeight.value) ? Number.MAX_VALUE : positionable.maximumHeight.getComputedValue(availableHeight);
						if (align != Align.STRETCH) {
							preferredHeight = positionable.preferredHeight.getComputedValue(availableHeight - marginTop - marginBottom);
							childDimension.height = Math.max(minHeight, Math.min(maxHeight, preferredHeight));
						} else {
							childDimension.height = Math.max(minHeight, Math.min(maxHeight, availableHeight - marginTop - marginBottom));
						}
						childHeight = childDimension.height;
					} else {
						childWidth = child.width;
						childHeight = child.height;
						marginLeft = marginTop = marginRight = marginBottom = 0;
					}
					
					switch(align) {
						case Align.START:
						y = _paddingTop;
						break;
						
						case Align.END:
						y = availableHeight - childHeight + _paddingTop;
						break;
						
						case Align.CENTER:
						y = availableHeight / 2 - childHeight / 2 + _paddingTop;
						break;
						
						case Align.STRETCH:
						y = _paddingTop;
						break;
					}
					
					x += marginLeft;
					y += marginTop;
					childWidth += marginRight;
					childDimension.x = x;
					childDimension.y = y;
					
					x += childWidth;
				}
			}
			
			_measuredWidth = x + _paddingRight;
			if (_autoHeight) {
				_measuredHeight = _paddingTop + maxChildBoundsHeight + _paddingBottom;
			} else {
				_measuredHeight = _paddingTop + _height + _paddingBottom;
			}
			
			this.positionChildren(childDimensions);
		}
		
		protected function layoutVertically ( container:DisplayObjectContainer, items:Array ):void {
			var availableWidth:Number = Math.max(0, _width - _paddingLeft - _paddingRight);
			var availableHeight:Number = Math.max(0, _height - _paddingTop - _paddingBottom);
			
			var i:int, l:int, child:DisplayObject, positionable:Positionable, boxElement:FlexibleBoxElement;
			var x:Number, y:Number, width:Number, height:Number;
			
			var preferredWidth:Number, preferredHeight:Number, minWidth:Number, maxWidth:Number, minHeight:Number, maxHeight:Number;
			
			var inlineChildren:Array = [], fixedChildren:Array = [], toPosition:Array = [], childDimension:Rectangle, childDimensions:Dictionary = new Dictionary();
			var isFlexible:Dictionary = new Dictionary(), groups:Array = [], flexGroups:Array = [], flexTotalByGroup:Object = {};
			var group:Array, flexGroup:Array, ordinalGroup:int;
			
			for (i = 0, l = items.length; i < l; ++i) {
				child = items[i] as DisplayObject;
				if (child is Collapsable && Collapsable(child).collapsed) {
					child.x = 0, child.y = 0;
					continue;
				}
				
				childDimensions[child] = childDimension = new Rectangle(NaN, NaN, NaN, NaN);
				toPosition[toPosition.length] = child;
				positionable = child as Positionable;
				if (positionable) {
					if (positionable.left.value || positionable.top.value || positionable.right.value || positionable.bottom.value) {
						fixedChildren[fixedChildren.length] = child;
						continue;
					} 
				}
				
				boxElement = child as FlexibleBoxElement;
				inlineChildren[inlineChildren.length] = child;
				if (boxElement) {
					if (boxElement.boxFlex) {
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
				group = (groups[ordinalGroup] ||= []);
				group[group.length] = child;
			}
			
			var minTotalHeight:Number = 0, verticalMargin:Number;
			var maxChildIntrinsicWidth:Number = 0, maxChildBoundsWidth:Number = 0;
			for (i = 0, l = inlineChildren.length; i < l; ++i) {
				child = inlineChildren[i];
				positionable = child as Positionable;
				if (positionable) {
					verticalMargin = positionable.marginTop.getComputedValue(availableHeight) + positionable.marginBottom.getComputedValue(availableHeight); 
					preferredHeight = positionable.preferredHeight.getComputedValue(availableHeight);
					if (!isNaN(positionable.minimumHeight.value)) {
						preferredHeight = Math.max(positionable.minimumHeight.getComputedValue(availableHeight), preferredHeight);
					}
					if (!isNaN(positionable.maximumHeight.value)) {
						preferredHeight = Math.min(positionable.maximumHeight.getComputedValue(availableHeight), preferredHeight);
					}
					preferredHeight = int(verticalMargin + preferredHeight);
					// TODO: subtract margin from availableWidth
					preferredWidth = positionable.preferredWidth.getComputedValue(availableWidth);
					maxChildIntrinsicWidth = Math.max(maxChildIntrinsicWidth, preferredWidth);
					maxChildBoundsWidth = Math.max(maxChildBoundsWidth, preferredWidth + positionable.marginLeft.getComputedValue(availableWidth) + positionable.marginRight.getComputedValue(availableWidth));
				} else {
					preferredWidth = child.width;
					preferredHeight = child.height;
					maxChildIntrinsicWidth = Math.max(maxChildIntrinsicWidth, preferredWidth);
					maxChildBoundsWidth = Math.max(maxChildBoundsWidth, preferredWidth);
				}
				
				minTotalHeight += preferredHeight;
			}
			
			if (_autoHeight) {
				availableHeight = minTotalHeight;
			}
			
			if (_autoWidth) {
				availableWidth = maxChildBoundsWidth;
			}
			
			_availableWidth = availableWidth, _availableHeight = availableHeight;
			
			var spaceToDistribute:Number = availableHeight - minTotalHeight;
			
			var childWidth:Number, childHeight:Number;
			
			if (spaceToDistribute) {
				var diffHeight:Number, flexTotal:Number;
				flexloop:for (var flexGroupID:Object in flexGroups) {
					flexGroup = flexGroups[flexGroupID];
					flexTotal = flexTotalByGroup[flexGroupID];
					if (spaceToDistribute > 0) {
						flexGroup.sort(this.sortByMaximumHeight);
					} else {
						flexGroup.sort(this.sortByMinimumHeight);
					}
					for (i = 0, l = flexGroup.length; i < l; ++i) {
						boxElement = flexGroup[i];
						// TODO: subtract margins from availableHeight
						preferredHeight = boxElement.preferredHeight.getComputedValue(availableHeight);
						minHeight = isNaN(boxElement.minimumHeight.value) ? 0 : int(boxElement.minimumHeight.getComputedValue(availableHeight));
						maxHeight = isNaN(boxElement.maximumHeight.value) ? Number.MAX_VALUE : int(boxElement.maximumHeight.getComputedValue(availableHeight));
						diffHeight = int((boxElement.boxFlex / flexTotal) * spaceToDistribute);
						childHeight = preferredHeight + diffHeight;
						if (childHeight < minHeight) {
							diffHeight = minHeight - preferredHeight;
							childHeight = minHeight;
						}
						if (childHeight > maxHeight) {
							diffHeight = maxHeight - preferredHeight;
							childHeight = maxWidth;
						}
						
						Rectangle(childDimensions[boxElement]).height = childHeight;
						spaceToDistribute -= diffHeight;
						flexTotal -= boxElement.boxFlex;
					}
					
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
				gap = Math.max(0, spaceToDistribute) / (inlineChildren.length - 1) || 0;
				break;
			}
			
			var marginLeft:Number, marginTop:Number, marginRight:Number, marginBottom:Number;
			
			for each(group in groups) {
				if (reverse) {
					group.reverse();
				}
				for (i = 0, l = group.length; i < l; ++i) {
					child = group[i];
					childDimension = childDimensions[child];
					positionable = child as Positionable;
					if (positionable) {
						marginLeft = positionable.marginLeft.getComputedValue(availableWidth);
						marginTop = positionable.marginTop.getComputedValue(availableHeight);
						marginRight = positionable.marginRight.getComputedValue(availableWidth);
						marginBottom = positionable.marginBottom.getComputedValue(availableHeight);
						if (isNaN(childDimension.height)) {
							//TODO: subtract margins from availableHeight
							preferredHeight = positionable.preferredHeight.getComputedValue(availableHeight);
							minHeight = isNaN(positionable.minimumHeight.value) ? 0 : positionable.minimumHeight.getComputedValue(availableHeight);
							maxHeight = isNaN(positionable.maximumHeight.value) ? Number.MAX_VALUE : positionable.maximumHeight.getComputedValue(availableHeight);
							childDimension.height = Math.max(minHeight, Math.min(maxHeight, preferredHeight)); 
						}
						childHeight = childDimension.height;
						minWidth = isNaN(positionable.minimumWidth.value) ? 0 : positionable.minimumWidth.getComputedValue(availableWidth);
						maxWidth = isNaN(positionable.maximumWidth.value) ? Number.MAX_VALUE : positionable.maximumWidth.getComputedValue(availableWidth);
						if (align != Align.STRETCH) {
							preferredWidth = positionable.preferredWidth.getComputedValue(availableWidth - marginLeft - marginRight);
							childDimension.width = Math.max(minWidth, Math.min(maxWidth, preferredWidth));
						} else {
							childDimension.width = Math.max(minWidth, Math.min(maxWidth, availableWidth - marginLeft - marginRight));
						}
						childWidth = childDimension.width;
					} else {
						childWidth = child.width;
						childHeight = child.height;
						marginLeft = marginTop = marginRight = marginBottom = 0;
					}
					
					switch(align) {
						case Align.START:
						x = _paddingLeft;
						break;
						
						case Align.END:
						x = availableWidth - childWidth + _paddingLeft;
						break;
						
						case Align.CENTER:
						x = availableWidth / 2 - childWidth / 2 + _paddingLeft;
						break;
						
						case Align.STRETCH:
						x = _paddingLeft;
						break;
					}
					
					x += marginLeft;
					y += marginTop;
					childHeight += marginBottom;
					childDimension.x = x;
					childDimension.y = y;
					
					y += childHeight;
				}
			}
			
			_measuredHeight = y + _paddingBottom;
			if (_autoWidth) {
				_measuredWidth = _paddingLeft + maxChildBoundsWidth + _paddingRight;
			} else {
				_measuredWidth = _paddingLeft + _width + _paddingRight;
			}
			
			this.positionChildren(childDimensions);
		}
		
		protected function positionChildren ( dimensions:Dictionary ):void {
			var child:DisplayObject, dimension:Rectangle;
			var x:Number, y:Number, width:Number, height:Number;
			var childWidth:Number, childHeight:Number;
			var injectable:Injectable;
			for (var obj:Object in dimensions) {
				child = DisplayObject(obj);
				dimension = dimensions[obj];
				x = dimension.x, y = dimension.y;
				childWidth = width = dimension.width;
				childHeight = height = dimension.height;
				
				if (child is Injectable) {
					injectable = Injectable(child);
					injectable.setProperty("x", x);
					injectable.setProperty("y", y);
					if (width == width) {
						injectable.setProperty("width", width);
					}
					if (height == height) {
						injectable.setProperty("height", height);
					}
				} else {
					child.x = x, child.y = y;
					if (width == width) {
						child.width = width;
					}
					if (height == height) {
						child.height = height;
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
			_childBounds.x = x, _childBounds.y = y, _childBounds.width = width, _childBounds.height = height;
			return _childBounds;
		}
		
		protected function sortByMinimumWidth ( childA:FlexibleBoxElement, childB:FlexibleBoxElement ):int {
			var valueA:Number = childA.minimumWidth.getComputedValue(_availableWidth);
			var valueB:Number = childB.minimumWidth.getComputedValue(_availableWidth);
			if (isNaN(valueA)) {
				valueA = Number.MIN_VALUE;
			}
			if (isNaN(valueB)) {
				valueB = Number.MIN_VALUE;
			}
			var result:int;
			if (valueA > valueB) {
				result = -1;
			} else if (valueA == valueB) {
				result = 0;
			} else {
				result = 1;
			}
			return result;
		}
		
		protected function sortByMaximumWidth ( childA:FlexibleBoxElement, childB:FlexibleBoxElement ):int {
			var valueA:Number = childA.maximumWidth.getComputedValue(_availableWidth);
			var valueB:Number = childB.maximumWidth.getComputedValue(_availableWidth);
			if (isNaN(valueA)) {
				valueA = Number.MIN_VALUE;
			}
			if (isNaN(valueB)) {
				valueB = Number.MIN_VALUE;
			}
			var result:int;
			if (valueA > valueB) {
				result = -1;
			} else if (valueA == valueB) {
				result = 0;
			} else {
				result = 1;
			}
			return result;
		}
		
		protected function sortByMinimumHeight ( childA:FlexibleBoxElement, childB:FlexibleBoxElement ):int {
			var valueA:Number = childA.minimumHeight.getComputedValue(_availableHeight);
			var valueB:Number = childB.minimumHeight.getComputedValue(_availableHeight);
			if (isNaN(valueA)) {
				valueA = Number.MIN_VALUE;
			}
			if (isNaN(valueB)) {
				valueB = Number.MIN_VALUE;
			}
			var result:int;
			if (valueA > valueB) {
				result = -1;
			} else if (valueA == valueB) {
				result = 0;
			} else {
				result = 1;
			}
			return result;
		}
		
		protected function sortByMaximumHeight ( childA:FlexibleBoxElement, childB:FlexibleBoxElement ):int {
			var valueA:Number = childA.maximumHeight.getComputedValue(_availableHeight);
			var valueB:Number = childB.maximumHeight.getComputedValue(_availableHeight);
			if (isNaN(valueA)) {
				valueA = Number.MIN_VALUE;
			}
			if (isNaN(valueB)) {
				valueB = Number.MIN_VALUE;
			}
			var result:int;
			if (valueA > valueB) {
				result = -1;
			} else if (valueA == valueB) {
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