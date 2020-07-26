import 'dart:js_util' as JSUtils;
import 'dart:js' as JS;

import 'media_stream.dart';
import 'rtc_rtp_sender.dart';
import 'rtc_rtp_receiver.dart';

enum RTCRtpTransceiverDirection {
  RTCRtpTransceiverDirectionSendRecv,
  RTCRtpTransceiverDirectionSendOnly,
  RTCRtpTransceiverDirectionRecvOnly,
  RTCRtpTransceiverDirectionInactive,
}

final typeStringToRtpTransceiverDirection =
    <String, RTCRtpTransceiverDirection>{
  'sendrecv': RTCRtpTransceiverDirection.RTCRtpTransceiverDirectionSendRecv,
  'sendonly': RTCRtpTransceiverDirection.RTCRtpTransceiverDirectionSendOnly,
  'recvonly': RTCRtpTransceiverDirection.RTCRtpTransceiverDirectionRecvOnly,
  'inactive': RTCRtpTransceiverDirection.RTCRtpTransceiverDirectionInactive,
};

final typeRtpTransceiverDirectionToString =
    <RTCRtpTransceiverDirection, String>{
  RTCRtpTransceiverDirection.RTCRtpTransceiverDirectionSendRecv: 'sendrecv',
  RTCRtpTransceiverDirection.RTCRtpTransceiverDirectionSendOnly: 'sendonly',
  RTCRtpTransceiverDirection.RTCRtpTransceiverDirectionRecvOnly: 'recvonly',
  RTCRtpTransceiverDirection.RTCRtpTransceiverDirectionInactive: 'inactive',
};

class RTCRtpTransceiverInit {
  RTCRtpTransceiverDirection direction;
  // TODO: add sendEncodings field
  List<MediaStream> streams;

  Map<String, dynamic> toMap() {
    return {
      'direction': typeRtpTransceiverDirectionToString[this.direction],
      'streams': streams.map((e) => e.jsStream),
    };
  }

  RTCRtpTransceiverInit(this.direction, this.streams);
}

class RTCRtpTransceiver {
  final JS.JsObject jsTransceiver;
  RTCRtpTransceiver(this.jsTransceiver);

  String get mid {
    if (JSUtils.hasProperty(jsTransceiver, "mid")) {
      return JSUtils.getProperty(jsTransceiver, "mid");
    }
    return null;
  }

  RTCRtpSender get sender {
    if (JSUtils.hasProperty(jsTransceiver, "sender")) {
      return RTCRtpSender(JSUtils.getProperty(jsTransceiver, "sender"));
    }
    return null;
  }

  RTCRtpReceiver get receiver {
    if (JSUtils.hasProperty(jsTransceiver, "receiver")) {
      return RTCRtpReceiver(JSUtils.getProperty(jsTransceiver, "receiver"));
    }
    return null;
  }
}
