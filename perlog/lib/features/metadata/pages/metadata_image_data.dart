class MetadataImageData {
  const MetadataImageData({
    required this.selectedDate,
    this.publicUrl,
    this.width,
    this.height,
  });

  final DateTime selectedDate;
  final String? publicUrl;
  final double? width;
  final double? height;
}
