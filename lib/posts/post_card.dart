import 'package:material_ui/material_ui.dart';

import '../models/post.dart';
import '../theme.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.onImagesTap,
    required this.onCommentsTap,
  });

  final Post post;
  final VoidCallback onImagesTap;
  final VoidCallback onCommentsTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              post.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, height: 1.4, color: greyText),
            ),
            Row(
              children: [
                IconButton(
                  tooltip: 'Ver imágenes',
                  icon: const Icon(Icons.photo_library_outlined),
                  onPressed: onImagesTap,
                ),
                const SizedBox(width: 24),
                IconButton(
                  tooltip: 'Ver comentarios',
                  icon: const Icon(Icons.sms_outlined),
                  onPressed: onCommentsTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
