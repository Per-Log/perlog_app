class MetadataImageData {
  const MetadataImageData({
    required this.selectedDate,
    this.publicUrl,
    this.width,
    this.height,
    this.ocrText,
  });

  final DateTime selectedDate;
  final String? publicUrl;
  final double? width;
  final double? height;
  final String? ocrText;

  MetadataImageData copyWith({
    DateTime? selectedDate,
    String? publicUrl,
    double? width,
    double? height,
    String? ocrText,
  }) {
    return MetadataImageData(
      selectedDate: selectedDate ?? this.selectedDate,
      publicUrl: publicUrl ?? this.publicUrl,
      width: width ?? this.width,
      height: height ?? this.height,
      ocrText: ocrText ?? this.ocrText,
    );
  }
}
