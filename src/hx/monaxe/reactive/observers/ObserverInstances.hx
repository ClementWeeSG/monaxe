package monaxe.reactive.observers;

class ObserverInstances {
    var traceO: Observe<Void> =  evt -> switch evt {
        case Event(msg): trace(msg);
        case _ : {};
    }
}