import monaxe.reactive.Observable;

import utest.Assert;

class TestMain {
	static function main() {
		utest.UTest.run([new TestCase(), new TestCase2()]);
	}
}

class TestCase extends utest.Test {
	function testSuccess() {
		Assert.isTrue(true);
	}

	function testFailure() {
		Assert.equals("A", "B");
		Assert.isTrue(true);
	}

	function testError() {
		throw "failure";
	}

	function testEmpty() {}

	@Ignored("Description")
	function testIgnore() {}
}

class TestCase2 extends utest.Test {
	function testSuccess() {
		Assert.isTrue(true);
	}
}