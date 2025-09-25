import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sign_in_page.dart';
import 'profile_info.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeIn,
        ));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم تسجيل الخروج بنجاح ✅"),
          backgroundColor: Colors.teal,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person,
                        size: 40, color: Colors.teal.shade700),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user?.email ?? "No Email",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.teal),
              title: const Text("البروفايل", style: TextStyle(color: Colors.black87)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileInfo()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.grey),
              title: const Text("الإعدادات", style: TextStyle(color: Colors.grey)),
              onTap: null,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("تسجيل الخروج", style: TextStyle(color: Colors.red)),
              onTap: _signOut,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("الصفحة الرئيسية"),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person,
                        size: 60, color: Colors.teal.shade700),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Welcome 🎉",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user?.email ?? "No Email",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      elevation: 5,
                    ),
                    onPressed: _signOut,
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      "Sign Out",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
