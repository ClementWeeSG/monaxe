package monaxe.reactive.observer;

enum EventOrState<T> {
    Start;
    Complete;
    Event(item: T);
    Error(msg: String);
}