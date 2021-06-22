package monaxe.execution;

typedef Cancellable = { var cancel: Cancel;}

var blankCancellable: Cancellable = {cancel: () -> {}};