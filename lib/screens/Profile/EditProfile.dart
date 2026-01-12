import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../Provider/address_provider.dart';
import '../../Provider/auth_provider.dart';
import '../../Provider/profile_provider.dart';
import '../../core/profile_provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  File? _profileImageFile;
  String? _profileImageUrl; // from API
  final ImagePicker _picker = ImagePicker();
  bool _initialized = false;
  bool isSubmitting = false;

  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final profileProvider = context.read<ProfileProvider>();
      final addressProvider = context.read<AddressProvider>();

      await profileProvider.loadProfile();
      await addressProvider.loadAddressData();

      final profile = profileProvider.state.profile;

      if (profile != null) {
        nameController.text = profile.fullName;
        mobileController.text = profile.mobileNumber;
        emailController.text = profile.email ?? "";
        _profileImageUrl = profile.profilePic;

        addressProvider.selectedStateId = profile.stateId;
        addressProvider.selectedDistrictId = profile.districtId;
        addressProvider.selectedTalukId = profile.talukId;
        addressProvider.selectedHobliId = profile.hobliId;
        addressProvider.selectedVillageId = profile.villageId;
      }

      setState(() => _initialized = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = context.watch<AddressProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "SETTINGS",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ClipOval(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: _profileImageFile != null
                          ? Image.file(_profileImageFile!, fit: BoxFit.cover)
                          : (_profileImageUrl != null &&
                                _profileImageUrl!.isNotEmpty)
                          ? Image.network(
                              _profileImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => SvgPicture.asset(
                                "assets/animations/profile_e.svg",
                              ),
                            )
                          : SvgPicture.asset(
                              "assets/animations/profile_e.svg",
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),

                  /// ✏️ Edit / Upload icon
                  GestureDetector(
                    onTap: isUploading ? null : _showImageSourcePicker,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4),
                        ],
                      ),
                      child: isUploading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.green,
                            ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Center(
            //   child: Container(
            //     height: 34,
            //     width: 120,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(20),
            //       boxShadow: const [
            //         BoxShadow(color: Colors.black12, blurRadius: 4),
            //       ],
            //     ),
            //     child: const Center(child: Text("Edit Profile")),
            //   ),
            // ),
            const SizedBox(height: 10),

            _label("Full name"),
            _inputField(controller: nameController, hint: "Enter name"),

            _label("Mobile number"),
            _inputField(
              controller: mobileController,
              hint: "Enter mobile number",
            ),

            _label("Email Id (optional)"),
            _inputField(controller: emailController, hint: "Enter email id"),

            _label("State"),
            _dropdown(
              value: addressProvider.selectedStateId,
              hint: "Select State",
              items: addressProvider.states,
              onChanged: (v) {
                addressProvider.selectState(v);
              },
            ),

            _label("District"),
            _dropdown(
              value: addressProvider.selectedDistrictId,
              hint: "Select District",
              items: addressProvider.filteredDistricts,
              onChanged: (v) {
                addressProvider.selectDistrict(v);
              },
            ),

            _label("Taluk"),
            _dropdown(
              value: addressProvider.selectedTalukId,
              hint: "Select Taluk",
              items: addressProvider.filteredTaluks,
              onChanged: (v) {
                addressProvider.selectTaluk(v);
              },
            ),

            _label("Hobli"),
            _dropdown(
              value: addressProvider.selectedHobliId,
              hint: "Select Hobli",
              items: addressProvider.filteredHoblis,
              onChanged: (v) {
                addressProvider.selectHobli(v);
              },
            ),

            _label("Village"),
            _dropdown(
              value: addressProvider.selectedVillageId,
              hint: "Select Village",
              items: addressProvider.filteredVillages,
              onChanged: (v) {
                addressProvider.selectedVillageId = v;
                addressProvider.notifyListeners();
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: ElevatedButton(
          onPressed: isSubmitting
              ? null
              : () async {
                  final addressProvider = context.read<AddressProvider>();
                  final profileProvider = context.read<ProfileProvider>();

                  setState(() => isSubmitting = true);

                  try {
                    await profileProvider.updateProfile(
                      fullName: nameController.text.trim(),
                      profileImage: _profileImageUrl ?? "",
                      mobileNumber: mobileController.text.trim(),
                      emailId: emailController.text.trim(),
                      gender: "male",
                      stateId: addressProvider.selectedStateId ?? "",
                      districtId: addressProvider.selectedDistrictId ?? "",
                      talukId: addressProvider.selectedTalukId ?? "",
                      hobliId: addressProvider.selectedHobliId ?? "",
                      villageId: addressProvider.selectedVillageId ?? "",
                    );

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Profile updated successfully"),
                      ),
                    );

                    Navigator.pop(context);
                  } catch (e) {
                    debugPrint("Update failed: $e");
                  } finally {
                    if (mounted) {
                      setState(() => isSubmitting = false);
                    }
                  }
                },

          // onPressed: () async {
          //   final addressProvider = context.read<AddressProvider>();
          //   final profileProvider = context.read<ProfileProvider>();
          //
          //   await profileProvider.updateProfile(
          //     fullName: nameController.text.trim(),
          //     profileImage: _profileImageUrl ?? "",
          //     mobileNumber: mobileController.text.trim(),
          //     emailId: emailController.text.trim(),
          //     gender: "male",
          //     stateId: addressProvider.selectedStateId ?? "",
          //     districtId: addressProvider.selectedDistrictId ?? "",
          //     talukId: addressProvider.selectedTalukId ?? "",
          //     hobliId: addressProvider.selectedHobliId ?? "",
          //     villageId: addressProvider.selectedVillageId ?? "",
          //   );
          //   profileProvider.notifyListeners();
          //   if (mounted) {
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(content: Text("Profile updated successfully")),
          //     );
          //     Navigator.pop(context);
          //   }
          // },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8BC34A),
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Save Changes",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfileChanges() async {
    final profileProvider = context.read<ProfileProvider>();

    final Map<String, dynamic> payload = {
      "full_name": nameController.text.trim(),
      "mobile_number": mobileController.text.trim(),
      "email": emailController.text.trim(),
      "profile_pic": _profileImageUrl, // latest uploaded image
      "state_id": context.read<AddressProvider>().selectedStateId,
      "district_id": context.read<AddressProvider>().selectedDistrictId,
      "taluk_id": context.read<AddressProvider>().selectedTalukId,
      "hobli_id": context.read<AddressProvider>().selectedHobliId,
      "village_id": context.read<AddressProvider>().selectedVillageId,
    };
    print(payload);

    // await profileProvider.updateProfile(payload);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
      Navigator.pop(context);
    }
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  pickAndUploadProfileImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  pickAndUploadProfileImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pickAndUploadProfileImage(ImageSource source) async {
    try {
      final picker = ImagePicker();

      // 1️⃣ Pick image (camera or gallery)
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
          IOSUiSettings(title: 'Crop Image', aspectRatioLockEnabled: false),
        ],
      );

      if (croppedFile == null) return;

      final File croppedImageFile = File(croppedFile.path);

      setState(() {
        _profileImageFile = croppedImageFile; // preview
        isUploading = true;
      });

      // 3️⃣ Upload ONLY image
      final authNotifier = context.read<AuthNotifier>();
      final uploadedUrl = await authNotifier.uploadImage(croppedImageFile);

      setState(() => isUploading = false);

      if (uploadedUrl == null || uploadedUrl.isEmpty) return;

      // 4️⃣ Replace API image
      setState(() {
        _profileImageUrl = uploadedUrl;
        _profileImageFile = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Profile image uploaded")));
      }
    } catch (e) {
      setState(() => isUploading = false);
      debugPrint("Upload error: $e");
    }
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFA7A7A7)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
      ),
    );
  }

  Widget _dropdown({
    required String? value,
    required String hint,
    required List<dynamic> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFA7A7A7)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          items: items
              .map(
                (e) =>
                    DropdownMenuItem<String>(value: e.id, child: Text(e.name)),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
