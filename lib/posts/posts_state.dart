import '../load_status.dart';
import '../models/post.dart';

class PostsState {
  PostsState({
    this.status = LoadStatus.initial,
    this.posts = const [],
    this.query = '',
    this.refreshing = false,
    this.refreshFailed = false,
  });

  final LoadStatus status;
  final List<Post> posts;
  final String query;
  final bool refreshing;
  final bool refreshFailed;

  List<Post> get filteredPosts {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return posts;
    return posts
        .where((p) =>
            p.title.toLowerCase().contains(q) ||
            p.body.toLowerCase().contains(q))
        .toList();
  }

  PostsState copyWith({
    LoadStatus? status,
    List<Post>? posts,
    String? query,
    bool? refreshing,
    bool? refreshFailed,
  }) {
    return PostsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      query: query ?? this.query,
      refreshing: refreshing ?? this.refreshing,
      refreshFailed: refreshFailed ?? this.refreshFailed,
    );
  }
}
