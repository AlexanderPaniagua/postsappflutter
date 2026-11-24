import '../load_status.dart';
import '../models/photo.dart';

class AlbumState {
  AlbumState({this.status = LoadStatus.initial, this.photos = const []});

  final LoadStatus status;
  final List<Photo> photos;
}
