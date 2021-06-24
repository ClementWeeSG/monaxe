import monaxe.reactive.Observer;
import monaxe.reactive.observer.EventOrState;
import utest.Assert;

class ObservableContract{
    public static function newInstance<T>(async: utest.Async): Observer<T>{
        var isComplete = false;
        var isConnected = false;

        return (es: EventOrState<T>) -> {

            switch es {
                case Complete: 
                    Assert.isFalse(isComplete); // Observable can only terminate once.
                    isComplete = true;
                    async.done();
                case Start: 
                    Assert.isFalse(isComplete);
                    Assert.isFalse(isConnected);
                    isConnected = true;
                case Event(_):
                    Assert.isTrue(isConnected);
                    Assert.isFalse(isComplete);
                case Error(_):
                    if(!isComplete) {
                        isComplete = true;
                        Assert.isTrue(isComplete);
                        async.done();
                    }                
            }

        }
    }
}