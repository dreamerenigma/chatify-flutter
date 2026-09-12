import '../../../core/enums/call_status_type.dart';
import '../../../core/enums/call_type.dart';

class CallResult {
  final CallType type;
  final CallStatusType status;

  const CallResult({
    required this.type,
    required this.status,
  });
}
