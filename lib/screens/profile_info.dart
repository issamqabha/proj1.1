import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({Key? key}) : super(key: key);

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late DateFormat _dateFormat;
  late DateFormat _timeFormat;

  @override
  void initState() {
    super.initState();
    _initializeFormats();
  }

  Future<void> _initializeFormats() async {
    await initializeDateFormatting('ar_SA', null);
    _dateFormat = DateFormat.yMMMMd('ar_SA');
    _timeFormat = DateFormat.Hm('ar_SA');
  }

  @override
  Widget build(BuildContext context) {
    final user = firebaseAuth.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.teal),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "معلومات البروفايل",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _initializeFormats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal.shade700, Colors.teal.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Profile Avatar
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.teal.shade700,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        user?.email ?? "No Email",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Information Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Account Timeline Card
                      _buildModernCard(
                        icon: Icons.timeline_outlined,
                        title: "سجل الحساب",
                        children: [
                          _buildInfoItem(
                            icon: Icons.add_circle_outlined,
                            label: "تاريخ ووقت الإنشاء",
                            value: user?.metadata.creationTime != null
                                ? _formatDateTime(user!.metadata.creationTime!)
                                : "غير متوفر",
                            valueColor: Colors.teal.shade700,
                            isImportant: true,
                          ),
                          const Divider(height: 20),
                          _buildInfoItem(
                            icon: Icons.login_outlined,
                            label: "تاريخ ووقت آخر دخول",
                            value: user?.metadata.lastSignInTime != null
                                ? _formatDateTime(user!.metadata.lastSignInTime!)
                                : "غير متوفر",
                            valueColor: Colors.blue.shade700,
                            isImportant: true,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Email Info Card
                      _buildModernCard(
                        icon: Icons.email_outlined,
                        title: "معلومات الاتصال",
                        children: [
                          _buildInfoItem(
                            icon: Icons.alternate_email_outlined,
                            label: "البريد الإلكتروني",
                            value: user?.email ?? "غير متوفر",
                            valueColor: Colors.grey.shade800,
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Statistics Card
                      _buildModernCard(
                        icon: Icons.analytics_outlined,
                        title: "الإحصائيات",
                        children: [
                          _buildStatItem(
                            icon: Icons.calendar_today_outlined,
                            label: "عمر الحساب",
                            value: user?.metadata.creationTime != null
                                ? _calculateAccountAge(user!.metadata.creationTime!)
                                : "غير متوفر",
                          ),
                          const SizedBox(height: 15),
                          _buildStatItem(
                            icon: Icons.update_outlined,
                            label: "آخر نشاط",
                            value: user?.metadata.lastSignInTime != null
                                ? _calculateLastActivity(user!.metadata.lastSignInTime!)
                                : "غير متوفر",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  // دالة لبناء الكارت الحديث
  Widget _buildModernCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.teal, size: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Card Content
            Column(children: children),
          ],
        ),
      ),
    );
  }

  // دالة لبناء عنصر المعلومات
  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool isImportant = false,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: Colors.grey.shade600),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  color: valueColor ?? Colors.black87,
                  fontWeight: isImportant ? FontWeight.w600 : FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // دالة لبناء عنصر الإحصائيات
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.teal),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // دالة لتنسيق التاريخ والوقت باستخدام intl package
  String _formatDateTime(DateTime date) {
    final dateString = _dateFormat.format(date);
    final timeString = _timeFormat.format(date);
    return "$dateString - $timeString";
  }

  // دالة لحساب عمر الحساب باستخدام intl package
  String _calculateAccountAge(DateTime creationTime) {
    final now = DateTime.now();
    final difference = now.difference(creationTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      final months = ((difference.inDays % 365) / 30).floor();
      return "$years سنة و $months شهر";
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      final days = difference.inDays % 30;
      return "$months شهر و $days يوم";
    } else if (difference.inDays > 0) {
      return "${difference.inDays} يوم";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} ساعة";
    } else {
      return "أقل من ساعة";
    }
  }

  // دالة لحساب آخر نشاط باستخدام intl package
  String _calculateLastActivity(DateTime lastSignInTime) {
    final now = DateTime.now();
    final difference = now.difference(lastSignInTime);

    if (difference.inDays > 30) {
      return _dateFormat.format(lastSignInTime);
    } else if (difference.inDays > 0) {
      return "منذ ${difference.inDays} يوم";
    } else if (difference.inHours > 0) {
      return "منذ ${difference.inHours} ساعة";
    } else if (difference.inMinutes > 0) {
      return "منذ ${difference.inMinutes} دقيقة";
    } else {
      return "الآن";
    }
  }
}