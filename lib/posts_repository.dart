import 'api_service.dart';
import 'models/comment.dart';
import 'models/photo.dart';
import 'models/post.dart';

class PostsRepository {
  PostsRepository(this.api);

  final ApiService api;

  List<Post>? _posts;
  final Map<int, List<Comment>> _comments = {};
  final Map<int, List<Photo>> _photos = {};

  Future<List<Post>> getPosts({bool refresh = false}) async {
    if (_posts != null && !refresh) return _posts!;
    final data = await api.get('/posts');
    _posts = data.map((e) => Post.fromJson(e)).toList();
    return _posts!;
  }

  Future<List<Comment>> getComments(int postId) async {
    if (_comments[postId] != null) return _comments[postId]!;
    final data = await api.get('/posts/$postId/comments');
    _comments[postId] = data.map((e) => Comment.fromJson(e)).toList();
    return _comments[postId]!;
  }

  // each post has an album with the same id
  Future<List<Photo>> getPhotos(int postId) async {
    if (_photos[postId] != null) return _photos[postId]!;
    final data = await api.get('/albums/$postId/photos');
    _photos[postId] = data.map((e) => Photo.fromJson(e)).toList();
    return _photos[postId]!;
  }
}
