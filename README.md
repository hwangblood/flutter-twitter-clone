# Twitter Clone

Full Stack Twitter App building with [Appwrite](https://appwrite.io/) - Works on Android & iOS!

Appwrite 1.3.3

## Architectural

UI - Controller - Repository

- UI: User interface, interact with the user

- Controller: Control state of widgets from UI, and process data that get from repository

- Repository: Request to backend, like API server, etc

## Folder Pattern

```text
lib
├── apis
├── constants
├── features
│   └── auth
│       ├── controller
│       ├── view
│       └── widgets
└── theme
```
