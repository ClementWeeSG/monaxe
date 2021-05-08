package monaxe;

interface Observer<T> {
    function onData(item: T): Void;
    function onError(err: String): Void;
    function onComplete(): Void;
}