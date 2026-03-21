/// Injectable dialogs. Use from anywhere in the app.
///
/// Example:
/// ```dart
/// import 'package:crb_mobile/dialogs/dialogs.dart';
///
/// // Show OTP dialog (loading then completes; use onVerified for next step)
/// await OtpDialog.show(context);
///
/// // Show OTP with custom callback
/// await OtpDialog.show(context, onVerified: (code) async { ... });
///
/// // Show success dialog
/// await SuccessDialog.show(context);
/// ```
library;

export 'package:crb_mobile/dialogs/balance_code_dialog.dart';
export 'package:crb_mobile/dialogs/dialog_theme.dart';
export 'package:crb_mobile/dialogs/logout_dialog.dart';
export 'package:crb_mobile/dialogs/otp_dialog.dart';
export 'package:crb_mobile/dialogs/success_dialog.dart';
