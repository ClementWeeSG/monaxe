package monaxe.reactive.observable;

class SubscriptionOps{
    static public function map<T,U>(subscription: Subscription<T>, fn: T -> U){

    }
}

class MappedSubscription<Dest, Origin>{
    var fn: Origin -> Dest;
    var empty: Int;
}