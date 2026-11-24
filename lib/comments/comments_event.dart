abstract class CommentsEvent {}

class CommentsRequested extends CommentsEvent {}

class CommentsSearched extends CommentsEvent {
  CommentsSearched(this.query);

  final String query;
}
