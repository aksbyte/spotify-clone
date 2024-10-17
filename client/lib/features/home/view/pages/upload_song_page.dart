import 'dart:io';

import 'package:client/core/widget/loader.dart';
import 'package:client/features/home/repositories/home_repository.dart';
import 'package:client/features/home/view/widget/audio_wave.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:client/helper/logcat.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constant/app_export.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<UploadSongPage> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final _artistController = TextEditingController();
  final _songController = TextEditingController();
  Color _selectedColor = AppColor.cardColor;
  File? _selectedAudio;
  File? _selectedThumbnail;
  final _formKey = GlobalKey<FormState>();

  void _selectImage() async {
    final pickedImage = await pickImage();

    if (pickedImage != null) {
      setState(() {
        _selectedThumbnail = pickedImage;
      });
    }
  }

  void _selectAudio() async {
    final pickedAudio = await pickAudio();
    if (pickedAudio != null) {
      setState(() {
        _selectedAudio = pickedAudio;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _artistController.dispose();
    _songController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
        homeViewModelProvider.select((value) => value?.isLoading == true));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload songs'),
        actions: [
          IconButton(
              onPressed: () async {
                if (_formKey.currentState!.validate() &&
                    _selectedAudio != null &&
                    _selectedThumbnail != null) {
                  await ref
                      .read(homeViewModelProvider.notifier)
                      .uploadSong(
                        selectedAudio: _selectedAudio!,
                        selectedThumbnail: _selectedThumbnail!,
                        songName: _songController.text,
                        artist: _artistController.text,
                        selectedColor: _selectedColor,
                      )
                      .whenComplete(
                        () => customSnackBar(
                            context: context,
                            msg: 'Song uploaded successfully'),
                      );
                } else {
                  customSnackBar(context: context, msg: 'Missing filed');
                }
              },
              icon: const Icon(Icons.done))
        ],
      ),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _selectImage,
                      child: _selectedThumbnail != null
                          ? SizedBox(
                              height: 156,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  _selectedThumbnail!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : DottedBorder(
                              color: AppColor.borderColor,
                              radius: const Radius.circular(30),
                              borderType: BorderType.RRect,
                              dashPattern: const [10, 4],
                              strokeCap: StrokeCap.round,
                              child: SizedBox(
                                height: 156,
                                width: double.infinity,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.folder_open),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Select thumbnail for your song',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    _selectedAudio != null
                        ? AudioWave(path: _selectedAudio!.path)
                        : CustomField(
                            hintText: 'Pick songs',
                            controller: null,
                            onTap: _selectAudio,
                            readOnly: true,
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomField(
                      hintText: 'Artist',
                      controller: _artistController,
                      onTap: () {},
                    ),
                    SizedBox(height: 20),
                    CustomField(
                      hintText: 'Song Name',
                      controller: _songController,
                      onTap: () {},
                    ),
                    SizedBox(height: 20),
                    ColorPicker(
                      color: _selectedColor,
                      pickersEnabled: const {ColorPickerType.wheel: true},
                      onColorChanged: (color) {
                        setState(() {
                          _selectedColor = color;
                          logCatPro(
                              valueName: 'Selected hex Color',
                              value: _selectedColor);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
