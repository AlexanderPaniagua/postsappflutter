abstract class PostsEvent {}

class PostsRequested extends PostsEvent {}

class PostsRefreshed extends PostsEvent {}

class PostsSearched extends PostsEvent {
  PostsSearched(this.query);

  final String query;
}
