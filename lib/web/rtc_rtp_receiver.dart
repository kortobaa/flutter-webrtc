import 'dart:html' as HTML;

import 'media_stream_track.dart';

enum RTCRtpMediaType {
  RTCRtpMediaTypeAudio,
  RTCRtpMediaTypeVideo,
  RTCRtpMediaTypeData,
}

final typeRTCRtpMediaTypeToString = <RTCRtpMediaType, String>{
  RTCRtpMediaType.RTCRtpMediaTypeAudio: 'audio',
  RTCRtpMediaType.RTCRtpMediaTypeVideo: 'video',
  RTCRtpMediaType.RTCRtpMediaTypeData: 'data',
};

class RTCRtpReceiver {
  final HTML.RtcRtpReceiver jsReceiver;
  RTCRtpReceiver(this.jsReceiver);

  MediaStreamTrack get track => MediaStreamTrack(jsReceiver.track);

  List<RTCRtpContributingSource> getContributingSources() => this
      .jsReceiver
      .getContributingSources()
      .map((e) => RTCRtpContributingSource(e));
}

class RTCRtpContributingSource {
  final HTML.RtcRtpContributingSource jsContributingSource;
  RTCRtpContributingSource(this.jsContributingSource);

  int get source => this.jsContributingSource.source;

  num get timestamp => this.jsContributingSource.timestamp;
}
