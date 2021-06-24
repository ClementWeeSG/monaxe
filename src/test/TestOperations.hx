import monaxe.reactive.*;
import utest.Assert;

class TestOperations extends utest.Test {

    function testFlatMap(async: utest.Async) {

		var finalResult: Int = 0;

		var orig: Observable<Int> = 2;
        var cdate = orig.flatMap(i -> [i, i+1]);

        //Check Observable Contract

		async.branch(branch -> {
			var contract: Observer<Int> = ObservableContract.newInstance(branch);
			cdate.subscribe(contract);
		});

        //Check main function

		async.branch(opTest -> {
            var results = [];
			cdate.subscribe(evt -> return switch evt {
				case Start: finalResult = 0;
				case Event(item): 
                    results.push(item);	
                    trace(item);		
				case Complete: 
					Assert.equals([2,3], results);
					opTest.done();
				case Error(msg):
					throw "Shouldn't throw error: " + msg;
	
			});
		});		
	}

}