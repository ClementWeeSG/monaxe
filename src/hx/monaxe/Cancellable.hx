package monaxe;

typedef CancelFunction<T> = Observer<T> -> Void;

var cannotCancel = ob -> ob.onError("This is uncancellable!");

var cancelled = ob -> ob.onError("This is already cancelled!");