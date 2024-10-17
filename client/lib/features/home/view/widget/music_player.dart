import 'package:client/core/constant/app_export.dart';
import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/providers/current_user_notifier_provider.dart';
import 'package:client/features/about_us/about_us_page.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.read(currentSongNotifierProvider.notifier);
    final userFavorites = ref
        .watch(currentUserNotifierProvider.select((data) => data!.favorites));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [hexToColor(currentSong!.hex_code), const Color(0xff121212)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Scaffold(
          backgroundColor: AppColor.transparentColor,
          appBar: AppBar(
            backgroundColor: AppColor.transparentColor,
            leading: Transform.translate(
              offset: const Offset(-15, 0),
              child: InkWell(
                onTap: () => popPage(context),
                highlightColor: AppColor.transparentColor,
                focusColor: AppColor.transparentColor,
                splashColor: AppColor.transparentColor,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    AppVector.pullDownArrow,
                    color: AppColor.whiteColor,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    pushAnimation(context, AboutScreen());
                  },
                  icon: const Icon(Icons.settings_rounded))
            ],
          ),
          body: Column(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(currentSong.thumbnail_url),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentSong.song_name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      color: AppColor.whiteColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  currentSong.artist,
                                  style: const TextStyle(
                                      color: AppColor.subtitleText,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          IconButton(
                            onPressed: () async {
                              await ref
                                  .read(homeViewModelProvider.notifier)
                                  .favSong(songId: currentSong.id);
                            },
                            icon: Icon(
                                userFavorites
                                        .where((element) =>
                                            element.song_id == currentSong.id)
                                        .toList()
                                        .isNotEmpty
                                    ? CupertinoIcons.heart_fill
                                    : CupertinoIcons.heart,
                                color: AppColor.whiteColor),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StreamBuilder(
                          stream: songNotifier.audioPlayer!.positionStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox();
                            }
                            final position = snapshot.data;
                            final duration = songNotifier.audioPlayer!.duration;

                            double sliderValue = 0.0;
                            if (position != null && duration != null) {
                              sliderValue = position.inMilliseconds /
                                  duration.inMilliseconds;
                            }
                            return Column(
                              children: [
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: AppColor.whiteColor,
                                      inactiveTrackColor: AppColor.whiteColor
                                          .withOpacity(0.117),
                                      thumbColor: AppColor.whiteColor,
                                      trackHeight: 4,
                                      overlayShape:
                                          SliderComponentShape.noOverlay),
                                  child: Slider(
                                    value: sliderValue,
                                    onChanged: (value) {
                                      sliderValue = value;
                                    },
                                    min: 0,
                                    max: 1,
                                    onChangeEnd: songNotifier.seek,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${position!.inMinutes}:${position.inSeconds}',
                                      style: const TextStyle(
                                        color: AppColor.subtitleText,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    const Expanded(child: SizedBox()),
                                    Text(
                                      '${duration!.inMinutes}:${duration.inSeconds}',
                                      style: const TextStyle(
                                        color: AppColor.subtitleText,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              AppVector.shuffle,
                              color: AppColor.whiteColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              AppVector.previousSong,
                              color: AppColor.whiteColor,
                            ),
                          ),
                          IconButton(
                            onPressed: songNotifier.playPause,
                            iconSize: 80,
                            color: AppColor.whiteColor,
                            icon: Icon(songNotifier.isPlaying
                                ? CupertinoIcons.pause_circle_fill
                                : CupertinoIcons.play_circle_fill),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              AppVector.nextSong,
                              color: AppColor.whiteColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              AppVector.repeat,
                              color: AppColor.whiteColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              AppVector.connectDevice,
                              color: AppColor.whiteColor,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              AppVector.playlist,
                              color: AppColor.whiteColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
