import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class ChatInputField extends StatefulWidget {
  final Function(String) onSendMessage;
  final VoidCallback? onVoiceInput;
  final VoidCallback? onCameraInput;
  final bool isLoading;

  const ChatInputField({
    super.key,
    required this.onSendMessage,
    this.onVoiceInput,
    this.onCameraInput,
    this.isLoading = false,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isComposing = _controller.text.isNotEmpty;
    });
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;
    
    widget.onSendMessage(text.trim());
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.aiMessageBorder,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            _buildActionButton(
              icon: Icons.camera_alt,
              onPressed: widget.onCameraInput,
              tooltip: 'Camera',
            ),
            const SizedBox(width: 8),
            _buildActionButton(
              icon: Icons.mic,
              onPressed: widget.onVoiceInput,
              tooltip: 'Voice Input',
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(),
            ),
            const SizedBox(width: 12),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.aiMessageBorder,
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: onPressed != null 
                ? AppColors.primary 
                : AppColors.textLight,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _focusNode.hasFocus 
              ? AppColors.primary 
              : AppColors.aiMessageBorder,
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: !widget.isLoading,
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          hintText: widget.isLoading 
              ? 'AI is typing...' 
              : 'Type your message...',
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textLight,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        style: AppTextStyles.bodyMedium,
        onSubmitted: _handleSubmitted,
      ),
    );
  }

  Widget _buildSendButton() {
    bool canSend = _isComposing && !widget.isLoading;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Tooltip(
        message: canSend ? 'Send' : 'Type a message',
        child: InkWell(
          onTap: canSend ? () => _handleSubmitted(_controller.text) : null,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: canSend 
                  ? AppColors.primaryGradient
                  : null,
              color: canSend 
                  ? null 
                  : AppColors.background,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: canSend 
                    ? AppColors.primary 
                    : AppColors.aiMessageBorder,
                width: 1.5,
              ),
            ),
            child: Icon(
              widget.isLoading ? Icons.hourglass_empty : Icons.send,
              size: 20,
              color: canSend 
                  ? Colors.white 
                  : AppColors.textLight,
            ),
          ),
        ),
      ),
    );
  }
} 