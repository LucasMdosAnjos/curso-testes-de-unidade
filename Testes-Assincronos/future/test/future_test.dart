import 'package:future/future.dart';
import 'package:test/test.dart';

void main() {
  test('deve completar a requisição trazendo uma lista de nomes', () {
    final future = getFutureList();

    expect(future,completes);

    expect(future,completion(isA<List<String>>()));

    expect(future,completion(equals(['masterclass','flutterando'])));

    // se retorna erro faz do jeito abaixo:
    //expect(future,throwsA(matcher));
  });
}
