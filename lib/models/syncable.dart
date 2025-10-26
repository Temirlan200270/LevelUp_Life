// lib/models/syncable.dart
import 'package:json_annotation/json_annotation.dart';
enum SyncStatus { synced, pending, failed }

mixin Syncable {
  @JsonKey(includeFromJson: false, includeToJson: false)
  SyncStatus syncStatus = SyncStatus.synced;
  DateTime? lastSync;
}