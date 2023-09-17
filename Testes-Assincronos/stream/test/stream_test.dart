import 'package:stream/stream.dart';
import 'package:test/test.dart';

void main() {
  test('deve completar a requisição trazendo uma lista de nomes', () {
    final stream = getStreamList();

    // analisa somente o primeiro item da stream
    //expect(stream,emits('masterclass'));

    // analisa todo o fluxo
    expect(stream,emitsInOrder(['masterclass','flutterando']));
  });
}
