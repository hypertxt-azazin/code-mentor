import 'package:code_mentor/features/catalog/domain/models/challenge.dart';
import 'package:code_mentor/features/catalog/domain/models/lesson.dart';
import 'package:code_mentor/features/catalog/domain/models/module.dart';
import 'package:code_mentor/features/catalog/domain/models/quiz_question.dart';
import 'package:code_mentor/features/catalog/domain/models/track.dart';
import 'package:code_mentor/features/progress/domain/models/badge.dart';

/// Static seed data used during development / first-run seeding.
class SeedData {
  SeedData._();

  // ── App Config ─────────────────────────────────────────────────────────────
  static const Map<String, dynamic> appConfig = {
    'free_daily_attempt_limit': 15,
    'free_modules_per_track': 2,
  };

  // ── Badges ─────────────────────────────────────────────────────────────────
  static const List<Map<String, String>> badgeMaps = [
    {
      'id': 'badge-001',
      'key': 'FIRST_LESSON',
      'title': 'First Step',
      'description': 'Completed your first lesson.',
      'icon_name': 'school',
    },
    {
      'id': 'badge-002',
      'key': 'SEVEN_DAY_STREAK',
      'title': '7-Day Streak',
      'description': 'Maintained a 7-day learning streak.',
      'icon_name': 'local_fire_department',
    },
    {
      'id': 'badge-003',
      'key': 'TEN_CORRECT',
      'title': 'Sharp Mind',
      'description': 'Answered 10 challenges correctly.',
      'icon_name': 'check_circle',
    },
    {
      'id': 'badge-004',
      'key': 'FIRST_QUIZ_PASS',
      'title': 'Quiz Champion',
      'description': 'Passed your first module quiz.',
      'icon_name': 'emoji_events',
    },
  ];

  static List<Badge> get badges =>
      badgeMaps.map((m) => Badge.fromJson(m)).toList();

  // ── Tracks ─────────────────────────────────────────────────────────────────
  static List<Track> get tracks => [
        const Track(
          id: 'track-001',
          title: 'Python Fundamentals',
          description:
              'Master the basics of Python — variables, control flow, functions, and more.',
          difficulty: 'beginner',
          tags: ['Python', 'Programming', 'Beginner'],
          order: 1,
        ),
        const Track(
          id: 'track-002',
          title: 'Web Development Basics',
          description:
              'Build modern websites with HTML, CSS, and JavaScript fundamentals.',
          difficulty: 'beginner',
          tags: ['Web Dev', 'JavaScript', 'HTML', 'CSS'],
          order: 2,
        ),
        const Track(
          id: 'track-003',
          title: 'Data Structures & Algorithms',
          description:
              'Understand core data structures and classic algorithms to ace technical interviews.',
          difficulty: 'intermediate',
          tags: ['Algorithms', 'Data Structures', 'Python'],
          order: 3,
        ),
      ];

  // ── Modules ────────────────────────────────────────────────────────────────
  static List<CourseModule> get modules => [
        // Python Fundamentals
        const CourseModule(
          id: 'mod-py-01',
          trackId: 'track-001',
          title: 'Variables & Data Types',
          description: 'Learn about Python variables, numbers, strings, and booleans.',
          order: 1,
          passPercent: 70,
        ),
        const CourseModule(
          id: 'mod-py-02',
          trackId: 'track-001',
          title: 'Control Flow',
          description: 'Master if/else statements and loops in Python.',
          order: 2,
          passPercent: 70,
        ),
        const CourseModule(
          id: 'mod-py-03',
          trackId: 'track-001',
          title: 'Functions',
          description: 'Define and call functions, understand scope and return values.',
          order: 3,
          passPercent: 70,
        ),
        const CourseModule(
          id: 'mod-py-04',
          trackId: 'track-001',
          title: 'Lists & Dictionaries',
          description: 'Work with Python\'s most-used collection types.',
          order: 4,
          passPercent: 70,
        ),

        // Web Development Basics
        const CourseModule(
          id: 'mod-web-01',
          trackId: 'track-002',
          title: 'HTML Essentials',
          description: 'Structure web pages with semantic HTML5 elements.',
          order: 1,
          passPercent: 70,
        ),
        const CourseModule(
          id: 'mod-web-02',
          trackId: 'track-002',
          title: 'CSS Styling',
          description: 'Style pages with CSS selectors, the box model, and flexbox.',
          order: 2,
          passPercent: 70,
        ),
        const CourseModule(
          id: 'mod-web-03',
          trackId: 'track-002',
          title: 'JavaScript Basics',
          description: 'Variables, functions, and DOM manipulation in JavaScript.',
          order: 3,
          passPercent: 70,
        ),
        const CourseModule(
          id: 'mod-web-04',
          trackId: 'track-002',
          title: 'Responsive Design',
          description: 'Build pages that look great on any screen size.',
          order: 4,
          passPercent: 70,
        ),

        // Data Structures & Algorithms
        const CourseModule(
          id: 'mod-dsa-01',
          trackId: 'track-003',
          title: 'Arrays & Strings',
          description: 'Core operations on arrays and string manipulation techniques.',
          order: 1,
          passPercent: 70,
        ),
        const CourseModule(
          id: 'mod-dsa-02',
          trackId: 'track-003',
          title: 'Linked Lists',
          description: 'Singly and doubly linked lists — traversal, insertion, deletion.',
          order: 2,
          passPercent: 70,
        ),
        const CourseModule(
          id: 'mod-dsa-03',
          trackId: 'track-003',
          title: 'Sorting & Searching',
          description: 'Classic algorithms: bubble sort, merge sort, binary search.',
          order: 3,
          passPercent: 70,
        ),
        const CourseModule(
          id: 'mod-dsa-04',
          trackId: 'track-003',
          title: 'Stacks & Queues',
          description: 'LIFO and FIFO structures and their real-world applications.',
          order: 4,
          passPercent: 70,
        ),
      ];

  // ── Lessons ────────────────────────────────────────────────────────────────
  static List<Lesson> get lessons => [
        // mod-py-01: Variables & Data Types
        Lesson(
          id: 'les-py-01-01',
          moduleId: 'mod-py-01',
          title: 'What is a Variable?',
          order: 1,
          estimatedMinutes: 5,
          content: {
            'markdown': '## Variables\n\n'
                'A variable is a named container for a value.\n\n'
                '```python\nname = "Alice"\nage = 30\n```\n',
          },
        ),
        Lesson(
          id: 'les-py-01-02',
          moduleId: 'mod-py-01',
          title: 'Numbers & Arithmetic',
          order: 2,
          estimatedMinutes: 6,
          content: {
            'markdown': '## Numbers\n\n'
                'Python supports `int`, `float`, and `complex` types.\n\n'
                '```python\nx = 5\ny = 2.5\nprint(x + y)  # 7.5\n```\n',
          },
        ),
        Lesson(
          id: 'les-py-01-03',
          moduleId: 'mod-py-01',
          title: 'Strings & Booleans',
          order: 3,
          estimatedMinutes: 5,
          content: {
            'markdown': '## Strings\n\n'
                'Strings are sequences of characters enclosed in quotes.\n\n'
                '```python\ngreeting = "Hello, World!"\nprint(len(greeting))\n```\n',
          },
        ),

        // mod-py-02: Control Flow
        Lesson(
          id: 'les-py-02-01',
          moduleId: 'mod-py-02',
          title: 'If / Else Statements',
          order: 1,
          estimatedMinutes: 6,
          content: {
            'markdown': '## Conditionals\n\n'
                '```python\nif age >= 18:\n    print("Adult")\nelse:\n    print("Minor")\n```\n',
          },
        ),
        Lesson(
          id: 'les-py-02-02',
          moduleId: 'mod-py-02',
          title: 'For Loops',
          order: 2,
          estimatedMinutes: 7,
          content: {
            'markdown': '## For Loops\n\n'
                '```python\nfor i in range(5):\n    print(i)\n```\n',
          },
        ),
        Lesson(
          id: 'les-py-02-03',
          moduleId: 'mod-py-02',
          title: 'While Loops',
          order: 3,
          estimatedMinutes: 6,
          content: {
            'markdown': '## While Loops\n\n'
                '```python\nn = 0\nwhile n < 5:\n    n += 1\n```\n',
          },
        ),

        // mod-py-03: Functions
        Lesson(
          id: 'les-py-03-01',
          moduleId: 'mod-py-03',
          title: 'Defining Functions',
          order: 1,
          estimatedMinutes: 6,
          content: {
            'markdown': '## def keyword\n\n'
                '```python\ndef greet(name):\n    return f"Hello, {name}!"\n```\n',
          },
        ),
        Lesson(
          id: 'les-py-03-02',
          moduleId: 'mod-py-03',
          title: 'Parameters & Return Values',
          order: 2,
          estimatedMinutes: 7,
          content: {
            'markdown': '## Parameters\n\n'
                'Functions can accept multiple parameters and return values.\n\n'
                '```python\ndef add(a, b):\n    return a + b\n```\n',
          },
        ),
        Lesson(
          id: 'les-py-03-03',
          moduleId: 'mod-py-03',
          title: 'Scope & Default Arguments',
          order: 3,
          estimatedMinutes: 8,
          content: {
            'markdown': '## Scope\n\n'
                'Variables defined inside a function are local to that function.\n\n'
                '```python\ndef greet(name="World"):\n    print(f"Hello, {name}!")\n```\n',
          },
        ),

        // mod-py-04: Lists & Dictionaries
        Lesson(
          id: 'les-py-04-01',
          moduleId: 'mod-py-04',
          title: 'Python Lists',
          order: 1,
          estimatedMinutes: 7,
          content: {
            'markdown': '## Lists\n\n'
                '```python\nfruits = ["apple", "banana", "cherry"]\nfruits.append("date")\n```\n',
          },
        ),
        Lesson(
          id: 'les-py-04-02',
          moduleId: 'mod-py-04',
          title: 'List Methods & Slicing',
          order: 2,
          estimatedMinutes: 7,
          content: {
            'markdown': '## Slicing\n\n'
                '```python\nmy_list = [0, 1, 2, 3, 4]\nprint(my_list[1:3])  # [1, 2]\n```\n',
          },
        ),
        Lesson(
          id: 'les-py-04-03',
          moduleId: 'mod-py-04',
          title: 'Dictionaries',
          order: 3,
          estimatedMinutes: 8,
          content: {
            'markdown': '## Dictionaries\n\n'
                '```python\nperson = {"name": "Alice", "age": 30}\nprint(person["name"])\n```\n',
          },
        ),

        // mod-web-01: HTML Essentials
        Lesson(
          id: 'les-web-01-01',
          moduleId: 'mod-web-01',
          title: 'HTML Document Structure',
          order: 1,
          estimatedMinutes: 5,
          content: {
            'markdown': '## HTML Skeleton\n\n'
                '```html\n<!DOCTYPE html>\n<html>\n  <head><title>My Page</title></head>\n'
                '  <body><h1>Hello!</h1></body>\n</html>\n```\n',
          },
        ),
        Lesson(
          id: 'les-web-01-02',
          moduleId: 'mod-web-01',
          title: 'Headings & Paragraphs',
          order: 2,
          estimatedMinutes: 4,
          content: {
            'markdown': '## Text Elements\n\n'
                'Use `<h1>`–`<h6>` for headings and `<p>` for paragraphs.\n',
          },
        ),
        Lesson(
          id: 'les-web-01-03',
          moduleId: 'mod-web-01',
          title: 'Links & Images',
          order: 3,
          estimatedMinutes: 5,
          content: {
            'markdown': '## Links\n\n'
                '```html\n<a href="https://example.com">Visit</a>\n<img src="photo.jpg" alt="A photo">\n```\n',
          },
        ),

        // mod-web-02: CSS Styling
        Lesson(
          id: 'les-web-02-01',
          moduleId: 'mod-web-02',
          title: 'CSS Selectors',
          order: 1,
          estimatedMinutes: 6,
          content: {
            'markdown': '## Selectors\n\n'
                'Element, class (`.`), and ID (`#`) selectors.\n\n'
                '```css\np { color: blue; }\n.highlight { background: yellow; }\n```\n',
          },
        ),
        Lesson(
          id: 'les-web-02-02',
          moduleId: 'mod-web-02',
          title: 'The Box Model',
          order: 2,
          estimatedMinutes: 7,
          content: {
            'markdown': '## Box Model\n\n'
                'Every element has: content → padding → border → margin.\n',
          },
        ),
        Lesson(
          id: 'les-web-02-03',
          moduleId: 'mod-web-02',
          title: 'Flexbox Layout',
          order: 3,
          estimatedMinutes: 8,
          content: {
            'markdown': '## Flexbox\n\n'
                '```css\n.container {\n  display: flex;\n  justify-content: center;\n}\n```\n',
          },
        ),

        // mod-web-03: JavaScript Basics
        Lesson(
          id: 'les-web-03-01',
          moduleId: 'mod-web-03',
          title: 'Variables in JS',
          order: 1,
          estimatedMinutes: 5,
          content: {
            'markdown': '## let & const\n\n'
                '```js\nlet name = "Alice";\nconst PI = 3.14;\n```\n',
          },
        ),
        Lesson(
          id: 'les-web-03-02',
          moduleId: 'mod-web-03',
          title: 'Functions & Arrow Functions',
          order: 2,
          estimatedMinutes: 6,
          content: {
            'markdown': '## Arrow Functions\n\n'
                '```js\nconst add = (a, b) => a + b;\n```\n',
          },
        ),
        Lesson(
          id: 'les-web-03-03',
          moduleId: 'mod-web-03',
          title: 'DOM Manipulation',
          order: 3,
          estimatedMinutes: 8,
          content: {
            'markdown': '## DOM\n\n'
                '```js\ndocument.getElementById("title").textContent = "Hello!";\n```\n',
          },
        ),

        // mod-web-04: Responsive Design
        Lesson(
          id: 'les-web-04-01',
          moduleId: 'mod-web-04',
          title: 'Media Queries',
          order: 1,
          estimatedMinutes: 6,
          content: {
            'markdown': '## Media Queries\n\n'
                '```css\n@media (max-width: 600px) {\n  body { font-size: 14px; }\n}\n```\n',
          },
        ),
        Lesson(
          id: 'les-web-04-02',
          moduleId: 'mod-web-04',
          title: 'Mobile-First Design',
          order: 2,
          estimatedMinutes: 6,
          content: {
            'markdown': '## Mobile First\n\n'
                'Design for small screens first, then scale up with media queries.\n',
          },
        ),
        Lesson(
          id: 'les-web-04-03',
          moduleId: 'mod-web-04',
          title: 'CSS Grid Basics',
          order: 3,
          estimatedMinutes: 8,
          content: {
            'markdown': '## CSS Grid\n\n'
                '```css\n.container {\n  display: grid;\n  grid-template-columns: repeat(3, 1fr);\n}\n```\n',
          },
        ),

        // mod-dsa-01: Arrays & Strings
        Lesson(
          id: 'les-dsa-01-01',
          moduleId: 'mod-dsa-01',
          title: 'Array Basics',
          order: 1,
          estimatedMinutes: 6,
          content: {
            'markdown': '## Arrays\n\n'
                'Arrays store elements at contiguous memory locations.\n\n'
                '```python\narr = [1, 2, 3, 4, 5]\nprint(arr[0])  # 1\n```\n',
          },
        ),
        Lesson(
          id: 'les-dsa-01-02',
          moduleId: 'mod-dsa-01',
          title: 'Two-Pointer Technique',
          order: 2,
          estimatedMinutes: 8,
          content: {
            'markdown': '## Two Pointers\n\n'
                'Use two pointers to reduce O(n²) problems to O(n).\n',
          },
        ),
        Lesson(
          id: 'les-dsa-01-03',
          moduleId: 'mod-dsa-01',
          title: 'String Manipulation',
          order: 3,
          estimatedMinutes: 7,
          content: {
            'markdown': '## Strings\n\n'
                'Common operations: reverse, palindrome check, anagram check.\n\n'
                '```python\nprint("hello"[::-1])  # "olleh"\n```\n',
          },
        ),

        // mod-dsa-02: Linked Lists
        Lesson(
          id: 'les-dsa-02-01',
          moduleId: 'mod-dsa-02',
          title: 'Singly Linked Lists',
          order: 1,
          estimatedMinutes: 8,
          content: {
            'markdown': '## Singly Linked List\n\n'
                'Each node holds a value and a pointer to the next node.\n',
          },
        ),
        Lesson(
          id: 'les-dsa-02-02',
          moduleId: 'mod-dsa-02',
          title: 'Traversal & Search',
          order: 2,
          estimatedMinutes: 7,
          content: {
            'markdown': '## Traversal\n\n'
                'Start at the head node and follow `next` pointers until `None`.\n',
          },
        ),
        Lesson(
          id: 'les-dsa-02-03',
          moduleId: 'mod-dsa-02',
          title: 'Insertion & Deletion',
          order: 3,
          estimatedMinutes: 8,
          content: {
            'markdown': '## Insertion\n\n'
                'Update the `next` pointer of the preceding node to insert a new node.\n',
          },
        ),

        // mod-dsa-03: Sorting & Searching
        Lesson(
          id: 'les-dsa-03-01',
          moduleId: 'mod-dsa-03',
          title: 'Bubble Sort',
          order: 1,
          estimatedMinutes: 7,
          content: {
            'markdown': '## Bubble Sort\n\n'
                'Repeatedly swap adjacent elements if they are in the wrong order. O(n²).\n',
          },
        ),
        Lesson(
          id: 'les-dsa-03-02',
          moduleId: 'mod-dsa-03',
          title: 'Merge Sort',
          order: 2,
          estimatedMinutes: 10,
          content: {
            'markdown': '## Merge Sort\n\n'
                'Divide and conquer: split, sort halves, merge. O(n log n).\n',
          },
        ),
        Lesson(
          id: 'les-dsa-03-03',
          moduleId: 'mod-dsa-03',
          title: 'Binary Search',
          order: 3,
          estimatedMinutes: 8,
          content: {
            'markdown': '## Binary Search\n\n'
                'Search a sorted array in O(log n) by halving the search space each step.\n',
          },
        ),

        // mod-dsa-04: Stacks & Queues
        Lesson(
          id: 'les-dsa-04-01',
          moduleId: 'mod-dsa-04',
          title: 'Stack (LIFO)',
          order: 1,
          estimatedMinutes: 6,
          content: {
            'markdown': '## Stack\n\n'
                'Last-In, First-Out. Operations: push, pop, peek.\n\n'
                '```python\nstack = []\nstack.append(1)\nstack.pop()\n```\n',
          },
        ),
        Lesson(
          id: 'les-dsa-04-02',
          moduleId: 'mod-dsa-04',
          title: 'Queue (FIFO)',
          order: 2,
          estimatedMinutes: 6,
          content: {
            'markdown': '## Queue\n\n'
                'First-In, First-Out. Use `collections.deque` in Python.\n\n'
                '```python\nfrom collections import deque\nq = deque()\nq.append(1)\nq.popleft()\n```\n',
          },
        ),
        Lesson(
          id: 'les-dsa-04-03',
          moduleId: 'mod-dsa-04',
          title: 'Real-World Applications',
          order: 3,
          estimatedMinutes: 7,
          content: {
            'markdown': '## Applications\n\n'
                '- **Stack**: undo/redo, call stack, balanced parentheses\n'
                '- **Queue**: print jobs, BFS, task scheduling\n',
          },
        ),
      ];

  // ── Challenges ─────────────────────────────────────────────────────────────
  static List<Challenge> get challenges => [
        // les-py-01-01
        Challenge(
          id: 'ch-py-01-01-a',
          lessonId: 'les-py-01-01',
          type: 'multiple_choice',
          prompt: 'Which keyword is used to assign a value to a variable in Python?',
          order: 1,
          data: {
            'options': ['var', 'let', '=', 'assign'],
            'correct_index': 2,
            'explanation': 'Python uses the = operator for assignment.',
          },
        ),
        Challenge(
          id: 'ch-py-01-01-b',
          lessonId: 'les-py-01-01',
          type: 'short_text',
          prompt: 'What is the value of x after: x = 5?',
          order: 2,
          data: {
            'acceptable': ['5'],
            'explanation': 'x is assigned the integer value 5.',
          },
        ),

        // les-py-01-02
        Challenge(
          id: 'ch-py-01-02-a',
          lessonId: 'les-py-01-02',
          type: 'multiple_choice',
          prompt: 'What is the result of 10 // 3 in Python?',
          order: 1,
          data: {
            'options': ['3.33', '3', '4', '1'],
            'correct_index': 1,
            'explanation': '// is integer (floor) division.',
          },
        ),
        Challenge(
          id: 'ch-py-01-02-b',
          lessonId: 'les-py-01-02',
          type: 'short_text',
          prompt: 'What type does 3.14 have in Python?',
          order: 2,
          data: {
            'acceptable': ['float', 'Float'],
            'explanation': '3.14 is a float (floating-point number).',
          },
        ),
        Challenge(
          id: 'ch-py-01-02-c',
          lessonId: 'les-py-01-02',
          type: 'multiple_choice',
          prompt: 'Which operator gives the remainder of division?',
          order: 3,
          data: {
            'options': ['/', '//', '%', '^'],
            'correct_index': 2,
            'explanation': 'The % operator returns the modulo (remainder).',
          },
        ),

        // les-py-01-03
        Challenge(
          id: 'ch-py-01-03-a',
          lessonId: 'les-py-01-03',
          type: 'multiple_choice',
          prompt: 'Which of these is a valid Python string?',
          order: 1,
          data: {
            'options': ['"hello"', '`hello`', '#hello#', '<<hello>>'],
            'correct_index': 0,
            'explanation': 'Python strings use single or double quotes.',
          },
        ),
        Challenge(
          id: 'ch-py-01-03-b',
          lessonId: 'les-py-01-03',
          type: 'code_style',
          prompt: 'Write a Python boolean literal for True.',
          order: 2,
          data: {
            'exact_match': 'True',
            'explanation': 'Python booleans are True and False (capitalised).',
          },
        ),

        // les-py-02-01
        Challenge(
          id: 'ch-py-02-01-a',
          lessonId: 'les-py-02-01',
          type: 'multiple_choice',
          prompt: 'What keyword starts an if statement in Python?',
          order: 1,
          data: {
            'options': ['if', 'when', 'check', 'case'],
            'correct_index': 0,
            'explanation': 'Python uses the if keyword for conditionals.',
          },
        ),
        Challenge(
          id: 'ch-py-02-01-b',
          lessonId: 'les-py-02-01',
          type: 'short_text',
          prompt: 'What keyword follows an if block to handle the opposite case?',
          order: 2,
          data: {
            'acceptable': ['else'],
            'explanation': 'else handles the case when the if condition is False.',
          },
        ),

        // les-py-02-02
        Challenge(
          id: 'ch-py-02-02-a',
          lessonId: 'les-py-02-02',
          type: 'multiple_choice',
          prompt: 'How many times does this loop run: for i in range(3)?',
          order: 1,
          data: {
            'options': ['2', '3', '4', '0'],
            'correct_index': 1,
            'explanation': 'range(3) produces 0, 1, 2 — three iterations.',
          },
        ),
        Challenge(
          id: 'ch-py-02-02-b',
          lessonId: 'les-py-02-02',
          type: 'code_style',
          prompt: 'Write the Python keyword used to iterate over a sequence.',
          order: 2,
          data: {
            'exact_match': 'for',
            'explanation': 'The for keyword is used to iterate.',
          },
        ),
        Challenge(
          id: 'ch-py-02-02-c',
          lessonId: 'les-py-02-02',
          type: 'multiple_choice',
          prompt: 'What does break do inside a loop?',
          order: 3,
          data: {
            'options': [
              'Skips current iteration',
              'Exits the loop immediately',
              'Restarts the loop',
              'Does nothing'
            ],
            'correct_index': 1,
            'explanation': 'break exits the nearest enclosing loop.',
          },
        ),

        // les-py-02-03
        Challenge(
          id: 'ch-py-02-03-a',
          lessonId: 'les-py-02-03',
          type: 'multiple_choice',
          prompt: 'A while loop continues as long as its condition is…',
          order: 1,
          data: {
            'options': ['False', 'True', 'None', 'Zero'],
            'correct_index': 1,
            'explanation': 'while keeps looping while the condition evaluates to True.',
          },
        ),
        Challenge(
          id: 'ch-py-02-03-b',
          lessonId: 'les-py-02-03',
          type: 'short_text',
          prompt: 'What keyword skips to the next iteration without exiting the loop?',
          order: 2,
          data: {
            'acceptable': ['continue'],
            'explanation': 'continue skips the rest of the current iteration.',
          },
        ),

        // les-py-03-01
        Challenge(
          id: 'ch-py-03-01-a',
          lessonId: 'les-py-03-01',
          type: 'multiple_choice',
          prompt: 'Which keyword is used to define a function in Python?',
          order: 1,
          data: {
            'options': ['func', 'function', 'def', 'define'],
            'correct_index': 2,
            'explanation': 'Python uses def to declare functions.',
          },
        ),
        Challenge(
          id: 'ch-py-03-01-b',
          lessonId: 'les-py-03-01',
          type: 'code_style',
          prompt: 'Write the Python keyword to define a function.',
          order: 2,
          data: {
            'exact_match': 'def',
            'explanation': 'def is short for "define".',
          },
        ),

        // les-py-03-02
        Challenge(
          id: 'ch-py-03-02-a',
          lessonId: 'les-py-03-02',
          type: 'multiple_choice',
          prompt: 'What keyword sends a value back from a function?',
          order: 1,
          data: {
            'options': ['send', 'yield', 'return', 'output'],
            'correct_index': 2,
            'explanation': 'return exits the function and optionally provides a value.',
          },
        ),
        Challenge(
          id: 'ch-py-03-02-b',
          lessonId: 'les-py-03-02',
          type: 'short_text',
          prompt: 'What does a function return if it has no return statement?',
          order: 2,
          data: {
            'acceptable': ['None', 'none'],
            'explanation': 'Python implicitly returns None when no return is specified.',
          },
        ),
        Challenge(
          id: 'ch-py-03-02-c',
          lessonId: 'les-py-03-02',
          type: 'multiple_choice',
          prompt: 'Function inputs are called…',
          order: 3,
          data: {
            'options': ['variables', 'parameters', 'constants', 'attributes'],
            'correct_index': 1,
            'explanation':
                'The inputs listed in the function signature are parameters.',
          },
        ),

        // les-py-03-03
        Challenge(
          id: 'ch-py-03-03-a',
          lessonId: 'les-py-03-03',
          type: 'multiple_choice',
          prompt: 'A variable created inside a function is…',
          order: 1,
          data: {
            'options': ['global', 'local', 'static', 'shared'],
            'correct_index': 1,
            'explanation':
                'Variables defined inside a function have local scope.',
          },
        ),
        Challenge(
          id: 'ch-py-03-03-b',
          lessonId: 'les-py-03-03',
          type: 'short_text',
          prompt:
              'What are parameters with a preset value called (two words)?',
          order: 2,
          data: {
            'acceptable': ['default arguments', 'default parameters'],
            'explanation':
                'Parameters with pre-set values are called default arguments.',
          },
        ),

        // les-py-04-01
        Challenge(
          id: 'ch-py-04-01-a',
          lessonId: 'les-py-04-01',
          type: 'multiple_choice',
          prompt: 'How do you add an element to the end of a Python list?',
          order: 1,
          data: {
            'options': ['list.add(x)', 'list.push(x)', 'list.append(x)', 'list.insert(x)'],
            'correct_index': 2,
            'explanation': 'append() adds an element to the end of a list.',
          },
        ),
        Challenge(
          id: 'ch-py-04-01-b',
          lessonId: 'les-py-04-01',
          type: 'short_text',
          prompt: 'What index does the first element of a list have?',
          order: 2,
          data: {
            'acceptable': ['0'],
            'explanation': 'Python lists are zero-indexed.',
          },
        ),

        // les-py-04-02
        Challenge(
          id: 'ch-py-04-02-a',
          lessonId: 'les-py-04-02',
          type: 'multiple_choice',
          prompt: 'What does my_list[1:3] return for [10, 20, 30, 40]?',
          order: 1,
          data: {
            'options': ['[10, 20]', '[20, 30]', '[20, 30, 40]', '[10, 20, 30]'],
            'correct_index': 1,
            'explanation': 'Slicing is start-inclusive, end-exclusive.',
          },
        ),
        Challenge(
          id: 'ch-py-04-02-b',
          lessonId: 'les-py-04-02',
          type: 'code_style',
          prompt: 'Write the method to remove and return the last element of a list.',
          order: 2,
          data: {
            'regex_pattern': r'^\.?pop\(\)$',
            'explanation': 'list.pop() removes and returns the last element.',
          },
        ),

        // les-py-04-03
        Challenge(
          id: 'ch-py-04-03-a',
          lessonId: 'les-py-04-03',
          type: 'multiple_choice',
          prompt: 'Which bracket style creates a Python dictionary?',
          order: 1,
          data: {
            'options': ['[]', '()', '{}', '<>'],
            'correct_index': 2,
            'explanation': 'Dictionaries use curly braces {}.',
          },
        ),
        Challenge(
          id: 'ch-py-04-03-b',
          lessonId: 'les-py-04-03',
          type: 'short_text',
          prompt: 'What do you call the lookup identifier in a dictionary?',
          order: 2,
          data: {
            'acceptable': ['key', 'Key'],
            'explanation': 'Dictionaries are accessed via keys.',
          },
        ),
        Challenge(
          id: 'ch-py-04-03-c',
          lessonId: 'les-py-04-03',
          type: 'multiple_choice',
          prompt: 'Which method returns all keys of a dictionary?',
          order: 3,
          data: {
            'options': ['dict.values()', 'dict.items()', 'dict.keys()', 'dict.all()'],
            'correct_index': 2,
            'explanation': 'dict.keys() returns a view of all keys.',
          },
        ),

        // les-web-01-01
        Challenge(
          id: 'ch-web-01-01-a',
          lessonId: 'les-web-01-01',
          type: 'multiple_choice',
          prompt: 'Which tag defines the root of an HTML document?',
          order: 1,
          data: {
            'options': ['<body>', '<root>', '<html>', '<head>'],
            'correct_index': 2,
            'explanation': '<html> is the root element of every HTML document.',
          },
        ),
        Challenge(
          id: 'ch-web-01-01-b',
          lessonId: 'les-web-01-01',
          type: 'short_text',
          prompt: 'What does DOCTYPE declaration tell the browser?',
          order: 2,
          data: {
            'acceptable': [
              'the document type',
              'html version',
              'document type',
              'type of document'
            ],
            'explanation':
                'DOCTYPE declares the HTML version/type to the browser.',
          },
        ),

        // les-web-01-02
        Challenge(
          id: 'ch-web-01-02-a',
          lessonId: 'les-web-01-02',
          type: 'multiple_choice',
          prompt: 'Which tag creates the largest heading?',
          order: 1,
          data: {
            'options': ['<h6>', '<heading>', '<h1>', '<big>'],
            'correct_index': 2,
            'explanation': '<h1> is the largest, most important heading.',
          },
        ),
        Challenge(
          id: 'ch-web-01-02-b',
          lessonId: 'les-web-01-02',
          type: 'code_style',
          prompt: 'Write the HTML tag for a paragraph.',
          order: 2,
          data: {
            'exact_match': '<p>',
            'explanation': '<p> defines a paragraph.',
          },
        ),

        // les-web-01-03
        Challenge(
          id: 'ch-web-01-03-a',
          lessonId: 'les-web-01-03',
          type: 'multiple_choice',
          prompt: 'Which attribute specifies the URL for a hyperlink?',
          order: 1,
          data: {
            'options': ['src', 'href', 'url', 'link'],
            'correct_index': 1,
            'explanation': 'The href attribute specifies the destination URL.',
          },
        ),
        Challenge(
          id: 'ch-web-01-03-b',
          lessonId: 'les-web-01-03',
          type: 'short_text',
          prompt: 'What attribute provides alternative text for an image?',
          order: 2,
          data: {
            'acceptable': ['alt'],
            'explanation': 'alt provides a text alternative for screen readers.',
          },
        ),

        // les-web-02-01
        Challenge(
          id: 'ch-web-02-01-a',
          lessonId: 'les-web-02-01',
          type: 'multiple_choice',
          prompt: 'How do you select an element with class "box" in CSS?',
          order: 1,
          data: {
            'options': ['#box', '.box', 'box', '*box'],
            'correct_index': 1,
            'explanation': 'Classes are selected with a dot prefix.',
          },
        ),
        Challenge(
          id: 'ch-web-02-01-b',
          lessonId: 'les-web-02-01',
          type: 'short_text',
          prompt: 'What symbol prefixes an ID selector in CSS?',
          order: 2,
          data: {
            'acceptable': ['#'],
            'explanation': 'ID selectors use the # symbol.',
          },
        ),

        // les-web-02-02
        Challenge(
          id: 'ch-web-02-02-a',
          lessonId: 'les-web-02-02',
          type: 'multiple_choice',
          prompt: 'From inside to outside, the box model layers are:',
          order: 1,
          data: {
            'options': [
              'margin → border → padding → content',
              'content → padding → border → margin',
              'padding → content → margin → border',
              'border → margin → content → padding'
            ],
            'correct_index': 1,
            'explanation':
                'content is innermost, then padding, border, and margin.',
          },
        ),
        Challenge(
          id: 'ch-web-02-02-b',
          lessonId: 'les-web-02-02',
          type: 'short_text',
          prompt: 'Which CSS property sets the space inside an element\'s border?',
          order: 2,
          data: {
            'acceptable': ['padding'],
            'explanation': 'padding creates space between content and border.',
          },
        ),

        // les-web-02-03
        Challenge(
          id: 'ch-web-02-03-a',
          lessonId: 'les-web-02-03',
          type: 'multiple_choice',
          prompt: 'Which CSS value enables flexbox on a container?',
          order: 1,
          data: {
            'options': ['display: block', 'display: flex', 'display: grid', 'display: inline'],
            'correct_index': 1,
            'explanation': 'display: flex activates flexbox layout.',
          },
        ),
        Challenge(
          id: 'ch-web-02-03-b',
          lessonId: 'les-web-02-03',
          type: 'short_text',
          prompt: 'Which flexbox property aligns items along the main axis?',
          order: 2,
          data: {
            'acceptable': ['justify-content'],
            'explanation': 'justify-content controls alignment on the main axis.',
          },
        ),
        Challenge(
          id: 'ch-web-02-03-c',
          lessonId: 'les-web-02-03',
          type: 'multiple_choice',
          prompt: 'Which property aligns flex items along the cross axis?',
          order: 3,
          data: {
            'options': [
              'justify-content',
              'align-items',
              'flex-direction',
              'flex-wrap'
            ],
            'correct_index': 1,
            'explanation': 'align-items aligns items on the cross axis.',
          },
        ),

        // les-web-03-01
        Challenge(
          id: 'ch-web-03-01-a',
          lessonId: 'les-web-03-01',
          type: 'multiple_choice',
          prompt: 'Which keyword declares a block-scoped variable in JS?',
          order: 1,
          data: {
            'options': ['var', 'let', 'def', 'dim'],
            'correct_index': 1,
            'explanation': 'let declares a block-scoped variable.',
          },
        ),
        Challenge(
          id: 'ch-web-03-01-b',
          lessonId: 'les-web-03-01',
          type: 'short_text',
          prompt: 'Which keyword declares a constant in JavaScript?',
          order: 2,
          data: {
            'acceptable': ['const'],
            'explanation': 'const declares a constant that cannot be reassigned.',
          },
        ),

        // les-web-03-02
        Challenge(
          id: 'ch-web-03-02-a',
          lessonId: 'les-web-03-02',
          type: 'multiple_choice',
          prompt: 'Which syntax represents an arrow function in JS?',
          order: 1,
          data: {
            'options': [
              'function() {}',
              '() -> {}',
              '() => {}',
              'fn() {}'
            ],
            'correct_index': 2,
            'explanation': '() => {} is the arrow function syntax.',
          },
        ),
        Challenge(
          id: 'ch-web-03-02-b',
          lessonId: 'les-web-03-02',
          type: 'short_text',
          prompt: 'What keyword defines a traditional JavaScript function?',
          order: 2,
          data: {
            'acceptable': ['function'],
            'explanation': 'The function keyword declares a traditional function.',
          },
        ),

        // les-web-03-03
        Challenge(
          id: 'ch-web-03-03-a',
          lessonId: 'les-web-03-03',
          type: 'multiple_choice',
          prompt: 'Which method selects a DOM element by its ID?',
          order: 1,
          data: {
            'options': [
              'document.querySelector()',
              'document.getElementById()',
              'document.getElement()',
              'document.selectById()'
            ],
            'correct_index': 1,
            'explanation': 'getElementById() selects an element by its ID attribute.',
          },
        ),
        Challenge(
          id: 'ch-web-03-03-b',
          lessonId: 'les-web-03-03',
          type: 'short_text',
          prompt: 'What property changes the text content of a DOM element?',
          order: 2,
          data: {
            'acceptable': ['textContent', 'innerText'],
            'explanation': 'textContent (or innerText) sets an element\'s text.',
          },
        ),
        Challenge(
          id: 'ch-web-03-03-c',
          lessonId: 'les-web-03-03',
          type: 'multiple_choice',
          prompt: 'How do you attach a click event listener in JS?',
          order: 3,
          data: {
            'options': [
              'element.onClick(fn)',
              'element.addEvent("click", fn)',
              'element.addEventListener("click", fn)',
              'element.on("click", fn)'
            ],
            'correct_index': 2,
            'explanation': 'addEventListener is the standard way to attach events.',
          },
        ),

        // les-web-04-01
        Challenge(
          id: 'ch-web-04-01-a',
          lessonId: 'les-web-04-01',
          type: 'multiple_choice',
          prompt: 'Media queries are written with which CSS at-rule?',
          order: 1,
          data: {
            'options': ['@screen', '@media', '@query', '@responsive'],
            'correct_index': 1,
            'explanation': '@media is the CSS at-rule for media queries.',
          },
        ),
        Challenge(
          id: 'ch-web-04-01-b',
          lessonId: 'les-web-04-01',
          type: 'short_text',
          prompt: 'Which feature condition checks the viewport width?',
          order: 2,
          data: {
            'acceptable': ['max-width', 'min-width'],
            'explanation': 'max-width and min-width are common media feature conditions.',
          },
        ),

        // les-web-04-02
        Challenge(
          id: 'ch-web-04-02-a',
          lessonId: 'les-web-04-02',
          type: 'multiple_choice',
          prompt: 'Mobile-first design means you start with styles for…',
          order: 1,
          data: {
            'options': ['large screens', 'small screens', 'tablets', 'print'],
            'correct_index': 1,
            'explanation': 'Mobile-first starts with styles for the smallest screens.',
          },
        ),
        Challenge(
          id: 'ch-web-04-02-b',
          lessonId: 'les-web-04-02',
          type: 'short_text',
          prompt: 'Which meta tag enables responsive design on mobile browsers?',
          order: 2,
          data: {
            'acceptable': ['viewport', '<meta name="viewport">'],
            'explanation': 'The viewport meta tag controls the layout viewport.',
          },
        ),

        // les-web-04-03
        Challenge(
          id: 'ch-web-04-03-a',
          lessonId: 'les-web-04-03',
          type: 'multiple_choice',
          prompt: 'Which CSS value enables grid layout?',
          order: 1,
          data: {
            'options': ['display: flex', 'display: grid', 'display: table', 'display: block'],
            'correct_index': 1,
            'explanation': 'display: grid enables CSS Grid layout.',
          },
        ),
        Challenge(
          id: 'ch-web-04-03-b',
          lessonId: 'les-web-04-03',
          type: 'short_text',
          prompt: 'Which property defines the columns of a grid container?',
          order: 2,
          data: {
            'acceptable': ['grid-template-columns'],
            'explanation': 'grid-template-columns sets the column track sizes.',
          },
        ),
        Challenge(
          id: 'ch-web-04-03-c',
          lessonId: 'les-web-04-03',
          type: 'multiple_choice',
          prompt: 'The fr unit in CSS grid means…',
          order: 3,
          data: {
            'options': ['fixed row', 'fraction of free space', 'font-relative', 'flex ratio'],
            'correct_index': 1,
            'explanation': 'fr represents a fraction of the available free space.',
          },
        ),

        // les-dsa-01-01
        Challenge(
          id: 'ch-dsa-01-01-a',
          lessonId: 'les-dsa-01-01',
          type: 'multiple_choice',
          prompt: 'Accessing an element by index in an array is…',
          order: 1,
          data: {
            'options': ['O(n)', 'O(log n)', 'O(1)', 'O(n²)'],
            'correct_index': 2,
            'explanation': 'Array random access by index is O(1).',
          },
        ),
        Challenge(
          id: 'ch-dsa-01-01-b',
          lessonId: 'les-dsa-01-01',
          type: 'short_text',
          prompt: 'What index is used to access the last element of a Python list called arr?',
          order: 2,
          data: {
            'acceptable': ['-1', 'len(arr)-1', 'len(arr) - 1'],
            'explanation': 'Use -1 or len(arr)-1 to access the last element.',
          },
        ),

        // les-dsa-01-02
        Challenge(
          id: 'ch-dsa-01-02-a',
          lessonId: 'les-dsa-01-02',
          type: 'multiple_choice',
          prompt: 'The two-pointer technique typically reduces time complexity from…',
          order: 1,
          data: {
            'options': ['O(n³) to O(n²)', 'O(n²) to O(n)', 'O(n) to O(1)', 'O(log n) to O(1)'],
            'correct_index': 1,
            'explanation': 'Two pointers often reduce nested-loop O(n²) to O(n).',
          },
        ),
        Challenge(
          id: 'ch-dsa-01-02-b',
          lessonId: 'les-dsa-01-02',
          type: 'short_text',
          prompt: 'In the two-pointer approach, where do the pointers usually start?',
          order: 2,
          data: {
            'acceptable': ['both ends', 'start and end', 'left and right'],
            'explanation': 'Pointers typically start at both ends of the array.',
          },
        ),

        // les-dsa-01-03
        Challenge(
          id: 'ch-dsa-01-03-a',
          lessonId: 'les-dsa-01-03',
          type: 'multiple_choice',
          prompt: 'Which Python syntax reverses a string s?',
          order: 1,
          data: {
            'options': ['s.reverse()', 's[::-1]', 'reverse(s)', 's.reversed()'],
            'correct_index': 1,
            'explanation': 's[::-1] creates a reversed copy using slice notation.',
          },
        ),
        Challenge(
          id: 'ch-dsa-01-03-b',
          lessonId: 'les-dsa-01-03',
          type: 'short_text',
          prompt: 'What is a word or phrase that reads the same forwards and backwards?',
          order: 2,
          data: {
            'acceptable': ['palindrome'],
            'explanation': 'A palindrome reads the same in both directions.',
          },
        ),

        // les-dsa-02-01
        Challenge(
          id: 'ch-dsa-02-01-a',
          lessonId: 'les-dsa-02-01',
          type: 'multiple_choice',
          prompt: 'In a singly linked list, each node contains…',
          order: 1,
          data: {
            'options': [
              'only a value',
              'a value and a pointer to the next node',
              'pointers to both next and previous nodes',
              'an index and a value'
            ],
            'correct_index': 1,
            'explanation': 'Singly linked list nodes have a value and a next pointer.',
          },
        ),
        Challenge(
          id: 'ch-dsa-02-01-b',
          lessonId: 'les-dsa-02-01',
          type: 'short_text',
          prompt: 'What is the first node in a linked list called?',
          order: 2,
          data: {
            'acceptable': ['head'],
            'explanation': 'The first node is called the head.',
          },
        ),

        // les-dsa-02-02
        Challenge(
          id: 'ch-dsa-02-02-a',
          lessonId: 'les-dsa-02-02',
          type: 'multiple_choice',
          prompt: 'Traversing a linked list of n nodes takes…',
          order: 1,
          data: {
            'options': ['O(1)', 'O(log n)', 'O(n)', 'O(n²)'],
            'correct_index': 2,
            'explanation': 'You must visit each node once — O(n).',
          },
        ),
        Challenge(
          id: 'ch-dsa-02-02-b',
          lessonId: 'les-dsa-02-02',
          type: 'short_text',
          prompt: 'What value does the last node\'s next pointer hold?',
          order: 2,
          data: {
            'acceptable': ['None', 'null', 'nil'],
            'explanation': 'The last node points to None (or null/nil).',
          },
        ),

        // les-dsa-02-03
        Challenge(
          id: 'ch-dsa-02-03-a',
          lessonId: 'les-dsa-02-03',
          type: 'multiple_choice',
          prompt: 'Inserting at the head of a linked list is…',
          order: 1,
          data: {
            'options': ['O(n)', 'O(log n)', 'O(n²)', 'O(1)'],
            'correct_index': 3,
            'explanation': 'Head insertion only requires updating one pointer — O(1).',
          },
        ),
        Challenge(
          id: 'ch-dsa-02-03-b',
          lessonId: 'les-dsa-02-03',
          type: 'short_text',
          prompt: 'How many pointers must you update to delete a middle node?',
          order: 2,
          data: {
            'acceptable': ['1', 'one'],
            'explanation':
                'Set the previous node\'s next pointer to the deleted node\'s next.',
          },
        ),

        // les-dsa-03-01
        Challenge(
          id: 'ch-dsa-03-01-a',
          lessonId: 'les-dsa-03-01',
          type: 'multiple_choice',
          prompt: 'What is the worst-case time complexity of bubble sort?',
          order: 1,
          data: {
            'options': ['O(n)', 'O(n log n)', 'O(n²)', 'O(log n)'],
            'correct_index': 2,
            'explanation': 'Bubble sort is O(n²) in the worst case.',
          },
        ),
        Challenge(
          id: 'ch-dsa-03-01-b',
          lessonId: 'les-dsa-03-01',
          type: 'short_text',
          prompt: 'Bubble sort is a ______-sort algorithm (in-place / out-of-place)?',
          order: 2,
          data: {
            'acceptable': ['in-place', 'in place'],
            'explanation': 'Bubble sort sorts the array in place without extra space.',
          },
        ),

        // les-dsa-03-02
        Challenge(
          id: 'ch-dsa-03-02-a',
          lessonId: 'les-dsa-03-02',
          type: 'multiple_choice',
          prompt: 'Merge sort\'s time complexity is…',
          order: 1,
          data: {
            'options': ['O(n²)', 'O(n)', 'O(n log n)', 'O(log n)'],
            'correct_index': 2,
            'explanation': 'Merge sort is O(n log n) in all cases.',
          },
        ),
        Challenge(
          id: 'ch-dsa-03-02-b',
          lessonId: 'les-dsa-03-02',
          type: 'short_text',
          prompt: 'Merge sort follows the ______ and conquer paradigm.',
          order: 2,
          data: {
            'acceptable': ['divide', 'divide and conquer'],
            'explanation': 'Merge sort is a classic divide-and-conquer algorithm.',
          },
        ),

        // les-dsa-03-03
        Challenge(
          id: 'ch-dsa-03-03-a',
          lessonId: 'les-dsa-03-03',
          type: 'multiple_choice',
          prompt: 'Binary search requires the input array to be…',
          order: 1,
          data: {
            'options': ['unsorted', 'sorted', 'unique', 'non-empty'],
            'correct_index': 1,
            'explanation': 'Binary search only works on sorted arrays.',
          },
        ),
        Challenge(
          id: 'ch-dsa-03-03-b',
          lessonId: 'les-dsa-03-03',
          type: 'short_text',
          prompt: 'Binary search has a time complexity of…',
          order: 2,
          data: {
            'acceptable': ['O(log n)', 'O(logn)'],
            'explanation': 'Binary search halves the search space each step — O(log n).',
          },
        ),

        // les-dsa-04-01
        Challenge(
          id: 'ch-dsa-04-01-a',
          lessonId: 'les-dsa-04-01',
          type: 'multiple_choice',
          prompt: 'A stack follows which principle?',
          order: 1,
          data: {
            'options': ['FIFO', 'FILO', 'LIFO', 'LILO'],
            'correct_index': 2,
            'explanation': 'Stacks are Last-In, First-Out (LIFO).',
          },
        ),
        Challenge(
          id: 'ch-dsa-04-01-b',
          lessonId: 'les-dsa-04-01',
          type: 'short_text',
          prompt: 'Which operation adds an element to a stack?',
          order: 2,
          data: {
            'acceptable': ['push'],
            'explanation': 'push adds an element to the top of a stack.',
          },
        ),

        // les-dsa-04-02
        Challenge(
          id: 'ch-dsa-04-02-a',
          lessonId: 'les-dsa-04-02',
          type: 'multiple_choice',
          prompt: 'A queue follows which principle?',
          order: 1,
          data: {
            'options': ['LIFO', 'FILO', 'FIFO', 'LILO'],
            'correct_index': 2,
            'explanation': 'Queues are First-In, First-Out (FIFO).',
          },
        ),
        Challenge(
          id: 'ch-dsa-04-02-b',
          lessonId: 'les-dsa-04-02',
          type: 'short_text',
          prompt: 'Which Python class is recommended for efficient queue operations?',
          order: 2,
          data: {
            'acceptable': ['deque', 'collections.deque'],
            'explanation': 'collections.deque provides O(1) append and popleft.',
          },
        ),

        // les-dsa-04-03
        Challenge(
          id: 'ch-dsa-04-03-a',
          lessonId: 'les-dsa-04-03',
          type: 'multiple_choice',
          prompt: 'Which traversal algorithm uses a queue?',
          order: 1,
          data: {
            'options': ['DFS', 'BFS', 'Dijkstra', 'A*'],
            'correct_index': 1,
            'explanation': 'Breadth-First Search (BFS) uses a queue.',
          },
        ),
        Challenge(
          id: 'ch-dsa-04-03-b',
          lessonId: 'les-dsa-04-03',
          type: 'short_text',
          prompt: 'Which data structure is used to implement undo/redo functionality?',
          order: 2,
          data: {
            'acceptable': ['stack'],
            'explanation': 'A stack naturally supports undo (pop) and redo operations.',
          },
        ),
      ];

  // ── Quiz Questions ─────────────────────────────────────────────────────────
  static List<QuizQuestion> get quizQuestions => [
        // mod-py-01
        QuizQuestion(
          id: 'qz-py-01-01',
          moduleId: 'mod-py-01',
          type: 'multiple_choice',
          prompt: 'Which of the following is NOT a valid Python data type?',
          order: 1,
          data: {
            'options': ['int', 'float', 'char', 'bool'],
            'correct_index': 2,
            'explanation': 'Python has no char type; single characters are strings.',
          },
        ),
        QuizQuestion(
          id: 'qz-py-01-02',
          moduleId: 'mod-py-01',
          type: 'short_text',
          prompt: 'What function converts a number to a string in Python?',
          order: 2,
          data: {
            'acceptable': ['str()', 'str'],
            'explanation': 'str() converts a value to its string representation.',
          },
        ),
        QuizQuestion(
          id: 'qz-py-01-03',
          moduleId: 'mod-py-01',
          type: 'multiple_choice',
          prompt: 'What is the result of type(42) in Python?',
          order: 3,
          data: {
            'options': ["<class 'str'>", "<class 'float'>", "<class 'int'>", "<class 'number'>"],
            'correct_index': 2,
            'explanation': '42 is an integer, so type() returns <class \'int\'>.',
          },
        ),

        // mod-py-02
        QuizQuestion(
          id: 'qz-py-02-01',
          moduleId: 'mod-py-02',
          type: 'multiple_choice',
          prompt: 'Which statement is used to exit a loop prematurely?',
          order: 1,
          data: {
            'options': ['exit', 'stop', 'break', 'end'],
            'correct_index': 2,
            'explanation': 'break exits the nearest enclosing loop.',
          },
        ),
        QuizQuestion(
          id: 'qz-py-02-02',
          moduleId: 'mod-py-02',
          type: 'short_text',
          prompt: 'What does range(1, 6) produce?',
          order: 2,
          data: {
            'acceptable': ['1, 2, 3, 4, 5', '[1, 2, 3, 4, 5]'],
            'explanation': 'range(1, 6) generates integers from 1 up to (not including) 6.',
          },
        ),
        QuizQuestion(
          id: 'qz-py-02-03',
          moduleId: 'mod-py-02',
          type: 'multiple_choice',
          prompt: 'What is printed by: for x in [1,2,3]: if x == 2: continue; print(x)',
          order: 3,
          data: {
            'options': ['1 2 3', '1 3', '2', '1 2'],
            'correct_index': 1,
            'explanation': 'continue skips printing 2, so 1 and 3 are printed.',
          },
        ),

        // mod-py-03
        QuizQuestion(
          id: 'qz-py-03-01',
          moduleId: 'mod-py-03',
          type: 'multiple_choice',
          prompt: 'What is a lambda in Python?',
          order: 1,
          data: {
            'options': [
              'A loop construct',
              'An anonymous function',
              'A class decorator',
              'A variable type'
            ],
            'correct_index': 1,
            'explanation': 'lambda creates small anonymous functions.',
          },
        ),
        QuizQuestion(
          id: 'qz-py-03-02',
          moduleId: 'mod-py-03',
          type: 'short_text',
          prompt: 'What keyword accesses a global variable inside a function?',
          order: 2,
          data: {
            'acceptable': ['global'],
            'explanation': 'The global keyword lets you modify a global variable inside a function.',
          },
        ),
        QuizQuestion(
          id: 'qz-py-03-03',
          moduleId: 'mod-py-03',
          type: 'multiple_choice',
          prompt: 'A function that calls itself is called…',
          order: 3,
          data: {
            'options': ['iterative', 'recursive', 'lambda', 'closure'],
            'correct_index': 1,
            'explanation': 'A function that calls itself is recursive.',
          },
        ),

        // mod-py-04
        QuizQuestion(
          id: 'qz-py-04-01',
          moduleId: 'mod-py-04',
          type: 'multiple_choice',
          prompt: 'How do you check if a key exists in a dictionary d?',
          order: 1,
          data: {
            'options': ['d.has("key")', '"key" in d', 'd.contains("key")', 'd.exists("key")'],
            'correct_index': 1,
            'explanation': 'The in operator checks for key membership.',
          },
        ),
        QuizQuestion(
          id: 'qz-py-04-02',
          moduleId: 'mod-py-04',
          type: 'short_text',
          prompt: 'What method removes and returns an arbitrary (key, value) pair from a dict?',
          order: 2,
          data: {
            'acceptable': ['popitem()', 'popitem'],
            'explanation': 'dict.popitem() removes and returns the last inserted key-value pair.',
          },
        ),
        QuizQuestion(
          id: 'qz-py-04-03',
          moduleId: 'mod-py-04',
          type: 'multiple_choice',
          prompt: 'Which creates a list of squares [1, 4, 9] using list comprehension?',
          order: 3,
          data: {
            'options': [
              '[x^2 for x in range(1,4)]',
              '[x**2 for x in range(1,4)]',
              '[x*x in range(1,4)]',
              '[square(x) for x in range(1,4)]'
            ],
            'correct_index': 1,
            'explanation': 'x**2 is the exponentiation operator in Python.',
          },
        ),

        // mod-web-01
        QuizQuestion(
          id: 'qz-web-01-01',
          moduleId: 'mod-web-01',
          type: 'multiple_choice',
          prompt: 'Which HTML element is used for the main navigation links?',
          order: 1,
          data: {
            'options': ['<menu>', '<nav>', '<section>', '<header>'],
            'correct_index': 1,
            'explanation': '<nav> is the semantic element for navigation links.',
          },
        ),
        QuizQuestion(
          id: 'qz-web-01-02',
          moduleId: 'mod-web-01',
          type: 'short_text',
          prompt: 'Which HTML element groups related form inputs with a visible border?',
          order: 2,
          data: {
            'acceptable': ['fieldset', '<fieldset>'],
            'explanation': '<fieldset> groups related form controls.',
          },
        ),
        QuizQuestion(
          id: 'qz-web-01-03',
          moduleId: 'mod-web-01',
          type: 'multiple_choice',
          prompt: 'Which attribute makes an HTML input required?',
          order: 3,
          data: {
            'options': ['mandatory', 'required', 'validate', 'must'],
            'correct_index': 1,
            'explanation': 'The required attribute prevents form submission if the field is empty.',
          },
        ),

        // mod-web-02
        QuizQuestion(
          id: 'qz-web-02-01',
          moduleId: 'mod-web-02',
          type: 'multiple_choice',
          prompt: 'Which CSS property controls text size?',
          order: 1,
          data: {
            'options': ['text-size', 'font-size', 'letter-size', 'text-scale'],
            'correct_index': 1,
            'explanation': 'font-size sets the size of the text.',
          },
        ),
        QuizQuestion(
          id: 'qz-web-02-02',
          moduleId: 'mod-web-02',
          type: 'short_text',
          prompt: 'What does "em" refer to in CSS units?',
          order: 2,
          data: {
            'acceptable': [
              'font size of the parent',
              'parent font size',
              'the font size of the element',
            ],
            'explanation': '1em equals the font-size of the current element (or parent).',
          },
        ),
        QuizQuestion(
          id: 'qz-web-02-03',
          moduleId: 'mod-web-02',
          type: 'multiple_choice',
          prompt: 'Which CSS property makes an element not visible but still occupies space?',
          order: 3,
          data: {
            'options': ['display: none', 'opacity: 0', 'visibility: hidden', 'hidden: true'],
            'correct_index': 2,
            'explanation': 'visibility: hidden hides the element but preserves its space.',
          },
        ),

        // mod-web-03
        QuizQuestion(
          id: 'qz-web-03-01',
          moduleId: 'mod-web-03',
          type: 'multiple_choice',
          prompt: 'Which JS method converts a JSON string to an object?',
          order: 1,
          data: {
            'options': ['JSON.stringify()', 'JSON.parse()', 'JSON.decode()', 'JSON.toObject()'],
            'correct_index': 1,
            'explanation': 'JSON.parse() converts a JSON string into a JavaScript object.',
          },
        ),
        QuizQuestion(
          id: 'qz-web-03-02',
          moduleId: 'mod-web-03',
          type: 'short_text',
          prompt: 'What method adds an element to the end of a JavaScript array?',
          order: 2,
          data: {
            'acceptable': ['push()', 'push'],
            'explanation': 'array.push() appends one or more elements.',
          },
        ),
        QuizQuestion(
          id: 'qz-web-03-03',
          moduleId: 'mod-web-03',
          type: 'multiple_choice',
          prompt: 'Which operator checks both value and type equality in JS?',
          order: 3,
          data: {
            'options': ['==', '=', '===', '!='],
            'correct_index': 2,
            'explanation': '=== is the strict equality operator (value + type).',
          },
        ),

        // mod-web-04
        QuizQuestion(
          id: 'qz-web-04-01',
          moduleId: 'mod-web-04',
          type: 'multiple_choice',
          prompt: 'What does "responsive" mean in web design?',
          order: 1,
          data: {
            'options': [
              'Pages load quickly',
              'Pages look good on all screen sizes',
              'Pages have animations',
              'Pages use dark mode'
            ],
            'correct_index': 1,
            'explanation': 'Responsive design adapts layout to any screen size.',
          },
        ),
        QuizQuestion(
          id: 'qz-web-04-02',
          moduleId: 'mod-web-04',
          type: 'short_text',
          prompt: 'What CSS unit is relative to the viewport width?',
          order: 2,
          data: {
            'acceptable': ['vw'],
            'explanation': '1vw = 1% of the viewport width.',
          },
        ),
        QuizQuestion(
          id: 'qz-web-04-03',
          moduleId: 'mod-web-04',
          type: 'multiple_choice',
          prompt: 'Which CSS property controls how flex items wrap?',
          order: 3,
          data: {
            'options': ['flex-flow', 'flex-wrap', 'flex-direction', 'flex-grow'],
            'correct_index': 1,
            'explanation': 'flex-wrap controls whether items wrap to a new line.',
          },
        ),

        // mod-dsa-01
        QuizQuestion(
          id: 'qz-dsa-01-01',
          moduleId: 'mod-dsa-01',
          type: 'multiple_choice',
          prompt: 'What is the time complexity of searching for a value in an unsorted array?',
          order: 1,
          data: {
            'options': ['O(1)', 'O(log n)', 'O(n)', 'O(n²)'],
            'correct_index': 2,
            'explanation': 'Linear search on an unsorted array requires O(n) time.',
          },
        ),
        QuizQuestion(
          id: 'qz-dsa-01-02',
          moduleId: 'mod-dsa-01',
          type: 'short_text',
          prompt: 'Two strings are anagrams if they contain the same characters in any ______.',
          order: 2,
          data: {
            'acceptable': ['order', 'arrangement'],
            'explanation': 'Anagrams have the same characters but in different orders.',
          },
        ),
        QuizQuestion(
          id: 'qz-dsa-01-03',
          moduleId: 'mod-dsa-01',
          type: 'multiple_choice',
          prompt: 'Sliding window is best used for problems involving…',
          order: 3,
          data: {
            'options': [
              'Sorting',
              'Contiguous sub-arrays or substrings',
              'Graph traversal',
              'Tree operations'
            ],
            'correct_index': 1,
            'explanation': 'Sliding window efficiently handles contiguous sub-array problems.',
          },
        ),

        // mod-dsa-02
        QuizQuestion(
          id: 'qz-dsa-02-01',
          moduleId: 'mod-dsa-02',
          type: 'multiple_choice',
          prompt: 'A doubly linked list node has pointers to…',
          order: 1,
          data: {
            'options': [
              'only next',
              'only previous',
              'both next and previous',
              'parent and child'
            ],
            'correct_index': 2,
            'explanation': 'Doubly linked list nodes point to both next and previous nodes.',
          },
        ),
        QuizQuestion(
          id: 'qz-dsa-02-02',
          moduleId: 'mod-dsa-02',
          type: 'short_text',
          prompt: 'What is the last node of a linked list called?',
          order: 2,
          data: {
            'acceptable': ['tail'],
            'explanation': 'The last node is called the tail.',
          },
        ),
        QuizQuestion(
          id: 'qz-dsa-02-03',
          moduleId: 'mod-dsa-02',
          type: 'multiple_choice',
          prompt: 'Detecting a cycle in a linked list is efficiently done with…',
          order: 3,
          data: {
            'options': [
              'Two pointers (fast & slow)',
              'Sorting',
              'Binary search',
              'Hash map only'
            ],
            'correct_index': 0,
            'explanation':
                'Floyd\'s cycle detection uses fast and slow pointers.',
          },
        ),

        // mod-dsa-03
        QuizQuestion(
          id: 'qz-dsa-03-01',
          moduleId: 'mod-dsa-03',
          type: 'multiple_choice',
          prompt: 'Which algorithm is most efficient for sorting a nearly-sorted array?',
          order: 1,
          data: {
            'options': ['Merge sort', 'Quick sort', 'Insertion sort', 'Bubble sort'],
            'correct_index': 2,
            'explanation':
                'Insertion sort is nearly O(n) on nearly-sorted data.',
          },
        ),
        QuizQuestion(
          id: 'qz-dsa-03-02',
          moduleId: 'mod-dsa-03',
          type: 'short_text',
          prompt: 'What is the best-case time complexity of binary search?',
          order: 2,
          data: {
            'acceptable': ['O(1)'],
            'explanation': 'If the target is the middle element, it\'s found in O(1).',
          },
        ),
        QuizQuestion(
          id: 'qz-dsa-03-03',
          moduleId: 'mod-dsa-03',
          type: 'multiple_choice',
          prompt: 'Quick sort\'s average time complexity is…',
          order: 3,
          data: {
            'options': ['O(n²)', 'O(n log n)', 'O(n)', 'O(log n)'],
            'correct_index': 1,
            'explanation': 'Quick sort averages O(n log n) with a good pivot.',
          },
        ),

        // mod-dsa-04
        QuizQuestion(
          id: 'qz-dsa-04-01',
          moduleId: 'mod-dsa-04',
          type: 'multiple_choice',
          prompt: 'Which data structure is used for function call management?',
          order: 1,
          data: {
            'options': ['Queue', 'Stack', 'Array', 'Tree'],
            'correct_index': 1,
            'explanation': 'The call stack manages function invocations.',
          },
        ),
        QuizQuestion(
          id: 'qz-dsa-04-02',
          moduleId: 'mod-dsa-04',
          type: 'short_text',
          prompt: 'Which queue operation removes the front element?',
          order: 2,
          data: {
            'acceptable': ['dequeue', 'popleft', 'dequeue()'],
            'explanation': 'dequeue (or popleft) removes the front element of a queue.',
          },
        ),
        QuizQuestion(
          id: 'qz-dsa-04-03',
          moduleId: 'mod-dsa-04',
          type: 'multiple_choice',
          prompt: 'A priority queue dequeues elements based on…',
          order: 3,
          data: {
            'options': ['insertion order', 'priority value', 'alphabetical order', 'random order'],
            'correct_index': 1,
            'explanation': 'Priority queues serve the highest-priority element first.',
          },
        ),
      ];
}
