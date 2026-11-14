enum BookStatus { available, borrowed}

class Book{
  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.status,
    this.coverUrl,
    this.dueDate,
    this.expectedReturn,
});

  final int id;
  final String title;
  final String author;
  final BookStatus status;
  final String? coverUrl;
  final String? dueDate;
  final String? expectedReturn;

  bool get isAvailable =>status == BookStatus.available;
}