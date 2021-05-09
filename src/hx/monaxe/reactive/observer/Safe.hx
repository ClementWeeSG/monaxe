package monaxe.reactive;

class Safe{
    public static function protect<T>(unsafe: Observer<T>): Observe<T>{
        var isComplete = false;
        return (es: EventOrState<T>) -> {

            switch es {
                case Complete: 
                    if (isComplete) unsafe.onError("Already completed!");
                    else {
                        isComplete = true;
                        unsafe.onComplete();
                    }
                case Start: unsafe.onStart();
                case Event(data):
                    if(isComplete) unsafe.onError("Already Completed! Cannot receive any more events!");
                    else unsafe.onData(data);
                case Error(msg):
                    unsafe.onError(msg);
                    if(!isComplete) {
                        isComplete = true;
                        unsafe.onComplete();
                    }                
            }

        }
    }
}