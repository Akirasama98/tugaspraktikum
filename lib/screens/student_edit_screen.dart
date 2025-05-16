import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../services/student_service.dart';

class StudentEditScreen extends StatefulWidget {
  final BlueArchiveStudent student;

  const StudentEditScreen({super.key, required this.student});

  @override
  State<StudentEditScreen> createState() => _StudentEditScreenState();
}

class _StudentEditScreenState extends State<StudentEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _imageUrlController;
  final StudentService _studentService = StudentService();
  bool _isLoading = false;

  // Dropdown values
  late String _selectedSchool;
  late String _selectedClub;
  late int _selectedAge;
  late String _selectedRarity;
  late String _selectedCombatType;
  late String _selectedWeaponType;

  // Dropdown options
  final List<String> _schools = [
    'Abydos',
    'Trinity',
    'Gehenna',
    'Millennium',
    'Hyakkiyako',
    'Shanhaijing',
    'Red Winter',
    'Valkyrie',
    'SRT',
    'Arius',
    'Others',
  ];

  final List<String> _clubs = [
    'Countermeasures Committee',
    'Disciplinary Committee',
    'Tea Party',
    'Game Development',
    'Gourmet Research Society',
    'Engineering',
    'Justice Task Force',
    'Prefect Team',
    'Foreclosure Task Force',
    'Cleaning & Clearing',
    'Sisterhood',
    'Cooking Club',
    'Handyman',
    'Library Committee',
    'School Lunch Club',
    'Ninjutsu Research Club',
    'Yin-Yang Club',
    'Pandemonium Society',
    'Remedial Knights',
    'Vigilante Crew',
    'Spec Ops',
    'None',
  ];

  final List<int> _ages = List.generate(10, (index) => index + 14);

  final List<String> _rarities = ['1★', '2★', '3★'];

  final List<String> _combatTypes = ['Striker', 'Special'];

  final List<String> _weaponTypes = [
    'AR',
    'SMG',
    'SR',
    'SG',
    'MG',
    'GL',
    'RL',
    'HG',
    'MT',
    'RG',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student.name);
    _imageUrlController = TextEditingController(text: widget.student.imageUrl);
    _selectedSchool = widget.student.school;
    _selectedClub = widget.student.club;
    _selectedAge = widget.student.age;
    _selectedRarity = widget.student.rarity;
    _selectedCombatType = widget.student.combatType;
    _selectedWeaponType = widget.student.weaponType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _updateStudent() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final updatedStudent = BlueArchiveStudent(
          id: widget.student.id,
          name: _nameController.text,
          school: _selectedSchool,
          club: _selectedClub,
          age: _selectedAge,
          rarity: _selectedRarity,
          combatType: _selectedCombatType,
          weaponType: _selectedWeaponType,
          imageUrl: _imageUrlController.text,
        );

        await _studentService.updateStudent(updatedStudent);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Student updated successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error updating student: $e')));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Student'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Delete Student'),
                      content: const Text(
                        'Are you sure you want to delete this student?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
              );

              if (confirm == true && mounted) {
                try {
                  await _studentService.deleteStudent(widget.student.id!);
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Student deleted successfully'),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error deleting student: $e')),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'School',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedSchool,
                          items:
                              _schools.map((school) {
                                return DropdownMenuItem(
                                  value: school,
                                  child: Text(school),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedSchool = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Club',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedClub,
                          items:
                              _clubs.map((club) {
                                return DropdownMenuItem(
                                  value: club,
                                  child: Text(club),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedClub = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Age',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedAge,
                          items:
                              _ages.map((age) {
                                return DropdownMenuItem(
                                  value: age,
                                  child: Text(age.toString()),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedAge = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Rarity',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedRarity,
                          items:
                              _rarities.map((rarity) {
                                return DropdownMenuItem(
                                  value: rarity,
                                  child: Text(rarity),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedRarity = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Combat Type',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedCombatType,
                          items:
                              _combatTypes.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCombatType = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Weapon Type',
                            border: OutlineInputBorder(),
                          ),
                          value: _selectedWeaponType,
                          items:
                              _weaponTypes.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedWeaponType = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _imageUrlController,
                          decoration: const InputDecoration(
                            labelText: 'Image URL (optional)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _updateStudent,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Update Student'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
