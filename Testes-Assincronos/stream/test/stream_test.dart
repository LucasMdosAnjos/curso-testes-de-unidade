import 'package:stream/stream.dart';
import 'package:test/test.dart';

void main() {
  test('deve completar a requisição trazendo uma lista de nomes', () {
    final stream = getStreamList();
    
    expect(stream,emits('masterclass'));


  });
}
