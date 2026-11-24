import 'package:flutter_bloc/flutter_bloc.dart';

import '../load_status.dart';
import '../posts_repository.dart';
import 'posts_event.dart';
import 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc(this.repository) : super(PostsState()) {
    on<PostsRequested>(_onRequested);
    on<PostsRefreshed>(_onRefreshed);
    on<PostsSearched>((event, emit) {
      emit(state.copyWith(query: event.query));
    });
  }

  final PostsRepository repository;

  Future<void> _onRequested(
      PostsRequested event, Emitter<PostsState> emit) async {
    emit(state.copyWith(status: LoadStatus.loading));
    try {
      final posts = await repository.getPosts();
      emit(state.copyWith(status: LoadStatus.success, posts: posts));
    } catch (e) {
      emit(state.copyWith(status: LoadStatus.failure));
    }
  }

  Future<void> _onRefreshed(
      PostsRefreshed event, Emitter<PostsState> emit) async {
    emit(state.copyWith(refreshing: true, refreshFailed: false));
    try {
      final posts = await repository.getPosts(refresh: true);
      emit(state.copyWith(
        status: LoadStatus.success,
        posts: posts,
        refreshing: false,
      ));
    } catch (e) {
      // keep the old list on screen if we have one
      emit(state.copyWith(
        status: state.posts.isEmpty ? LoadStatus.failure : state.status,
        refreshing: false,
        refreshFailed: true,
      ));
    }
  }
}
