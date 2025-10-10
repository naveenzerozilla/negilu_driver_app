import 'dart:ui';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:negilu_shared_package/components/applogo.dart';
import 'package:negilu_shared_package/components/custom_card.dart';
import 'package:negilu_shared_package/components/custom_text.dart';
import 'package:negilu_shared_package/components/utils/navigate.dart';
import 'package:negilu_shared_package/core/enums.dart';

import '../utils/Appstyle.dart';
import '../utils/custom.dart';
import '../utils/customTextfield.dart' hide CustomTextField;
import '../utils/custom_button.dart';
import 'RegistrationCompleteScreen.dart';
import 'complete_profile.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  int currentStep = 0;
  final int totalSteps = 7;

  // Titles for each step
  final List<String> stepTitles = [
    "PERSONAL INFORMATIONS",
    "DRIVER DETAILS",
    "VEHICLE DETAILS",
    "ADD ATTACHMENTS",
    "SET PRICING",
    "Bank and Aadhar details",
    "REVIEW AND SUBMIT",
  ];

  // Example widgets for steps (replace with your own custom ones)
  final List<Widget> stepWidgets = [
    StepPhotoUpload(),
    DriverDetailsPage(),
    VehicleDetailsPage(),
    AttachmentDetailsPage(),
    PricingDetailsPage(),
    BankAdharDetailsPage(),
    ReviewDetailsPage(),
  ];

  void nextStep() {
    if (currentStep < totalSteps - 1) {
      setState(() {
        currentStep++;
      });
    }else{
      goTo(context, CompleteProfileScreen());
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
              color: Color(0xFF8CCB2C),
              minHeight: 8,
              borderRadius: BorderRadius.circular(20),
            ),
            const SizedBox(height: 5),
            Text("Step ${currentStep + 1} of $totalSteps "),
            // const Divider(),
            const SizedBox(height: 10),
            // Current Step Content
            Expanded(child: stepWidgets[currentStep]),
          ],
        ),
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
                          width: 1, // 👈 reduce thickness (default is 1.0)
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
              child: CustomButton(
                text:
                    currentStep + 1 == 2 ||
                        currentStep + 1 == 5 ||
                        currentStep + 1 == 6
                    ? "Save  & Proceed"
                    : "Next",
                buttonType: ButtonType.filled,
                onPressed: nextStep,
                textStyle: AppTextStyles.buttonStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Example step widget
class StepPhotoUpload extends StatefulWidget {
  StepPhotoUpload({super.key});

  @override
  State<StepPhotoUpload> createState() => _StepPhotoUploadState();
}

class _StepPhotoUploadState extends State<StepPhotoUpload> {
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
            options: RoundedRectDottedBorderOptions(
              dashPattern: [10, 11],
              strokeWidth: 0,
              padding: EdgeInsets.all(22),
              radius: Radius.circular(16),
            ),

            child: Container(
              width: double.infinity,
              height: 160,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                    SizedBox(height: 10),
                    Text("Take a Photo/Upload Driver License"),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 40),

        ProfilePhotoTipsCard(
          title: 'Tips for a good profile photo:',
          tips: [
            '- Ensure your face is clearly visible'
                '- Use good lighting',
            '- Have a neutral background',
            '- Wear appropriate attire',
          ],
        ),
      ],
    );
  }
}

class DriverDetailsPage extends StatelessWidget {
  const DriverDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dobController = TextEditingController();
    final dlController = TextEditingController();
    return ListView(
      children: [
        TextWidget(
          text:
              "Please provide your driver’s licence number, date of birth, and upload a clear image of your driver’s licence card.",
        ),
        const SizedBox(height: 20),
        const Text('Date of Birth'),
        CustomDatePicker(
          label: 'Date of Birth',
          controller: dobController,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        ),
        const SizedBox(height: 16),
        const Text('Enter Driver Licence Number'),
        CustomTextField(
          hint: 'Driver’s Licence Number',
          controller: dlController,
        ),
        SizedBox(height: 20),
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
            options: RoundedRectDottedBorderOptions(
              dashPattern: [10, 11],
              strokeWidth: 0,
              padding: EdgeInsets.all(22),
              radius: Radius.circular(16),
            ),
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
          ),
        ),
        SizedBox(height: 20),

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
    );
  }
}

class VehicleDetailsPage extends StatefulWidget {
  VehicleDetailsPage({super.key});

  @override
  State<VehicleDetailsPage> createState() => _VehicleDetailsPageState();
}

class _VehicleDetailsPageState extends State<VehicleDetailsPage> {
  String? vehicleType;
  String? makeBrand;
  String? model;
  String? hpRange;

  final yearController = TextEditingController();
  final regNumberController = TextEditingController();
  final insuranceDateController = TextEditingController(text: "12/12/2028");

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextWidget(
          text:
              "Upload images of your vehicle registration certificate (RC) and enter vehicle details",
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
                  'Make sure the registration certification is valid '
                  'and all the details match the information on your RC.',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        const Text('Vehicle Type'),
        CustomDropdown(
          hint: 'Select vehicle type',
          value: vehicleType,
          items: ['Car', 'Bike', 'Truck'],
          onChanged: (val) => setState(() => vehicleType = val),
        ),
        const SizedBox(height: 16),

        const Text('Make/Brand'),
        CustomDropdown(
          hint: 'Select Make/Brand',
          value: makeBrand,
          items: ['Toyota', 'Honda', 'Suzuki'],
          onChanged: (val) => setState(() => makeBrand = val),
        ),
        const SizedBox(height: 16),

        const Text('Model'),
        CustomDropdown(
          hint: 'Select Model',
          value: model,
          items: ['Model X', 'Model Y'],
          onChanged: (val) => setState(() => model = val),
        ),
        const SizedBox(height: 16),

        const Text('Horse Power(HP) Range'),
        CustomDropdown(
          hint: 'Select HP Range',
          value: hpRange,
          items: ['<100', '100-200', '200+'],
          onChanged: (val) => setState(() => hpRange = val),
        ),
        const SizedBox(height: 16),

        const Text('Manufacture Year'),
        CustomTextField(
          hint: 'e.g. 2018',
          controller: yearController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),

        const Text('Registration Number'),
        CustomTextField(
          hint: 'e.g. KA01AB1234',
          controller: regNumberController,
        ),
        const SizedBox(height: 20),

        const Text('Upload Registration Certificate images'),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _uploadBox('Front Side'),
            SizedBox(width: 15),
            _uploadBox('Back Side'),
          ],
        ),
        const SizedBox(height: 20),

        const Text(
          'Insurance Details',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 5),
        const Text(
          'Vehicle Insurance Expiry Date',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        CustomTextField(
          hint: 'Vehicle Insurance Expiry Date',
          controller: insuranceDateController,
          keyboardType: TextInputType.datetime,
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
            options: RoundedRectDottedBorderOptions(
              dashPattern: [10, 11],
              strokeWidth: 0,
              padding: EdgeInsets.all(22),
              radius: Radius.circular(14),
            ),
            child: Container(
              width: double.infinity,
              height: 180,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 40,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Upload Insurance Image",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black38,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _uploadBox(String label) {
    return Expanded(
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          dashPattern: [10, 11],
          strokeWidth: 0,
          padding: EdgeInsets.all(12),
          radius: Radius.circular(11),
        ),
        child: Container(
          alignment: Alignment.center,
          height: 110,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.camera_alt_outlined,
                size: 28,
                color: Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AttachmentDetailsPage extends StatefulWidget {
  const AttachmentDetailsPage({super.key});

  @override
  State<AttachmentDetailsPage> createState() => _AttachmentDetailsPageState();
}

class _AttachmentDetailsPageState extends State<AttachmentDetailsPage> {
  String? selectedAttachment;
  final TextEditingController suitableForController = TextEditingController();

  final List<Map<String, String>> attachments = [
    {'title': 'Mild Steel Tractor Trolley', 'subtitle': '450 Tons'},
    {'title': '3-4 foot rotavator', 'subtitle': 'For small plots and gardens'},
  ];

  final List<String> attachmentOptions = [
    'Rotavator',
    'Tractor Trolley',
    'Seeder',
    'Plough',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextWidget(
          text:
              "Add any attachment that you own for your vehicle (like plough, trailer, etc...)",
        ),
        const SizedBox(height: 20),
        Text("Your attachment"),
        const SizedBox(height: 10),
        Container(
          margin: EdgeInsets.only(right: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFFF4F4F4),
          ),

          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: "Attachment Name",
                  alignment: AlignmentGeometry.centerLeft,
                ),

                // CustomTitleWidget(title: 'What happens next:'),
                Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: DropdownButtonFormField<String>(
                    value: selectedAttachment,
                    decoration: InputDecoration(
                      hintText: "Attachment name (e.g. Rotavator etc.)",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: attachmentOptions
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedAttachment = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Upload / Take Photo box
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
                    options: RoundedRectDottedBorderOptions(
                      dashPattern: [10, 11],
                      strokeWidth: 0,
                      padding: EdgeInsets.all(22),
                      radius: Radius.circular(16),
                    ),

                    child: Container(
                      width: double.infinity,
                      height: 160,
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 10),
                            Text("Take a Photo/Upload Driver License"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Suitable for input
                TextField(
                  controller: suitableForController,
                  decoration: InputDecoration(
                    hintText: "e.g. For small plots and gardens",
                    labelText: "Suitable for",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Add more link
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,

                  children: [
                    GestureDetector(
                      onTap: () {
                        // Add new attachment logic
                      },
                      child: const Text(
                        "Add more +",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Added attachments
        const Text(
          "Added attachments",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),

        Column(
          children: attachments.map((att) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Icon(
                    Icons.network_locked,
                    size: 60,
                    color: Colors.grey,
                  ),
                  // Image.network(
                  //  ,
                  //   width: 60,
                  //   height: 60,
                  //   fit: BoxFit.cover,
                  // ),
                ),
                title: Text(att['title']!),
                subtitle: Text(att['subtitle']!),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      attachments.remove(att);
                    });
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class PricingDetailsPage extends StatefulWidget {
  const PricingDetailsPage({super.key});

  @override
  State<PricingDetailsPage> createState() => _PricingDetailsPageState();
}

class _PricingDetailsPageState extends State<PricingDetailsPage> {
  final vehicles = [
    {"title": "Tractor + Rotavator"},
    {"title": "Tractor + 7 Teeth"},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextWidget(
          text:
              "Add any attachment that you own  for your vehicle (like plough, trailer, etc...)",
        ),
        const SizedBox(height: 20),
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
                  'Make sure the registration certification is valid '
                  'and all the details match the information on your RC.',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Vehicle Pricing",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 16),

        // Loop through vehicles
        ...vehicles.map((vehicle) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image + Title (Grey background)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Icon(
                          Icons.network_locked,
                          size: 50,
                          color: Colors.grey,
                        ),

                        // Image.network(
                        //   vehicle["image"]!,
                        //   width: 50,
                        //   height: 50,
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          vehicle["title"]!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Hourly rate
                const Text(
                  "Hourly rate (₹)",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                TextField(
                  decoration: InputDecoration(
                    hintText: "₹ e.g. 500",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 6),
                Text(
                  "Recommended ₹600 - ₹800 per hour for tractor",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),

                const SizedBox(height: 16),

                // Daily rate
                const Text(
                  "Daily rate (₹)",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                TextField(
                  decoration: InputDecoration(
                    hintText: "₹ e.g. 500",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 6),
                Text(
                  "Recommended ₹600 - ₹800 per hour for tractor",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}

class ReviewDetailsPage extends StatelessWidget {
  ReviewDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
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

        // Expansion Tiles Section
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: const Text(
                "Personal Information",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              childrenPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              children: const [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "License Number:",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    Text("DL123456789"),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Expiry Date:",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    Text("2028-05-12"),
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: const Text(
                "Driver's License",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              childrenPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              children: const [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "License Number:",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    Text("DL123456789"),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Expiry Date:",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    Text("2028-05-12"),
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: const Text(
                "Vehicle Details",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              childrenPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              children: const [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "License Number:",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    Text("DL123456789"),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Expiry Date:",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    Text("2028-05-12"),
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: const Text(
                "Attachments",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              childrenPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              children: const [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "License Number:",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    Text("DL123456789"),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Expiry Date:",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    Text("2028-05-12"),
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: const Text(
                "Pricing",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              childrenPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              children: const [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "License Number:",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    Text("DL123456789"),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Expiry Date:",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    Text("2028-05-12"),
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFDFDFDF)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(),
            child: ExpansionTile(
              title: const Text(
                "Bank and Aadhar Details",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              childrenPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              children: const [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "License Number:",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    Text("DL123456789"),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Expiry Date:",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    Text("2028-05-12"),
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }
}



class BankAdharDetailsPage extends StatefulWidget {
  BankAdharDetailsPage({super.key});

  @override
  State<BankAdharDetailsPage> createState() => _BankAdharDetailsPageState();
}

class _BankAdharDetailsPageState extends State<BankAdharDetailsPage> {
  String? vehicleType;
  String? makeBrand;
  String? model;
  String? hpRange;

  final yearController = TextEditingController();
  final regNumberController = TextEditingController();
  final insuranceDateController = TextEditingController(text: "12/12/2028");

  @override
  Widget build(BuildContext context) {
    return ListView(
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

        const Text('Bank Account deatils'),

        TextWidget(
          text: 'Account Holder name',
          alignment: AlignmentGeometry.centerLeft,
        ),
        CustomTextField(
          hint: 'Enter name as per bank records',
          controller: regNumberController,
        ),
        const SizedBox(height: 16),
        TextWidget(
          text: 'Account Number',
          alignment: AlignmentGeometry.centerLeft,
        ),
        CustomTextField(
          hint: 'Enter account number',
          controller: regNumberController,
        ),
        const SizedBox(height: 16),
        TextWidget(text: 'IFSC Code', alignment: AlignmentGeometry.centerLeft),
        CustomTextField(
          hint: 'e.g. SBIN0000133',
          controller: regNumberController,
        ),
        const SizedBox(height: 16),
        TextWidget(text: 'Bank name', alignment: AlignmentGeometry.centerLeft),
        CustomTextField(
          hint: 'e.g. State Bank of India',
          controller: regNumberController,
        ),
        const SizedBox(height: 16),
        TextWidget(text: 'Branch', alignment: AlignmentGeometry.centerLeft),
        CustomTextField(
          hint: 'e.g. Main branch, Bangalore',
          controller: regNumberController,
        ),
        const SizedBox(height: 16),

        const SizedBox(height: 20),
        TextWidget(
          text: 'Bank Passbook / Cancelled Cheque',
          alignment: AlignmentGeometry.centerLeft,
        ),
        const SizedBox(height: 10),
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
            options: RoundedRectDottedBorderOptions(
              dashPattern: [10, 11],
              strokeWidth: 0,
              padding: EdgeInsets.all(22),
              radius: Radius.circular(14),
            ),
            child: Container(
              width: double.infinity,
              height: 180,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 40,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Take photo of passbook or cancelled cheque",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black38,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        TextWidget(
          text: 'Aadhar Card',
          alignment: AlignmentGeometry.centerLeft,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _uploadBox('Front Side'),
            SizedBox(width: 15),
            _uploadBox('Back Side'),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _uploadBox(String label) {
    return Expanded(
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          dashPattern: [10, 11],
          strokeWidth: 0,
          padding: EdgeInsets.all(12),
          radius: Radius.circular(11),
        ),
        child: Container(
          alignment: Alignment.center,
          height: 110,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.camera_alt_outlined,
                size: 28,
                color: Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
