import 'package:equatable/equatable.dart';

class CustomerDealAttachmentModel extends Equatable {
  const CustomerDealAttachmentModel({
    this.id,
    required this.file,
    required this.isPdf,
  });

  final int? id;
  final String file;
  final bool isPdf;

  factory CustomerDealAttachmentModel.fromJson(Map<String, dynamic> json) {
    final rawIsPdf = json['is_pdf'];
    return CustomerDealAttachmentModel(
      id: int.tryParse(json['id']?.toString() ?? ''),
      file: json['file']?.toString() ?? '',
      isPdf:
          rawIsPdf == true ||
          rawIsPdf == 1 ||
          rawIsPdf?.toString().toLowerCase() == 'true',
    );
  }

  @override
  List<Object?> get props => [id, file, isPdf];
}
