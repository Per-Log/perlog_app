class MetadataImageData {
  const MetadataImageData({
    required this.selectedDate,
    this.publicUrl,
    this.width,
    this.height,
    this.ocrText,
    this.editMessageLine1,
    this.editMessageLine2,
    this.editMessageLine3,
  });

  final DateTime selectedDate;
  final String? publicUrl;
  final double? width;
  final double? height;
  final String? ocrText;
  final String? editMessageLine1;
  final String? editMessageLine2;
  final String? editMessageLine3;

  MetadataImageData copyWith({
    DateTime? selectedDate,
    String? publicUrl,
    double? width,
    double? height,
    String? ocrText,
    String? editMessageLine1,
    String? editMessageLine2,
    String? editMessageLine3,
  }) {
    return MetadataImageData(
      selectedDate: selectedDate ?? this.selectedDate,
      publicUrl: publicUrl ?? this.publicUrl,
      width: width ?? this.width,
      height: height ?? this.height,
      ocrText: ocrText ?? this.ocrText,
      editMessageLine1: editMessageLine1 ?? this.editMessageLine1,
      editMessageLine2: editMessageLine2 ?? this.editMessageLine2,
      editMessageLine3: editMessageLine3 ?? this.editMessageLine3,
    );
  }
}
