package monaxe.reactive.observable;

import monaxe.execution.Cancellable;
import monaxe.reactive.Observer;

typedef Subscribe<T> = Observer<T> -> Cancellable;