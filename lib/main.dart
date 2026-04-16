import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tubes_apb_flutter/app/app.dart';
import 'package:tubes_apb_flutter/core/session/auth_session_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  final sessionController = container.read(
    authSessionControllerProvider.notifier,
  );

  try {
    await sessionController.restoreSession();
  } catch (error, stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'app_startup',
        context: ErrorDescription('while restoring auth session'),
      ),
    );

    try {
      await sessionController.markUnauthenticated(clearRefreshToken: false);
    } catch (fallbackError, fallbackStackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: fallbackError,
          stack: fallbackStackTrace,
          library: 'app_startup',
          context: ErrorDescription('while applying unauthenticated fallback'),
        ),
      );
    }
  }

  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
