import 'dart:io';

import 'package:dermai/features/core/presentation/textfields.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AIPage extends StatefulWidget {
  const AIPage({super.key});

  @override
  State<AIPage> createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> {
  File? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: const Text('AI Assistant'),
              floating: true,
              snap: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Hello there,\nhow can I help you today?',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16.0),
                    if (image != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.file(
                          image!,
                          height: 200.0,
                        ),
                      )
                    else
                      Card(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Tap the button below to add an image of the affected area.',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16.0),
                    if (image == null)
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () {
                                showModalBottomSheet<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // ignore: sized_box_for_whitespace
                                    return Container(
                                      height: 128,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () async {
                                                final imageWrapper =
                                                    await ImagePicker()
                                                        .pickImage(
                                                            source: ImageSource
                                                                .camera);

                                                if (imageWrapper != null &&
                                                    imageWrapper
                                                        .path.isNotEmpty &&
                                                    mounted) {
                                                  setState(() {
                                                    image =
                                                        File(imageWrapper.path);
                                                  });
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                    horizontal: 16.0),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.camera_alt),
                                                    SizedBox(width: 8.0),
                                                    Text(
                                                        'Take Picture From Camera'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const Divider(),
                                            GestureDetector(
                                              onTap: () async {
                                                final imageWrapper =
                                                    await ImagePicker()
                                                        .pickImage(
                                                            source: ImageSource
                                                                .gallery);

                                                if (imageWrapper != null &&
                                                    imageWrapper
                                                        .path.isNotEmpty &&
                                                    mounted) {
                                                  setState(() {
                                                    image =
                                                        File(imageWrapper.path);
                                                  });
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                    horizontal: 16.0),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.photo),
                                                    SizedBox(width: 8.0),
                                                    Text(
                                                        'Take Picture From Gallery'),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Add Image'),
                            ),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () {
                                setState(() {
                                  image = null;
                                });
                              },
                              icon: const Icon(Icons.delete),
                              label: const Text('Remove Image'),
                              style: FilledButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16.0),
                    UniversalTextField(
                        labelText: 'Describe your symptoms',
                        onChanged: (value) {},
                        maxLines: 5),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  const Expanded(child: SizedBox(height: 16.0)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: () {},
                            child: const Text('Submit Case'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32.0),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
