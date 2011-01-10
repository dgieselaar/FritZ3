package fritz3.document  {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.BevelFilter;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.filters.GradientBevelFilter;
	import flash.filters.GradientGlowFilter;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import fritz3.display.core.DisplayComponentContainer;
	import fritz3.display.core.DisplayValue;
	import fritz3.display.core.DisplayValueType;
	import fritz3.invalidation.InvalidationManager;
	import fritz3.style.invalidation.InvalidatableStyleSheetCollector;
	import fritz3.style.StyleManager;
	import fritz3.utils.object.addClassAlias;
	import fritz3.utils.object.hasClassAlias;
	import fritz3.utils.tween.ftween.FTweenEngine;
	import fritz3.utils.tween.TweenEngine;
	import fritz3.utils.tween.Tweener;
	import ru.etcs.utils.getDefinitionNames;
	/**

	/**
	 * @author Dario Gieselaar
	 * @review 
	 * @copyright Frontier Information Technologies BV
	 * @package fritz3.document
	 * 
	 * [Description]
	*/
	
	public class ApplicationDocument extends DisplayComponentContainer {
		
		protected var _initialized:Boolean;
		
		public function ApplicationDocument ( properties:Object = null ) {
			super(properties);
			if (!stage) {
				this.addEventListener(Event.ADDED_TO_STAGE, this.onStageAdd);
			} else {
				this.initStage();
			}
		}
		
		override protected function initializeComponent ( ):void  {
			if (!stage || _initialized) {
				return;
			}
			_initialized = true;
			this.getClassDefinitions();
			Tweener.engine = this.getTweenEngine();
			super.initializeComponent();
		}
		
		override protected function setDefaultProperties():void {
			super.setDefaultProperties();
			this.preferredWidth = new DisplayValue(100, DisplayValueType.PERCENTAGE);
			this.preferredHeight = new DisplayValue(100, DisplayValueType.PERCENTAGE);
		}
		
		override protected function setInvalidationMethodOrder():void {
			super.setInvalidationMethodOrder();
			_invalidationHelper.insertBefore(this.setDimensions, this.rearrange);
		}
		
		protected function onStageAdd ( e:Event ):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, this.onStageAdd);
			this.initStage();
		}
		
		protected function initStage ( ):void {
			InvalidationManager.init(stage);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, this.onStageResize);
			this.onAdd();
		}
		
		override public function onAdd():void {
			super.onAdd();
			if (_styleSheetCollector) {
				if (_styleSheetCollector is InvalidatableStyleSheetCollector) {
					InvalidatableStyleSheetCollector(_styleSheetCollector).invalidateCollector();
				}
			}
			_invalidationHelper.invalidateMethod(this.setDimensions);
		}
		
		protected function onStageResize ( e:Event ):void {
			this.setDimensions();
		}
		
		protected function setDimensions ( ):void {
			var availableWidth:Number = stage.stageWidth - _marginLeft.getComputedValue(stage.stageWidth) - _marginRight.getComputedValue(stage.stageHeight);
			var availableHeight:Number = stage.stageHeight - _marginTop.getComputedValue(stage.stageHeight) - _marginBottom.getComputedValue(stage.stageHeight);
			var width:Number = _preferredWidth.getComputedValue(availableWidth);
			var height:Number = _preferredHeight.getComputedValue(availableHeight);
			if (!isNaN(_minimumWidth.value)) {
				width = Math.max(_minimumWidth.getComputedValue(availableWidth), width);
			}
			if (!isNaN(_maximumWidth.value)) {
				width = Math.min(_maximumWidth.getComputedValue(availableWidth), width);
			}
			if (!isNaN(_minimumHeight.value)) {
				height = Math.max(_minimumWidth.getComputedValue(availableHeight), height);
			}
			if (!isNaN(_maximumHeight.value)) {
				height = Math.min(_maximumHeight.getComputedValue(availableHeight), height);
			}
			this.width = width; this.height = height;
		}
		
		override public function invalidateLayout():void {
			super.invalidateLayout();
			_invalidationHelper.invalidateMethod(this.setDimensions);
		}
		
		protected function getClassDefinitions ( ):void {
			// define filters
			var classes:Array = this.getNativeDefinitions();
			var i:int, l:int = classes.length, classObject:Class, definition:String, alias:String;
			for (; i < l; ++i) {
				classObject = classes[i];
				definition = getQualifiedClassName(classObject);
				alias = definition.match(/(.*?::)?(.*?)$/)[2];
				if (!hasClassAlias(alias)) {
					addClassAlias(alias, classObject);
				}
			}
			
			var definitions:Array = getDefinitionNames(stage.loaderInfo.bytes, true, false);
			for (i = 0, l = definitions.length; i < l; ++i) {
				definition = definitions[i];
				try {
					classObject = getDefinitionByName(definition) as Class;
					if (!classObject) {
						continue;
					}
					alias = definition.match(/(.*?::)?(.*?)$/)[2];
					// if alias is already registered, override when current 
					// class is part of FritZ3 package
					if (!hasClassAlias(alias) || definition.indexOf("fritz3") == 0) {
						addClassAlias(alias, classObject);
					}
				} catch ( error:Error ) {
					
				}
			}
		}
		
		override protected function applyPreferredHeight ( ):void {
			super.applyPreferredHeight();
			_invalidationHelper.invalidateMethod(this.setDimensions);
		}
		
		override protected function applyPreferredWidth ( ):void {
			super.applyPreferredWidth();
			_invalidationHelper.invalidateMethod(this.setDimensions);
		}
		
		override protected function applyMinimumHeight ( ):void {
			super.applyMinimumHeight();
			_invalidationHelper.invalidateMethod(this.setDimensions);
		}
		
		override protected function applyMaximumHeight ( ):void {
			super.applyMaximumHeight();
			_invalidationHelper.invalidateMethod(this.setDimensions);
		}
		
		override protected function applyMinimumWidth ( ):void {
			super.applyMinimumWidth();
			_invalidationHelper.invalidateMethod(this.setDimensions);
		}
		
		override protected function applyMaximumWidth ( ):void {
			super.applyMaximumWidth();
			_invalidationHelper.invalidateMethod(this.setDimensions);
		}
		
		protected function getNativeDefinitions ( ):Array {
			var array:Array = [
			BevelFilter, BlurFilter, ColorMatrixFilter, DropShadowFilter, GlowFilter, GradientBevelFilter, GradientGlowFilter
			];
			return array;
		}
		
		protected function getTweenEngine ( ):TweenEngine {
			return new FTweenEngine();
		}
		
	}

}