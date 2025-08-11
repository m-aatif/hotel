# AI Hotel Receptionist App

A professional Flutter application that provides an AI-powered hotel assistant interface with modern UI design and comprehensive features.

## 🏨 Features

- **AI Chat Interface**: Intelligent conversation with hotel guests
- **Professional UI**: Modern, clean design with Material 3
- **Multi-modal Input**: Text, voice, and camera input support
- **Face Recognition**: Secure guest identification system
- **Responsive Design**: Works across different screen sizes
- **Real-time Chat**: Instant messaging with AI responses

## 📱 Screenshots

The app features a beautiful chat interface with:
- Gradient header with hotel branding
- Professional message bubbles
- Interactive input field with voice and camera options
- Smooth animations and transitions
- Modern color scheme and typography

## 🏗️ Project Structure

```
lib/
├── core/
│   └── constants/
│       ├── app_colors.dart      # Color definitions
│       └── app_text_styles.dart # Typography styles
├── models/
│   └── chat_message.dart        # Chat message data model
├── screens/
│   └── chat_screen.dart         # Main chat interface
├── widgets/
│   ├── chat/
│   │   ├── chat_message_bubble.dart  # Message display widget
│   │   └── chat_input_field.dart     # Input interface
│   └── common/
│       └── app_header.dart           # App header component
└── main.dart                   # App entry point
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd hotel_ai_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 🎨 Design System

### Colors
- **Primary**: Blue (#1976D2)
- **Secondary**: Teal (#26A69A)
- **Background**: Light Gray (#FAFAFA)
- **Surface**: White (#FFFFFF)
- **Text**: Dark Gray (#212121)

### Typography
- **Headings**: Bold, large text for titles
- **Body**: Regular weight for content
- **Captions**: Smaller text for metadata
- **Buttons**: Medium weight for actions

## 🔧 Configuration

The app uses a centralized configuration system:

- **App Colors**: Defined in `lib/core/constants/app_colors.dart`
- **Text Styles**: Defined in `lib/core/constants/app_text_styles.dart`
- **Theme**: Configured in `lib/main.dart`

## 📋 Features Status

### ✅ Implemented
- Professional UI design
- Chat interface
- Message bubbles with actions
- Input field with send button
- Welcome message
- Basic AI responses
- Responsive layout

### 🚧 Coming Soon
- Voice input functionality
- Camera integration
- Face recognition
- Text-to-speech
- Translation services
- Settings screen
- User authentication

## 🛠️ Development

### Adding New Features

1. Create new widgets in appropriate folders
2. Follow the existing naming conventions
3. Use the defined color and text style constants
4. Add proper documentation

### Code Style

- Follow Flutter/Dart conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Keep widgets focused and reusable

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📞 Support

For support and questions, please open an issue in the repository.

---

**Built with ❤️ using Flutter**
