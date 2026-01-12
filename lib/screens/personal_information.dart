import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:negilu_shared_package/components/applogo.dart';
import 'package:negilu_shared_package/components/custom_card.dart';
import 'package:negilu_shared_package/components/custom_text.dart';
import 'package:negilu_shared_package/core/enums.dart';
import 'package:provider/provider.dart';
import '../Model/AttatchmentModel.dart';
import '../Model/VehicleModel.dart';
import '../Model/vehicle_model.dart';
import '../Provider/auth_provider.dart';
import '../utils/Appstyle.dart';
import '../utils/custom.dart';
import '../utils/customTextfield.dart' hide CustomTextField;
import '../utils/custom_button.dart';
import 'RegistrationCompleteScreen.dart';
import 'complete_profile.dart';

class PersonalInfoScreen extends StatefulWidget {
  final int initialStep;

  const PersonalInfoScreen({super.key, this.initialStep = 0}); // 👈 Default = 0

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final GlobalKey<_StepPhotoUploadState> stepPhotoKey =
  GlobalKey<_StepPhotoUploadState>();

  // Add this key for DriverDetailsPage
  final GlobalKey<_DriverDetailsPageState> driverDetailsKey =
  GlobalKey<_DriverDetailsPageState>();
  final GlobalKey<_VehicleDetailsPageState> vehicleDetailsKey =
  GlobalKey<_VehicleDetailsPageState>();
  final GlobalKey<_AttachmentDetailsPageState> attachmentDetailsKey =
  GlobalKey<_AttachmentDetailsPageState>();
  final GlobalKey<_PricingDetailsPageState> pricingDetailsKey =
  GlobalKey<_PricingDetailsPageState>();
  final GlobalKey<_BankAdharDetailsPageState> bankDetailsKey =
  GlobalKey<_BankAdharDetailsPageState>();
  final GlobalKey<_ReviewDetailsPageState> reviewDetailsKey =
  GlobalKey<_ReviewDetailsPageState>();

  late int currentStep = widget.initialStep;
  final int totalSteps = 7;

  // Titles for each step
  final List<String> stepTitles = [
    "PERSONAL INFORMATION",
    "DRIVER DETAILS",
    "VEHICLE DETAILS",
    "ADD ATTACHMENTS",
    "SET PRICING",
    "Bank and Aadhar details",
    "REVIEW AND SUBMIT",
  ];

  late final List<Widget> stepWidgets;

  @override
  void initState() {
    super.initState();
    currentStep = widget.initialStep;
    stepWidgets = [
      StepPhotoUpload(key: stepPhotoKey),
      DriverDetailsPage(key: driverDetailsKey),
      VehicleDetailsPage(key: vehicleDetailsKey),
      AttachmentDetailsPage(key: attachmentDetailsKey),
      PricingDetailsPage(key: pricingDetailsKey),
      BankAdharDetailsPage(key: bankDetailsKey),
      ReviewDetailsPage(key: reviewDetailsKey),
    ];
  }

  void nextStep() async {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    if (currentStep == 0) {
      final uploadedUrl = stepPhotoKey.currentState?.getUploadedUrl();
      if (uploadedUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please upload a selfie to continue")),
        );
        return;
      }

      final body = {"selfie_photo": uploadedUrl, "action": "save"};
      bool success = await authNotifier.submitStep(
        context,
        stepNumber: 1,
        body: body,
      );
      if (!success) return;
    } else if (currentStep == 1) {
      // Step 2: Driver Details
      final driverState = driverDetailsKey.currentState;
      if (driverState == null || !driverState.validateFields()) {
        return; // snackbar shown inside validateFields()
      }

      final body = {
        "date_of_birth": driverState.dobController.text,
        "license_number": driverState.dlController.text,
        "license_photo": driverState.getUploadedUrl(),
        "action": "save",
      };

      bool success = await authNotifier.submitStep(
        context,
        stepNumber: 2,
        body: body,
      );
      if (!success) return;
    } else if (currentStep == 2) {
      final vehicleState = vehicleDetailsKey.currentState;
      if (vehicleState == null || !vehicleState.validateFields()) {
        return;
      }

      final body = vehicleState.getVehicleDetailsBody();

      bool success = await authNotifier.submitStep(
        context,
        stepNumber: 3,
        body: body,
      );
      if (!success) return;
    }
    // else if (currentStep == 2) {
    //   // Step 3: Vehicle Details — **use vehicleDetailsKey**, NOT driverState
    //   final vehicleState = vehicleDetailsKey.currentState;
    //   if (vehicleState == null || !vehicleState.validateFields()) {
    //     return; // snackbar shown inside validateFields()
    //   }
    //
    //   // getVehicleDetailsBody() is defined on _VehicleDetailsPageState
    //   final body = vehicleState.getVehicleDetailsBody();
    //
    //   bool success = await authNotifier.submitStep(
    //     context,
    //     stepNumber: 3,
    //     body: body,
    //   );
    //   if (!success) return;
    // }
    else if (currentStep == 3) {
      // Step 4: Attachment Details — use attachmentDetailsKey
      final attachState = attachmentDetailsKey.currentState;
      if (attachState == null || !attachState.validateFields()) {
        return; // snackbar shown inside validateFields()
      }

      // getAttachmentDetailsBody() is defined in _AttachmentDetailsPageState
      final body = attachState.getAttachmentDetailsBody();

      bool success = await authNotifier.submitStep(
        context,
        stepNumber: 4,
        body: body,
      );

      if (!success) return;
    } else if (currentStep == 4) {
      // Step 4: Attachment Details — use attachmentDetailsKey
      final priceState = pricingDetailsKey.currentState;
      if (priceState == null || !priceState.validateFields()) {
        return; // snackbar shown inside validateFields()
      }

      // getAttachmentDetailsBody() is defined in _AttachmentDetailsPageState
      final body = priceState.getPricingDetailsBody();

      bool success = await authNotifier.submitStep(
        context,
        stepNumber: 5,
        body: body,
      );

      if (!success) return;
    } else if (currentStep == 5) {
      // Step 3: Vehicle Details — **use vehicleDetailsKey**, NOT driverState
      final bankState = bankDetailsKey.currentState;
      if (bankState == null || !bankState.validateFields()) {
        return; // snackbar shown inside validateFields()
      }

      final body = bankState.getBankAadhaarDetailsBody();

      bool success = await authNotifier.submitStep(
        context,
        stepNumber: 6,
        body: body,
      );
      if (!success) return;
    } else if (currentStep == 6) {
      bool success = await authNotifier.submitStep(
        context,
        stepNumber: 7,
        body: {"confirmation_checkbox": true},
      );
      if (!success) return;
    }

    // Move to next step after successful API
    setState(() {
      currentStep++;
    });
    if (currentStep >= totalSteps) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RegistrationCompleteScreen()),
      );
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppLogo(size: 50, color: const Color(0xFF8CCB2C)),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // if (currentStep > 0)
                //   InkWell(
                //     onTap: prevStep,
                //     child: Icon(Icons.arrow_back_ios, color: Colors.black),
                //   ),
                HeadingText(
                  stepTitles[currentStep],
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Divider(thickness: 1, color: Colors.grey[300]),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text("Step ${currentStep + 1} of $totalSteps "),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: (currentStep + 1) / totalSteps,
                    backgroundColor: Colors.grey[300],
                    color: Color(0xFF8CCB2C),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(width: 12),
                Text('${progress.toStringAsFixed(0)}%'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: stepWidgets[currentStep],
            ),
          ),
        ],
      ),
      // Bottom static Next button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 30),
        child: Row(
          children: [
            currentStep + 1 == 2 || currentStep + 1 == 5 || currentStep + 1 == 6
                ? Expanded(
              child: OutlinedButton(
                onPressed: nextStep,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.lightGreen,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      6,
                    ), // 👈 reduce corner radius
                  ),
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text(
                  'Save for Later',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            )
                : SizedBox(),
            const SizedBox(width: 12),
            Expanded(
              child: Consumer<AuthNotifier>(
                builder: (context, authNotifier, child) {
                  return CustomButton(
                    text: currentStep == 6 ? "Submit" : "Next",
                    isLoading: authNotifier.isLoading,
                    buttonType: ButtonType.filled,
                    onPressed: authNotifier.isLoading ? () {} : nextStep,
                    textStyle: AppTextStyles.buttonStyle,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StepPhotoUpload extends StatefulWidget {
  StepPhotoUpload({super.key});

  @override
  State<StepPhotoUpload> createState() => _StepPhotoUploadState();
}

class _StepPhotoUploadState extends State<StepPhotoUpload> {
  XFile? _pickedImage;
  String? uploadedImageUrl; // store uploaded file URL
  Future<void> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();

      // 1️⃣ Pick image
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (image == null) return;

      // 2️⃣ Crop image
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        // aspectRatioPresets: [
        //   CropAspectRatioPreset.square,
        //   CropAspectRatioPreset.original,
        //   CropAspectRatioPreset.ratio4x3,
        // ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: false,
          ),
        ],
      );

      // If user cancels cropping
      if (croppedFile == null) return;

      final croppedImageFile = File(croppedFile.path);

      if (!await croppedImageFile.exists()) {
        throw Exception("Cropped file does not exist");
      }

      if (!mounted) return;

      // 3️⃣ Update UI with CROPPED image
      setState(() {
        _pickedImage = XFile(croppedFile.path);
      });

      // 4️⃣ Upload cropped image
      final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
      final uploadedUrl = await authNotifier.uploadImage(croppedImageFile);

      if (!mounted) return;

      if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
        setState(() => uploadedImageUrl = uploadedUrl);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image uploaded successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to upload image")),
        );
      }
    } catch (e, stack) {
      debugPrint("Image pick/upload error: $e");
      debugPrintStack(stackTrace: stack);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Something went wrong while uploading image"),
          ),
        );
      }
    }
  }

  String? getUploadedUrl() => uploadedImageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextWidget(
          text:
          "Please take a clear selfie to verify your identity. Make sure your face is well-lit and clearly visible.",
        ),
        const SizedBox(height: 20),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _pickedImage == null
              ? () {
            showModalBottomSheet(
              context: context,
              builder: (context) => SafeArea(
                child: Wrap(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.camera_alt),
                      title: const Text('Take Photo'),
                      onTap: () async {
                        Navigator.pop(context);
                        await pickImage(ImageSource.camera);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Choose from Gallery'),
                      onTap: () async {
                        Navigator.pop(context);
                        await pickImage(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              ),
            );
          }
              : null, // Disable tap when image is already picked
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              dashPattern: [8, 8],
              strokeWidth: 0,
              padding: _pickedImage == null
                  ? const EdgeInsets.all(22)
                  : const EdgeInsets.fromLTRB(3, 1, 3, 1),
              color: Colors.black54,
              radius: const Radius.circular(16),
            ),
            child: Container(
              height: 191,
              width: double.infinity,
              alignment: Alignment.center,
              child: _pickedImage == null
                  ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 40,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Take a Photo/Upload Photo",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF606060),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
                  : Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.file(
                      File(_pickedImage!.path),
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Delete Image"),
                            content: const Text(
                              "Are you sure you want to delete this image?",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, true),
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm != true) return;

                        final authNotifier = Provider.of<AuthNotifier>(
                          context,
                          listen: false,
                        );
                        final success = await authNotifier.DeleteImage(
                          uploadedImageUrl!,
                        );

                        if (success) {
                          setState(() {
                            _pickedImage = null;
                            uploadedImageUrl = null;
                          });
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Image deleted successfully",
                                ),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Failed to delete image"),
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 40),

        ProfilePhotoTipsCard(
          title: 'Tips for a good profile photo:',
          tips: [
            '- Ensure your face is clearly visible',
            '- Use good lighting',
            '- Have a neutral background',
            '- Wear appropriate attire',
          ],
        ),
      ],
    );
  }
}

class DriverDetailsPage extends StatefulWidget {
  const DriverDetailsPage({super.key});

  @override
  State<DriverDetailsPage> createState() => _DriverDetailsPageState();
}

class _DriverDetailsPageState extends State<DriverDetailsPage> {
  final dobController = TextEditingController();
  final dlController = TextEditingController();
  XFile? pickedLicenseImage;
  String? uploadedLicenseUrl;

  // Method to pick image and upload
  Future<void> pickLicenseImage(ImageSource source) async {
    try {
      final picker = ImagePicker();

      // 1️⃣ Pick image
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (image == null) return;

      // 2️⃣ Crop image
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop License',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop License',
            aspectRatioLockEnabled: false,
          ),
        ],
      );

      // If user cancels cropping
      if (croppedFile == null) return;

      final File croppedImageFile = File(croppedFile.path);

      if (!await croppedImageFile.exists()) {
        throw Exception("Cropped license file does not exist");
      }

      if (!mounted) return;

      setState(() {
        pickedLicenseImage = XFile(croppedFile.path);
      });

      // 4️⃣ Upload cropped image
      final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
      final uploadedUrl = await authNotifier.uploadImage(croppedImageFile);

      if (!mounted) return;

      if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
        setState(() => uploadedLicenseUrl = uploadedUrl);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("License uploaded successfully1")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to upload license")),
        );
      }
    } catch (e, stack) {
      debugPrint("License image pick/upload error: $e");
      debugPrintStack(stackTrace: stack);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Something went wrong while uploading license"),
          ),
        );
      }
    }
  }

  // Future<void> pickLicenseImage(ImageSource source) async {
  //   final picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: source);
  //   if (image == null) return;
  //
  //   setState(() => pickedLicenseImage = XFile(image.path));
  //
  //   final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
  //   uploadedLicenseUrl = await authNotifier.uploadImage(File(image.path));
  //
  //   if (uploadedLicenseUrl != null) {
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("License uploaded successfully")),
  //       );
  //     }
  //   } else {
  //     if (context.mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Failed to upload license")),
  //       );
  //     }
  //   }
  // }

  bool validateFields() {
    if (dobController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your date of birth")),
      );
      return false;
    }
    if (dlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your license number")),
      );
      return false;
    }
    if (uploadedLicenseUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload your license photo")),
      );
      return false;
    }
    return true;
  }

  String? getUploadedUrl() => uploadedLicenseUrl;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text:
            "Please provide your driver’s licence number, date of birth, and upload a clear image of your driver’s licence card.",
          ),
          const SizedBox(height: 20),
          const Text('Date of Birth'),
          const SizedBox(height: 6),
          CustomDatePicker(
            label: 'select date of birth',
            controller: dobController,
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          ),

          const SizedBox(height: 16),
          const Text('Enter Driver Licence Number'),
          const SizedBox(height: 6),
          CustomTextFieldC(hint: 'Enter DL Number', controller: dlController),
          const SizedBox(height: 20),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: pickedLicenseImage == null
                ? () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                builder: (context) => SafeArea(
                  child: Wrap(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.camera_alt),
                        title: const Text('Take Photo'),
                        onTap: () async {
                          Navigator.pop(context);
                          await pickLicenseImage(ImageSource.camera);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: const Text('Choose from Gallery'),
                        onTap: () async {
                          Navigator.pop(context);
                          await pickLicenseImage(ImageSource.gallery);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
                : null, // Disable tap when license image is already picked
            child: DottedBorder(
              options: RoundedRectDottedBorderOptions(
                dashPattern: [8, 8],
                strokeWidth: 0,
                padding: pickedLicenseImage == null
                    ? const EdgeInsets.all(22)
                    : const EdgeInsets.all(3),
                radius: const Radius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                height: 180,
                alignment: Alignment.center,
                child: pickedLicenseImage == null
                    ? const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 40,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Take a Photo/Upload Driver License",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF606060),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
                    : Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: Image.file(
                        File(pickedLicenseImage!.path),
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Delete Image"),
                              content: const Text(
                                "Are you sure you want to delete this license image?",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );

                          if (confirm != true) return;

                          final authNotifier = Provider.of<AuthNotifier>(
                            context,
                            listen: false,
                          );
                          final success = await authNotifier.DeleteImage(
                            uploadedLicenseUrl!, // 👈 use your API URL variable for license image
                          );

                          if (success) {
                            setState(() {
                              pickedLicenseImage = null;
                              uploadedLicenseUrl = null;
                            });
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "License image deleted successfully",
                                  ),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Failed to delete license image",
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 24),
          ProfilePhotoTipsCard(
            title: 'Photo Capture Tips:',
            tips: [
              '- Good lighting',
              '- No glare or blur',
              '- Show full document',
              '- Hold camera steady',
            ],
          ),
        ],
      ),
    );
  }
}

class VehicleDetailsPage extends StatefulWidget {
  const VehicleDetailsPage({super.key});

  @override
  State<VehicleDetailsPage> createState() => _VehicleDetailsPageState();
}

class _VehicleDetailsPageState extends State<VehicleDetailsPage> {
  bool isLoadingMaster = true;
  List<VehicleType> vehicleTypes = [];
  List<Brand> brands = [];
  List<VehicleModel> models = [];
  List<HorsePower> horsePowers = [];

  VehicleType? selectedVehicleType;
  Brand? selectedBrand;
  VehicleModel? selectedModel;
  HorsePower? selectedHp;
  bool isUploading = false;

  final yearController = TextEditingController();
  final regNumberController = TextEditingController();
  final insuranceDateController = TextEditingController();

  String? frontRcImageUrl;
  String? backRcImageUrl;
  String? insuranceImageUrl;

  @override
  void initState() {
    super.initState();
    _loadMasterData();
  }

  bool validateFields() {
    if (selectedVehicleType == null ||
        selectedBrand == null ||
        selectedModel == null ||
        selectedHp == null ||
        yearController.text.isEmpty ||
        regNumberController.text.isEmpty ||
        frontRcImageUrl == null ||
        backRcImageUrl == null ||
        insuranceDateController.text.isEmpty ||
        insuranceImageUrl == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return false;
    }
    return true;
  }

  Future<void> _loadMasterData() async {
    try {
      final authNotifier = Provider.of<AuthNotifier>(context, listen: false);

      final data = await authNotifier.fetchVehicleMasterData(context);

      if (!mounted) return;

      setState(() {
        vehicleTypes = (data['vehicle_types'] as List)
            .map((e) => VehicleType.fromJson(e))
            .toList();

        brands = (data['brands'] as List)
            .map((e) => Brand.fromJson(e))
            .toList();

        models = (data['models'] as List)
            .map((e) => VehicleModel.fromJson(e))
            .toList();

        horsePowers = (data['horsepowers'] as List)
            .map((e) => HorsePower.fromJson(e))
            .toList();

        isLoadingMaster = false;
      });
    } catch (e) {
      debugPrint("Master data error: $e");

      if (mounted) {
        setState(() {
          isLoadingMaster = false;
        });
      }
    }
  }
  Future<void> pickAndUploadImage(String type) async {
    try {
      final picker = ImagePicker();

      // 1️⃣ Pick image
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) return;

      // 2️⃣ Crop image
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: false,
          ),
        ],
      );

      // If user cancels crop
      if (croppedFile == null) return;

      final File croppedImageFile = File(croppedFile.path);

      if (!await croppedImageFile.exists()) {
        throw Exception("Cropped image does not exist");
      }

      setState(() => isUploading = true);

      // 3️⃣ Upload cropped image
      final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
      final uploadedUrl =
      await authNotifier.uploadImage(croppedImageFile);

      setState(() => isUploading = false);

      if (uploadedUrl == null || uploadedUrl.isEmpty) return;

      // 4️⃣ Assign URL based on type
      setState(() {
        if (type == "front") frontRcImageUrl = uploadedUrl;
        if (type == "back") backRcImageUrl = uploadedUrl;
        if (type == "insurance") insuranceImageUrl = uploadedUrl;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image uploaded successfully")),
        );
      }
    } catch (e, stack) {
      debugPrint("Image pick/upload error: $e");
      debugPrintStack(stackTrace: stack);

      setState(() => isUploading = false);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Something went wrong while uploading image"),
          ),
        );
      }
    }
  }

  // Future<void> pickAndUploadImage(String type) async {
  //   final picker = ImagePicker();
  //   final image = await picker.pickImage(source: ImageSource.gallery);
  //   if (image == null) return;
  //
  //   setState(() => isUploading = true);
  //
  //   final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
  //   final uploadedUrl = await authNotifier.uploadImage(File(image.path));
  //
  //   setState(() => isUploading = false);
  //
  //   if (uploadedUrl == null) return;
  //
  //   setState(() {
  //     if (type == "front") frontRcImageUrl = uploadedUrl;
  //     if (type == "back") backRcImageUrl = uploadedUrl;
  //     if (type == "insurance") insuranceImageUrl = uploadedUrl;
  //   });
  // }

  void _showImageSourceSheet(String type) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take Photo"),
              onTap: () {
                Navigator.pop(context);
                _pickCropAndUpload(ImageSource.camera, type);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickCropAndUpload(ImageSource.gallery, type);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickCropAndUpload(
      ImageSource source,
      String type,
      ) async {
    try {
      final picker = ImagePicker();

      // 1️⃣ Pick image
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (image == null) return;

      // 2️⃣ Crop image
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: false,
          ),
        ],
      );

      if (croppedFile == null) return;

      final croppedImage = File(croppedFile.path);

      setState(() => isUploading = true);

      // 3️⃣ Upload cropped image
      final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
      final uploadedUrl = await authNotifier.uploadImage(croppedImage);

      setState(() => isUploading = false);

      if (uploadedUrl == null || uploadedUrl.isEmpty) return;

      // 4️⃣ Assign URL
      setState(() {
        if (type == "front") frontRcImageUrl = uploadedUrl;
        if (type == "back") backRcImageUrl = uploadedUrl;
        if (type == "insurance") insuranceImageUrl = uploadedUrl;
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image uploaded successfully")),
        );
      }
    } catch (e) {
      setState(() => isUploading = false);
      debugPrint("Image error: $e");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image upload failed")),
        );
      }
    }
  }

  /// Common Upload Box with Delete + Cached Image
  Widget _uploadCommon({
    required String label,
    required String? imageUrl,
    required VoidCallback onTap,
    required VoidCallback onDelete,
    required double height,
  }) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: imageUrl == null ? onTap : null,
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            dashPattern: [8, 8],
            strokeWidth: 0,
            padding: imageUrl == null
                ? const EdgeInsets.all(22)
                : const EdgeInsets.all(3),
            radius: const Radius.circular(16),
          ),
          child: Container(
            height: height,
            alignment: Alignment.center,
            child: imageUrl == null
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.camera_alt_outlined,
                  size: 32,
                  color: Colors.grey,
                ),
                const SizedBox(height: 6),
                Text(label, style: const TextStyle(color: Colors.grey)),
              ],
            )
                : Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    height: height,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Delete Image"),
                          content: Text(
                            "Are you sure you want to delete the $label?",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, false),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, true),
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm != true) return;

                      final authNotifier = Provider.of<AuthNotifier>(
                        context,
                        listen: false,
                      );
                      final success = await authNotifier.DeleteImage(
                        imageUrl,
                      );

                      if (success) {
                        onDelete();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "$label deleted successfully.",
                              ),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Failed to delete $label image.",
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ FINAL PAYLOAD (ID MAPPED)
  Map<String, dynamic> getVehicleDetailsBody() {
    return {
      "vehicle_type_id": selectedVehicleType?.id,
      "brand_id": selectedBrand?.id,
      "model_id": selectedModel?.id,
      "horsepower_id": selectedHp?.id,
      "manufacture_year": int.tryParse(yearController.text) ?? 0,
      "registration_number": regNumberController.text.trim(),
      "rc_images": [frontRcImageUrl, backRcImageUrl],
      "insurance_expiry_date": insuranceDateController.text,
      "insurance_image": insuranceImageUrl,
      "action": "save",
    };
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingMaster) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vehicleTypes.isEmpty) {
      return const Center(child: Text("No vehicle master data found"));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// VEHICLE TYPE
          const Text("Vehicle Type"),
          CustomDropdownVehile<VehicleType>(
            hint: "Select vehicle type",
            value: selectedVehicleType,
            items: vehicleTypes,
            displayText: (v) => v.name,
            onChanged: (v) {
              setState(() {
                selectedVehicleType = v;
                selectedBrand = null;
                selectedModel = null;
                selectedHp = null;
              });
            },
          ),
          const SizedBox(height: 16),

          /// BRAND
          const Text("Brand"),
          CustomDropdownVehile<Brand>(
            hint: "Select brand",
            value: selectedBrand,
            items: brands
                .where((b) => b.category == selectedVehicleType?.category)
                .toList(),
            displayText: (b) => b.name,
            onChanged: (b) {
              setState(() {
                selectedBrand = b;
                selectedModel = null;
              });
            },
          ),
          const SizedBox(height: 16),

          /// MODEL
          const Text("Model"),
          CustomDropdownVehile<VehicleModel>(
            hint: 'Select model',
            value: selectedModel,
            items: models.where((m) => m.brandId == selectedBrand?.id).toList(),
            displayText: (m) => m.displayName!,
            onChanged: (val) {
              setState(() {
                selectedModel = val;
              });
            },
          ),

          const SizedBox(height: 16),

          /// HORSE POWER
          const Text("Horse Power"),
          CustomDropdownVehile<HorsePower>(
            hint: "Select HP range",
            value: selectedHp,
            items: horsePowers
                .where((h) => h.category == selectedVehicleType?.category)
                .toList(),
            displayText: (h) => h.displayRange,
            onChanged: (h) => setState(() => selectedHp = h),
          ),
          const SizedBox(height: 16),

          /// YEAR
          const Text("Manufacture Year"),
          CustomTextFieldyear(
            controller: yearController,
            hint: "Select year",
            readOnly: true,
            onTap: () => showYearBottomSheet(context, yearController),
          ),
          const SizedBox(height: 16),

          /// REG NUMBER
          const Text('Registration Number'),
          CustomTextFieldC(
            hint: 'e.g. KA01AB1234',
            controller: regNumberController,
          ),
          const SizedBox(height: 20),

          /// RC UPLOAD
          const Text('Upload RC Images'),
          const SizedBox(height: 8),
          Row(
            children: [
              _uploadCommon(
                label: 'Front Side',
                imageUrl: frontRcImageUrl,
                onTap: () => _showImageSourceSheet("front"), // ✅ NEW
                onDelete: () => setState(() => frontRcImageUrl = null),
                height: 140,
              ),

              // _uploadCommon(
              //   label: 'Front Side',
              //   imageUrl: frontRcImageUrl,
              //   onTap: () => pickAndUploadImage("front"),
              //   onDelete: () => setState(() => frontRcImageUrl = null),
              //   height: 140,
              // ),
              const SizedBox(width: 12),
              _uploadCommon(
                label: 'Back Side',
                imageUrl: backRcImageUrl,
                onTap: () => pickAndUploadImage("back"),
                onDelete: () => setState(() => backRcImageUrl = null),
                height: 140,
              ),
            ],
          ),
          const SizedBox(height: 20),

          /// INSURANCE
          const Text('Insurance Expiry Date'),
          CustomDatePicker(
            label: 'Select expiry date',
            controller: insuranceDateController,
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              _uploadCommon(
                label: 'Insurance Image',
                imageUrl: insuranceImageUrl,
                onTap: () => pickAndUploadImage("insurance"),
                onDelete: () => setState(() => insuranceImageUrl = null),
                height: 160,
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// class VehicleDetailsPage extends StatefulWidget {
//   const VehicleDetailsPage({super.key});
//
//   @override
//   State<VehicleDetailsPage> createState() => _VehicleDetailsPageState();
// }
//
// class _VehicleDetailsPageState extends State<VehicleDetailsPage> {
//   // ===================== MASTER DATA =====================
//   List<VehicleType> vehicleTypes = [];
//   List<Brand> brands = [];
//   List<VehicleModel> models = [];
//   List<HorsePower> horsePowers = [];
//
//   VehicleType? selectedVehicleType;
//   Brand? selectedBrand;
//   VehicleModel? selectedModel;
//   HorsePower? selectedHp;
//
//   // ===================== CONTROLLERS =====================
//   final yearController = TextEditingController();
//   final regNumberController = TextEditingController();
//   final insuranceDateController = TextEditingController();
//
//   String? frontRcImageUrl;
//   String? backRcImageUrl;
//   String? insuranceImageUrl;
//
//   bool isUploading = false;
//   bool isLoadingMaster = true;
//
//   // ===================== INIT =====================
//   @override
//   void initState() {
//     super.initState();
//     _loadMasterData();
//   }
//
//   Future<void> _loadMasterData() async {
//     try {
//       final data = await fetchVehicleMasterData(context);
//
//       setState(() {
//         vehicleTypes = (data['vehicle_types'] as List)
//             .map((e) => VehicleType.fromJson(e))
//             .toList();
//         brands = (data['brands'] as List)
//             .map((e) => Brand.fromJson(e))
//             .toList();
//         models = (data['models'] as List)
//             .map((e) => VehicleModel.fromJson(e))
//             .toList();
//         horsePowers = (data['horsepowers'] as List)
//             .map((e) => HorsePower.fromJson(e))
//             .toList();
//         isLoadingMaster = false;
//       });
//     } catch (e) {
//       isLoadingMaster = false;
//       debugPrint("Master data error: $e");
//     }
//   }
//
//   // ===================== IMAGE UPLOAD =====================
//   Future<void> pickAndUploadImage(String type) async {
//     final picker = ImagePicker();
//     final image = await picker.pickImage(source: ImageSource.gallery);
//     if (image == null) return;
//
//     setState(() => isUploading = true);
//
//     final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
//     final uploadedUrl = await authNotifier.uploadImage(File(image.path));
//
//     setState(() => isUploading = false);
//
//     if (uploadedUrl == null) return;
//
//     setState(() {
//       if (type == "front") frontRcImageUrl = uploadedUrl;
//       if (type == "back") backRcImageUrl = uploadedUrl;
//       if (type == "insurance") insuranceImageUrl = uploadedUrl;
//     });
//   }
//
//   // ===================== VALIDATION =====================
//   bool validateFields() {
//     if (selectedVehicleType == null ||
//         selectedBrand == null ||
//         selectedModel == null ||
//         selectedHp == null ||
//         yearController.text.isEmpty ||
//         regNumberController.text.isEmpty ||
//         frontRcImageUrl == null ||
//         backRcImageUrl == null ||
//         insuranceDateController.text.isEmpty ||
//         insuranceImageUrl == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
//       return false;
//     }
//     return true;
//   }
//
//   // ===================== API BODY =====================
//   Map<String, dynamic> getVehicleDetailsBody() {
//     return {
//       "vehicle_type_id": selectedVehicleType!.id,
//       "brand_id": selectedBrand!.id,
//       "model_id": selectedModel!.id,
//       "horsepower_id": selectedHp!.id,
//       "manufacture_year": int.parse(yearController.text),
//       "registration_number": regNumberController.text,
//       "rc_images": [frontRcImageUrl, backRcImageUrl],
//       "insurance_expiry_date": insuranceDateController.text,
//       "insurance_image": insuranceImageUrl,
//       "action": "save",
//     };
//   }
//
//   // ===================== UI =====================
//   @override
//   Widget build(BuildContext context) {
//     if (isLoadingMaster) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 12),
//
//           /// VEHICLE TYPE
//           const Text('Vehicle Type'),
//           CustomDropdown<VehicleType>(
//             hint: 'Select vehicle type',
//             value: selectedVehicleType,
//             items: vehicleTypes,
//             displayText: (v) => v.name,
//             onChanged: (val) {
//               setState(() {
//                 selectedVehicleType = val;
//                 selectedBrand = null;
//                 selectedModel = null;
//                 selectedHp = null;
//               });
//             },
//           ),
//           const SizedBox(height: 16),
//
//           /// BRAND
//           const Text('Make / Brand'),
//           CustomDropdown<Brand>(
//             hint: 'Select brand',
//             value: selectedBrand,
//             items: brands
//                 .where((b) => b.category == selectedVehicleType?.category)
//                 .toList(),
//             displayText: (b) => b.name,
//             onChanged: (val) {
//               setState(() {
//                 selectedBrand = val;
//                 selectedModel = null;
//               });
//             },
//           ),
//           const SizedBox(height: 16),
//
//           /// MODEL
//           const Text('Model'),
//           CustomDropdown<VehicleModel>(
//             hint: 'Select model',
//             value: selectedModel,
//             items: models.where((m) => m.brandId == selectedBrand?.id).toList(),
//             displayText: (m) => m.displayName,
//             onChanged: (val) => setState(() => selectedModel = val),
//           ),
//           const SizedBox(height: 16),
//
//           /// HORSE POWER
//           const Text('Horse Power'),
//           CustomDropdown<HorsePower>(
//             hint: 'Select HP range',
//             value: selectedHp,
//             items: horsePowers
//                 .where((h) => h.category == selectedVehicleType?.category)
//                 .toList(),
//             displayText: (h) => h.displayRange,
//             onChanged: (val) => setState(() => selectedHp = val),
//           ),
//           const SizedBox(height: 16),
//
//           /// MANUFACTURE YEAR
//           const Text('Manufacture Year'),
//           CustomTextFieldyear(
//             hint: 'Select year',
//             controller: yearController,
//             readOnly: true,
//             onTap: () => showYearBottomSheet(context, yearController),
//           ),
//           const SizedBox(height: 16),
//
//           /// REG NUMBER
//           const Text('Registration Number'),
//           CustomTextFieldC(
//             hint: 'e.g. KA01AB1234',
//             controller: regNumberController,
//           ),
//           const SizedBox(height: 20),
//
//           /// RC UPLOAD
//           const Text('Upload RC Images'),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               _uploadCommon(
//                 label: 'Front Side',
//                 imageUrl: frontRcImageUrl,
//                 onTap: () => pickAndUploadImage("front"),
//                 onDelete: () => setState(() => frontRcImageUrl = null),
//                 height: 140,
//               ),
//               const SizedBox(width: 12),
//               _uploadCommon(
//                 label: 'Back Side',
//                 imageUrl: backRcImageUrl,
//                 onTap: () => pickAndUploadImage("back"),
//                 onDelete: () => setState(() => backRcImageUrl = null),
//                 height: 140,
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//
//           /// INSURANCE
//           const Text('Insurance Expiry Date'),
//           CustomDatePicker(
//             label: 'Select expiry date',
//             controller: insuranceDateController,
//             firstDate: DateTime(1900),
//             lastDate: DateTime(2100),
//           ),
//           const SizedBox(height: 12),
//
//           Row(
//             children: [
//               _uploadCommon(
//                 label: 'Insurance Image',
//                 imageUrl: insuranceImageUrl,
//                 onTap: () => pickAndUploadImage("insurance"),
//                 onDelete: () => setState(() => insuranceImageUrl = null),
//                 height: 160,
//               ),
//             ],
//           ),
//           const SizedBox(height: 30),
//         ],
//       ),
//     );
//   }
// }

// class VehicleDetailsPage extends StatefulWidget {
//   const VehicleDetailsPage({super.key});
//
//   @override
//   State<VehicleDetailsPage> createState() => _VehicleDetailsPageState();
// }
//
// class _VehicleDetailsPageState extends State<VehicleDetailsPage> {
//   String? vehicleType;
//   String? makeBrand;
//   String? model;
//   String? hpRange;
//
//   final yearController = TextEditingController();
//   final regNumberController = TextEditingController();
//   final insuranceDateController = TextEditingController();
//
//   String? frontRcImageUrl;
//   String? backRcImageUrl;
//   String? insuranceImageUrl;
//
//   bool isUploading = false;
//
//   /// Pick & upload image
//   Future<void> pickAndUploadImage(String type) async {
//     final ImagePicker picker = ImagePicker();
//
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);
//     if (image == null) return;
//
//     setState(() => isUploading = true);
//
//     final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
//     final uploadedUrl = await authNotifier.uploadImage(File(image.path));
//
//     setState(() => isUploading = false);
//
//     if (uploadedUrl == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Failed to upload $type image")));
//       return;
//     }
//
//     setState(() {
//       if (type == "front") frontRcImageUrl = uploadedUrl;
//       if (type == "back") backRcImageUrl = uploadedUrl;
//       if (type == "insurance") insuranceImageUrl = uploadedUrl;
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("$type image uploaded successfully")),
//     );
//   }
//
//   /// Validate all fields
//   bool validateFields() {
//     if (vehicleType == null ||
//         makeBrand == null ||
//         model == null ||
//         hpRange == null ||
//         yearController.text.isEmpty ||
//         regNumberController.text.isEmpty ||
//         frontRcImageUrl == null ||
//         backRcImageUrl == null ||
//         insuranceDateController.text.isEmpty ||
//         insuranceImageUrl == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Please fill all fields and upload all images"),
//         ),
//       );
//       return false;
//     }
//     return true;
//   }
//
//   /// API request body
//   // Map<String, dynamic> getVehicleDetailsBody() {
//   //   return {
//   //     "vehicle_type_id": "9fd933fd-d3e9-49b0-8878-90085dff0274",
//   //     "brand_id": "0f98101b-21f1-4291-bbf0-6a96baf4c9de",
//   //     "model_id": "c8698120-af2d-40ab-be1f-6693aacbb9c9",
//   //     "horsepower_id": "6879390f-4f01-4ead-88fb-f65fd01fd976",
//   //     "manufacture_year": int.tryParse(yearController.text) ?? 0,
//   //     "registration_number": regNumberController.text,
//   //     "rc_images": [frontRcImageUrl, backRcImageUrl],
//   //     "insurance_expiry_date": insuranceDateController.text,
//   //     "insurance_image": insuranceImageUrl,
//   //     "action": "save",
//   //   };
//   // }
//
//   /// Common Upload Box with Delete + Cached Image
//   Widget _uploadCommon({
//     required String label,
//     required String? imageUrl,
//     required VoidCallback onTap,
//     required VoidCallback onDelete,
//     required double height,
//   }) {
//     return Expanded(
//       child: GestureDetector(
//         behavior: HitTestBehavior.opaque,
//         onTap: imageUrl == null ? onTap : null,
//         child: DottedBorder(
//           options: RoundedRectDottedBorderOptions(
//             dashPattern: [8, 8],
//             strokeWidth: 0,
//             padding: imageUrl == null
//                 ? const EdgeInsets.all(22)
//                 : const EdgeInsets.all(3),
//             radius: const Radius.circular(16),
//           ),
//           child: Container(
//             height: height,
//             alignment: Alignment.center,
//             child: imageUrl == null
//                 ? Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Icon(
//                         Icons.camera_alt_outlined,
//                         size: 32,
//                         color: Colors.grey,
//                       ),
//                       const SizedBox(height: 6),
//                       Text(label, style: const TextStyle(color: Colors.grey)),
//                     ],
//                   )
//                 : Stack(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: CachedNetworkImage(
//                           imageUrl: imageUrl,
//                           width: double.infinity,
//                           height: height,
//                           fit: BoxFit.cover,
//                           placeholder: (context, url) => const Center(
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           ),
//                           errorWidget: (context, url, error) => const Icon(
//                             Icons.broken_image,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         top: 6,
//                         right: 6,
//                         child: GestureDetector(
//                           onTap: () async {
//                             final confirm = await showDialog<bool>(
//                               context: context,
//                               builder: (context) => AlertDialog(
//                                 title: const Text("Delete Image"),
//                                 content: Text(
//                                   "Are you sure you want to delete the $label?",
//                                   style: const TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () =>
//                                         Navigator.pop(context, false),
//                                     child: const Text(
//                                       "Cancel",
//                                       style: TextStyle(color: Colors.black),
//                                     ),
//                                   ),
//                                   TextButton(
//                                     onPressed: () =>
//                                         Navigator.pop(context, true),
//                                     child: const Text(
//                                       "Delete",
//                                       style: TextStyle(color: Colors.red),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//
//                             if (confirm != true) return;
//
//                             final authNotifier = Provider.of<AuthNotifier>(
//                               context,
//                               listen: false,
//                             );
//                             final success = await authNotifier.DeleteImage(
//                               imageUrl,
//                             );
//
//                             if (success) {
//                               onDelete();
//                               if (context.mounted) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text(
//                                       "$label deleted successfully.",
//                                     ),
//                                   ),
//                                 );
//                               }
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(
//                                     "Failed to delete $label image.",
//                                   ),
//                                 ),
//                               );
//                             }
//                           },
//                           child: Container(
//                             decoration: const BoxDecoration(
//                               color: Colors.black54,
//                               shape: BoxShape.circle,
//                             ),
//                             padding: const EdgeInsets.all(6),
//                             child: const Icon(
//                               Icons.delete,
//                               color: Colors.red,
//                               size: 18,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TextWidget(
//             text:
//                 "Upload images of your vehicle registration certificate (RC) and enter vehicle details",
//           ),
//           const SizedBox(height: 20),
//
//           // Info Banner
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: const Color(0xFFFFF8E1),
//               border: Border.all(color: Colors.orange),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: const Row(
//               children: [
//                 Icon(Icons.info, color: Colors.orange),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     'Make sure the registration certification is valid and all the details match the information on your RC.',
//                     style: TextStyle(fontSize: 13),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//
//           // Dropdowns & Text Fields
//           const Text('Vehicle Type'),
//           CustomDropdown(
//             hint: 'Select vehicle type',
//             value: vehicleType,
//             items: ['Car', 'Bike', 'Truck'],
//             onChanged: (val) => setState(() => vehicleType = val),
//           ),
//           const SizedBox(height: 16),
//
//           const Text('Make/Brand'),
//           CustomDropdown(
//             hint: 'Select Make/Brand',
//             value: makeBrand,
//             items: ['Toyota', 'Honda', 'Suzuki'],
//             onChanged: (val) => setState(() => makeBrand = val),
//           ),
//           const SizedBox(height: 16),
//
//           const Text('Model'),
//           CustomDropdown(
//             hint: 'Select Model',
//             value: model,
//             items: ['Model X', 'Model Y'],
//             onChanged: (val) => setState(() => model = val),
//           ),
//           const SizedBox(height: 16),
//
//           const Text('Horse Power (HP) Range'),
//           CustomDropdown(
//             hint: 'Select HP Range',
//             value: hpRange,
//             items: ['<100', '100-200', '200+'],
//             onChanged: (val) => setState(() => hpRange = val),
//           ),
//           const SizedBox(height: 16),
//
//           const Text('Manufacture Year'),
//           CustomTextFieldyear(
//             hint: 'e.g. 2024',
//             controller: yearController,
//             readOnly: true,
//             onTap: () {
//               showYearBottomSheet(context, yearController);
//             },
//           ),
//           // CustomTextField(
//           //   hint: 'e.g. 2018',
//           //   controller: yearController,
//           //   keyboardType: TextInputType.number,
//           // ),
//           const SizedBox(height: 16),
//
//           const Text('Registration Number'),
//           CustomTextFieldC(
//             hint: 'e.g. KA01AB1234',
//             controller: regNumberController,
//           ),
//           const SizedBox(height: 20),
//
//           // RC Upload
//           const Text('Upload Registration Certificate Images'),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               _uploadCommon(
//                 label: 'Front Side',
//                 imageUrl: frontRcImageUrl,
//                 onTap: () => pickAndUploadImage("front"),
//                 onDelete: () => setState(() => frontRcImageUrl = null),
//                 height: 140,
//               ),
//               const SizedBox(width: 15),
//               _uploadCommon(
//                 label: 'Back Side',
//                 imageUrl: backRcImageUrl,
//                 onTap: () => pickAndUploadImage("back"),
//                 onDelete: () => setState(() => backRcImageUrl = null),
//                 height: 140,
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//
//           // Insurance Upload
//           const Text(
//             'Insurance Details',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 11),
//
//           const Text('Vehicle Insurance Expiry Date'),
//           CustomDatePicker(
//             label: 'Select Insurance Expiry Date',
//             controller: insuranceDateController,
//             firstDate: DateTime(1900),      // or vehicle purchase year
//             lastDate: DateTime(2100),       // ✅ allow future expiry
//           ),
//           // CustomDatePicker(
//           //   label: 'Select Insurance Expiry Date',
//           //   controller: insuranceDateController,
//           //   firstDate: DateTime.now(),
//           //   lastDate: DateTime(2100),
//           // ),
//           const SizedBox(height: 10),
//           Row(
//             children: [
//               _uploadCommon(
//                 label: 'Insurance Image',
//                 imageUrl: insuranceImageUrl,
//                 onTap: () => pickAndUploadImage("insurance"),
//                 onDelete: () => setState(() => insuranceImageUrl = null),
//                 height: 159,
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }

void showYearBottomSheet(
    BuildContext context,
    TextEditingController controller,
    ) {
  final int currentYear = DateTime.now().year;
  final List<int> years = List.generate(
    currentYear - 1900 + 1,
        (i) => currentYear - i,
  );

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            const SizedBox(height: 8),

            /// drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Select Year",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: years.length,
                itemBuilder: (context, index) {
                  final year = years[index];

                  return ListTile(
                    title: Text(year.toString()),
                    onTap: () {
                      controller.text = year.toString();
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

class AttachmentDetailsPage extends StatefulWidget {
  const AttachmentDetailsPage({super.key});

  @override
  State<AttachmentDetailsPage> createState() => _AttachmentDetailsPageState();
}

class _AttachmentDetailsPageState extends State<AttachmentDetailsPage> {
  String? selectedAttachment;
  final TextEditingController suitableForController = TextEditingController();

  String? uploadedImageUrl;
  bool isUploading = false;

  final List<Map<String, String>> attachments = [];

  final List<String> attachmentOptions = [
    'Mild Steel Tractor Trolley',
    'Rotavator',
    'Seeder',
    'Plough',
  ];
  Future<void> pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();

    try {
      // 🔹 Step 1: Ask source (Camera / Gallery)
      final ImageSource? source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (context) => SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      );

      if (source == null) return;

      // 🔹 Step 2: Pick image
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (image == null) return;

      // 🔹 Step 3: Crop image
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 90,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Attachment Image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Colors.blue,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Attachment Image',
            aspectRatioLockEnabled: false,
          ),
        ],
      );

      if (croppedFile == null) return;

      final File croppedImage = File(croppedFile.path);

      if (!await croppedImage.exists()) {
        throw Exception("Cropped image not found");
      }

      // 🔹 Step 4: Upload
      setState(() => isUploading = true);

      final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
      final uploadedUrl = await authNotifier.uploadImage(croppedImage);

      setState(() => isUploading = false);

      if (uploadedUrl == null || uploadedUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to upload attachment image")),
        );
        return;
      }

      // 🔹 Step 5: Save result
      setState(() => uploadedImageUrl = uploadedUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Attachment image uploaded successfully")),
      );
    } catch (e) {
      setState(() => isUploading = false);

      debugPrint("Image pick/crop/upload error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong while uploading image"),
        ),
      );
    }
  }

  // Future<void> pickAndUploadImage() async {
  //   final ImagePicker picker = ImagePicker();
  //
  //   // Step 1: Pick image from gallery
  //   final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  //   if (image == null) return;
  //
  //   // Step 2: Crop the selected image before upload
  //   // final croppedFile = await ImageCropper().cropImage(
  //   //   sourcePath: image.path,
  //   //   aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
  //   //   compressFormat: ImageCompressFormat.jpg,
  //   //   compressQuality: 90,
  //   //   uiSettings: [
  //   //     AndroidUiSettings(
  //   //       toolbarTitle: 'Crop Attachment Image',
  //   //       toolbarColor: Colors.blue,
  //   //       toolbarWidgetColor: Colors.white,
  //   //       activeControlsWidgetColor: Colors.blue,
  //   //       initAspectRatio: CropAspectRatioPreset.original,
  //   //       lockAspectRatio: false,
  //   //     ),
  //   //     IOSUiSettings(
  //   //       title: 'Crop Attachment Image',
  //   //       aspectRatioLockEnabled: false,
  //   //     ),
  //   //   ],
  //   // );
  //   //
  //   // if (croppedFile == null) return; // user canceled cropping
  //
  //   setState(() => isUploading = true);
  //
  //   // Step 3: Upload the cropped image
  //   final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
  //   final uploadedUrl = await authNotifier.uploadImage(File(image.path));
  //
  //   setState(() => isUploading = false);
  //
  //   // Step 4: Handle upload result
  //   if (uploadedUrl == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Failed to upload attachment image")),
  //     );
  //     return;
  //   }
  //
  //   setState(() => uploadedImageUrl = uploadedUrl);
  //
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text("Attachment image uploaded successfully")),
  //   );
  // }

  bool validateFields() {
    if (attachments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please add at least one attachment before proceeding"),
        ),
      );
      return false;
    }
    return true;
  }

  bool validateAddMoreFields() {
    if (selectedAttachment == null ||
        selectedAttachment!.isEmpty ||
        uploadedImageUrl == null ||
        suitableForController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all fields and upload the attachment image before adding",
          ),
        ),
      );
      return false;
    }
    return true;
  }

  Map<String, dynamic> getAttachmentDetailsBody() {
    return {
      "attachments": attachments.map((att) {
        return {
          "attachment_name": att['title'],
          "attachment_photo": att['photo'],
          "suitable_for": att['subtitle'],
        };
      }).toList(),
      "action": "save",
    };
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        // padding: const EdgeInsets.all(16),
        children: [
          TextWidget(
            text:
            "Add any attachment that you own for your vehicle (like plough, trailer, etc...)",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 20),
          Text(
            'Your attachment',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),

          Container(
            padding: EdgeInsets.only(right: 16, left: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F4),
              borderRadius: BorderRadius.circular(13),
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text("Attachment Name"),
                const SizedBox(height: 8),
                DropdownMenu<String>(
                  initialSelection: selectedAttachment,

                  width: MediaQuery.of(context).size.width - 40,
                  hintText: "Attachment name (e.g. Rotavator etc.)",
                  onSelected: (value) {
                    setState(() => selectedAttachment = value);
                  },
                  dropdownMenuEntries: attachmentOptions
                      .map(
                        (e) => DropdownMenuEntry<String>(
                      value: e,
                      label: e,
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 16,
                          ),
                        ),
                        textStyle: MaterialStateProperty.all(
                          const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  )
                      .toList(),
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13), // rounded border
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 1.5,
                      ),
                    ),
                  ),
                  menuStyle: MenuStyle(
                    fixedSize: MaterialStateProperty.all(
                      Size(MediaQuery.of(context).size.width - 65, double.nan),
                    ),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 6),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      Colors.grey.shade100,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Upload Image
                const Text("Upload Attachment Image"),
                const SizedBox(height: 8),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: uploadedImageUrl == null ? pickAndUploadImage : null,
                  // Disable tap when an image is already uploaded
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      dashPattern: [8, 8],
                      strokeWidth: 0,
                      padding: uploadedImageUrl == null
                          ? const EdgeInsets.all(22)
                          : const EdgeInsets.all(2),
                      radius: const Radius.circular(14),
                    ),
                    child: Container(
                      height: 180,
                      alignment: Alignment.center,
                      child: uploadedImageUrl == null
                          ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 36,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Take photo of your attachment",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                          : Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: uploadedImageUrl!,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.green,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Delete Image"),
                                    content: const Text(
                                      "Are you sure you want to delete this image?",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm != true) return;

                                final authNotifier =
                                Provider.of<AuthNotifier>(
                                  context,
                                  listen: false,
                                );

                                final success =
                                await authNotifier.DeleteImage(
                                  uploadedImageUrl!,
                                );
                                if (success) {
                                  setState(() => uploadedImageUrl = null);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(
                                      context,
                                    ).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Image deleted successfully",
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Failed to delete image",
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(6),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // GestureDetector(
                //   behavior: HitTestBehavior.opaque,
                //   onTap: uploadedImageUrl == null ? pickAndUploadImage : null,
                //   // disable tap if already uploaded
                //   child: DottedBorder(
                //     options: RoundedRectDottedBorderOptions(
                //       dashPattern: [8, 8],
                //       strokeWidth: 0,
                //       padding: uploadedImageUrl == null
                //           ? const EdgeInsets.all(22)
                //           : const EdgeInsets.all(2),
                //       radius: const Radius.circular(14),
                //     ),
                //     child: Container(
                //       height: 180,
                //       alignment: Alignment.center,
                //       child: uploadedImageUrl == null
                //           ? const Column(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 Icon(
                //                   Icons.camera_alt_outlined,
                //                   size: 36,
                //                   color: Colors.grey,
                //                 ),
                //                 SizedBox(height: 6),
                //                 Text(
                //                   "Take photo of your attachment",
                //                   style: TextStyle(color: Colors.grey),
                //                 ),
                //               ],
                //             )
                //           : Stack(
                //               children: [
                //                 ClipRRect(
                //                   borderRadius: BorderRadius.circular(8),
                //                   child: CachedNetworkImage(
                //                     imageUrl: uploadedImageUrl!,
                //                     height: 180,
                //                     width: double.infinity,
                //                     fit: BoxFit.cover,
                //                     placeholder: (context, url) => const Center(
                //                       child: CircularProgressIndicator(
                //                         color: Colors.green,
                //                       ),
                //                     ),
                //                     errorWidget: (context, url, error) =>
                //                         const Icon(Icons.error),
                //                   ),
                //                 ),
                //                 Positioned(
                //                   top: 8,
                //                   right: 8,
                //                   child: GestureDetector(
                //                     onTap: () async {
                //                       final confirm = await showDialog<bool>(
                //                         context: context,
                //                         builder: (context) => AlertDialog(
                //                           title: const Text("Delete Image"),
                //                           content: const Text(
                //                             "Are you sure you want to delete this image?",
                //                             style: TextStyle(
                //                               color: Colors.black,
                //                               fontSize: 16,
                //                               fontWeight: FontWeight.w500,
                //                             ),
                //                           ),
                //                           actions: [
                //                             TextButton(
                //                               onPressed: () =>
                //                                   Navigator.pop(context, false),
                //                               child: const Text(
                //                                 "Cancel",
                //                                 style: TextStyle(
                //                                   color: Colors.black,
                //                                 ),
                //                               ),
                //                             ),
                //                             TextButton(
                //                               onPressed: () =>
                //                                   Navigator.pop(context, true),
                //                               child: const Text(
                //                                 "Delete",
                //                                 style: TextStyle(
                //                                   color: Colors.red,
                //                                 ),
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                       );
                //
                //                       if (confirm != true) return;
                //
                //                       // 🧩 Call delete API
                //                       final authNotifier =
                //                           Provider.of<AuthNotifier>(
                //                             context,
                //                             listen: false,
                //                           );
                //                       final success =
                //                           true; // await authNotifier.deleteImage(uploadedImageUrl!);
                //
                //                       if (success) {
                //                         setState(() => uploadedImageUrl = null);
                //                         if (context.mounted) {
                //                           ScaffoldMessenger.of(
                //                             context,
                //                           ).showSnackBar(
                //                             const SnackBar(
                //                               content: Text(
                //                                 "Image deleted successfully",
                //                               ),
                //                             ),
                //                           );
                //                         }
                //                       }
                //                     },
                //                     child: Container(
                //                       decoration: BoxDecoration(
                //                         color: Colors.black54,
                //                         shape: BoxShape.circle,
                //                       ),
                //                       padding: const EdgeInsets.all(6),
                //                       child: const Icon(
                //                         Icons.delete,
                //                         color: Colors.red,
                //                         size: 18,
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 16),

                // Suitable For
                const Text("Suitable For"),
                const SizedBox(height: 8),
                TextField(
                  controller: suitableForController,
                  decoration: InputDecoration(
                    hintText: "e.g. For small plots and gardens",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Add More Button
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      if (validateAddMoreFields()) {
                        setState(() {
                          attachments.add({
                            "title": selectedAttachment!,
                            "photo": uploadedImageUrl!,
                            "subtitle": suitableForController.text,
                          });
                          selectedAttachment = null;
                          uploadedImageUrl = null;
                          suitableForController.clear();
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Attachment added successfully "
                                  "",
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Add more +",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Added Attachments List
          if (attachments.isNotEmpty) ...[
            const Text(
              "Added Attachments",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Column(
              children: attachments.map((att) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: att['photo'] != null
                          ? Image.network(
                        att['photo']!,
                        height: 48,
                        width: 48,
                        fit: BoxFit.cover,
                      )
                          : const Icon(
                        Icons.build_circle,
                        color: Colors.green,
                        size: 48,
                      ),
                    ),
                    title: Text(att['title'] ?? ''),
                    subtitle: Text(att['subtitle'] ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() => attachments.remove(att));
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          if (isUploading)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Center(
                child: CircularProgressIndicator(color: Colors.green),
              ),
            ),
        ],
      ),
    );
  }
}

class PricingDetailsPage extends StatefulWidget {
  const PricingDetailsPage({super.key});

  @override
  State<PricingDetailsPage> createState() => _PricingDetailsPageState();
}

class _PricingDetailsPageState extends State<PricingDetailsPage> {
  VehicleItem? vehicle;
  List<AttachmentItem> attachments = [];

  final List<TextEditingController> hourlyRateControllers = [];
  final List<TextEditingController> dailyRateControllers = [];

  @override
  void initState() {
    super.initState();
    fetchAttachments();
  }

  Future<void> fetchAttachments() async {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    final result = await authNotifier.fetchVehicleAttachments(context);

    setState(() {
      vehicle = result['vehicle'];
      attachments = result['attachments'] ?? [];
      hourlyRateControllers.clear();
      dailyRateControllers.clear();
      for (var _ in attachments) {
        hourlyRateControllers.add(TextEditingController());
        dailyRateControllers.add(TextEditingController());
      }
    });
  }

  bool validateFields() {
    if (attachments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No attachments found for pricing.")),
      );
      return false;
    }

    for (int i = 0; i < attachments.length; i++) {
      if (hourlyRateControllers[i].text.trim().isEmpty ||
          dailyRateControllers[i].text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Please fill hourly and daily rates for ${attachments[i].name}",
            ),
          ),
        );
        return false;
      }
    }
    return true;
  }

  Map<String, dynamic> getPricingDetailsBody() {
    final List<Map<String, dynamic>> pricingList = [];

    for (int i = 0; i < attachments.length; i++) {
      pricingList.add({
        "combination_name": attachments[i].name,
        "vehicle_id": vehicle?.id ?? "",
        "attachment_id": attachments[i].id,
        "hourly_rate": hourlyRateControllers[i].text.trim(),
        "daily_rate": dailyRateControllers[i].text.trim(),
        "recommended_hourly_range": "500-700",
        "recommended_daily_range": "4800-5600",
      });
    }

    return {"vehicle_attachment_pricing": pricingList};
  }

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextWidget(
            text:
            "Set your pricing for the vehicle and add any attachment you have ",
          ),
          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              border: Border.all(color: Colors.orange),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.info, color: Colors.orange),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Set competitive prices to get more bookings. You can always update your prices later.',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          // Text(
          //   'Vehicle Pricing',
          //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          // ),
          Container(
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              // color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: attachments.length,
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.only(top: 2),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.network(
                            attachments[index].fileUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            attachments[index].name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text("Hourly Rate (₹)"),
                      const SizedBox(height: 6),
                      TextField(
                        controller: hourlyRateControllers[index],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "e.g. 600",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Recommended ₹600 - ₹800 per hour for tractor",
                      ),

                      const SizedBox(height: 12),
                      const Text("Daily Rate (₹)"),
                      const SizedBox(height: 6),
                      TextField(
                        controller: dailyRateControllers[index],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "e.g. 4800",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Recommended ₹4800 - ₹5600 per day for tractor",
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BankAdharDetailsPage extends StatefulWidget {
  const BankAdharDetailsPage({super.key});

  @override
  State<BankAdharDetailsPage> createState() => _BankAdharDetailsPageState();
}

class _BankAdharDetailsPageState extends State<BankAdharDetailsPage> {
  final accountHolderController = TextEditingController();
  final accountNumberController = TextEditingController();
  final ifscController = TextEditingController();
  final bankNameController = TextEditingController();
  final branchController = TextEditingController();

  String? passbookImageUrl;
  String? aadhaarFrontImageUrl;
  String? aadhaarBackImageUrl;

  bool isUploading = false;
  Future<void> pickAndUploadImage(String type) async {
    final ImagePicker picker = ImagePicker();

    try {
      // 🔹 Step 1: Choose Camera / Gallery
      final ImageSource? source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (context) => SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        ),
      );

      if (source == null) return; // user cancelled

      // 🔹 Step 2: Pick image
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (image == null) return;

      // 🔹 Step 3: Crop image
      final CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 90,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop ${type.toUpperCase()} Image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Colors.blue,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop ${type.toUpperCase()} Image',
            aspectRatioLockEnabled: false,
          ),
        ],
      );

      if (croppedFile == null) return; // user cancelled cropping

      final File croppedImage = File(croppedFile.path);

      if (!await croppedImage.exists()) {
        throw Exception("Cropped image not found");
      }

      // 🔹 Step 4: Upload
      setState(() => isUploading = true);

      final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
      final uploadedUrl = await authNotifier.uploadImage(croppedImage);

      setState(() => isUploading = false);

      if (uploadedUrl == null || uploadedUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to upload $type image")),
        );
        return;
      }

      // 🔹 Step 5: Assign based on type
      setState(() {
        if (type == "passbook") passbookImageUrl = uploadedUrl;
        if (type == "aadhaarFront") aadhaarFrontImageUrl = uploadedUrl;
        if (type == "aadhaarBack") aadhaarBackImageUrl = uploadedUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$type image uploaded successfully")),
      );
    } catch (e) {
      setState(() => isUploading = false);

      debugPrint("Image pick/crop/upload error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong while uploading image"),
        ),
      );
    }
  }

  // Future<void> pickAndUploadImage(String type) async {
  //   final ImagePicker picker = ImagePicker();
  //
  //   // Step 1: Show bottom sheet to choose source
  //   final source = await showModalBottomSheet<ImageSource>(
  //     context: context,
  //     builder: (context) => SafeArea(
  //       child: Wrap(
  //         children: [
  //           ListTile(
  //             leading: const Icon(Icons.camera_alt),
  //             title: const Text('Take Photo'),
  //             onTap: () => Navigator.pop(context, ImageSource.camera),
  //           ),
  //           ListTile(
  //             leading: const Icon(Icons.photo_library),
  //             title: const Text('Choose from Gallery'),
  //             onTap: () => Navigator.pop(context, ImageSource.gallery),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  //
  //   if (source == null) return; // user cancelled
  //
  //   // Step 2: Pick image
  //   final XFile? image = await picker.pickImage(source: source);
  //   if (image == null) return;
  //
  //   // Step 3: Crop image before upload
  //   // final croppedFile = await ImageCropper().cropImage(
  //   //   sourcePath: image.path,
  //   //   aspectRatio: CropAspectRatio(ratioX: 4, ratioY: 3),
  //   //   uiSettings: [
  //   //     AndroidUiSettings(
  //   //       toolbarTitle: 'Crop $type Image',
  //   //       toolbarColor: Colors.blue,
  //   //       toolbarWidgetColor: Colors.white,
  //   //       activeControlsWidgetColor: Colors.blue,
  //   //       initAspectRatio: CropAspectRatioPreset.ratio4x3,
  //   //       lockAspectRatio: false,
  //   //     ),
  //   //     IOSUiSettings(title: 'Crop $type Image'),
  //   //   ],
  //   // );
  //   //
  //   // if (croppedFile == null) return; // user cancelled cropping
  //
  //   setState(() => isUploading = true);
  //
  //   // Step 4: Upload the cropped image
  //   final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
  //   final uploadedUrl = await authNotifier.uploadImage(File(image.path));
  //
  //   setState(() => isUploading = false);
  //
  //   // Step 5: Handle upload result
  //   if (uploadedUrl == null) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("Failed to upload $type image")));
  //     return;
  //   }
  //
  //   setState(() {
  //     if (type == "passbook") passbookImageUrl = uploadedUrl;
  //     if (type == "aadhaarFront") aadhaarFrontImageUrl = uploadedUrl;
  //     if (type == "aadhaarBack") aadhaarBackImageUrl = uploadedUrl;
  //   });
  //
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text("$type image uploaded successfully")),
  //   );
  // }

  bool validateFields() {
    if (accountHolderController.text.isEmpty ||
        accountNumberController.text.isEmpty ||
        ifscController.text.isEmpty ||
        bankNameController.text.isEmpty ||
        branchController.text.isEmpty ||
        passbookImageUrl == null ||
        aadhaarFrontImageUrl == null ||
        aadhaarBackImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields and upload images"),
        ),
      );
      return false;
    }
    return true;
  }

  Map<String, dynamic> getBankAadhaarDetailsBody() {
    return {
      "account_holder_name": accountHolderController.text.trim(),
      "account_number": accountNumberController.text.trim(),
      "ifsc_code": ifscController.text.trim(),
      "bank_name": bankNameController.text.trim(),
      "branch": branchController.text.trim(),
      "bank_passbook_image": passbookImageUrl,
      "aadhar_front_image": aadhaarFrontImageUrl,
      "aadhar_back_image": aadhaarBackImageUrl,
      "action": "save",
    };
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextWidget(
            text:
            "Please enter your bank details and upload Aadhaar card for KYC verification",
          ),
          const SizedBox(height: 20),
          // Info banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              border: Border.all(color: Colors.orange, width: 0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.info, color: Colors.orange),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your bank details will be used for making payouts. Make sure all details are accurate.',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // const Text('Bank Account Details'),
          TextWidget(
            text: 'Account Holder Name',
            alignment: AlignmentGeometry.centerLeft,
          ),
          const SizedBox(height: 6),
          CustomTextField(
            hint: 'Enter name as per bank records',
            controller: accountHolderController,
          ),
          const SizedBox(height: 16),

          TextWidget(
            text: 'Account Number',
            alignment: AlignmentGeometry.centerLeft,
          ),
          const SizedBox(height: 6),
          CustomTextField(
            hint: 'Enter account number',
            controller: accountNumberController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

          TextWidget(
            text: 'IFSC Code',
            alignment: AlignmentGeometry.centerLeft,
          ),
          const SizedBox(height: 6),
          CustomTextFieldC(
            hint: 'e.g. SBIN0000133',
            controller: ifscController,
          ),
          const SizedBox(height: 16),

          TextWidget(
            text: 'Bank Name',
            alignment: AlignmentGeometry.centerLeft,
          ),
          const SizedBox(height: 6),
          CustomTextField(
            hint: 'e.g. State Bank of India',
            controller: bankNameController,
          ),
          const SizedBox(height: 16),

          TextWidget(
            text: 'Branch Name',
            alignment: AlignmentGeometry.centerLeft,
          ),
          const SizedBox(height: 6),
          CustomTextField(
            hint: 'e.g. Main branch, Bangalore',
            controller: branchController,
          ),
          const SizedBox(height: 20),

          TextWidget(
            text: 'Bank Passbook / Cancelled Cheque',
            alignment: AlignmentGeometry.centerLeft,
          ),

          const SizedBox(height: 8),
          _uploadBox(
            "passbook",
            passbookImageUrl,
            "Take photo of passbook or cancelled cheque",
          ),

          const SizedBox(height: 20),
          const Text("Aadhaar Card"),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _uploadBox(
                  "aadhaarFront",
                  aadhaarFrontImageUrl,
                  "Front Side",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _uploadBox(
                  "aadhaarBack",
                  aadhaarBackImageUrl,
                  "Back Side",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _uploadBox(String type, String? imageUrl, String label) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: imageUrl == null ? () => pickAndUploadImage(type) : null,
      child: DottedBorder(
        // DottedBorder(
        options: RoundedRectDottedBorderOptions(
          dashPattern: [8, 8],
          strokeWidth: 0,
          padding: imageUrl == null
              ? const EdgeInsets.all(22)
              : EdgeInsets.fromLTRB(3, 1, 3, 1),
          // padding: _pickedImage == null
          //     ? const EdgeInsets.all(22)
          //     : const EdgeInsets.fromLTRB(3, 1, 3, 1),
          color: Colors.black54,
          radius: const Radius.circular(16),
        ),

        // dashPattern:  [8, 8],
        // strokeWidth: 0,
        // borderType: BorderType.RRect,
        // radius: const Radius.circular(14),
        child: Container(
          height: 150,
          alignment: Alignment.center,
          child: imageUrl == null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.camera_alt_outlined,
                size: 32,
                color: Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          )
              : Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  ),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: GestureDetector(
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Delete Image"),
                        content: const Text(
                          "Are you sure you want to delete this image?",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, false),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (confirm != true) return;

                    final authNotifier = Provider.of<AuthNotifier>(
                      context,
                      listen: false,
                    );
                    final success = await authNotifier.DeleteImage(
                      imageUrl!,
                    );

                    if (success) {
                      setState(() {
                        imageUrl = null;
                        type == "passbook"
                            ? passbookImageUrl = null
                            : type == "aadhaarFront"
                            ? aadhaarFrontImageUrl = null
                            : aadhaarBackImageUrl = null;
                      });
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Image deleted successfully"),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Failed to delete image"),
                        ),
                      );
                    }
                  },
                  // onTap: () => DeleteImage(imageUrl),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 18,
                    ),
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

class ReviewDetailsPage extends StatefulWidget {
  const ReviewDetailsPage({super.key});

  @override
  State<ReviewDetailsPage> createState() => _ReviewDetailsPageState();
}

class _ReviewDetailsPageState extends State<ReviewDetailsPage> {
  Map<String, dynamic>? reviewData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReviewSummary();
  }

  Future<void> fetchReviewSummary() async {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    final result = await authNotifier.fetchReviewSummary(context);

    if (mounted) {
      setState(() {
        reviewData = result;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (reviewData == null) {
      return const Center(child: Text("No data found"));
    }

    final step1 = reviewData?['step1']?['data'];
    final step2 = reviewData?['step2']?['data'];
    final step3 = reviewData?['step3']?['data'];
    final step4 = reviewData?['step4']?['data'] ?? [];
    final step5 = reviewData?['step5']?['data'] ?? [];
    final step6 = reviewData?['step6']?['data'];

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildExpansionTile("Personal Information", [
            if (step1?['selfie_photo'] != null)
              Container(
                padding: EdgeInsets.only(left: 12, bottom: 12, top: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Profile Picture",
                          style: TextStyle(
                            height: 1.5,
                            color: Color(0xFF606060),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green, // Border color
                              width: 0, // Border width
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ), // Rounded corners
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            // Apply same radius to clip
                            child: CachedNetworkImage(
                              imageUrl: step1['selfie_photo'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ]),
          _buildExpansionTile("Driver Details", [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.only(left: 12, bottom: 12, top: 12),

              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "License: ${step2?['license_number'] ?? '-'}",
                        style: TextStyle(
                          color: Color(0xFF606060),
                          fontSize: 14,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  if (step2?['license_photo'] != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              // color: Colors.green, // Border color
                              width: 0, // Border width
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ), // Rounded corners
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            // Apply same radius to clip
                            child: CachedNetworkImage(
                              imageUrl: step2['license_photo'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ]),
          _buildExpansionTile("Vehicle Details", [
            if (step3?['insurance_image'] != null)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.only(left: 12, bottom: 12, top: 18),

                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              // color: Colors.green, // Border color
                              width: 0, // Border width
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ), // Rounded corners
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            // Apply same radius to clip
                            child: CachedNetworkImage(
                              imageUrl: step3['insurance_image'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Vehicle Type: ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF606060),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: step3?['VehicleType']?['name'] ?? '-',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF414141),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                            style: DefaultTextStyle.of(context).style,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Make/Brand: ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF606060),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: step3?['Brand']?['brand_name'] ?? '-',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF414141),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                            style: DefaultTextStyle.of(context).style,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Model ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF606060),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: step3?['Model']?['model_name'] ?? '-',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF414141),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                            style: DefaultTextStyle.of(context).style,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Year ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF606060),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text:
                                step3?['year_of_manufacture'].toString() ??
                                    '-',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF414141),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                            style: DefaultTextStyle.of(context).style,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Reg Number ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF606060),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: step3?['vehicle_number'] ?? '-',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF414141),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                            style: DefaultTextStyle.of(context).style,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ]),
          _buildExpansionTile("Attachments", [
            for (var attachment in step4)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.only(left: 12, bottom: 12, top: 18),

                child: ListTile(
                  leading: Container(
                    width: 80,
                    height: 70,
                    decoration: BoxDecoration(
                      border: Border.all(
                        // color: Colors.green, // Border color
                        width: 0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(
                        10,
                      ), // Rounded corners
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      // Apply same radius to clip
                      child: CachedNetworkImage(
                        imageUrl: attachment['file_url'] ?? '',
                        width: 80,
                        height: 70,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                      ),
                    ),
                  ),

                  title: Text(
                    attachment['name'] ?? '-',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF414141),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    attachment['description'] ?? '-',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF606060),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
          ]),
          _buildExpansionTile("Pricing", [
            for (var price in step5)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  top: 18,
                ),

                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          price['combination_name'] ?? '-',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF606060),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hourly rate ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF606060),
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        Text(
                          "₹" + price['hourly_rate'] ?? '-',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF606060),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Daily rate ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF606060),
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        Text(
                          "₹" + price['daily_rate'] ?? '-',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF606060),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ]),
          _buildExpansionTile("Bank & Aadhaar", [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                bottom: 12,
                top: 15,
              ),

              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Account Holder name",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF606060),
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      Text(
                        step6?['account_holder_name'] ?? '-',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF414141),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Account Number",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF606060),
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      Text(
                        step6?['account_number'] ?? '-',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF414141),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "IFSC Code",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF606060),
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      Text(
                        step6?['ifsc_code'] ?? '-',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF414141),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Bank Name",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF606060),
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      Text(
                        step6?['bank_name'] ?? '-',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF414141),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Branch",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF606060),
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      Text(
                        step6?['branch'] ?? '-',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF414141),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(
                            // color: Colors.green, // Border color
                            width: 0, // Border width
                          ),
                          borderRadius: BorderRadius.circular(
                            10,
                          ), // Rounded corners
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          // Apply same radius to clip
                          child: CachedNetworkImage(
                            imageUrl: step6['bank_passbook_image'],
                            width: 80,
                            height: 70,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Aadhar Card",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF606060),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(
                            // color: Colors.green, // Border color
                            width: 0, // Border width
                          ),
                          borderRadius: BorderRadius.circular(
                            10,
                          ), // Rounded corners
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          // Apply same radius to clip
                          child: CachedNetworkImage(
                            imageUrl: step6['aadhar_front_image'],
                            width: 80,
                            height: 70,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 80,
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(
                            // color: Colors.green, // Border color
                            width: 0, // Border width
                          ),
                          borderRadius: BorderRadius.circular(
                            10,
                          ), // Rounded corners
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          // Apply same radius to clip
                          child: CachedNetworkImage(
                            imageUrl: step6['aadhar_back_image'],
                            width: 80,
                            height: 70,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
          SizedBox(height: 24),
          ProfilePhotoTipsCard(
            title: 'What happens next:',
            tips: [
              '1. Our team will verify all your documents.',
              '2. You’ll receive notification when approved.',
              '3. Once approved, you can start accepting bookings.',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
          childrenPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 0,
          ),

          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF414141),
              fontWeight: FontWeight.w600,
            ),
          ),
          children: children,
        ),
      ),
    );
  }
}
