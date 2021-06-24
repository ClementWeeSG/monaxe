import monaxe.reactive.*;
import utest.Assert;

class FactoryTestCases extends utest.Test {

    function testEmpty(async: utest.Async) {

		var finalResult: Int = 0;

		var cdate: Observable<Int> = Observable.empty();
		async.branch(branch -> {
			var contract: Observer<Int> = ObservableContract.newInstance(branch);
			cdate.subscribe(contract);
		});
		async.branch(secondTest -> {
			cdate.subscribe(evt -> return switch evt {
				case Start: finalResult = 0;
				case Event(_): 
					secondTest.done();
					throw "not supposed to have items";				
				case Complete: 
					Assert.equals(0, finalResult);
					secondTest.done();
				case Error(msg): 
					secondTest.done();
					throw "Shouldn't throw error: " + msg;
	
			});
		});		
	}

}