import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/student_model.dart';

class StudentService {
  final CollectionReference studentsCollection = 
      FirebaseFirestore.instance.collection('students');

  // Create a new student
  Future<void> addStudent(BlueArchiveStudent student) async {
    await studentsCollection.add(student.toMap());
  }

  // Read all students
  Stream<List<BlueArchiveStudent>> getStudents() {
    return studentsCollection
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return BlueArchiveStudent.fromMap(
          doc.data() as Map<String, dynamic>, 
          doc.id
        );
      }).toList();
    });
  }

  // Update a student
  Future<void> updateStudent(BlueArchiveStudent student) async {
    await studentsCollection.doc(student.id).update(student.toMap());
  }

  // Delete a student
  Future<void> deleteStudent(String studentId) async {
    await studentsCollection.doc(studentId).delete();
  }
  
  // Get students by school
  Stream<List<BlueArchiveStudent>> getStudentsBySchool(String school) {
    return studentsCollection
        .where('school', isEqualTo: school)
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return BlueArchiveStudent.fromMap(
          doc.data() as Map<String, dynamic>, 
          doc.id
        );
      }).toList();
    });
  }
}
