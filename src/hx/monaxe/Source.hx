package monaxe;

typedef Source<T> = {
    onStart: Void -> Void,
    onData: T -> Void,
    onComplete: Void -> Void,
    onError: String -> Void
}