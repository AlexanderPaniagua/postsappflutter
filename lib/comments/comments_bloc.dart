import 'package:flutter_bloc/flutter_bloc.dart';

import '../load_status.dart';
import '../posts_repository.dart';
import 'comments_event.dart';
import 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc(this.repository, this.postId) : super(CommentsState()) {
    on<CommentsRequested>((event, emit) async {
      emit(state.copyWith(status: LoadStatus.loading));
      try {
        final comments = await repository.getComments(postId);
        emit(state.copyWith(status: LoadStatus.success, comments: comments));
      } catch (e) {
        emit(state.copyWith(status: LoadStatus.failure));
      }
    });
    on<CommentsSearched>((event, emit) {
      emit(state.copyWith(query: event.query));
    });
  }

  final PostsRepository repository;
  final int postId;
}
