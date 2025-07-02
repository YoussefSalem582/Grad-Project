# GraphSmile - CustomerSense Pro 

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20|%20iOS%20|%20Web-lightgrey.svg)](https://flutter.dev/)

##  Enterprise-Grade Customer Service Analytics Platform

**GraphSmile** (CustomerSense Pro) is a cutting-edge Flutter application that revolutionizes customer service through advanced emotion analysis and real-time sentiment monitoring. Built with **Clean Architecture** principles, this enterprise-ready solution empowers businesses to understand, analyze, and improve customer interactions across multiple channels.

###  Perfect for Companies Like:
- **Amazon** - Customer service optimization
- **Google** - User experience analytics  
- **Microsoft** - Support team performance
- **Salesforce** - Customer sentiment tracking
- **Any Enterprise** seeking data-driven customer insights

---

##  Key Features

###  **Role-Based Access Control**
- **Admin Dashboard**: Complete system oversight and analytics
- **Employee Portal**: Specialized tools for customer service representatives
- **Secure Authentication**: Enterprise-grade user management

###  **Advanced Analytics Suite**
- **Real-time Sentiment Monitoring**: Live customer emotion tracking
- **Team Performance Analytics**: Employee productivity insights
- **Customer Journey Mapping**: Interaction flow analysis
- **Statistical Reporting**: Comprehensive data visualization

###  **Multi-Modal Analysis Tools**
- **Text Analysis**: Email, chat, and review sentiment analysis
- **Voice Analysis**: Call center emotion detection
- **Video Link Analysis**: Emotion extraction from video snapshots with subtitles
- **Social Media Monitoring**: Real-time brand sentiment tracking
- **Batch Processing**: Bulk data analysis capabilities

###  **Enterprise Features**
- **Live Monitoring Dashboard**: Real-time system health and metrics
- **Advanced Reporting**: Exportable analytics and insights
- **System Configuration**: Customizable settings and parameters
- **User Management**: Complete admin control over access and permissions

---

##  Architecture

This application follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
 core/                 # Shared utilities and configurations
    constants/       # App-wide constants and themes
    di/             # Dependency injection
    errors/         # Error handling
    network/        # Network configurations
    routing/        # App navigation
    usecases/       # Base use case definitions
 data/                # Data layer
    datasources/    # Remote and local data sources
    models/         # Data transfer objects
    repositories/   # Repository implementations
    services/       # External service integrations
 domain/              # Business logic layer
    entities/       # Core business entities
    repositories/   # Repository contracts
    usecases/       # Business use cases
 presentation/        # UI layer
     providers/      # State management
     screens/        # Feature-organized screens
        admin/      # Admin-specific screens
        employee/   # Employee-specific screens
        analysis/   # Analysis tools
        analytics/  # Analytics dashboards
        core/       # Shared screens
     widgets/        # Reusable UI components
         cards/      # Display components
         buttons/    # Interactive elements
         forms/      # Input forms
```

---

##  Screenshots & Features

### Admin Dashboard
- **Executive Overview**: High-level metrics and KPIs
- **User Management**: Complete control over user access and roles
- **System Configuration**: Advanced settings and customization
- **Reports & Analytics**: Comprehensive data export and visualization

### Employee Tools
- **Customer Interaction Analysis**: Real-time sentiment analysis during calls/chats
- **Performance Tracking**: Individual and team productivity metrics
- **Task Management**: Organized workflow and assignment tracking
- **Social Media Monitoring**: Brand sentiment and customer feedback analysis

### Analysis Suite
- **Emotion Detection**: Advanced AI-powered sentiment recognition
- **Batch Processing**: Efficient handling of large datasets
- **Video Link Analysis**: Extract emotions from video snapshots with subtitles
- **Voice Analysis**: Real-time voice emotion detection
- **Text Analysis**: Comprehensive text sentiment and emotion analysis
- **Social Media Analysis**: Platform-specific sentiment monitoring
- **Multi-language Support**: Global customer base analysis

---

##  Getting Started

### Prerequisites
- **Flutter SDK**: 3.0.0 or higher
- **Dart SDK**: 3.0.0 or higher
- **Android Studio** / **VS Code** with Flutter extensions
- **Git** for version control

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/YoussefSalem582/Grad-Project.git
cd Grad-Project
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the application**
```bash
flutter run
```

### Build for Production

**Android APK:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

---

##  Technology Stack

### **Frontend**
- **Flutter 3.0+**: Cross-platform UI framework
- **Dart 3.0+**: Programming language
- **Provider**: State management
- **Material Design 3**: Modern UI components

### **Architecture**
- **Clean Architecture**: Separation of concerns
- **Dependency Injection**: Modular design
- **Repository Pattern**: Data abstraction
- **Use Cases**: Business logic encapsulation

### **Features**
- **Multi-platform Support**: Android, iOS, Web
- **Responsive Design**: Adaptive layouts
- **Real-time Updates**: Live data synchronization
- **Advanced Analytics**: Data visualization
- **Role-based Security**: Enterprise authentication

---

##  Project Stats

- **15+ Professional Screens**: Complete enterprise UI/UX
- **Clean Architecture**: Maintainable and scalable codebase
- **Role-based Access**: Admin and Employee portals
- **Multi-modal Analysis**: Text, Voice, and Social media
- **Real-time Monitoring**: Live dashboard capabilities
- **Enterprise Ready**: Suitable for large-scale deployment

---

##  Developer

**Youssef Hassan**
-  Email: youssef.salem.hassan582@gmail.com
-  Computer Science Graduate
-  Flutter Developer & Mobile App Specialist

---

##  Documentation

For detailed documentation, please refer to:
- [`ARCHITECTURE.md`](ARCHITECTURE.md) - Clean Architecture implementation guide
- [`MIGRATION_GUIDE.md`](MIGRATION_GUIDE.md) - Project migration and update guide
- [`PROJECT_IMPROVEMENTS.md`](PROJECT_IMPROVEMENTS.md) - Recent improvements and enhancements

---

##  Contributing

We welcome contributions! Please read our contributing guidelines and submit pull requests for any improvements.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

##  License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

##  Acknowledgments

- Flutter team for the amazing framework
- Material Design team for the beautiful UI components
- Open source community for various packages and tools
- Enterprise customers for valuable feedback and requirements

---

**Built with  using Flutter**

*Empowering businesses through intelligent customer analytics*
