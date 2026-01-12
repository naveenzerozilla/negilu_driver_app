class SupportTicket {
  final String id;
  final String ticketId;
  final String issueDescription;
  final String status;
  final String priority;
  final DateTime createdAt;

  SupportTicket({
    required this.id,
    required this.ticketId,
    required this.issueDescription,
    required this.status,
    required this.priority,
    required this.createdAt,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['id'],
      ticketId: json['ticket_id'],
      issueDescription: json['issue_description'],
      status: json['status'],
      priority: json['priority'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
