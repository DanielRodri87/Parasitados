import 'package:flutter/material.dart';
import 'package:parasitados/routes/routes.dart';
import 'login_page.dart';
import 'single_login_page.dart';
import '../about/about.dart';  // Novo import

class ModeGamePage extends StatefulWidget {
  const ModeGamePage({super.key});

  @override
  State<ModeGamePage> createState() => _ModeGamePageState();
}

class _ModeGamePageState extends State<ModeGamePage> {
  int _selectedMode = 0; // 0 = none, 1 = individual, 2 = multiplayer

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF69D1E9),
              Color(0xFF75D6AB),
              Color(0xFF7BD98D),
              Color(0xFF81DC6E),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Image.asset(
              'assets/images/LogoApp.png',
              height: 180,
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(60)),
                child: _GameModeSelector(
                  selectedMode: _selectedMode,
                  onModeSelected: (mode) => setState(() => _selectedMode = mode),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GameModeSelector extends StatelessWidget {
  final int selectedMode;
  final Function(int) onModeSelected;

  const _GameModeSelector({
    required this.selectedMode,
    required this.onModeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/back_login.png'),
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/game.png', height: 60),
          const SizedBox(height: 20),
          const Text(
            'Escolha o modo de Jogo!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 30),

          // Individual
          SizedBox(
            width: double.infinity,
            child: _ModeButton(
              icon: 'assets/images/user.png',
              label: 'Partida Individual',
              selected: selectedMode == 1,
              onTap: () => onModeSelected(1),
            ),
          ),

          const SizedBox(height: 15),

          // Multiplayer
          SizedBox(
            width: double.infinity,
            child: _ModeButton(
              icon: 'assets/images/user.png',
              label: 'Jogue com seu amigo',
              selected: selectedMode == 2,
              onTap: () => onModeSelected(2),
            ),
          ),

          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: () {
              if (selectedMode == 1) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SingleLoginPage()));
              } else if (selectedMode == 2) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              backgroundColor: const Color(0xFF00DB8F),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text(
              'Jogar',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),

          const SizedBox(height: 20),

          // Footer - apenas Sobre Nós
          TextButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (_) => const AboutPage())
              );
            },
            child: const Text('Sobre Nós', style: TextStyle(color: Color(0xFF00DB8F))),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black45),
          borderRadius: BorderRadius.circular(30),
          color: selected ? const Color(0xFFE8FDF5) : Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(icon, height: 24),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
