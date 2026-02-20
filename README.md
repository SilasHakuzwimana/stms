#### STMS – Student Task Management System (Mobile)

## Overview

STMS (Student Task Management System) is a production-oriented Flutter mobile application designed to help students efficiently manage academic tasks. The application demonstrates clean architecture principles, scalable project structure, and modern mobile development practices.

This project is built as part of a software development lab and serves as a foundation for a full-stack task management platform integrating a Flutter frontend with a Spring Boot backend.

## Problem Statement

Students often struggle to manage assignments, deadlines, and academic responsibilities across multiple courses. STMS provides a centralized system to create, organize, and track tasks efficiently through a mobile-first experience.

## Key Features

1. Task creation, update, and deletion (CRUD operations)
2. Task completion tracking
3. Structured and modular Flutter architecture
4. Android device support
5. Scalable project structure for backend integration
6. Clean Material Design-based UI

## Architecture

The application follows a layered architecture to promote maintainability and scalability.

## Presentation Layer

1. Screens (UI)
2. Widgets
3. State handling

## Domain Layer (Planned Extension)

1. Business logic
2. Models and entities
3. Use case definitions

## Data Layer

1. Services
2. API integration (future)
3. Local data handling

### Technology Stack

## Mobile Application

1. Flutter
2. Dart
3. Material Design

## Backend (Planned Integration)

1. Spring Boot (Java)
2. RESTful APIs
3. PostgreSQL

## Development Tools

1. VS Code
2. Git and GitHub
3. Android SDK
4. Java JDK 17/21

### Project Structure

```bash
stms_app/
│
├── android/
├── ios/
├── lib/
│   ├── main.dart
│   ├── models/
│   ├── screens/
│   ├── services/
│   └── widgets/
│
├── test/
├── pubspec.yaml
└── README.md

```

The structure is organized to support future expansion such as authentication, API integration, and advanced state management.

Installation

1. Clone the Repository

```bash
git clone https://github.com/SilasHakuzwimana/stms.git
```

2. Navigate to Project Directory

```bash
cd stms_app
```

3. Install Dependencies

```bash
flutter pub get
```

4. Run the Application

```bash
flutter run
```

### Environment Requirements

1. Flutter SDK (latest stable)
2. Java JDK 17 or 21
3. Android SDK
4. Physical Android device or emulator
5. USB debugging enabled (for physical devices)

Verify setup:

```bash
flutter doctor
```

### Development Roadmap

Planned improvements include:

1. Authentication (JWT-based)
2. Backend integration with Spring Boot
3. Persistent database storage
4. Task categorization and tagging
5. Notifications and reminders
6. Role-based access control
7. Improved state management (Provider, Riverpod, or Bloc)
8. Unit and widget testing coverage
9. CI/CD pipeline integration
10. Engineering Practices
11. Version control using Git
12. Modular folder structure
13. Separation of concerns
14. Clean commit history
15. Scalable architecture design
16. Code readability and maintainability focus

### Contribution

This project is currently maintained as an academic and portfolio project. Contributions, suggestions, and improvements are welcome through pull requests.

### License

This project is licensed under the terms specified in the LICENSE file in this repository.
