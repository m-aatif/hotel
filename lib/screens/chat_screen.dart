import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../models/chat_message.dart';
import '../services/api_service.dart';
import '../widgets/chat/chat_message_bubble.dart';
import '../widgets/chat/chat_input_field.dart';
import '../widgets/common/app_header.dart';

class ChatScreen extends StatefulWidget {
  final String guestName;
  
  const ChatScreen({
    super.key,
    required this.guestName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: '',
      response: '''Welcome to our AI Hotel Assistant! 🏨

I'm here to help you with:
• Room bookings and reservations
• Hotel amenities and services
• Check-in and check-out assistance
• Local recommendations
• Face recognition for quick access
• Voice commands and queries

How can I assist you today?''',
      type: MessageType.text,
      timestamp: DateTime.now(),
      isUser: false,
    );
    
    setState(() {
      _messages.add(welcomeMessage);
    });
  }

  void _handleSendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: message,
      response: '',
      type: MessageType.text,
      timestamp: DateTime.now(),
      isUser: true,
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      // Get AI response from server
      final response = await _apiService.sendMessage(message, widget.guestName);
      
      if (response['success'] == true) {
        final aiMessage = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message: message,
          response: response['response'] ?? 'Sorry, I could not process your request.',
          type: MessageType.text,
          timestamp: DateTime.now(),
          isUser: false,
        );

        if (mounted) {
          setState(() {
            _messages.add(aiMessage);
            _isLoading = false;
          });
          _scrollToBottom();
        }
      } else {
        throw Exception('Failed to get AI response');
      }
    } catch (e) {
      print('Error getting AI response: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to get response. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _handleSpeak(String text) async {
    try {
      final success = await _apiService.textToSpeech(text);
      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Text-to-speech is not available'),
            backgroundColor: AppColors.warning,
          ),
        );
      }
    } catch (e) {
      print('Text-to-speech error: $e');
    }
  }

  Future<void> _handleTranslate(String text) async {
    // TODO: Implement translation using a translation service
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Translation feature coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleVoiceInput() {
    // TODO: Implement voice input
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice input feature coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _handleCameraInput() {
    // TODO: Implement camera input
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Camera feature coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppHeader(
        title: 'Hotel Assistant',
        showBackButton: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildChatList(),
          ),
          ChatInputField(
            onSendMessage: _handleSendMessage,
            onVoiceInput: _handleVoiceInput,
            onCameraInput: _handleCameraInput,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    if (_messages.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return ChatMessageBubble(
          message: message,
          onSpeak: () => _handleSpeak(message.response),
          onTranslate: (text) => _handleTranslate(text),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Start a conversation',
            style: AppTextStyles.h3,
          ),
          const SizedBox(height: 8),
          Text(
            'Ask me anything about your hotel stay',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }


} 