import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import 'api_service.dart';
import 'posts/posts_page.dart';
import 'posts_repository.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => PostsRepository(ApiService()),
      child: MaterialApp(
        title: 'Posts',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const PostsPage(),
      ),
    );
  }
}
