import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:negilu_shared_package/components/applogo.dart';
import 'package:negilu_shared_package/components/custom_text.dart';
import 'package:negilu_shared_package/components/utils/custom_card.dart';

import '../utils/Appstyle.dart';
import '../utils/custom.dart';
import '../utils/customTextfield.dart' hide CustomTextField;
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
    DriverDetailsPage(),
    VehicleDetailsPage(),
    AttachmentDetailsPage(),
    PricingDetailsPage(),
    ReviewDetailsPage(),
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
            child: Container(
              width: double.infinity,
              height: 180,
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
        SizedBox(height: 20),
        ProfileTipsBox(
          title: 'Meeting Preparation:',
          tips: [
            'Check your internet connection',
            'Prepare your notes',
            'Join 5 minutes early',
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
          ),
        ),
        SizedBox(height: 20),
        CustomDatePicker(
          label: 'Date of Birth',
          controller: dobController,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          hint: 'Driver’s Licence Number',
          controller: dlController,
        ),
        SizedBox(height: 20),
        ProfileTipsBox(
          title: 'Photo Capture Tips:',
          tips: [
            ' Good lighting',
            ' No glare or blur',
            ' Show full document',
            ' Hold camera steady',
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_uploadBox('Front Side'), _uploadBox('Back Side')],
        ),
        const SizedBox(height: 20),

        const Text('Insurance Details'),
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
            child: Container(
              width: double.infinity,
              height: 180,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                    SizedBox(height: 10),
                    Text("Upload Insurance Image"),
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
      child: Container(
        height: 110,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt_outlined, size: 28),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 14)),
          ],
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
              "Upload images of your vehicle registration certificate (RC) and enter vehicle details",
        ),
        const SizedBox(height: 20),
        Container(
          margin: EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black12,
          ),

          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedAttachment,
                decoration: InputDecoration(
                  labelText: "Attachment Name",
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
              const SizedBox(height: 16),

              // Upload / Take Photo box
              GestureDetector(
                onTap: () {
                  // open camera/gallery picker
                },
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade400,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 32,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Take photo of your attachment",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
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
  const ReviewDetailsPage({super.key});

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
        ProfileTipsBox(
          title: 'What happens next:',
          tips: [
            '1. Our team will verify all your documents.',
            '2. You’ll receive notification when approved.',
            '3. Once approved, you can start accepting bookings.',
          ],
        ),
      ],
    );
  }
}
