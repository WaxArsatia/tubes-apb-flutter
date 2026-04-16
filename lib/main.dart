import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tubes_apb_flutter/app/app.dart';
import 'package:tubes_apb_flutter/core/session/auth_session_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  await container.read(authSessionControllerProvider.notifier).restoreSession();

  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
