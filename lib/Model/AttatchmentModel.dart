class AttachmentItem {
  final String id;
  final String attachmentId;
  final String name;
  final String fileUrl;

  AttachmentItem({
    required this.id,
    required this.attachmentId,
    required this.name,
    required this.fileUrl,
  });

  factory AttachmentItem.fromJson(Map<String, dynamic> json) {
    return AttachmentItem(
      id: json['id'] ?? '',
      attachmentId: json['attachment_id'] ?? '',
      name: json['name'] ?? '',
      fileUrl: json['file_url'] ?? '',
    );
  }
}
