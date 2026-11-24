import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:postsapp/api_service.dart';
import 'package:postsapp/models/post.dart';
import 'package:postsapp/posts/post_card.dart';
import 'package:postsapp/posts/posts_page.dart';
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

Widget app(PostsRepository repo) {
  return RepositoryProvider.value(
    value: repo,
    child: const MaterialApp(home: PostsPage()),
  );
}

void main() {
  testWidgets('shows a card per post', (tester) async {
    await tester.pumpWidget(app(FakeRepo()));
    await tester.pumpAndSettle();
    expect(find.byType(PostCard), findsNWidgets(2));
  });

  testWidgets('search filters the list', (tester) async {
    await tester.pumpWidget(app(FakeRepo()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'streams');
    await tester.pump();
    expect(find.byType(PostCard), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'kotlin');
    await tester.pump();
    expect(find.text('No hay resultados'), findsOneWidget);
  });

  testWidgets('retry after an error', (tester) async {
    final repo = FakeRepo()..fail = true;
    await tester.pumpWidget(app(repo));
    await tester.pumpAndSettle();
    expect(find.text('Reintentar'), findsOneWidget);

    repo.fail = false;
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(find.byType(PostCard), findsNWidgets(2));
  });
}
