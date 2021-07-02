import haxe.Timer;
import monaxe.reactive.*;
import monaxe.reactive.FlattenableObservable;
import utest.Assert;

class TestOperations extends utest.Test {

    function testMap(async: utest.Async){
		var startVal: Observable<Int> = 3;
		var cdate = startVal.map(i -> i*2);

		//Check Observable Contract

		async.branch(branch -> {
			var contract: Observer<Int> = ObservableContract.newInstance(branch);
			cdate.subscribe(contract);
		});

		//Check main function

			async.branch(opTest -> {
				cdate.subscribe(evt -> return switch evt {
					case Start: trace("Started");
					case Event(item): 
						Assert.equals(6, item);
						opTest.done();		
					case Complete: 
						trace("Complete");
					case Error(msg):
						throw "Shouldn't throw error: " + msg;
		
				});
			});


	}
	
	
	function testConcat(async: utest.Async){
		var finalResult: Int = 0;
		var left: Observable<Int> = 2;
		var right: Observable<Int> = 3;
		var cdate = left.concat(right);

		//Check Observable Contract

		async.branch(branch -> {
			var contract: Observer<Int> = ObservableContract.newInstance(branch);
			cdate.subscribe(contract);
		});

        //Check main function

		async.branch(opTest -> {
            var isComplete = false;
			var isStarted = false;
			cdate.subscribe(evt -> return switch evt {
				case Start:
					finalResult = 0;	
					Assert.isFalse(isStarted); 
					trace("Started");
					isStarted = true;
				case Event(item): 
					trace("Downstream receives [" + item + "]");
                    finalResult = finalResult + item;	
                    trace(item);
					trace(finalResult);		
				case Complete: 
					Assert.isFalse(isComplete);
					isComplete = true;
					Assert.equals(5, finalResult);
					opTest.done();
				case Error(msg):
					throw "Shouldn't throw error: " + msg;
	
			});
		});


	}

	@:timeout(1000)
	function testFlatten(async: utest.Async){
		var orig = Observable.fromArray([1,3]);
		var lifted: FlattenableObservable<Int> = orig.map(single -> Observable.fromSingle(single));
		var cdate = lifted.flatten();
		var finalResult = 0;

		//Check Observable Contract

		async.branch(branch -> {
			var contract: Observer<Int> = ObservableContract.newInstance(branch);
			cdate.subscribe(contract);
		});

		//Check operation result

		async.branch( opTest -> {
			cdate.subscribe( evt -> return switch evt {
				case Start: finalResult = 0;
				case Event(num): 
					trace(num);
					finalResult+=num;
				case Complete:
					Assert.equals(4, finalResult);
					trace("Test Complete");
					opTest.done();
				case Error(msg): 
					
				throw msg;
			});
		});


	}
	
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
					Assert.equals("2,3", results.join(","));
					opTest.done();
				case Error(msg):
					throw "Shouldn't throw error: " + msg;
	
			});
		});		
	}

}