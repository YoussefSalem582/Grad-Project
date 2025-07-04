# CustomerSense Pro - Clean Architecture Guide

## Overview

CustomerSense Pro has been restructured following **Clean Architecture** principles with **feature-based organization** for maximum maintainability, scalability, and separation of concerns.

## 🏗️ Project Structure

```
lib/
├── core/                     # Core infrastructure & utilities
│   ├── config/              # App configuration
│   ├── constants/           # App constants (colors, strings, theme)
│   ├── di/                  # Dependency injection
│   ├── errors/              # Error handling & failures
│   ├── network/             # Network utilities
│   ├── routing/             # App routing configuration
│   ├── usecases/            # Base use case interfaces
│   ├── utils/               # Utility functions
│   └── core.dart           # Core layer exports
│
├── domain/                   # Business logic layer (pure Dart)
│   ├── entities/            # Business entities
│   ├── repositories/        # Repository interfaces
│   ├── usecases/            # Business use cases
│   └── domain.dart         # Domain layer exports
│
├── data/                     # Data access layer
│   ├── datasources/         # Remote & local data sources
│   ├── models/              # Data models
│   ├── repositories/        # Repository implementations
│   ├── services/            # External services
│   └── data.dart           # Data layer exports
│
├── presentation/             # UI layer
│   ├── providers/           # State management
│   ├── screens/             # Feature-organized screens
│   │   ├── admin/          # Admin-only screens
│   │   ├── employee/       # Employee screens
│   │   ├── analysis/       # Analysis tools
│   │   ├── analytics/      # Analytics & monitoring
│   │   ├── core/           # Shared/core screens
│   │   └── screens.dart    # Screen exports
│   ├── widgets/             # Reusable UI components
│   │   ├── cards/          # Card widgets
│   │   ├── buttons/        # Button widgets
│   │   ├── forms/          # Form widgets
│   │   └── widgets.dart    # Widget exports
│   └── presentation.dart    # Presentation layer exports
│
└── main.dart                # App entry point
```

## 🎯 Clean Architecture Layers

### 1. Domain Layer (`lib/domain/`)
- **Purpose**: Contains business logic and entities
- **Dependencies**: None (pure Dart)
- **Components**:
  - **Entities**: Core business objects (`AnalysisResult`, `UserEntity`)
  - **Repositories**: Abstract interfaces for data access
  - **Use Cases**: Business logic implementation

### 2. Data Layer (`lib/data/`)
- **Purpose**: Handles data access and storage
- **Dependencies**: Domain layer only
- **Components**:
  - **Data Sources**: Remote API & local storage
  - **Models**: Data transfer objects with JSON serialization
  - **Repository Implementations**: Concrete repository implementations

### 3. Presentation Layer (`lib/presentation/`)
- **Purpose**: UI and user interaction
- **Dependencies**: Domain layer (via use cases)
- **Components**:
  - **Providers**: State management using Provider pattern
  - **Screens**: Feature-organized UI screens
  - **Widgets**: Reusable UI components

### 4. Core Layer (`lib/core/`)
- **Purpose**: Infrastructure and shared utilities
- **Dependencies**: Used by all other layers
- **Components**:
  - **Dependency Injection**: Service locator pattern
  - **Routing**: Centralized navigation
  - **Constants**: Colors, strings, themes
  - **Error Handling**: Typed failures and exceptions

## 📱 Screen Organization

### Feature-Based Structure
Screens are organized by feature areas for better maintainability:

#### Admin Screens (`lib/presentation/screens/admin/`)
- `admin_navigation_screen.dart` - Main admin navigation
- `admin_reports_screen.dart` - Report generation
- `admin_system_config_screen.dart` - System configuration
- `admin_user_management_screen.dart` - User management

#### Employee Screens (`lib/presentation/screens/employee/`)
- `employee_navigation_screen.dart` - Employee navigation
- `employee_dashboard_screen.dart` - Employee home
- `employee_profile_screen.dart` - Profile management
- `employee_performance_screen.dart` - Performance metrics
- `employee_customer_interactions_screen.dart` - Customer interactions
- `employee_text_analysis_screen.dart` - Text analysis tools
- `employee_voice_analysis_screen.dart` - Voice analysis tools


#### Analysis Screens (`lib/presentation/screens/analysis/`)
- `emotion_analyzer_screen.dart` - Core emotion analysis
- `video_analyzer_screen.dart` - Video analysis tools
- `batch_processing_screen.dart` - Batch analysis

#### Analytics Screens (`lib/presentation/screens/analytics/`)
- `customer_analytics_screen.dart` - Customer insights
- `statistics_screen.dart` - Statistical analysis
- `live_monitor_screen.dart` - Real-time monitoring
- `team_performance_screen.dart` - Team metrics

#### Core Screens (`lib/presentation/screens/core/`)
- `role_selection_screen.dart` - Entry point
- `app_status_screen.dart` - System status
- `settings_screen.dart` - App settings
- `dashboard_screen.dart` - Main dashboard
- `model_info_screen.dart` - Model information
- `history_screen.dart` - Analysis history

## 🧩 Widget Organization

Widgets are categorized by type for better reusability:

### Cards (`lib/presentation/widgets/cards/`)
- Display information in card format
- Examples: `analytics_card.dart`, `results_card.dart`

### Buttons (`lib/presentation/widgets/buttons/`)
- Interactive button components
- Examples: `analyze_button.dart`

### Forms (`lib/presentation/widgets/forms/`)
- Input and form-related widgets
- Examples: `emotion_input_field.dart`, `video_analysis_form.dart`

## 📦 Export Strategy

Each layer and feature group has a main export file for clean imports:

### Layer Exports
- `lib/core/core.dart` - All core utilities
- `lib/domain/domain.dart` - All domain components
- `lib/data/data.dart` - All data components
- `lib/presentation/presentation.dart` - All presentation components

### Feature Exports
- `lib/presentation/screens/admin/admin_screens.dart` - Admin screens
- `lib/presentation/screens/employee/employee_screens.dart` - Employee screens
- `lib/presentation/widgets/cards/cards.dart` - Card widgets
- `lib/presentation/widgets/buttons/buttons.dart` - Button widgets

### Usage Example
```dart
// Clean imports using export files
import '../../../core/core.dart';               // Core utilities
import '../../providers/providers.dart';        // State management
import '../../widgets/widgets.dart';            // UI components
import '../screens.dart';                       // Screen navigation
```

## 🔄 State Management

Using Provider pattern with clean architecture:

### Provider Structure
- `AnalysisProvider` - Analysis operations
- `UserProvider` - User management
- `EmotionProvider` - Emotion analysis (legacy, to be refactored)

### Best Practices
- Providers only call use cases, never repositories directly
- Use cases handle business logic and validation
- Repositories abstract data access

## 🚀 Benefits of This Structure

### 1. **Separation of Concerns**
- Each layer has a single responsibility
- Business logic is isolated in the domain layer
- UI logic is separate from business logic

### 2. **Testability**
- Easy unit testing with mock dependencies
- Business logic can be tested without UI
- Clear dependency boundaries

### 3. **Maintainability**
- Feature-based organization makes finding code easy
- Export files provide clean import paths
- Consistent structure across the app

### 4. **Scalability**
- Easy to add new features without affecting existing code
- Clear patterns for new developers to follow
- Modular architecture supports team development

### 5. **Enterprise Ready**
- Professional project structure
- Follows industry best practices
- Suitable for large development teams

## 🛠️ Development Workflow

### Adding New Features
1. **Define entities** in `domain/entities/`
2. **Create use cases** in `domain/usecases/`
3. **Implement data sources** in `data/datasources/`
4. **Create models** in `data/models/`
5. **Implement repositories** in `data/repositories/`
6. **Build UI screens** in `presentation/screens/[feature]/`
7. **Create providers** in `presentation/providers/`
8. **Update exports** in respective export files

### Import Guidelines
- Always use export files for imports
- Avoid deep relative paths (`../../../`)
- Import only what you need
- Group imports by layer (core, domain, data, presentation)

## 🔧 Migration Notes

### Current Status
- ✅ Project structure reorganized
- ✅ Export files created
- ✅ Core architecture implemented
- ⚠️ Some import statements need updating
- ⚠️ Legacy code needs refactoring

### Next Steps
1. Update remaining import statements to use export files
2. Refactor EmotionProvider to use clean architecture
3. Add comprehensive unit tests
4. Implement integration tests
5. Add documentation for each layer

## 📚 Learning Resources

- [Clean Architecture by Robert Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture Guide](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Provider State Management](https://pub.dev/packages/provider)

---

This architecture provides a solid foundation for enterprise-level Flutter development with excellent maintainability, testability, and scalability. 