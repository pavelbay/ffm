
import 'dart:async';

import 'package:friend_for_me/events.dart';

class MainBloc {

  int _progress = 0;

  final _progressStateController = StreamController<int>();
  StreamSink<int> get _progressSink => _progressStateController.sink;

  Stream<int> get progress => _progressStateController.stream;

  final _progressEventController = StreamController<PicEvent>();
  Sink<PicEvent> get progressEventSink => _progressEventController.sink;

  MainBloc() {
    _progressEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(PicEvent event) {
    if (event is ProgressEvent) {
      _progress++;
      _progressSink.add(_progress);
    }
  }

  void dispose() {
    _progressStateController.close();
    _progressEventController.close();
  }
}