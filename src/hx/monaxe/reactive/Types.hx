package monaxe.reactive;

import monaxe.reactive.observer.EventOrState;
import monaxe.execution.Ack;

typedef Sink<T> = T -> Ack;
typedef Observer<T> = EventOrState<T> -> Ack;
typedef VoidSink = Void -> Ack;

typedef Unsub = Void -> Void;

final nullSink: VoidSink = () -> Continue;

typedef Subscribe = Observer<T> -> Unsub;


