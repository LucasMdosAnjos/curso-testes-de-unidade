import 'dart:io';

import 'package:leitor_lcov/line_report.dart';

void main(List<String> args) {
  final result = coverage('coverage/lcov.info');
  print(result);
}

String coverage(String lcovPath) {
  final file = File(lcovPath);
  final content = file.readAsLinesSync();

  final reports = <LineReport>[];

  var sf = '';
  var lf = 0;
  var lh = 0;
  for (var text in content) {
    if (text == 'end_of_record') {
      final report = LineReport(sourceFile: sf, lineFound: lf, lineHit: lh);

      reports.add(report);

      continue;
    }

    final line = text.split(':');

    if(line[0] == 'SF'){
      sf = line[1];
    } else if (line[0] == 'LF'){
      lf = int.parse(line[1]);
    } else if (line[0] == 'LH'){
      lh = int.parse(line[1]);
    }

  }

  int totalLF = 0;
  int totalLH = 0;
  for (var report in reports) {
    totalLF += report.lineFound;
    totalLH += report.lineHit;
  }

  final percent = (totalLH / totalLF) * 100;

  return '${percent.toInt()}%';
}
