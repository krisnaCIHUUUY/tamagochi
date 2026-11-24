import 'package:freezed_annotation/freezed_annotation.dart';

part 'care_style.freezed.dart';
part 'care_style.g.dart';

/// Penghitung gaya perawatan yang tersembunyi; direset setiap evolusi.
/// Tanpa "aksi seimbang": Si Seimbang = tidak ada yang unggul (D9).
@freezed
abstract class CareStyle with _$CareStyle {
  const factory CareStyle({
    @Default(0) int plays,
    @Default(0) int snacks,
    @Default(0) int timelyCleans,
    @Default(Duration.zero) Duration neglectedFor,
  }) = _CareStyle;

  factory CareStyle.fromJson(Map<String, Object?> json) =>
      _$CareStyleFromJson(json);
}
