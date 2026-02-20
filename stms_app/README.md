
# STMS Mobile Application

## Overview

STMS (Student Task Management System) is a Flutter-based mobile application designed to help students manage tasks efficiently. The application allows users to create, update, delete, and track tasks in an organized manner.

This project is part of a school software development lab and demonstrates modern mobile development practices using Flutter.

## Features

* Create new tasks
* Edit existing tasks
* Delete tasks
* Mark tasks as completed
* View task list in real time
* Clean and responsive UI
* Android device support

## Technology Stack

### Frontend

* Flutter
* Dart
* Material Design

### Backend (Planned / Optional Integration)

* Spring Boot (Java)
* REST API
* PostgreSQL Database

## Project Structure

<pre class="overflow-visible! px-0!" data-start="904" data-end="1083"><div class="w-full my-4"><div class=""><div class="relative"><div class="h-full min-h-0 min-w-0"><div class="h-full min-h-0 min-w-0"><div class="border corner-superellipse/1.1 border-token-border-light bg-token-bg-elevated-secondary rounded-3xl"><div class="pointer-events-none absolute inset-x-4 top-12 bottom-4"><div class="pointer-events-none sticky z-40 shrink-0 z-1!"><div class="sticky bg-token-border-light"></div></div></div><div class="pointer-events-none absolute inset-x-px top-0 bottom-96"><div class="pointer-events-none sticky z-40 shrink-0 z-1!"><div class="sticky bg-token-bg-elevated-secondary"></div></div></div><div class="corner-superellipse/1.1 rounded-3xl bg-token-bg-elevated-secondary"><div class="relative z-0 flex max-w-full"><div id="code-block-viewer" dir="ltr" class="q9tKkq_viewer cm-editor z-10 light:cm-light dark:cm-light flex h-full w-full flex-col items-stretch ͼk ͼy"><div class="cm-scroller"><div class="cm-content q9tKkq_readonly"><span>stms_app/</span><br/><span>│</span><br/><span>├── android/</span><br/><span>├── ios/</span><br/><span>├── lib/</span><br/><span>│   ├── main.dart</span><br/><span>│   ├── models/</span><br/><span>│   ├── screens/</span><br/><span>│   ├── services/</span><br/><span>│   └── widgets/</span><br/><span>│</span><br/><span>├── test/</span><br/><span>├── pubspec.yaml</span><br/><span>└── README.md</span></div></div></div></div></div></div></div></div><div class=""><div class=""></div></div></div></div></div></pre>

## Requirements

* Flutter SDK (latest stable version)
* Java JDK 17 or 21
* Android Studio or VS Code
* Android device or emulator
* USB debugging enabled (for physical device testing)

## Installation and Setup

1. Clone the repository

<pre class="overflow-visible! px-0!" data-start="1334" data-end="1393"><div class="w-full my-4"><div class=""><div class="relative"><div class="h-full min-h-0 min-w-0"><div class="h-full min-h-0 min-w-0"><div class="border corner-superellipse/1.1 border-token-border-light bg-token-bg-elevated-secondary rounded-3xl"><div class="pointer-events-none absolute inset-x-4 top-12 bottom-4"><div class="pointer-events-none sticky z-40 shrink-0 z-1!"><div class="sticky bg-token-border-light"></div></div></div><div class="pointer-events-none absolute inset-x-px top-0 bottom-96"><div class="pointer-events-none sticky z-40 shrink-0 z-1!"><div class="sticky bg-token-bg-elevated-secondary"></div></div></div><div class="corner-superellipse/1.1 rounded-3xl bg-token-bg-elevated-secondary"><div class="relative z-0 flex max-w-full"><div id="code-block-viewer" dir="ltr" class="q9tKkq_viewer cm-editor z-10 light:cm-light dark:cm-light flex h-full w-full flex-col items-stretch ͼk ͼy"><div class="cm-scroller"><div class="cm-content q9tKkq_readonly"><span>git clone https://github.com/SilasHakuzwimana/stms.git</span></div></div></div></div></div></div></div></div><div class=""><div class=""></div></div></div></div></div></pre>

2. Navigate into the project directory

<pre class="overflow-visible! px-0!" data-start="1435" data-end="1454"><div class="w-full my-4"><div class=""><div class="relative"><div class="h-full min-h-0 min-w-0"><div class="h-full min-h-0 min-w-0"><div class="border corner-superellipse/1.1 border-token-border-light bg-token-bg-elevated-secondary rounded-3xl"><div class="pointer-events-none absolute inset-x-4 top-12 bottom-4"><div class="pointer-events-none sticky z-40 shrink-0 z-1!"><div class="sticky bg-token-border-light"></div></div></div><div class="pointer-events-none absolute inset-x-px top-0 bottom-96"><div class="pointer-events-none sticky z-40 shrink-0 z-1!"><div class="sticky bg-token-bg-elevated-secondary"></div></div></div><div class="corner-superellipse/1.1 rounded-3xl bg-token-bg-elevated-secondary"><div class="relative z-0 flex max-w-full"><div id="code-block-viewer" dir="ltr" class="q9tKkq_viewer cm-editor z-10 light:cm-light dark:cm-light flex h-full w-full flex-col items-stretch ͼk ͼy"><div class="cm-scroller"><div class="cm-content q9tKkq_readonly"><span>cd stms_app</span></div></div></div></div></div></div></div></div><div class=""><div class=""></div></div></div></div></div></pre>

3. Install dependencies

<pre class="overflow-visible! px-0!" data-start="1481" data-end="1504"><div class="w-full my-4"><div class=""><div class="relative"><div class="h-full min-h-0 min-w-0"><div class="h-full min-h-0 min-w-0"><div class="border corner-superellipse/1.1 border-token-border-light bg-token-bg-elevated-secondary rounded-3xl"><div class="pointer-events-none absolute inset-x-4 top-12 bottom-4"><div class="pointer-events-none sticky z-40 shrink-0 z-1!"><div class="sticky bg-token-border-light"></div></div></div><div class="pointer-events-none absolute inset-x-px top-0 bottom-96"><div class="pointer-events-none sticky z-40 shrink-0 z-1!"><div class="sticky bg-token-bg-elevated-secondary"></div></div></div><div class="corner-superellipse/1.1 rounded-3xl bg-token-bg-elevated-secondary"><div class="relative z-0 flex max-w-full"><div id="code-block-viewer" dir="ltr" class="q9tKkq_viewer cm-editor z-10 light:cm-light dark:cm-light flex h-full w-full flex-col items-stretch ͼk ͼy"><div class="cm-scroller"><div class="cm-content q9tKkq_readonly"><span>flutter pub get</span></div></div></div></div></div></div></div></div><div class=""><div class=""></div></div></div></div></div></pre>

4. Run the application

<pre class="overflow-visible! px-0!" data-start="1530" data-end="1549"><div class="w-full my-4"><div class=""><div class="relative"><div class="h-full min-h-0 min-w-0"><div class="h-full min-h-0 min-w-0"><div class="border corner-superellipse/1.1 border-token-border-light bg-token-bg-elevated-secondary rounded-3xl"><div class="pointer-events-none absolute inset-x-4 top-12 bottom-4"><div class="pointer-events-none sticky z-40 shrink-0 z-1!"><div class="sticky bg-token-border-light"></div></div></div><div class="pointer-events-none absolute inset-x-px top-0 bottom-96"><div class="pointer-events-none sticky z-40 shrink-0 z-1!"><div class="sticky bg-token-bg-elevated-secondary"></div></div></div><div class="corner-superellipse/1.1 rounded-3xl bg-token-bg-elevated-secondary"><div class="relative z-0 flex max-w-full"><div id="code-block-viewer" dir="ltr" class="q9tKkq_viewer cm-editor z-10 light:cm-light dark:cm-light flex h-full w-full flex-col items-stretch ͼk ͼy"><div class="cm-scroller"><div class="cm-content q9tKkq_readonly"><span>flutter run</span></div></div></div></div></div></div></div></div><div class=""><div class=""></div></div></div></div></div></pre>

## Environment Configuration

Ensure the following:

* JAVA_HOME is correctly set to your installed JDK directory.
* Android SDK is properly installed.
* USB debugging is enabled if using a physical device.

You can verify Flutter setup with:

<pre class="overflow-visible! px-0!" data-start="1800" data-end="1822"><div class="w-full my-4"><div class=""><div class="relative"><div class="h-full min-h-0 min-w-0"><div class="h-full min-h-0 min-w-0"><div class="border corner-superellipse/1.1 border-token-border-light bg-token-bg-elevated-secondary rounded-3xl"><div class="pointer-events-none absolute inset-x-4 top-12 bottom-4"><div class="pointer-events-none sticky z-40 shrink-0 z-1!"><div class="sticky bg-token-border-light"></div></div></div><div class="pointer-events-none absolute inset-x-px top-0 bottom-96"><div class="pointer-events-none sticky z-40 shrink-0 z-1!"><div class="sticky bg-token-bg-elevated-secondary"></div></div></div><div class="corner-superellipse/1.1 rounded-3xl bg-token-bg-elevated-secondary"><div class="relative z-0 flex max-w-full"><div id="code-block-viewer" dir="ltr" class="q9tKkq_viewer cm-editor z-10 light:cm-light dark:cm-light flex h-full w-full flex-col items-stretch ͼk ͼy"><div class="cm-scroller"><div class="cm-content q9tKkq_readonly"><span>flutter doctor</span></div></div></div></div></div></div></div></div><div class=""><div class=""></div></div></div></div></div></pre>

## Future Improvements

* User authentication
* Cloud database integration
* Task reminders and notifications
* Task categorization
* Backend API integration
* State management improvement (Provider, Riverpod, or Bloc)

## License

This project is licensed under the terms specified in the LICENSE file in this repository.
