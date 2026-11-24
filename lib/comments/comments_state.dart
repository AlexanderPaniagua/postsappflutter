import '../load_status.dart';
import '../models/comment.dart';

class CommentsState {
  CommentsState({
    this.status = LoadStatus.initial,
    this.comments = const [],
    this.query = '',
  });

  final LoadStatus status;
  final List<Comment> comments;
  final String query;

  List<Comment> get filteredComments {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return comments;
    return comments
        .where((c) =>
            c.body.toLowerCase().contains(q) ||
            c.name.toLowerCase().contains(q) ||
            c.email.toLowerCase().contains(q))
        .toList();
  }

  CommentsState copyWith({
    LoadStatus? status,
    List<Comment>? comments,
    String? query,
  }) {
    return CommentsState(
      status: status ?? this.status,
      comments: comments ?? this.comments,
      query: query ?? this.query,
    );
  }
}
