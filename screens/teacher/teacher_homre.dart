// screens/teacher/teacher_home.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/database_service.dart';
import '../../models/course_model.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  int _selectedIndex = 0;
  late Future<List<CourseModel>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    if (user != null) {
      _coursesFuture = DatabaseService().getCoursesByTeacher(user.id);
    } else {
      _coursesFuture = Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel del Profesor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddCourseDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: _buildScreen(_selectedIndex),
      drawer: _buildDrawer(context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'Clases',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Tareas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Estudiantes',
          ),
        ],
      ),
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return TeacherDashboard();
      case 1:
        return CoursesScreen();
      case 2:
        return AssignmentsScreen();
      case 3:
        return StudentsScreen();
      default:
        return const Center(child: Text('Pantalla no encontrada'));
    }
  }

  Drawer _buildDrawer(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.name ?? 'Profesor'),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person, size: 40),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Horario'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/teacher/schedule');
            },
          ),
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('Estadísticas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/teacher/analytics');
            },
          ),
          ListTile(
            leading: const Icon(Icons.announcement),
            title: const Text('Anuncios'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/teacher/announcements');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              Navigator.pop(context);
              Navigator