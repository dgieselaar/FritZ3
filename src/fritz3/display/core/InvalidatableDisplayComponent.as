package fritz3.display.core {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import fritz3.base.injection.Injectable;
	import fritz3.base.parser.Parsable;
	import fritz3.base.parser.ParseHelper;
	import fritz3.base.parser.PropertyParser;
	import fritz3.base.transition.Transitionable;
	import fritz3.base.transition.TransitionData;
	import fritz3.base.transition.TransitionType;
	import fritz3.invalidation.Invalidatable;
	import fritz3.invalidation.InvalidationHelper;
	import fritz3.invalidation.InvalidationManager;
	import fritz3.style.PropertyData;
	import fritz3.utils.tween.hasTween;
	import fritz3.utils.tween.removeTween;
	import fritz3.utils.tween.tween;
	import org.osflash.signals.IDispatcher;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class InvalidatableDisplayComponent extends Sprite implements Invalidatable, Parsable, Injectable, Addable, Transitionable, Cyclable {
		
		protected var _invalidationHelper:InvalidationHelper;
		protected var _priority:int;
		
		protected var _parameters:Object;
		
		protected var _properties:Object = { };
		
		protected var _parseHelper:ParseHelper;
		protected var _propertyParsers:Object = { };
		
		protected var _transitions:Object = { };
		
		protected var _parentComponent:Addable;
		
		protected var _cyclePhase:String = CyclePhase.CONSTRUCTED;
		protected var _cycle:int = 1;
		
		public function InvalidatableDisplayComponent ( parameters:Object = null ) {
			super();
			_parameters = parameters;
			this.initializeComponent();
		}
		
		protected function initializeComponent ( ):void {
			this.initializeDependencies();
			this.setInvalidationMethodOrder();
			this.setParsers();
			this.setDefaultProperties();
			this.applyParameters();
			this.setCyclePhase(CyclePhase.INITIALIZED);
		}
		
		public function onAdd ( ):void {
			if (_cyclePhase == CyclePhase.REMOVED) {
				this.setCycle(_cycle + 1);
			}
			this.setCyclePhase(CyclePhase.ADDED);
		}
		
		public function onRemove ( ):void {
			this.setCyclePhase(CyclePhase.REMOVED);
		}
		
		protected function initializeDependencies ( ):void {
			this.initializeInvalidation();
			this.initializeParseHelper();
		}
		
		protected function setInvalidationMethodOrder ( ):void {
			
		}
		
		protected function setParsers ( ):void {
			
		}
		
		protected function setDefaultProperties ( ):void {
			
		}
		
		protected function setCyclePhase ( cyclePhase:String ):void {
			_cyclePhase = cyclePhase;
		}
		
		protected function setCycle ( cycle:int ):void {
			_cycle = cycle;
		}
		
		protected function initializeInvalidation ( ):void {
			_invalidationHelper = new InvalidationHelper();
		}
		
		protected function initializeParseHelper ( ):void {
			_parseHelper = new ParseHelper();
		}
		
		public function parseProperty ( propertyName:String, value:* ):void {
			this.cacheParsedProperty(propertyName, value);
		}
		
		protected function cacheParsedProperty ( propertyName:String, value:* ):void {
			_parseHelper.setProperty(propertyName, value);
		}
		
		public function applyParsedProperties ( ):void {
			var node:PropertyData = _parseHelper.firstNode;
			while (node) {
				this.setProperty(node.propertyName, node.value);
				node = node.nextNode;
			}
			_parseHelper.reset();
		}
		
		public function setProperty ( propertyName:String, value:* ):void {
			_properties[propertyName] = value;
			var transitionData:TransitionData = _transitions[propertyName]; 
			if (!transitionData || transitionData.cyclePhase != _cyclePhase) {
				if (hasTween(this, propertyName)) {
					removeTween(this, propertyName);
				} 
				this[propertyName] = value;
			} else {
				if (transitionData.type == TransitionType.TO) {
					transitionData.value = value;
				}
				tween(this, propertyName, transitionData);
			}
		}
		
		public function setTransition ( propertyName:String, transitionData:TransitionData ):void {
			_transitions[propertyName] = transitionData;
		}
		
		protected function applyParameters ( ):void {
			for (var name:String in _parameters) {
				this.parseProperty(name, _parameters[name]);
			}
			this.applyParsedProperties();
		}
		
		protected function addParser ( propertyName:String, parser:PropertyParser ):void {
			_propertyParsers[propertyName] = parser;
		}
		
		protected function getParser ( propertyName:String ):PropertyParser {
			return _propertyParsers[propertyName];
		}
		
		protected function removeParser ( propertyName:String ):void {
			delete _propertyParsers[propertyName];
		}
		
		protected function setPriority ( value:int ):void {
			_priority = value;
			_invalidationHelper.priority = value;
		}
		
		protected function setParentComponent ( parentComponent:Addable ):void {
			_parentComponent = parentComponent;
		}
		
		public function executeInvalidatedMethods():void{
			_invalidationHelper.executeInvalidatedMethods();
		}
		
		public function get priority ( ):int { return _priority; }
		public function set priority ( value:int ):void{
			if (_priority != value) {
				this.setPriority(value);
			}
		}
		
		public function get properties ( ):Object { return _properties; }
		
		public function get parentComponent ( ):Addable { return _parentComponent; }
		public function set parentComponent ( value:Addable ):void {
			if (_parentComponent != value) {
				this.setParentComponent(value);
			}
		}
		
		public function get cyclePhase ( ):String { return _cyclePhase; }
		public function set cyclePhase ( value:String ):void {
			_cyclePhase = value;
		}
		
		public function get cycle ( ):int { return _cycle; }
		public function set cycle ( value:int ):void {
			_cycle = value;
		}
	}

}