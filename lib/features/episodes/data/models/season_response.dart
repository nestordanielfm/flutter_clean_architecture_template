import 'package:json_annotation/json_annotation.dart';
import 'package:template_app/features/episodes/data/models/episode_response.dart';
import 'package:template_app/features/episodes/domain/entities/season.dart';

part 'season_response.g.dart';

@JsonSerializable()
class SeasonResponse {
  final int id;
  final List<EpisodeResponse> episodes;

  SeasonResponse({
    required this.id,
    required this.episodes,
  });

  factory SeasonResponse.fromJson(Map<String, dynamic> json) =>
      _$SeasonResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SeasonResponseToJson(this);

  Season toEntity() {
    return Season(
      id: id,
      episodes: episodes.map((e) => e.toEntity()).toList(),
    );
  }
}
