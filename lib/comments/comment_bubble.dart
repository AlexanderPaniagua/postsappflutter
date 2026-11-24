import 'package:material_ui/material_ui.dart';

import '../models/comment.dart';
import '../theme.dart';

class CommentBubble extends StatefulWidget {
  const CommentBubble({super.key, required this.comment, this.right = false});

  final Comment comment;
  final bool right;

  @override
  State<CommentBubble> createState() => _CommentBubbleState();
}

class _CommentBubbleState extends State<CommentBubble> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.right ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Material(
              color: bubbleColor,
              elevation: 3,
              shadowColor: Colors.black38,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => setState(() => expanded = !expanded),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: Text(
                    widget.comment.body,
                    maxLines: expanded ? null : 3,
                    overflow: expanded ? null : TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15, height: 1.4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.comment.email,
              style: const TextStyle(fontSize: 11, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
