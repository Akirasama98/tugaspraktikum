import 'package:flutter/material.dart';
import '../models/student_model.dart';

class StudentDetailScreen extends StatelessWidget {
  final BlueArchiveStudent student;

  const StudentDetailScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(student.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student image or avatar
                Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getSchoolColor(student.school).withOpacity(0.2),
                      image:
                          student.imageUrl.isNotEmpty
                              ? DecorationImage(
                                image: NetworkImage(student.imageUrl),
                                fit: BoxFit.cover,
                              )
                              : null,
                    ),
                    child:
                        student.imageUrl.isEmpty
                            ? Center(
                              child: Text(
                                student.name.isNotEmpty ? student.name[0] : '?',
                                style: TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  color: _getSchoolColor(student.school),
                                ),
                              ),
                            )
                            : null,
                  ),
                ),

                // Student name
                Center(
                  child: Text(
                    student.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Rarity
                Center(
                  child: Text(
                    student.rarity,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Student details
                _buildDetailCard(
                  context,
                  title: 'Basic Information',
                  details: [
                    DetailItem(label: 'School', value: student.school),
                    DetailItem(label: 'Club', value: student.club),
                    DetailItem(label: 'Age', value: student.age.toString()),
                  ],
                ),

                const SizedBox(height: 16),

                _buildDetailCard(
                  context,
                  title: 'Combat Information',
                  details: [
                    DetailItem(label: 'Combat Type', value: student.combatType),
                    DetailItem(label: 'Weapon Type', value: student.weaponType),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context, {
    required String title,
    required List<DetailItem> details,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...details.map((detail) => _buildDetailRow(detail)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(DetailItem detail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '${detail.label}:',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              detail.value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Color _getSchoolColor(String school) {
    switch (school) {
      case 'Abydos':
        return Colors.blue;
      case 'Trinity':
        return Colors.yellow.shade800;
      case 'Gehenna':
        return Colors.red;
      case 'Millennium':
        return Colors.green;
      case 'Hyakkiyako':
        return Colors.pink;
      case 'Shanhaijing':
        return Colors.teal;
      case 'Red Winter':
        return Colors.deepOrange;
      case 'Valkyrie':
        return Colors.purple;
      case 'SRT':
        return Colors.grey;
      case 'Arius':
        return Colors.indigo;
      default:
        return Colors.blueGrey;
    }
  }
}

class DetailItem {
  final String label;
  final String value;

  DetailItem({required this.label, required this.value});
}
