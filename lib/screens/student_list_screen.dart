import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../services/student_service.dart';
import 'student_add_screen.dart';
import 'student_edit_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final StudentService _studentService = StudentService();
  String _selectedSchool = 'All';
  final List<String> _schools = [
    'All',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blue Archive Students'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Filter by School',
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
            ),
            Expanded(
              child: StreamBuilder<List<BlueArchiveStudent>>(
                stream:
                    _selectedSchool == 'All'
                        ? _studentService.getStudents()
                        : _studentService.getStudentsBySchool(_selectedSchool),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final students = snapshot.data;

                  if (students == null || students.isEmpty) {
                    return const Center(
                      child: Text('No students found. Add one!'),
                    );
                  }

                  return ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      return Dismissible(
                        key: Key(student.id!),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _studentService.deleteStudent(student.id!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${student.name} deleted')),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: ListTile(
                            leading:
                                student.imageUrl.isNotEmpty
                                    ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        student.imageUrl,
                                      ),
                                    )
                                    : CircleAvatar(
                                      backgroundColor: _getSchoolColor(
                                        student.school,
                                      ),
                                      child: Text(
                                        student.name.isNotEmpty
                                            ? student.name[0]
                                            : '?',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            title: Text(student.name),
                            subtitle: Text(
                              '${student.school} • ${student.club}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(student.rarity),
                                const SizedBox(width: 8),
                                Text(student.combatType),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          StudentEditScreen(student: student),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StudentAddScreen()),
          );
        },
        tooltip: 'Add Student',
        child: const Icon(Icons.add),
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
