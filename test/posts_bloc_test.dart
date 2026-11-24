import 'package:flutter_test/flutter_test.dart';
import 'package:postsapp/api_service.dart';
import 'package:postsapp/load_status.dart';
import 'package:postsapp/models/post.dart';
import 'package:postsapp/posts/posts_bloc.dart';
import 'package:postsapp/posts/posts_event.dart';
import 'package:postsapp/posts_repository.dart';

class FakeRepo extends PostsRepository {
  FakeRepo() : super(ApiService());

  bool fail = false;

  @override
  Future<List<Post>> getPosts({bool refresh = false}) async {
    if (fail) throw Exception('error');
    return [
      Post(id: 1, userId: 1, title: 'Flutter tips', body: 'Use const widgets'),
      Post(id: 2, userId: 1, title: 'Dart streams', body: 'Async all the way'),
    ];
  }
}

void main() {
  test('loads posts', () async {
    final bloc = PostsBloc(FakeRepo());
    bloc.add(PostsRequested());
    await bloc.stream.firstWhere((s) => s.status == LoadStatus.success);
    expect(bloc.state.posts.length, 2);
  });

  test('shows failure when request fails', () async {
    final repo = FakeRepo()..fail = true;
    final bloc = PostsBloc(repo);
    bloc.add(PostsRequested());
    await bloc.stream.firstWhere((s) => s.status == LoadStatus.failure);
    expect(bloc.state.posts, isEmpty);
  });

  test('search filters by title and body', () async {
    final bloc = PostsBloc(FakeRepo());
    bloc.add(PostsRequested());
    await bloc.stream.firstWhere((s) => s.status == LoadStatus.success);

    bloc.add(PostsSearched('STREAMS'));
    await bloc.stream.first;
    expect(bloc.state.filteredPosts.map((p) => p.id), [2]);

    bloc.add(PostsSearched('const'));
    await bloc.stream.first;
    expect(bloc.state.filteredPosts.map((p) => p.id), [1]);
  });

  test('failed refresh keeps the posts', () async {
    final repo = FakeRepo();
    final bloc = PostsBloc(repo);
    bloc.add(PostsRequested());
    await bloc.stream.firstWhere((s) => s.status == LoadStatus.success);

    repo.fail = true;
    bloc.add(PostsRefreshed());
    final state = await bloc.stream.firstWhere((s) => !s.refreshing);
    expect(state.refreshFailed, true);
    expect(state.posts.length, 2);
  });
}
