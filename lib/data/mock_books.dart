import '../models/book.dart';


const mockBooks = <Book>{
  Book(
    id: 1042,
    title: 'Clean Code',
    author: 'Robert C. Martin',
    status: BookStatus.available,
    coverUrl: 'https://covers.openlibrary.org/b/isbn/9780132350884-L.jpg',
  ),
  Book(
    id: 1043,
    title: 'Design Patterns',
    author: 'Erich Gamma',
    status: BookStatus.borrowed,
    dueDate: '20 Nov',
    expectedReturn: '20 Nov',
    coverUrl: 'https://covers.openlibrary.org/b/isbn/9780201633610-L.jpg',
  ),
  Book(
    id: 1044,
    title: 'Deep Learning',
    author: 'Ian Goodfellow',
    status: BookStatus.available,
    coverUrl: 'https://covers.openlibrary.org/b/isbn/9780262035613-L.jpg',
  ),
};