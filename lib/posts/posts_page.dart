import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../album/album_page.dart';
import '../comments/comments_page.dart';
import '../load_status.dart';
import '../posts_repository.dart';
import '../widgets/search_app_bar.dart';
import '../widgets/status_views.dart';
import 'post_card.dart';
import 'posts_bloc.dart';
import 'posts_event.dart';
import 'posts_state.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PostsBloc(context.read<PostsRepository>())..add(PostsRequested()),
      child: const PostsView(),
    );
  }
}

class PostsView extends StatelessWidget {
  const PostsView({super.key});

  Future<void> _refresh(BuildContext context) async {
    final bloc = context.read<PostsBloc>();
    bloc.add(PostsRefreshed());
    final state = await bloc.stream.firstWhere((s) => !s.refreshing);
    if (state.refreshFailed && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo actualizar la lista.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        title: 'Post',
        hint: 'Buscar Post',
        onChanged: (text) => context.read<PostsBloc>().add(PostsSearched(text)),
      ),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          if (state.status == LoadStatus.failure) {
            return ErrorView(
              message: 'No se pudieron cargar los posts.',
              onRetry: () => context.read<PostsBloc>().add(PostsRequested()),
            );
          }
          if (state.status != LoadStatus.success) {
            return const LoadingView();
          }

          final posts = state.filteredPosts;
          return RefreshIndicator(
            onRefresh: () => _refresh(context),
            child: posts.isEmpty
                ? const CustomScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    slivers: [SliverFillRemaining(child: EmptyView())],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
                    itemCount: posts.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 32),
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return PostCard(
                        post: post,
                        onImagesTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AlbumPage(postId: post.id)),
                        ),
                        onCommentsTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CommentsPage(postId: post.id)),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
