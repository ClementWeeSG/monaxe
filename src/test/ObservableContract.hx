import monaxe.reactive.Observer;
import monaxe.reactive.observer.EventOrState;
import utest.Assert;

class ObservableContract{
    public static function instance<T>(): Observer<T>{
        var isComplete = false;
        var isConnected = false;

        return (es: EventOrState<T>) -> {

            switch es {
                case Complete: 
                    Assert.isFalse(isComplete);
                    isComplete = true;
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
                    }                
            }

        }
    }
}