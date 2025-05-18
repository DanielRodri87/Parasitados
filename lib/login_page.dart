import 'package:flutter/material.dart';
import 'loading_game.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
            const SizedBox(height: 60),
            Image.asset(
              'assets/images/LogoApp.png',
              height: 260,
            ),
            const Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(60)),
                child: LoginFormContainer(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginFormContainer extends StatelessWidget {
  const LoginFormContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(60)),
      child: Container(
        height: 700,
        padding: const EdgeInsets.only(top: 20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Fundo com imagem
            Image.asset(
              'assets/images/back_login.png',
              fit: BoxFit.fitHeight,
            ),

            // Conteúdo do formulário com padding dinâmico para o teclado
            Padding(
              padding: EdgeInsets.only(
                top: 50,
                left: 30,
                right: 30,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/images/gato_login.png',
                      height: 80,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Olá, Seja Bem-vindo!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const CustomInputField(
                      hintText: 'Digite o jogador 1 aqui',
                    ),
                    const SizedBox(height: 20),
                    const CustomInputField(
                      hintText: 'Digite o jogador 2 aqui',
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoadingGamePage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00DB8F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      ),
                      child: const Text(
                        'Entrar',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Entre em Contato\nSobre Nós',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF00DB8F),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class CustomInputField extends StatelessWidget {
  final String hintText;

  const CustomInputField({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Image.asset('assets/images/user.png', scale: 2),
        suffixIcon: Image.asset('assets/images/add_foto.png', scale: 2),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
