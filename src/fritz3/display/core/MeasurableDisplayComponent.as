package fritz3.display.core {
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class MeasurableDisplayComponent extends PositionableDisplayComponent {
		
		protected var _measuredWidth:Number = 0;
		protected var _measuredHeight:Number = 0;
		
		public function MeasurableDisplayComponent ( parameters:Object = null ) {
			super(properties);
		}
		
		override protected function setInvalidationMethodOrder():void {
			super.setInvalidationMethodOrder();
			_invalidationHelper.insertBefore(this.measureDimensions, this.dispatchDisplayInvalidation);
		}
		
		protected function measureDimensions ( ):void {
			var measuredWidth:Number = int(this.getMeasuredWidth());
			var measuredHeight:Number = int(this.getMeasuredHeight());
			
			if (measuredWidth != _measuredWidth) {
				_measuredWidth = measuredWidth;
				this.updateDisplayValue("preferredWidth", true);
				this.updateDisplayValue("minimumWidth", true);
				this.updateDisplayValue("maximumWidth", true);
			}
			if (measuredHeight != _measuredHeight) {
				_measuredHeight = measuredHeight;
				this.updateDisplayValue("preferredHeight", true);
				this.updateDisplayValue("minimumHeight", true);
				this.updateDisplayValue("maximumHeight", true);
			}
		}
		
		protected function getMeasuredWidth ( ):Number {
			return 0;
		}
		
		protected function getMeasuredHeight ( ):Number {
			return 0;
		}
		
		override protected function applyWidth():void {
			super.applyWidth();
		}
		
		override protected function applyPreferredWidth ( ):void {
			super.applyPreferredWidth();
			this.updateDisplayValue("preferredWidth", false);
		}
			
		override protected function applyPreferredHeight():void {
			super.applyPreferredHeight();
			this.updateDisplayValue("preferredHeight", false);
		}
		
		override protected function applyMinimumWidth ( ):void {
			super.applyMinimumWidth();
			this.updateDisplayValue("minimumWidth", false);
		}
		
		override protected function applyMaximumWidth ( ):void {
			super.applyMaximumWidth();
			this.updateDisplayValue("maximumWidth", false);
		}
		
		override protected function applyMinimumHeight ( ):void {
			super.applyMinimumHeight();
			this.updateDisplayValue("minimumHeight", false);
		}
		
		override protected function applyMaximumHeight ( ):void {
			super.applyMaximumHeight();
			this.updateDisplayValue("maximumHeight", false);
		}
		
		protected function updateDisplayValue ( propertyName:String, apply:Boolean ):void {
			var displayValue:DisplayValue = DisplayValue(this[propertyName]);
			if (displayValue.valueType != DisplayValueType.AUTO) {
				return;
			}
			if (apply) {
				displayValue.setValue(this.getAutoSize(propertyName));
				this[propertyName] = displayValue;
			} else {
				displayValue.value = this.getAutoSize(propertyName);
			}
		}
		
		override protected function getAutoSize ( propertyName:String ):Number {
			var size:Number;
			switch(propertyName) {
				default:
				size = super.getAutoSize(propertyName);
				break;
				
				case "preferredWidth":
				case "minimumWidth":
				case "maximumWidth":
				size = _measuredWidth;
				break;
				
				case "preferredHeight":
				case "minimumHeight":
				case "maximumHeight":
				size = _measuredHeight;
				break;
			}
			return size;
		}
		
	}

}