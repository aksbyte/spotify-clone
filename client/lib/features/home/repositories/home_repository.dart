import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:client/core/constant/server_constant.dart';
import 'package:client/core/failure/app_failure.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:client/helper/logcat.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSongs({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required String hexCode,
    required String token,
  }) async {
    try {
      final response =
          http.MultipartRequest('POST', Uri.parse(ServerConstant.uploadSong));

      response
        ..files.addAll([
          await http.MultipartFile.fromPath('song', selectedAudio.path),
          await http.MultipartFile.fromPath('thumbnail', selectedThumbnail.path)
        ])
        ..fields.addAll(
            {'artist': artist, 'song_name': songName, 'hex_code': hexCode})
        ..headers.addAll({'x-auth-token': token});

      final data = await response.send();
      final result = await data.stream.bytesToString();
      logCat(result);
      return Right(result);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllSongs(
      {required String token}) async {
    try {
      final response =
          await http.get(Uri.parse(ServerConstant.getSongs), headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      });
      var dataResponse = jsonDecode(response.body);
      log(response.body);
      if (response.statusCode != 200) {
        dataResponse = dataResponse as Map<String, dynamic>;
        return Left(AppFailure(dataResponse['detail']));
      }
      dataResponse = dataResponse as List;
      List<SongModel> songs = [];
      for (var data in dataResponse) {
        songs.add(SongModel.fromMap(data));
      }

      return Right(songs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> favSong({
    required String token,
    required String songId,
  }) async {
    try {
      final response = await http.post(Uri.parse(ServerConstant.addFavorite),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          },
          body: jsonEncode({'song_id': songId}));
      var dataResponse = jsonDecode(response.body);
      log(response.body);
      if (response.statusCode != 200) {
        dataResponse = dataResponse as Map<String, dynamic>;
        return Left(AppFailure(dataResponse['detail']));
      }
      return Right(dataResponse['message']);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getFavSongs(
      {required String token}) async {
    try {
      final response =
          await http.get(Uri.parse(ServerConstant.getFavoriteSongs), headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      });
      var dataResponse = jsonDecode(response.body);
      log(response.body);
      if (response.statusCode != 200) {
        dataResponse = dataResponse as Map<String, dynamic>;
        return Left(AppFailure(dataResponse['detail']));
      }
      dataResponse = dataResponse as List;
      List<SongModel> songs = [];
      for (var map in dataResponse) {
        songs.add(SongModel.fromMap(map['song']));
      }

      return Right(songs);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
