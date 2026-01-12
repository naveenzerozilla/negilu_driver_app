import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Model/vehicle.dart';
import '../../Provider/vehicle_provider.dart';

class ManageVehiclesScreen extends ConsumerWidget {
  const ManageVehiclesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleAsync = ref.watch(
      vehicleAttachmentsProvider("203c51bc-ada7-4f06-82c8-2b98450a8c0b"),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Manage Vehicles",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      bottomNavigationBar: const _BottomActionButton(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child:
        vehicleAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text("Error: $e"),
            data: (vehicle) {
              return

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Manage your vehicles and attachments together for better service offerings.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Manage tractors and vehicles as complete equipment packages to help customers clearly understand what they are hiring.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Bullet Points
                    _bulletPoint("Manage vehicles and attachments together."),
                    _bulletPoint(
                        "Set pricing for vehicle and attachment pairs."),
                    _bulletPoint(
                      "Update documents and images for vehicles and equipment.",
                    ),
                    _bulletPoint("Monitor availability and maintenance."),
                    const SizedBox(height: 20),
                    AttachmentToggle(),
                    const SizedBox(height: 20),
                    _StatsRow(),

                    const SizedBox(height: 16),
                    SizedBox(height: 16),
                    _AddVehicleCard(),
                    SizedBox(height: 16),
                    VehicleCard(vehicle: vehicle),
                    SizedBox(height: 16),
                  ],
                )
              ;})),
    );
  }
}

class AttachmentToggle extends StatefulWidget {
  const AttachmentToggle({super.key});

  @override
  State<AttachmentToggle> createState() => _AttachmentToggleState();
}

class _AttachmentToggleState extends State<AttachmentToggle> {
  int selectedIndex = 0; // 0 = Vehicles, 1 = All Attachments

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          _buildTab(
            title: "Vehicles & Attachments",
            isSelected: selectedIndex == 0,
            onTap: () => setState(() => selectedIndex = 0),
          ),
          _buildTab(
            title: "All Attachments",
            isSelected: selectedIndex == 1,
            onTap: () => setState(() => selectedIndex = 1),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF8CCB2C) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _bulletPoint(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    child: Row(
      children: [
        const Icon(Icons.circle, color: Colors.green, size: 8),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF64748B),
            ),
          ),
        ),
      ],
    ),
  );
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _StatCard(title: "2", subtitle: "Total Vehicles"),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _StatCard(title: "2", subtitle: "Active"),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _StatCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF8CCB2C),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddVehicleCard extends StatelessWidget {
  const _AddVehicleCard();

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        dashPattern: [8, 8],
        strokeWidth: 0,
        padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
        color: Colors.black54,
        radius: const Radius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Plus icon
            const Icon(Icons.add, size: 36, color: Color(0xFF64748B)),

            const SizedBox(height: 16),

            /// Title
            const Text(
              "Add New Vehicle",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF020817),
              ),
            ),

            const SizedBox(height: 8),

            /// Subtitle
            const Text(
              "Register another vehicle to expand your services",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),

            const SizedBox(height: 16),

            /// Outlined button
            OutlinedButton(
              onPressed: () {
                // TODO: Navigate to Add Vehicle screen
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE5E7EB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: const Text(
                "Add Vehicle",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF020817),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _VehicleHeader(name: vehicle.name, number: vehicle.number),
          const SizedBox(height: 12),

          if (vehicle.attachments.isEmpty)
            const Text(
              "No attachments added",
              style: TextStyle(color: Color(0xFF6B7280)),
            )
          else
            ...vehicle.attachments.map(
              (a) =>
                  _AttachmentRow(name: a['name'], price: "₹${a['price']}/hour"),
            ),

          const SizedBox(height: 8),
          const _AddAttachmentButton(),
        ],
      ),
    );
  }
}

class _VehicleHeader extends StatelessWidget {
  final String name;
  final String number;

  const _VehicleHeader({required this.name, required this.number});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.agriculture, color: Color(0xFF8CCB2C)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                number,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
        _statusChip(),
      ],
    );
  }

  Widget _statusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5D8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        "Active",
        style: TextStyle(
          color: Color(0xFF8CCB2C),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _AttachmentRow extends StatelessWidget {
  final String name;
  final String price;

  const _AttachmentRow({required this.name, required this.price});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          Text(price, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _AddAttachmentButton extends StatelessWidget {
  const _AddAttachmentButton();

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.add, size: 18),
      label: const Text("Add Attachment"),
      style: TextButton.styleFrom(foregroundColor: const Color(0xFF8CCB2C)),
    );
  }
}

class _BottomActionButton extends StatelessWidget {
  const _BottomActionButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8CCB2C),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "Manage Equipment",
          style: TextStyle(
            fontSize: 16,

            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
