import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../load_status.dart';
import '../posts_repository.dart';
import '../theme.dart';
import '../widgets/status_views.dart';
import 'album_cubit.dart';
import 'album_state.dart';
import 'photo_viewer_page.dart';

class AlbumPage extends StatelessWidget {
  const AlbumPage({super.key, required this.postId});

  final int postId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AlbumCubit(context.read<PostsRepository>(), postId)..load(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Album')),
        body: BlocBuilder<AlbumCubit, AlbumState>(
          builder: (context, state) {
            if (state.status == LoadStatus.failure) {
              return ErrorView(
                message: 'No se pudieron cargar las imágenes.',
                onRetry: () => context.read<AlbumCubit>().load(),
              );
            }
            if (state.status != LoadStatus.success) {
              return const LoadingView();
            }
            if (state.photos.isEmpty) {
              return const EmptyView(message: 'Este post no tiene imágenes');
            }

            return GridView.builder(
              padding: const EdgeInsets.fromLTRB(28, 20, 28, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 34,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: state.photos.length,
              itemBuilder: (context, index) {
                final photo = state.photos[index];
                return Material(
                  color: photoTileColor,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => PhotoViewerPage(photo: photo)),
                    ),
                    child: Hero(
                      tag: 'photo-${photo.id}',
                      child: Image.network(
                        photo.thumbnailUrl,
                        fit: BoxFit.cover,
                        semanticLabel: photo.title,
                        loadingBuilder: (context, child, progress) =>
                            progress == null ? child : _placeholder(),
                        errorBuilder: (_, _, _) => _placeholder(),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _placeholder() {
    return const Center(
      child: Icon(Icons.image_outlined, size: 72, color: Colors.black54),
    );
  }
}
