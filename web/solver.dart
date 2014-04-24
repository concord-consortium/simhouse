import 'dart:isolate';
import 'dart:math';


void main(List<double> args, SendPort port) {
  
  assert(!args.isEmpty);

  // do some mindless work
  for (int i=0; i<100; i++) {

    List<double> results = new List<double>();
    // callback to the animation thread
    double percentComplete = i / 100;
    results.add(percentComplete);

    int n = 5000;
    double sum = 0.0;
    for (int j=0; j<n; j++) {
      for (int k=0; k<n; k++) {
        double x = cos(i * j * k);
        sum += x;
      }
    }
    results.add(sum);
    results.add(args[0]);
    results.add(args[1]);

    port.send(results);

  }

}
