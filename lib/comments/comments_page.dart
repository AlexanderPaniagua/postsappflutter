import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../load_status.dart';
import '../posts_repository.dart';
import '../widgets/search_app_bar.dart';
import '../widgets/status_views.dart';
import 'comment_bubble.dart';
import 'comments_bloc.dart';
import 'comments_event.dart';
import 'comments_state.dart';

class CommentsPage extends StatelessWidget {
  const CommentsPage({super.key, required this.postId});

  final int postId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CommentsBloc(context.read<PostsRepository>(), postId)
            ..add(CommentsRequested()),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: SearchAppBar(
            title: 'Comments',
            hint: 'Buscar Comentarios',
            onChanged: (text) =>
                context.read<CommentsBloc>().add(CommentsSearched(text)),
          ),
          body: BlocBuilder<CommentsBloc, CommentsState>(
            builder: (context, state) {
              if (state.status == LoadStatus.failure) {
                return ErrorView(
                  message: 'No se pudieron cargar los comentarios.',
                  onRetry: () =>
                      context.read<CommentsBloc>().add(CommentsRequested()),
                );
              }
              if (state.status != LoadStatus.success) {
                return const LoadingView();
              }

              final comments = state.filteredComments;
              if (comments.isEmpty) return const EmptyView();

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                itemCount: comments.length,
                separatorBuilder: (_, _) => const SizedBox(height: 24),
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  // use the id so bubbles don't switch sides while filtering
                  return CommentBubble(
                    key: ValueKey(comment.id),
                    comment: comment,
                    right: comment.id.isOdd,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
