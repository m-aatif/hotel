enum MessageType {
  text,
  audio,
  image,
  faceRecognition,
  system,
}

class ChatMessage {
  final String id;
  final String message;
  final String response;
  final MessageType type;
  final DateTime timestamp;
  final bool isUser;
  final Map<String, dynamic>? metadata;

  ChatMessage({
    required this.id,
    required this.message,
    required this.response,
    required this.type,
    required this.timestamp,
    required this.isUser,
    this.metadata,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      message: json['message'] as String,
      response: json['response'] as String,
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${json['type']}',
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isUser: json['isUser'] as bool,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'response': response,
      'type': type.toString().split('.').last,
      'timestamp': timestamp.toIso8601String(),
      'isUser': isUser,
      'metadata': metadata,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? message,
    String? response,
    MessageType? type,
    DateTime? timestamp,
    bool? isUser,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      message: message ?? this.message,
      response: response ?? this.response,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isUser: isUser ?? this.isUser,
      metadata: metadata ?? this.metadata,
    );
  }
} 