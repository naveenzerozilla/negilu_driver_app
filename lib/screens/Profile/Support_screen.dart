import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Provider/support_provider.dart';

class SupportScreen extends ConsumerStatefulWidget {
  const SupportScreen({super.key});

  @override
  ConsumerState<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends ConsumerState<SupportScreen> {
  // ---------------- FAQ LIST ---------------- //
  List<FAQItem> faqs = [
    FAQItem(
      question: "How do I change my vehicle pricing?",
      answer:
          "You can modify pricing under the Pricing section in your dashboard.",
    ),
    FAQItem(
      question: "What if a customer cancels a booking?",
      answer:
          "Cancellation rules apply based on the customer's cancellation policy.",
    ),
    FAQItem(
      question: "How do I update my documents?",
      answer: "Go to Profile → Documents and upload the latest files.",
    ),
    FAQItem(
      question: "When will I receive my payment?",
      answer: "Payments are processed every Monday and Thursday.",
    ),
    FAQItem(
      question: "How do I add new attachments?",
      answer: "Open booking details → Add Attachments → Upload your file.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help&Support'),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),

        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => openCreateSupportSheet(context, ref),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8CCB2C),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Create Ticket",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "We're here to help whenever you need us.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Get answers to common questions or connect with our support team. Raise a query and we'll get back as soon as possible.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 20),
            // Bullet Points
            _bulletPoint("Access frequently asked questions"),
            _bulletPoint("Start a support chat or raise a ticket"),
            _bulletPoint("Track your support requests"),
            const SizedBox(height: 20),

            // Live Chat Card
            _supportCard(
              icon: Icons.message_outlined,
              iconColor: Colors.blue,
              title: "Live Chat",
              subtitle: "Chat with our support team",
              onTap: () {
                print("Live Chat tapped");
              },
            ),

            const SizedBox(height: 12),

            _supportCard(
              icon: Icons.phone,
              iconColor: Colors.green,
              title: "Call Support",
              subtitle: "+91 8668011637",
              onTap: () async {
                final Uri phoneUri = Uri(scheme: 'tel', path: '+919876543210');

                try {
                  await launchUrl(
                    phoneUri,
                    mode: LaunchMode.externalApplication,
                  );
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Unable to make a call')),
                    );
                  }
                }
              },
            ),

            const SizedBox(height: 12),

            // Email Support Card
            _supportCard(
              icon: Icons.email_outlined,
              iconColor: Colors.orange,
              title: "Email Support",
              subtitle: "support@negilu.com",
              onTap: () async {
                final Uri emailUri = Uri(
                  scheme: 'mailto',
                  path: 'support@negilu.com',
                  queryParameters: {
                    'subject': 'Support Request',
                    'body': 'Hi Negilu Support,\n\n',
                  },
                );

                try {
                  await launchUrl(
                    emailUri,
                    mode: LaunchMode.externalApplication,
                  );
                } catch (_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Unable to open email app')),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 12),
            _sectionCard(
              title: "Frequently Asked Questions",
              icon: Icons.help_outline,
              child: Column(
                children: faqs.map((item) => _faqItem(item)).toList(),
              ),
            ),

            const SizedBox(height: 12),

            // -------------------- RECENT TICKETS -------------------- //
            _sectionCard(
              title: "Recent Support Tickets",
              icon: Icons.access_time,
              child: Builder(
                builder: (context) {
                  final ticketsAsync = ref.watch(supportTicketsProvider);

                  return ticketsAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => const Text(
                      "Failed to load tickets",
                      style: TextStyle(color: Colors.red),
                    ),
                    data: (tickets) {
                      if (tickets.isEmpty) {
                        return const Text("No support tickets found");
                      }

                      return Column(
                        children: tickets.map((ticket) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _ticketTile(
                              title: ticket.issueDescription,
                              ticketId: ticket.ticketId,
                              date:
                                  "${ticket.createdAt.day}/${ticket.createdAt.month}/${ticket.createdAt.year}",
                              priority: ticket.priority.toUpperCase(),
                              status: ticket.status.toUpperCase(),
                              statusColor: _statusColor(ticket.status),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  );
                },
              ),
            ),

            // _sectionCard(
            //   title: "Recent Support Tickets",
            //   icon: Icons.access_time,
            //   child: Column(
            //     children: [
            //       _ticketTile(
            //         title: "Payment issue for booking #1234",
            //         ticketId: "TKT001",
            //         date: "2024-01-20",
            //         priority: "High Priority",
            //         status: "In Progress",
            //         statusColor: Colors.blue,
            //       ),
            //       const SizedBox(height: 12),
            //       _ticketTile(
            //         title: "Document verification query",
            //         ticketId: "TKT002",
            //         date: "2024-01-18",
            //         priority: "Medium Priority",
            //         status: "Resolved",
            //         statusColor: Colors.green,
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void openCreateSupportSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const CreateSupportBottomSheet(),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "open":
        return Colors.orange;
      case "resolved":
        return Colors.green;
      case "in_progress":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // -------------------- FAQ EXPAND ITEM -------------------- //

  Widget _faqItem(FAQItem faq) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() => faq.isExpanded = !faq.isExpanded);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    faq.question,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
                  turns: faq.isExpanded ? 0.5 : 0.0,
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
              ],
            ),
          ),
        ),

        // Expandable answer
        if (faq.isExpanded)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFF5F6FA),
            ),
            child: Text(
              faq.answer,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),

        const SizedBox(height: 12),
      ],
    );
  }
}

// ---------- Widgets ---------- //

// Bullet point item
Widget _bulletPoint(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    child: Row(
      children: [
        const Icon(Icons.circle, color: Colors.green, size: 8),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF64748B),
            ),
          ),
        ),
      ],
    ),
  );
}

// Support Card
Widget _supportCard({
  required IconData icon,
  required Color iconColor,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 0, offset: Offset(0, 0)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// -------------------- SECTION CARD -------------------- //
Widget _sectionCard({
  required String title,
  required IconData icon,
  required Widget child,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.grey.shade300),
      // boxShadow: const [
      //   BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 3)),
      // ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.black87),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 14),
        child,
      ],
    ),
  );
}

// -------------------- TICKET TILE -------------------- //
Widget _ticketTile({
  required String title,
  required String ticketId,
  required String date,
  required String priority,
  required String status,
  required Color statusColor,
}) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title + Status Badge
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        Text(
          "Ticket ID: $ticketId",
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),

        const SizedBox(height: 6),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
            Text(
              priority,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ],
    ),
  );
}

class FAQItem {
  final String question;
  final String answer;
  bool isExpanded;

  FAQItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}

class CreateSupportBottomSheet extends ConsumerStatefulWidget {
  const CreateSupportBottomSheet({super.key});

  @override
  ConsumerState<CreateSupportBottomSheet> createState() =>
      _CreateSupportBottomSheetState();
}

class _CreateSupportBottomSheetState
    extends ConsumerState<CreateSupportBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();

  String? selectedIssue;
  String? selectedPriority;
  bool isLoading = false;

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF8CCB2C), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final optionsAsync = ref.watch(supportOptionsProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: optionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => const Text("Failed to load options"),
        data: (options) {
          final issueTypes = options['issue_types']!;
          final priorities = options['priorities']!;

          return Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create Support Ticket",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),

                // ISSUE TYPE
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration("Issue Type"),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  isExpanded: true,
                  items: issueTypes
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.value,
                          child: Text(e.label),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => selectedIssue = v,
                  validator: (v) =>
                      v == null ? "Please select issue type" : null,
                ),

                const SizedBox(height: 16),

                // PRIORITY
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration("Priority"),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  isExpanded: true,
                  items: priorities
                      .map(
                        (e) => DropdownMenuItem(
                          value: e.value,
                          child: Text(e.label),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => selectedPriority = v,
                  validator: (v) => v == null ? "Please select priority" : null,
                ),

                const SizedBox(height: 16),

                // DESCRIPTION
                TextFormField(
                  controller: _descController,
                  maxLines: 5,
                  decoration: _inputDecoration("Description"),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return "Description is required";
                    }
                    if (v.trim().length < 10) {
                      return "Description must be at least 10 characters";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // FULL WIDTH SUBMIT BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (!_formKey.currentState!.validate()) return;

                            setState(() => isLoading = true);

                            try {
                              await ref
                                  .read(supportRepositoryProvider)
                                  .createSupportTicket(
                                    issueType: selectedIssue!,
                                    description: _descController.text.trim(),
                                    priority: selectedPriority!,
                                  );

                              ref.invalidate(supportTicketsProvider);
                              Navigator.pop(context);
                            } catch (_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Failed to create ticket"),
                                ),
                              );
                            } finally {
                              setState(() => isLoading = false);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8CCB2C),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isLoading ? "Submitting..." : "Create Ticket",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}
