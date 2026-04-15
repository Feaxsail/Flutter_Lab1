import 'dart:io';
import 'package:todo_app/todo.dart';
import 'package:todo_app/todo_repository.dart';
import 'package:ansicolor/ansicolor.dart';

final AnsiPen errorPen = AnsiPen()..red(bold: true);
final AnsiPen successPen = AnsiPen()..green(bold: true);
final AnsiPen infoPen = AnsiPen()..blue(bold: true);
final AnsiPen menuPen = AnsiPen()..yellow(bold: true);

void main() {
  final repository = TodoRepository();

  while (true) {
    printMenu();
    stdout.write("> ");
    String? input = stdin.readLineSync();
    
    if (input == null || input.trim().isEmpty) {
      continue;
    }

    bool shouldExit = handleCommand(input, repository);
    if (shouldExit) {
      print("Выход из приложения. До свидания!");
      break;
    }
  }
}

void printMenu() {
  print("TODO CLI");
  print("add <task>   - Добавить задачу");
  print("list         - Показать список");
  print("done <id>    - Завершить задачу");
  print("delete <id>  - Удалить задачу");
  print("exit         - Выход");
  print("");
}

void addCommand(String input, TodoRepository repo) {
  if (input.length <= 4) {
    print("Ошибка: формат команды 'add <текст>'");
    return;
  }
  String title = input.substring(4);
  try {
    repo.add(title);
    print("Задача добавлена: $title");
  } catch (e) {
    print("Ошибка: $e");
  }
}

void listCommand(TodoRepository repo) {
  final todos = repo.getAll();
  if (todos.isEmpty) {
    print("Список задач пуст.");
    return;
  }
  for (var todo in todos) {
    print(todo);
  }
}

void doneCommand(String input, TodoRepository repo) {
  final parts = input.split(" ");
  if (parts.length != 2) {
    print("Ошибка: формат команды 'done <id>'");
    return;
  }
  try {
    int id = int.parse(parts[1]);
    repo.complete(id);
    print("Задача $id выполнена.");
  } catch (e) {
    print("Ошибка: $e");
  }
}

void deleteCommand(String input, TodoRepository repo) {
  final parts = input.split(" ");
  if (parts.length != 2) {
    print("Ошибка: формат команды 'delete <id>'");
    return;
  }
  try {
    int id = int.parse(parts[1]);
    repo.delete(id);
    print("Задача $id удалена.");
  } catch (e) {
    print("Ошибка: $e");
  }
}

bool handleCommand(String input, TodoRepository repo) {
  final parts = input.split(" ");
  final command = parts[0].toLowerCase();

  switch (command) {
    case "add":
      addCommand(input, repo);
      return false;
    case "list":
      listCommand(repo);
      return false;
    case "done":
      doneCommand(input, repo);
      return false;
    case "delete":
      deleteCommand(input, repo);
      return false;
    case "exit":
      return true;
    default:
      print("Неизвестная команда: $command");
      return false;
  }
}