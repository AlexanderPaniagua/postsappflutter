import 'package:flutter_bloc/flutter_bloc.dart';

import '../load_status.dart';
import '../posts_repository.dart';
import 'album_state.dart';

class AlbumCubit extends Cubit<AlbumState> {
  AlbumCubit(this.repository, this.postId) : super(AlbumState());

  final PostsRepository repository;
  final int postId;

  Future<void> load() async {
    emit(AlbumState(status: LoadStatus.loading));
    try {
      final photos = await repository.getPhotos(postId);
      emit(AlbumState(status: LoadStatus.success, photos: photos));
    } catch (e) {
      emit(AlbumState(status: LoadStatus.failure));
    }
  }
}
