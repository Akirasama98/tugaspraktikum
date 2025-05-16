import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../services/student_service.dart';

class StudentAddScreen extends StatefulWidget {
  const StudentAddScreen({super.key});

  @override
  State<StudentAddScreen> createState() => _StudentAddScreenState();
}

class _StudentAddScreenState extends State<StudentAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final StudentService _studentService = StudentService();
  bool _isLoading = false;

  // Dropdown values
  String _selectedSchool = 'Abydos';
  String _selectedClub = 'Countermeasures Committee';
  int _selectedAge = 16;
  String _selectedRarity = '3★';
  String _selectedCombatType = 'Striker';
  String _selectedWeaponType = 'AR';

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
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveStudent() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final student = BlueArchiveStudent(
          name: _nameController.text,
          school: _selectedSchool,
          club: _selectedClub,
          age: _selectedAge,
          rarity: _selectedRarity,
          combatType: _selectedCombatType,
          weaponType: _selectedWeaponType,
          imageUrl: _imageUrlController.text,
        );

        await _studentService.addStudent(student);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Student added successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error adding student: $e')));
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
        title: const Text('Add Student'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                          onPressed: _saveStudent,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Save Student'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
