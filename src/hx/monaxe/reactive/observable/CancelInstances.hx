package monaxe.reactive.observable;

class CancelInstances{
    static public function cannotCancel<T>(observer: Observer<T>){
        return () -> observer.onError("This observable cannot be cancelled!");
    }

    static public function alreadyCancelled<T>(observer: Observer<T>){
        return () -> observer.onError("This observable has already been cancelled!");
    }
}