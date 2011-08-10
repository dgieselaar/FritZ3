package test {
	import fritz3.base.parser.IPropertyParser;
	/**
	 * ...
	 * @author Dario Gieselaar
	 */
	public class ParserTestRunner extends TestRunner {
		
		public function ParserTestRunner() {
			
		}
		
		protected function getTests ( ):Array {
			return [];
		}
		
		protected function assertEquals ( result:Object, expectedResult:Object  ):Boolean {
			return false;
		}
		
		protected function getParser ( ):IPropertyParser {
			return null;
		}
		
		override protected function runDesignatedTest():void {
			super.runDesignatedTest();
			
			var tests:Array = this.getTests();
			var tst:Object, result:Object, succes:Boolean;
			var numSucceeded:int, numError:int, numTotal:int;
			var parser:IPropertyParser = this.getParser();
			for (var i:int, l:int = tests.length; i < l; ++i) {
				tst = tests[i];
				result = parser.parseValue(tst.value);
				succes = this.assertEquals(result, tst.expectedResult);
				numTotal++;
				if (succes) {
					numSucceeded++;
				} else {
					numError++;
					trace("Error: " + tst.value + " (expected " + tst.expectedResult + ", got " + result + ")");
				}
			}
			
			trace("Ran " + numTotal + " tests: " + (numError ? (numError + " errors") : " All OK"));
			
		}
		
		override protected function getTimeout():int {
			return 0;
		}
		
		override protected function getMaxIterations():int {
			return 1;
		}
	}

}