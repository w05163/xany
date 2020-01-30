typedef void RemoveListener();

typedef void Handler<T>(T data);

abstract class __EventEmitter__ {
  Map<String, List<Function>> events;

  RemoveListener on<T>(String event, Handler<T> handler);

  void once<T>(String event, Handler<T> handler);

  void off(String event);

  void clear();

  void emit(String event, [dynamic data]);
}

class EventEmitter extends __EventEmitter__ {
  ///storage for the event handler
  Map<String, List<Function>> _events = new Map();

  ///proxy the private property, make it readonly. cannot modify from outside
  Map<String, List<Function>> get events => _events;

  EventEmitter() {}

  ///listen the event,it will return a function to cancel this listening
  RemoveListener on<T>(String event, Handler<T> handler) {
    final List eventContainer =
        _events.putIfAbsent(event, () => new List<Function>());

    void offThisListener() {
      eventContainer.remove(handler);
    }

    if (eventContainer.indexOf(handler) == -1) eventContainer.add(handler);

    return offThisListener;
  }

  ///listen the event once,it will remove listening once it trigger
  RemoveListener once<T>(String event, Handler<T> handler) {
    final List eventContainer =
        _events.putIfAbsent(event, () => new List<Function>());
    void handlerPox(dynamic data) {
      handler(data);
      this.off(event);
    }

    eventContainer.add(handlerPox);
    void offThisListener() {
      eventContainer.remove(handlerPox);
    }

    return offThisListener;
  }

  /// remove a event listening
  void off(String event) {
    _events.remove(event);
  }

  ///emit a event with a optional data
  void emit(String event, [dynamic data]) {
    final List eventContainer = _events[event] ?? [];
    eventContainer.forEach((handler) {
      if (handler is Function) handler(data);
    });
  }

  ///clear the all listening
  void clear() {
    _events.clear();
  }
}
