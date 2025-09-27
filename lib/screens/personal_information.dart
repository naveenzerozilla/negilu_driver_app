import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:negilu_shared_package/components/applogo.dart';

import '../utils/Appstyle.dart';
import '../utils/customTextfield.dart';
import '../utils/custom_button.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  int currentStep = 0;
  final int totalSteps = 6;

  // Titles for each step
  final List<String> stepTitles = [
    "PERSONAL INFORMATIONS",
    "DRIVER DETAILS",
    "VEHICLE DETAILS",
    "ADD ATTACHMENTS",
    "SET PRICING",
    "REVIEW AND SUBMIT",
  ];

  // Example widgets for steps (replace with your own custom ones)
  final List<Widget> stepWidgets = [
    StepPhotoUpload(),
    StepPhotoUpload(),
    StepPhotoUpload(),

    Center(child: Text("Step 4: Upload License")),
    Center(child: Text("Step 5: Add Vehicle Details")),
    Center(child: Text("Step 6: Upload Insurance")),
    // Center(child: Text("Step 7: Final Review")),
  ];

  void nextStep() {
    if (currentStep < totalSteps - 1) {
      setState(() {
        currentStep++;
      });
    }
  }

  void prevStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = ((currentStep + 1) / totalSteps) * 100;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            AppLogo(size: 50, color: const Color(0xFF8CCB2C)),
            const SizedBox(height: 20),
            Row(
              children: [
                if (currentStep > 0)
                  InkWell(
                    onTap: prevStep,
                    child: Icon(Icons.arrow_back_ios, color: Colors.black),
                  ),
                SizedBox(width: 10),
                HeadingText(
                  stepTitles[currentStep],
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Divider(thickness: 1, color: Colors.grey[300]),

            const SizedBox(height: 20),
            // const Text("Complete your profile", style: AppTextStyles.heading),
            LinearProgressIndicator(
              value: (currentStep + 1) / totalSteps,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
            ),
            const SizedBox(height: 5),
            Text(
              "Step ${currentStep + 1} of $totalSteps - ${progress.toStringAsFixed(0)}%",
            ),

            const Divider(),

            // Current Step Content
            Expanded(child: stepWidgets[currentStep]),
          ],
        ),
      ),
      // Bottom static Next button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 30),
        child: CustomButton(
          text: "Next",
          onPressed: nextStep,
          textStyle: AppTextStyles.buttonStyle, // your existing style
        ),
      ),
    );
  }
}

// Example step widget
class StepPhotoUpload extends StatelessWidget {
  const StepPhotoUpload({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Please take a clear selfie to verify your identity. Make sure your face is well-lit and clearly visible.",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            // Use image_picker package to pick image from camera or gallery
            final ImagePicker picker = ImagePicker();
            showModalBottomSheet(
              context: context,
              builder: (context) => SafeArea(
                child: Wrap(
                  children: [
                    ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text('Take Photo'),
                      onTap: () async {
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.camera,
                        );
                        // TODO: handle picked image
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Choose from Gallery'),
                      onTap: () async {
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        // TODO: handle picked image
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          child: DottedBorder(
            child: Container(
              width: double.infinity,
              height: 180,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                    SizedBox(height: 10),
                    Text("Take a Photo / Upload Photo"),
                  ],
                ),
              ),
            ),
            // DottedBorder(
            //   color: Colors.grey,
            //   strokeWidth: 1,
            //   borderType: BorderType.RRect,
            //   radius: Radius.circular(12),
            //   dashPattern: [6, 3],
            //   child: Container(
            //     width: double.infinity,
            //     height: 180,
            //     child: const Center(
            //       child: Column(
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           Icon(Icons.camera_alt, size: 40, color: Colors.grey),
            //           SizedBox(height: 10),
            //           Text("Take a Photo / Upload Photo"),
            //         ],
            //       ),
            //     ),
            //   ),
          ),
        ),
      ],
    );
  }
}

class DriverDetailsPage extends StatelessWidget {
  const DriverDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Please take a clear selfie to verify your identity. Make sure your face is well-lit and clearly visible.",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            // Use image_picker package to pick image from camera or gallery
            final ImagePicker picker = ImagePicker();
            showModalBottomSheet(
              context: context,
              builder: (context) => SafeArea(
                child: Wrap(
                  children: [
                    ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text('Take Photo'),
                      onTap: () async {
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.camera,
                        );
                        // TODO: handle picked image
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Choose from Gallery'),
                      onTap: () async {
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        // TODO: handle picked image
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          child: DottedBorder(
            child: Container(
              width: double.infinity,
              height: 180,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                    SizedBox(height: 10),
                    Text("Take a Photo / Upload Photo"),
                  ],
                ),
              ),
            ),
            // DottedBorder(
            //   color: Colors.grey,
            //   strokeWidth: 1,
            //   borderType: BorderType.RRect,
            //   radius: Radius.circular(12),
            //   dashPattern: [6, 3],
            //   child: Container(
            //     width: double.infinity,
            //     height: 180,
            //     child: const Center(
            //       child: Column(
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           Icon(Icons.camera_alt, size: 40, color: Colors.grey),
            //           SizedBox(height: 10),
            //           Text("Take a Photo / Upload Photo"),
            //         ],
            //       ),
            //     ),
            //   ),
          ),
        ),
      ],
    );
  }
}

class VehicleDetailsPage extends StatelessWidget {
  const VehicleDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Please take a clear selfie to verify your identity. Make sure your face is well-lit and clearly visible.",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            // Use image_picker package to pick image from camera or gallery
            final ImagePicker picker = ImagePicker();
            showModalBottomSheet(
              context: context,
              builder: (context) => SafeArea(
                child: Wrap(
                  children: [
                    ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text('Take Photo'),
                      onTap: () async {
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.camera,
                        );
                        // TODO: handle picked image
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Choose from Gallery'),
                      onTap: () async {
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        // TODO: handle picked image
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          child: DottedBorder(
            child: Container(
              width: double.infinity,
              height: 180,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                    SizedBox(height: 10),
                    Text("Take a Photo / Upload Photo"),
                  ],
                ),
              ),
            ),
            // DottedBorder(
            //   color: Colors.grey,
            //   strokeWidth: 1,
            //   borderType: BorderType.RRect,
            //   radius: Radius.circular(12),
            //   dashPattern: [6, 3],
            //   child: Container(
            //     width: double.infinity,
            //     height: 180,
            //     child: const Center(
            //       child: Column(
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           Icon(Icons.camera_alt, size: 40, color: Colors.grey),
            //           SizedBox(height: 10),
            //           Text("Take a Photo / Upload Photo"),
            //         ],
            //       ),
            //     ),
            //   ),
          ),
        ),
      ],
    );
  }
}

class AttachmentDetailsPage extends StatelessWidget {
  const AttachmentDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Please take a clear selfie to verify your identity. Make sure your face is well-lit and clearly visible.",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            // Use image_picker package to pick image from camera or gallery
            final ImagePicker picker = ImagePicker();
            showModalBottomSheet(
              context: context,
              builder: (context) => SafeArea(
                child: Wrap(
                  children: [
                    ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text('Take Photo'),
                      onTap: () async {
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.camera,
                        );
                        // TODO: handle picked image
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Choose from Gallery'),
                      onTap: () async {
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        // TODO: handle picked image
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          child: DottedBorder(
            child: Container(
              width: double.infinity,
              height: 180,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                    SizedBox(height: 10),
                    Text("Take a Photo / Upload Photo"),
                  ],
                ),
              ),
            ),
            // DottedBorder(
            //   color: Colors.grey,
            //   strokeWidth: 1,
            //   borderType: BorderType.RRect,
            //   radius: Radius.circular(12),
            //   dashPattern: [6, 3],
            //   child: Container(
            //     width: double.infinity,
            //     height: 180,
            //     child: const Center(
            //       child: Column(
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           Icon(Icons.camera_alt, size: 40, color: Colors.grey),
            //           SizedBox(height: 10),
            //           Text("Take a Photo / Upload Photo"),
            //         ],
            //       ),
            //     ),
            //   ),
          ),
        ),
      ],
    );
  }
}

class PricingDetailsPage extends StatelessWidget {
  const PricingDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Please take a clear selfie to verify your identity. Make sure your face is well-lit and clearly visible.",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            // Use image_picker package to pick image from camera or gallery
            final ImagePicker picker = ImagePicker();
            showModalBottomSheet(
              context: context,
              builder: (context) => SafeArea(
                child: Wrap(
                  children: [
                    ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text('Take Photo'),
                      onTap: () async {
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.camera,
                        );
                        // TODO: handle picked image
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Choose from Gallery'),
                      onTap: () async {
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        // TODO: handle picked image
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          child: DottedBorder(
            child: Container(
              width: double.infinity,
              height: 180,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                    SizedBox(height: 10),
                    Text("Take a Photo / Upload Photo"),
                  ],
                ),
              ),
            ),
            // DottedBorder(
            //   color: Colors.grey,
            //   strokeWidth: 1,
            //   borderType: BorderType.RRect,
            //   radius: Radius.circular(12),
            //   dashPattern: [6, 3],
            //   child: Container(
            //     width: double.infinity,
            //     height: 180,
            //     child: const Center(
            //       child: Column(
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           Icon(Icons.camera_alt, size: 40, color: Colors.grey),
            //           SizedBox(height: 10),
            //           Text("Take a Photo / Upload Photo"),
            //         ],
            //       ),
            //     ),
            //   ),
          ),
        ),
      ],
    );
  }
}

class ReviewDetailsPage extends StatelessWidget {
  const ReviewDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Please take a clear selfie to verify your identity. Make sure your face is well-lit and clearly visible.",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            // Use image_picker package to pick image from camera or gallery
            final ImagePicker picker = ImagePicker();
            showModalBottomSheet(
              context: context,
              builder: (context) => SafeArea(
                child: Wrap(
                  children: [
                    ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text('Take Photo'),
                      onTap: () async {
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.camera,
                        );
                        // TODO: handle picked image
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Choose from Gallery'),
                      onTap: () async {
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        // TODO: handle picked image
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          child: DottedBorder(
            child: Container(
              width: double.infinity,
              height: 180,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                    SizedBox(height: 10),
                    Text("Take a Photo / Upload Photo"),
                  ],
                ),
              ),
            ),
            // DottedBorder(
            //   color: Colors.grey,
            //   strokeWidth: 1,
            //   borderType: BorderType.RRect,
            //   radius: Radius.circular(12),
            //   dashPattern: [6, 3],
            //   child: Container(
            //     width: double.infinity,
            //     height: 180,
            //     child: const Center(
            //       child: Column(
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           Icon(Icons.camera_alt, size: 40, color: Colors.grey),
            //           SizedBox(height: 10),
            //           Text("Take a Photo / Upload Photo"),
            //         ],
            //       ),
            //     ),
            //   ),
          ),
        ),
      ],
    );
  }
}
