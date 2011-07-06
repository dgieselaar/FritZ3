package fritz3.style {
	import flash.utils.Dictionary;
	import fritz3.base.parser.IParsable;
	import fritz3.base.transition.ITransitionable;
	import fritz3.base.transition.TransitionData;
	import fritz3.invalidation.InvalidationHelper;
	import fritz3.style.invalidation.IInvalidatableStyleSheetCollector;
	import fritz3.style.selector.ObjectCache;
	import fritz3.style.IStylable;
	import fritz3.utils.log.log;
	import fritz3.utils.log.LogLevel;
	import fritz3.utils.object.ObjectParser;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class StandardStyleSheetCollector implements IInvalidatableStyleSheetCollector {
		
		protected static var _propertyDataObjectPool:Array = [];
		protected static var _transitionDataObjectPool:Array = [];
		
		protected var _disabled:Boolean = false;
		
		protected var _stylable:IStylable;
		protected var _styleSheetIDs:Array;
		protected var _hasOnChangeListener:Boolean;
		
		protected var _invalidatedCollector:Boolean;
		protected var _invalidatedState:Boolean;
		protected var _invalidatedRules:Boolean;
		
		protected var _styleRules:Array;
		protected var _firstNode:PropertyData;
		protected var _lastNode:PropertyData;
		
		protected var _dataByTarget:Object;
		protected var _transitionByTarget:Object;
		
		protected var _complexContent:Dictionary;
		
		public function StandardStyleSheetCollector ( properties:Object = null ) {
			_dataByTarget = { };
			_transitionByTarget = { };
			_complexContent = new Dictionary();
			for (var id:String in properties) {
				this[id] = properties[id];
			}
		}
		
		protected function applyDisabled ( ):void {
			this.setOnChangeListener();
		}
		
		protected function setStylable ( stylable:IStylable ):void {
			_stylable = stylable;
			this.setOnChangeListener();
			this.invalidate();
		}
		
		protected function setStyleSheetIDs ( ids:Array ):void {
			_styleSheetIDs = ids;
			this.invalidateCollector();
		}
		
		protected function invalidate ( ):void {
			if (_stylable && !_disabled) {
				_stylable.invalidateStyle();
			}
		}
		
		protected function setOnChangeListener ( ):void {
			if (_hasOnChangeListener && (!_stylable || _disabled)) {
				StyleManager.onChange.remove(this);
				_hasOnChangeListener = false;
			}
			if (!_hasOnChangeListener && (_stylable && !_disabled)) {
				StyleManager.onChange.add(this);
				_hasOnChangeListener = true;
			}
		}
		
		protected function onStyleManagerChange ( ):void {
			this.invalidateCollector();
		}
		
		protected function collectNodes ( ):void {
			var node:StyleRule, i:int, l:int;
			var rules:Array = _styleRules;
			l = rules ? rules.length : 0;
			for (i = 0; i < l; ++i) {
				node = rules[i];
				node.onChange.remove(this);
			}
			
			_styleRules = rules = [];
			
			var numRules:int = 0;
			var ids:Array = _styleSheetIDs, id:String;
			var stylable:IStylable = _stylable;
			if (!ids) {
				node = StyleManager.getFirstRule(StyleManager.DEFAULT_STYLESHEET_ID);
				while (node) {
					if (node.selectorList.match(stylable)) {
						node.onChange.add(this);
						rules[numRules++] = node;
					}
					node = node.nextNode;
				}
			} else {
				for (i = 0, l = ids.length; i < l; ++i) {
					id = ids[i];
					node = StyleManager.getFirstRule(id);
					while (node) {
						if (node.selectorList.match(stylable)) {
							node.onChange.add(this);
							rules[numRules++] = node;
						}
						node = node.nextNode;
					}
				}
			}
		}
		
		protected function cacheProperties ( ):void {
			var rules:Array = _styleRules;
			var rule:StyleRule;
			
			var node:PropertyData = _firstNode, nextNode:PropertyData;
			while (node) {
				nextNode = node.nextNode;
				poolPropertyDataObject(node);
				node = nextNode;
			}
			
			_dataByTarget = { }, _transitionByTarget = { };
			
			
			var ruleNode:PropertyData, prevNode:PropertyData;
			_firstNode = _lastNode = null;
			var value:*;
			for (var i:int, l:int = rules ? rules.length : 0; i < l; ++i) {
				rule = rules[i];
				ruleNode = rule.firstNode;
				while (ruleNode) {
					node = this.getNode(ruleNode);
					if (!node) {
						node = ruleNode.clone(getPropertyDataObject(ruleNode));
						node.prevNode = prevNode;
						if (prevNode) {
							prevNode.nextNode = node;
						} else {
							_firstNode = node;
						}
						prevNode = node;
						if (node is TransitionData) {
							((_transitionByTarget[node.target] ||= { } )[node.propertyName] ||= { } )[TransitionData(node).cyclePhase] = node;
						} else {
							(_dataByTarget[node.target] ||={})[node.propertyName] = node;
						}
					} 
					if (node is TransitionData) {
						node = ruleNode.clone(node);
					} else {
						value = ruleNode.value;	
						if (value && value is XML) {
							value = this.getComplexContent(value);
						}
						node.value = value;
					}
					ruleNode = ruleNode.nextNode;
				}
			}
		} 
		
		protected function applyStyle ( ):void {
			var node:PropertyData = _firstNode;
			var object:Object, target:Object, parsable:IParsable, transitionable:ITransitionable;
			var stylable:IStylable = _stylable;
			var value:*;
			var isParsable:Object = { }, toParse:Array = [], nextNode:PropertyData;;
			while (node) {
				nextNode = node.nextNode;
				try {
					target = node.target == null ? stylable : stylable[node.target];
				} catch ( error:Error ) {
					log(LogLevel.WARN, stylable, error);
					node = nextNode;
					continue;
				}
				value = node.value;
				try {
					if (node is TransitionData) {
						if (target is ITransitionable) {
							ITransitionable(target).setTransition(node.propertyName, TransitionData(node.clone(getPropertyDataObject(node))));
						}
					} else if (value != undefined) {
						if (target is IParsable) {
							IParsable(target).parseProperty(node.propertyName, value);
							if (!isParsable[target]) {
								isParsable[target] = true;
								toParse[toParse.length] = target;
							}
						} else {
							target[node.propertyName] = value;
						}
					}
				} catch ( error:Error ) {
					log(LogLevel.WARN, target, error);
				}
				node = node.nextNode;
			}
			
			for each(target in toParse) {
				IParsable(target).applyParsedProperties();
			}
		}
		
		protected function getComplexContent ( value:XML ):* {
			var object:*;
			if (_complexContent[value] === undefined) {
				object = _complexContent[value] = this.parseComplexContent(value);
			} else {
				object = _complexContent[value];
			}
			return object;
		}
		
		protected function parseComplexContent ( value:XML ):* {
			return ObjectParser.parseXML(value);
		}
		
		public function invalidateRule ( styleRule:StyleRule ):void {
			_invalidatedRules = true;
			this.invalidate();
		}
		
		public function getStyle ( ):void {
			
			if (_disabled) {
				return;
			}
			
			if (_invalidatedCollector) {
				this.collectNodes();
			}
			
			if (_invalidatedRules) {
				this.cacheProperties();
			}
			
			if (_invalidatedState || _invalidatedRules) {
				this.applyStyle();
			}
			
			_invalidatedCollector = _invalidatedState = _invalidatedRules = false;
		}
		
		public function invalidateCollector ( ):void {
			_invalidatedCollector = _invalidatedRules = true;
			this.invalidate();
		}
		
		public function invalidateState ( ):void {
			_invalidatedState = true;
			this.invalidate();
		}
		
		protected function getNode ( fromNode:PropertyData ):PropertyData {
			var target:String = fromNode.target, propertyName:String = fromNode.propertyName;
			if(fromNode is TransitionData) {
				var transitionData:TransitionData = TransitionData(fromNode);
				var byTarget:Object, byPropertyName:Object;
				return (byTarget = _transitionByTarget[target] ) ? ((byPropertyName = byTarget[propertyName]) ? byPropertyName[transitionData.cyclePhase] : null) : null;
			} else {
				return _dataByTarget[target] ? _dataByTarget[target][propertyName] : null;
			}
		}
		
		protected static function getPropertyDataObject ( from:PropertyData ):PropertyData {
			if (from is TransitionData) {
				return _transitionDataObjectPool.length ? _transitionDataObjectPool.shift() : new TransitionData();
			} else {
				return _propertyDataObjectPool.length ? _propertyDataObjectPool.shift() : new PropertyData();
			}
		}
		
		protected static function poolPropertyDataObject ( propertyData:PropertyData ):void {
			propertyData.clear();
			propertyData.prevNode = propertyData.nextNode = null;
			if (propertyData is TransitionData) {
				_transitionDataObjectPool[_transitionDataObjectPool.length] = propertyData;
			} else {
				_propertyDataObjectPool[_propertyDataObjectPool.length] = propertyData;
			}
		}
		
		public function get stylable ( ):IStylable { return _stylable; }
		public function set stylable ( value:IStylable ):void {
			if (_stylable != value) {
				this.setStylable(value);
			}
		}
		
		public function get styleSheetIDs ( ):Array { return _styleSheetIDs; }
		public function set styleSheetIDs ( value:Array ):void {
			this.setStyleSheetIDs(value);
		}
		
		public function get disabled ( ):Boolean { return _disabled; }
		public function set disabled ( value:Boolean ):void {
			if(_disabled != value) {
				_disabled = value;
				this.applyDisabled();
			}
		}
		
	}

}