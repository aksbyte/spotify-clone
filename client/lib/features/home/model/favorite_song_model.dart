class FavoriteSongModel{
  final String id;
  final String song_id;
  final String user_id;

//<editor-fold desc="Data Methods">
  const FavoriteSongModel({
    required this.id,
    required this.song_id,
    required this.user_id,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteSongModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          song_id == other.song_id &&
          user_id == other.user_id);

  @override
  int get hashCode => id.hashCode ^ song_id.hashCode ^ user_id.hashCode;

  @override
  String toString() {
    return 'FavoriteModel{' +
        ' id: $id,' +
        ' song_id: $song_id,' +
        ' user_id: $user_id,' +
        '}';
  }

  FavoriteSongModel copyWith({
    String? id,
    String? song_id,
    String? user_id,
  }) {
    return FavoriteSongModel(
      id: id ?? this.id,
      song_id: song_id ?? this.song_id,
      user_id: user_id ?? this.user_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'song_id': this.song_id,
      'user_id': this.user_id,
    };
  }

  factory FavoriteSongModel.fromMap(Map<String, dynamic> map) {
    return FavoriteSongModel(
      id: map['id'] as String,
      song_id: map['song_id'] as String,
      user_id: map['user_id'] as String,
    );
  }

//</editor-fold>
}