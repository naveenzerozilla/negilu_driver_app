import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Model/supportModel.dart';
import '../Model/support_option.dart';
import '../core/Repository/support_repository.dart';

// Repository provider
final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  return SupportRepository();
});

// Tickets provider
final supportTicketsProvider = FutureProvider.autoDispose<List<SupportTicket>>((
  ref,
) {
  return ref.read(supportRepositoryProvider).fetchSupportTickets();
});


final supportOptionsProvider =
FutureProvider<Map<String, List<SupportOption>>>((ref) {
  return ref.read(supportRepositoryProvider).fetchSupportOptions();
});