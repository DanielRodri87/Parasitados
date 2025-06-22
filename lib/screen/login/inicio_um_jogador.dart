import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parasitados/database/database.dart';
import 'package:parasitados/database/user_database.dart';
import 'package:parasitados/routes/routes.dart';
import 'package:sqflite/sqflite.dart';

class InicioUmJogador extends StatelessWidget {
  const InicioUmJogador({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
        child: SafeArea(
          child: Column(
            children: [
              // Header com botão de voltar
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Logo com animação
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 800),
                tween: Tween<double>(begin: 0, end: 1),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value,
                      child: Image.asset(
                        'assets/images/LogoApp.png',
                        height: size.height * 0.25,
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: size.height * 0.02),

              // Container principal
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: const LoginFormContainer(),
                ),
              ),
            ],
          ),
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

class _LoginFormContainerState extends State<LoginFormContainer>
    with TickerProviderStateMixin {
  String nome1 = '';
  String foto1 = '';
  String? nomeFinal;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    lerDados();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> lerDados() async {
    final dados = await UserDatabase.lerUserLocal();
    if (dados != null && dados["nome"] != null) {
      setState(() {
        nomeFinal = dados["nome"];
      });
    }
  }

  Future<void> salvarNoBanco() async {
    if (nome1.isEmpty && nomeFinal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor, preencha o nome do jogador'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    final db = await LoginDatabase().database;
    final userDb = UserDatabase.withData();
    final int id = await userDb.addUser(nome1);
    await UserDatabase.salvarUserLocal(nome1, id);

    await db.insert('login', {
      'id': 1,
      'nome1': nome1,
      'nome2': 'fake',
      'foto1': foto1.isNotEmpty ? foto1 : null,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                image: const DecorationImage(
                  image: AssetImage('assets/images/back_login.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                  color: Colors.white.withValues(alpha: 0.95),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.08,
                    vertical: size.height * 0.03,
                  ),
                  child: Column(
                    children: [
                      // Avatar do gato
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade50,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF69D1E9,
                              ).withValues(alpha: 0.3),
                              blurRadius: 15,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/gato_login.png',
                          height: 60,
                        ),
                      ),

                      SizedBox(height: size.height * 0.01),

                      // Título de boas-vindas
                      Text(
                        'Olá, Seja Bem-vindo!',
                        style: TextStyle(
                          fontSize: size.width * 0.055,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                          letterSpacing: 0.5,
                        ),
                      ),

                      SizedBox(height: size.height * 0.03),

                      // Seção do Pulgo com design moderno
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: size.height * 0.02,
                        ),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF69D1E9).withValues(alpha: 0.1),
                              const Color(0xFF81DC6E).withValues(alpha: 0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/images/pulgo.png',
                                height: 80,
                              ),
                            ),

                            SizedBox(width: size.width * 0.04),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Senti pena de você... então decidi fazer caridade emocional. Não se preocupe, não vou te deixar sozinho!',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize:
                                          size.width *
                                          0.028, // Reduzido de 0.032
                                      fontWeight: FontWeight.w400,
                                      height: 1.3,
                                    ),
                                    overflow:
                                        TextOverflow
                                            .visible, // Garante que o texto quebre
                                  ),

                                  SizedBox(height: size.height * 0.01),

                                  Wrap(
                                    // Usando Wrap em vez de Row
                                    children: [
                                      Text(
                                        'Atenciosamente: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize:
                                              size.width *
                                              0.028, // Reduzido de 0.032
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Text(
                                        'Pulgo',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              size.width *
                                              0.028, // Reduzido de 0.032
                                          color: const Color(0xFF69D1E9),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Mensagem de boas-vindas para usuário existente
                      if (nomeFinal != null)
                        Padding(
                          padding: EdgeInsets.only(bottom: size.height * 0.02),
                          child: Text(
                            'Bem-vindo de volta, $nomeFinal! 👋',
                            style: TextStyle(
                              fontSize: size.width * 0.045,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF81DC6E),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      // Campo de entrada moderno
                      CustomInputField(
                        hintText:
                            nomeFinal == null
                                ? 'Digite seu nome aqui'
                                : 'Nome salvo: $nomeFinal',
                        onNameChanged: (v) => setState(() => nome1 = v),
                        onImageSelected: (p) => setState(() => foto1 = p),
                        enabled: nomeFinal == null,
                      ),

                      SizedBox(height: size.height * 0.04),

                      // Botão de entrada moderno
                      Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors:
                                (nome1.isNotEmpty || nomeFinal != null)
                                    ? [
                                      const Color(0xFF69D1E9),
                                      const Color(0xFF81DC6E),
                                    ]
                                    : [
                                      Colors.grey.shade300,
                                      Colors.grey.shade400,
                                    ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow:
                              (nome1.isNotEmpty || nomeFinal != null)
                                  ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF69D1E9,
                                      ).withValues(alpha: 0.4),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 5),
                                    ),
                                  ]
                                  : [],
                        ),
                        child: ElevatedButton(
                          onPressed:
                              (nome1.isNotEmpty || nomeFinal != null)
                                  ? () async {
                                    try {
                                      await salvarNoBanco();
                                      if (!context.mounted) return;
                                      Navigator.pushReplacementNamed(
                                        context,
                                        Routes.loadingScreenUmJogador,
                                      );
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Erro ao salvar: $e'),
                                          backgroundColor: Colors.red.shade400,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: size.width * 0.06,
                              ),
                              SizedBox(width: size.width * 0.02),
                              Text(
                                'Entrar no Jogo',
                                style: TextStyle(
                                  fontSize: size.width * 0.045,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: size.height * 0.02),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomInputField extends StatefulWidget {
  final String hintText;
  final bool enabled;
  final Function(String)? onNameChanged;
  final Function(String)? onImageSelected;

  const CustomInputField({
    super.key,
    required this.hintText,
    this.onNameChanged,
    this.onImageSelected,
    required this.enabled,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField>
    with SingleTickerProviderStateMixin {
  File? _selectedImage;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
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
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow:
                  _isFocused
                      ? [
                        BoxShadow(
                          color: const Color(0xFF69D1E9).withValues(alpha: 0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ]
                      : [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
            ),
            child: Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  _isFocused = hasFocus;
                });
                if (hasFocus) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
              },
              child: TextField(
                enabled: widget.enabled,
                onChanged: widget.onNameChanged,
                style: TextStyle(
                  fontSize: size.width * 0.04,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: size.width * 0.04,
                  ),
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(
                      'assets/images/user.png',
                      scale: 2,
                      color:
                          _isFocused
                              ? const Color(0xFF69D1E9)
                              : Colors.grey.shade400,
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: widget.enabled ? _pickImage : null,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            _selectedImage != null
                                ? Colors.transparent
                                : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                          _selectedImage == null
                              ? Icon(
                                Icons.add_a_photo_outlined,
                                color: Colors.grey.shade600,
                                size: 24,
                              )
                              : ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _selectedImage!,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color(0xFF69D1E9),
                      width: 2,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
