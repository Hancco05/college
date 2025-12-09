// screens/student/student_home.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/student_model.dart';
import '../../models/course_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/database_service.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _selectedIndex = 0;
  late Future<List<CourseModel>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser;
    if (user != null) {
      _coursesFuture = DatabaseService().getCoursesByStudent(user.id);
    } else {
      _coursesFuture = Future.value([]);
    }
  }

  final List<Widget> _screens = [
    const DashboardScreen(),
    const CoursesScreen(),
    const GradesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    final student = user != null ? StudentModel.fromUser(user) : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel del Estudiante'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
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
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
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
            icon: Icon(Icons.school),
            label: 'Cursos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grade),
            label: 'Calificaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saludo
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '¡Bienvenido!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, _) {
                            return Text(
                              authProvider.currentUser?.name ?? 'Estudiante',
                              style: const TextStyle(fontSize: 16),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      Navigator.pushNamed(context, '/schedule');
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Próximas tareas
          const Text(
            'Tareas Pendientes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder<List<CourseModel>>(
            future: DatabaseService().getAllCourses(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No hay tareas pendientes'),
                  ),
                );
              }

              // Aquí deberías obtener las tareas reales del estudiante
              return Column(
                children: [
                  _buildTaskItem('Matemáticas', 'Tarea de álgebra', 'Hoy'),
                  _buildTaskItem('Historia', 'Ensayo sobre la independencia', 'Mañana'),
                  _buildTaskItem('Ciencias', 'Proyecto científico', '15 Dic'),
                ],
              );
            },
          ),

          const SizedBox(height: 20),

          // Cursos recientes
          const Text(
            'Mis Cursos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCourseCard('Matemáticas', Icons.calculate, Colors.blue),
                _buildCourseCard('Historia', Icons.history, Colors.green),
                _buildCourseCard('Ciencias', Icons.science, Colors.orange),
                _buildCourseCard('Literatura', Icons.book, Colors.purple),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String course, String task, String dueDate) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.assignment),
        title: Text(task),
        subtitle: Text(course),
        trailing: Chip(
          label: Text(dueDate),
          backgroundColor: dueDate == 'Hoy' ? Colors.red[100] : Colors.grey[200],
        ),
        onTap: () {
          // Navegar a detalles de la tarea
        },
      ),
    );
  }

  Widget _buildCourseCard(String title, IconData icon, Color color) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 10),
      child: Card(
        color: color.withOpacity(0.1),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/course-details', arguments: title);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Otras pantallas del estudiante (CoursesScreen, GradesScreen, ProfileScreen)
// se implementarían de manera similar