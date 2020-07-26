import 'dart:html' as HTML;

import 'media_stream_track.dart';

class RTCRtpSender {
  final HTML.RtcRtpSender jsSender;
  RTCRtpSender(this.jsSender);

  MediaStreamTrack get track => MediaStreamTrack(jsSender.track);
}
