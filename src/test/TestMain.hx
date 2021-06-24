import monaxe.reactive.Observer;
import monaxe.reactive.Observable;

import utest.Assert;

class TestMain {
	static function main() {
		utest.UTest.run([new FactoryTestCases(), new TestOperations()]);
	}
}