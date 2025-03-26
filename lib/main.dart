import 'package:flutter/material.dart';
import 'package:dart_frog/dart_frog.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Time Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 247, 255),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 255, 255),
          brightness: Brightness.dark,
          primary: const Color.fromARGB(255, 112, 112, 112),
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: MainScreen(onThemeChanged: toggleTheme),
    );
  }
}

class MainScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const MainScreen({super.key, required this.onThemeChanged});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isDarkMode = false;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _updateScreens();
  }

  void _updateScreens() {
    _screens.clear();
    _screens.addAll([
      const HomeScreen(),
      const BlockedAppScreen(),
      const TimeManagementScreen(),
      const FocusModeScreen(),
      SettingsScreen(isDarkMode: _isDarkMode, onThemeChanged: _toggleTheme),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      widget.onThemeChanged(_isDarkMode);
      _updateScreens();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        elevation: 8,
        shadowColor: const Color.fromARGB(66, 53, 53, 53),
        height: 65,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              color: isDark ? const Color.fromARGB(255, 71, 71, 71) : const Color.fromARGB(255, 98, 102, 81),
            ),
            selectedIcon: Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.block_outlined,
              color: isDark ? const Color.fromARGB(255, 71, 71, 71) : Colors.grey[600],
            ),
            selectedIcon: Icon(
              Icons.block,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: 'Khóa ứng dụng',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.timer_outlined,
              color: isDark ? const Color.fromARGB(255, 71, 71, 71) : Colors.grey[600],
            ),
            selectedIcon: Icon(
              Icons.timer,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: 'Quản lý',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.self_improvement_outlined,
              color: isDark ? const Color.fromARGB(255, 71, 71, 71) : Colors.grey[600],
            ),
            selectedIcon: Icon(
              Icons.self_improvement,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: 'Tập trung',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.settings_outlined,
              color: isDark ? const Color.fromARGB(255, 71, 71, 71) : Colors.grey[600],
            ),
            selectedIcon: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: 'Cài đặt',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Time Management'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/app_intro.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Ứng dụng quản lý thời gian thông minh',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Giới thiệu ứng dụng',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ứng dụng giúp bạn quản lý thời gian sử dụng điện thoại một cách hiệu quả, tập trung vào những việc quan trọng và phát triển thói quen tốt. Với nhiều tính năng giúp bạn cải thiện thói quen',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 44),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Thống kê hôm nay',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem('Thời gian sử dụng', '0m'),
                              _buildStatItem('Ứng dụng bị khóa', '0'),
                              _buildStatItem('Chế độ tập trung', '0m'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }
}

class BlockedAppScreen extends StatelessWidget {
  const BlockedAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Khóa Ứng Dụng'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chọn thời gian khóa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Thời gian bắt đầu'),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.access_time),
                          label: const Text('08:00'),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Thời gian kết thúc'),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.access_time),
                          label: const Text('17:00'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Ứng dụng đã bị khóa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.apps),
                      title: Text('Ứng dụng ${index + 1}'),
                      subtitle: const Text('Facebook, Instagram, TikTok'),
                      trailing: Switch(value: true, onChanged: (bool value) {}),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TimeManagementScreen extends StatelessWidget {
  const TimeManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản Lý Thời Gian'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Giới hạn thời gian sử dụng ứng dụng',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Ứng dụng ${index + 1}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '2h 30m / 4h',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: 0.625,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.edit),
                                label: const Text('Chỉnh sửa'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FocusModeScreen extends StatelessWidget {
  const FocusModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chế Độ Tập Trung'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      '25:00',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('Thời gian còn lại'),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Bắt đầu'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.stop),
                          label: const Text('Dừng'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.settings),
                          label: const Text('Nâng cao')
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Danh sách ứng dụng đang bị khóa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.apps),
                      title: Text('Ứng dụng ${index + 1}'),
                      subtitle: const Text('Đang bị khóa'),
                      trailing: const Icon(Icons.lock),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cài Đặt'), centerTitle: true),
      body: ListView(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text('Trọng thích code'),
            accountEmail: Text('trongtran2015blue@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/avatar.jpg'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Chế độ tối'),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (bool value) => onThemeChanged(),
            ),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('Thông tin ứng dụng'),
            subtitle: Text('Phiên bản : Alpha Test :D'),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Thông báo ứng dụng'),
            trailing: Switch(value: true, onChanged: (bool value) {}),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Ngôn ngữ'),
            trailing: const Text('Tiếng Việt'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Đăng xuất'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
