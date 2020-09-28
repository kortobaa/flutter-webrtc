import 'dart:async';
import 'package:flutter/services.dart';

import 'media_stream.dart';
import 'rtc_rtp_receiver.dart';
import 'rtc_rtp_sender.dart';

import 'utils.dart';

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
  RTCRtpTransceiverInit(this.direction, this.streams);
  factory RTCRtpTransceiverInit.fromMap(Map<dynamic, dynamic> map) {
    return RTCRtpTransceiverInit(
        typeStringToRtpTransceiverDirection[map['direction']],
        map['streamIds']);
  }

  RTCRtpTransceiverDirection direction;
  List<MediaStream> streams;

  Map<String, dynamic> toMap() {
    return {
      'direction': typeRtpTransceiverDirectionToString[direction],
      'streamIds': streams.map((e) => e.id).toList()
    };
  }
}

class RTCRtpTransceiver {
  RTCRtpTransceiver(
      this._id, this._direction, this._mid, this._sender, this._receiver);

  factory RTCRtpTransceiver.fromMap(Map<dynamic, dynamic> map) {
    final transceiver = RTCRtpTransceiver(
        map['transceiverId'],
        typeStringToRtpTransceiverDirection[map['direction']],
        map['mid'],
        RTCRtpSender.fromMap(map['sender']),
        RTCRtpReceiver.fromMap(map['receiver']));
    return transceiver;
  }

  final MethodChannel _channel = WebRTC.methodChannel();
  String _peerConnectionId;
  String _id;
  bool _stop;
  RTCRtpTransceiverDirection _direction;
  String _mid;
  RTCRtpSender _sender;
  RTCRtpReceiver _receiver;

  set peerConnectionId(String id) {
    _peerConnectionId = id;
  }

  RTCRtpTransceiverDirection get currentDirection => _direction;

  String get mid => _mid;

  RTCRtpSender get sender => _sender;

  RTCRtpReceiver get receiver => _receiver;

  bool get stoped => _stop;

  String get transceiverId => _id;

  Future<void> setDirection(RTCRtpTransceiverDirection direction) async {
    try {
      await _channel
          .invokeMethod('rtpTransceiverSetDirection', <String, dynamic>{
        'peerConnectionId': _peerConnectionId,
        'transceiverId': _id,
        'direction': typeRtpTransceiverDirectionToString[direction]
      });
    } on PlatformException catch (e) {
      throw 'Unable to RTCRtpTransceiver::setDirection: ${e.message}';
    }
  }

  Future<RTCRtpTransceiverDirection> getCurrentDirection() async {
    try {
      final response = await _channel.invokeMethod(
          'rtpTransceiverGetCurrentDirection', <String, dynamic>{
        'peerConnectionId': _peerConnectionId,
        'transceiverId': _id
      });
      _direction = typeStringToRtpTransceiverDirection[response['result']];
      return _direction;
    } on PlatformException catch (e) {
      throw 'Unable to RTCRtpTransceiver::getCurrentDirection: ${e.message}';
    }
  }

  Future<void> stop() async {
    try {
      await _channel.invokeMethod('rtpTransceiverStop', <String, dynamic>{
        'peerConnectionId': _peerConnectionId,
        'transceiverId': _id
      });
    } on PlatformException catch (e) {
      throw 'Unable to RTCRtpTransceiver::stop: ${e.message}';
    }
  }
}
