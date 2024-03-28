// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bonsoir/bonsoir.dart';

final deviceDiscoveryProvider = Provider<BonsoirDiscovery>((ref) {
  final discovery = BonsoirDiscovery(type: '_testing._udp');

  discovery.ready.then((value) {
    discovery.eventStream!.listen(((event) => print('[Event] ${event.type}')));

    print('Starting');
    discovery.start();
  });

  ref.onDispose(() async {
    print('Stopping');
    await discovery.stop();
    print('Stopped');
  });

  return discovery;
});

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(deviceDiscoveryProvider);

    Timer.periodic(const Duration(seconds: 1), (timer) {
      ref.invalidate(deviceDiscoveryProvider);
    });

    return const MaterialApp(
      title: 'Bonsoir test',
      home: Scaffold(body: Center(child: Text('Hello World'))),
    );
  }
}
