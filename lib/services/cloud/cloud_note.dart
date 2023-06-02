import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:mynotes2/services/cloud/cloud_storage_constants.dart';
@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;
  final DateTime timestamp;

  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
    required this.timestamp,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName] as String,
        timestamp = (snapshot.data()[fieldTimeStamp] as Timestamp?)?.toDate() ?? DateTime.now();
}
