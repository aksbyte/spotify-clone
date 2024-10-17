import 'dart:io';

import 'package:client/core/constant/app_export.dart';
import 'package:client/core/providers/current_user_notifier_provider.dart';
import 'package:client/features/home/model/favorite_song_model.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:client/features/home/repositories/home_repository.dart';
import 'package:client/helper/logcat.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(GetAllSongsRef ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((value) => value!.token));
  final res = await ref.watch(homeRepositoryProvider).getAllSongs(token: token);
  return res.fold((l) => throw l.toString(), (r) => r);
}

@riverpod
Future<List<SongModel>> getFavSongs(GetFavSongsRef ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((value) => value!.token));
  final res = await ref.watch(homeRepositoryProvider).getFavSongs(token: token);
  return res.fold((l) => throw l.toString(), (r) => r);
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;

  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
// ignore: avoid_manual_providers_as_generated_provider_dependency
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required Color selectedColor,
  }) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.uploadSongs(
      selectedAudio: selectedAudio,
      selectedThumbnail: selectedThumbnail,
      songName: songName,
      artist: artist,
      hexCode: rgbToHex(selectedColor),
      token: ref.watch(currentUserNotifierProvider)!.token,
    );
    res.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => state = AsyncValue.data(r),
    );
  }

  List<SongModel> getRecentlyPlayedSongs() {
    return _homeLocalRepository.loadSong();
  }

  Future<void> favSong({required String songId}) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.favSong(
      songId: songId,
      token: ref.watch(currentUserNotifierProvider)!.token,
    );
    res.fold(
      (l) => state = AsyncValue.error(l.message, StackTrace.current),
      (r) => _favSongSuccess(r, songId),
    );
  }

  AsyncValue _favSongSuccess(bool isFavorite, String songId) {
    final userFavorite = ref.read(currentUserNotifierProvider.notifier);
    if (isFavorite) {
      userFavorite
          .addUser(ref.read(currentUserNotifierProvider)!.copyWith(favorites: [
        ...ref.read(currentUserNotifierProvider)!.favorites,
        FavoriteSongModel(
          id: '',
          song_id: songId,
          user_id: '',
        )
      ]));
    } else {
      userFavorite.addUser(ref.read(currentUserNotifierProvider)!.copyWith(
          favorites: ref
              .read(currentUserNotifierProvider)!
              .favorites
              .where(
                (element) => element.song_id != songId,
              )
              .toList()));
    }
    ref.invalidate(getFavSongsProvider);
    return state = AsyncValue.data(isFavorite);
  }
}
