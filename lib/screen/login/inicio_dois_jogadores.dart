import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parasitados/routes/routes.dart';
import 'package:sqflite/sqflite.dart';
import '../../database/database.dart';

class InicioDoisJogadores extends StatelessWidget {
  const InicioDoisJogadores({super.key});

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
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_outlined, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Image.asset('assets/images/LogoApp.png', height: 260),
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

class LoginFormContainer extends StatefulWidget {
  const LoginFormContainer({super.key});

  @override
  State<LoginFormContainer> createState() => _LoginFormContainerState();
}

class _LoginFormContainerState extends State<LoginFormContainer> {
  String nome1 = '';
  String nome2 = '';
  String foto1 = '';
  String foto2 = '';

  Future<void> salvarNoBanco() async {
    if (nome1.isEmpty || nome2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha os nomes dos jogadores'),
        ),
      );
      return;
    }

    final db = await LoginDatabase().database;

    await db.insert('login', {
      'id': 1, // Sempre sobrescrevendo este registro
      'nome1': nome1,
      'nome2': nome2,
      'foto1': foto1.isNotEmpty ? foto1 : null,
      'foto2': foto2.isNotEmpty ? foto2 : null,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/back_login.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 50,
              left: 30,
              right: 30,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Image.asset('assets/images/gato_login.png', height: 80),
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
                  CustomInputField(
                    hintText: 'Digite o jogador 1 aqui',
                    onNameChanged: (value) => setState(() => nome1 = value),
                    onImageSelected: (path) => setState(() => foto1 = path),
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    hintText: 'Digite o jogador 2 aqui',
                    onNameChanged: (value) => setState(() => nome2 = value),
                    onImageSelected: (path) => setState(() => foto2 = path),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed:
                        (nome1.isNotEmpty && nome2.isNotEmpty)
                            ? () async {
                              try {
                                await salvarNoBanco();
                                if (!context.mounted) return;
                                Navigator.pushNamed(
                                  context,
                                  Routes.loadingScreenDoisJogador,
                                );
                              } catch (e) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Erro ao salvar os dados: $e',
                                    ),
                                  ),
                                );
                              }
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00DB8F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 100,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'Entrar',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomInputField extends StatefulWidget {
  final String hintText;
  final Function(String)? onNameChanged;
  final Function(String)? onImageSelected;

  const CustomInputField({
    super.key,
    required this.hintText,
    this.onNameChanged,
    this.onImageSelected,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });

      if (widget.onImageSelected != null) {
        widget.onImageSelected!(pickedImage.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: widget.onNameChanged,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: Image.asset('assets/images/user.png', scale: 2),
        suffixIcon: IconButton(
          icon:
              _selectedImage == null
                  ? Image.asset('assets/images/add_foto.png', scale: 2)
                  : CircleAvatar(
                    backgroundImage: FileImage(_selectedImage!),
                    radius: 16,
                  ),
          onPressed: _pickImage,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
