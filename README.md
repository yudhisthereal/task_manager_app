# Task Manager App 📋✅

A task management app built using **Flutter** and **Bloc**, designed to help users manage their tasks in a simple and effective way. Users can sign up, log in, add/edit tasks, mark tasks as completed, and delete tasks. This app provides a personalized experience by displaying the user's name, email, and avatar at the top of the task list. 🎯

## Features ✨
- **User Authentication** 🔑: Login and logout functionality.
- **Task Management** 📝: Add, edit, update, and delete tasks.
- **Personalized Experience** 👤: Display the user's name, email, and avatar in the AppBar.
- **Task Visibility** 👁️: Toggle task visibility and delete buttons.
- **State Management** 📊: Bloc architecture to manage state for tasks and authentication.

## Requirements 🛠️
- **Flutter SDK** (Version 2.10 or higher)
- **Dart** (Version 2.16 or higher)
- A suitable IDE (e.g., **Android Studio**, **VS Code**)

## Setup ⚙️

### 1. Clone the repository
```bash
git clone https://github.com/your-repo/task-manager-app.git
```

### 2. Install dependencies
In the project root directory, run:
```bash
flutter pub get
```

### 3. Run the app
To run the app on a connected device or emulator, use:
```bash
flutter run
```

## Screenshots 📸

### Login Screen
![Login Screen](screenshots/login_screen.png)

### Task List Screen
![Task List Screen](screenshots/task_list_screen.png)

### Add/Edit Task Screen
![Add/Edit Task Screen](screenshots/add_edit_task_screen.png)

### Logout
![Logout](screenshots/logout.png)

## Screens 🖼️

### 1. **Login Screen** 🔑
- The login screen allows the user to log in with their credentials.
- Once logged in, users are redirected to the task list screen.

### 2. **Task List Screen** 📝
- Displays a list of tasks with the following functionalities:
  - Toggle delete buttons to show or hide the delete icon.
  - Mark tasks as completed using a checkbox.
  - Add new tasks by tapping the floating action button.
  - Delete tasks by tapping the delete button next to each task (if enabled).
  
### 3. **Add/Edit Task Screen** ✏️
- Allows users to add new tasks or edit existing ones.
- Tasks can be given a title, description, and a completion status.

### 4. **Logout** 🚪
- Logout functionality allows the user to sign out from their account.
- The user will be redirected to the login screen after logging out.

## Architecture 🏗️
This app follows the **BLoC (Business Logic Component)** architecture, where:
- **AuthBloc** handles user authentication state.
- **TaskBloc** manages the task-related states like fetching tasks, adding tasks, and updating tasks.
- **State Management**: The app uses `Bloc` for state management to handle business logic separately from UI.

## Dependencies 📦
- `flutter_bloc`: State management library for Flutter.
- `flutter`: For building the user interface.
- `shared_preferences`: To persist user authentication data locally.

## Folder Structure 📂
```
lib/
│
├── blocs/
│   ├── auth/
│   │   ├── auth_bloc.dart
│   │   ├── auth_event.dart
│   │   └── auth_state.dart
│   ├── tasks/
│   │   ├── task_bloc.dart
│   │   ├── task_event.dart
│   │   └── task_state.dart
│
├── data/
│   ├── local/
│   │   └── shared_prefs_helper.dart
│   └── models/
│       └── task.dart
│
├── screens/
│   ├── task_list_screen.dart
│   └── add_edit_task_screen.dart
│
└── main.dart
```

## Contributing 🤝
Feel free to fork the repository and submit a pull request with improvements, bug fixes, or new features. If you have any questions or suggestions, open an issue and we’ll get back to you!

## License 📄
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact 📧
- **Email**: [yudhisthereal@gmail.com](mailto:yudhisthereal@gmail.com)
- **LinkedIn**: [Yudhistira's LinkedIn](https://www.linkedin.com/in/yudhistira-yudhistira-351088272/)
