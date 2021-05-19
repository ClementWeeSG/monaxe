package monaxe.reactive.observable;

import monaxe.reactive.Subscription;
import monaxe.execution.Cancellable;
import monaxe.reactive.Observer;

typedef Subscribe<T> = Observer<T> -> Subscription<T>;