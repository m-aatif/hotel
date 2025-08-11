import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../models/chat_message.dart';
import '../../utils/date_utils.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback? onSpeak;
  final Function(String)? onTranslate;

  const ChatMessageBubble({
    super.key,
    required this.message,
    this.onSpeak,
    this.onTranslate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.isUser) _buildUserMessage(),
          if (!message.isUser) _buildAIMessage(),
        ],
      ),
    );
  }

  Widget _buildUserMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message.type == MessageType.audio)
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(Icons.mic, size: 16, color: Colors.white70),
                  ),
                Flexible(
                  child: Text(
                    message.message,
                    style: AppTextStyles.chatMessage.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: AppTextStyles.chatTimestamp.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIMessage() {
    bool isFaceRecognition = message.type == MessageType.faceRecognition;
    
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isFaceRecognition 
              ? AppColors.success.withOpacity(0.1)
              : AppColors.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(20),
          ),
          border: Border.all(
            color: isFaceRecognition 
                ? AppColors.success.withOpacity(0.3)
                : AppColors.aiMessageBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isFaceRecognition 
                        ? AppColors.success
                        : AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isFaceRecognition ? Icons.face : Icons.smart_toy,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isFaceRecognition ? 'Security System' : 'AI Receptionist',
                        style: AppTextStyles.chatSender,
                      ),
                      Text(
                        _formatTime(message.timestamp),
                        style: AppTextStyles.chatTimestamp,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              message.response,
              style: AppTextStyles.chatMessage,
            ),
            const SizedBox(height: 12),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onSpeak != null)
          _buildActionButton(
            icon: Icons.volume_up,
            onPressed: onSpeak!,
            tooltip: 'Speak',
          ),
        if (onTranslate != null)
          _buildActionButton(
            icon: Icons.translate,
            onPressed: () => onTranslate!(message.response),
            tooltip: 'Translate',
          ),
        _buildActionButton(
          icon: Icons.copy,
          onPressed: () => _copyToClipboard(message.response),
          tooltip: 'Copy',
        ),
        _buildActionButton(
          icon: Icons.thumb_up,
          onPressed: () => _showFeedback(),
          tooltip: 'Helpful',
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.aiMessageBorder,
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return AppDateUtils.formatTime(timestamp);
  }

  void _copyToClipboard(String text) {
    // Implementation for copying to clipboard
    // You can use flutter/services Clipboard.setData
  }

  void _showFeedback() {
    // Implementation for feedback
  }
} 