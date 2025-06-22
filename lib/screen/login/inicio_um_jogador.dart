import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parasitados/database/database.dart';
import 'package:parasitados/database/user_database.dart';
import 'package:parasitados/routes/routes.dart';
import 'package:parasitados/screen/login/balloon_painter.dart';
import 'package:sqflite/sqflite.dart';

class InicioUmJogador extends StatelessWidget {
  const InicioUmJogador({super.key});

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
						onPressed: (){
							Navigator.pop(context);
						}, 
						icon: Icon(
							Icons.arrow_back_outlined,
							color: Colors.white,
						)
					)
				],
			),
            const SizedBox(height: 30),
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

class LoginFormContainer extends StatefulWidget {
  const LoginFormContainer({super.key});

  @override
  State<LoginFormContainer> createState() => _LoginFormContainerState();
}

class _LoginFormContainerState extends State<LoginFormContainer> {
	String nome1 = '';
	String foto1 = '';
	String? nomeFinal;

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
				const SnackBar(content: Text('Por favor, preencha os nomes dos jogadores')),
			);
			return;
		}

		final db = await LoginDatabase().database;

		final userDb = UserDatabase.withData();
		final int id = await userDb.addUser(nome1);
		await UserDatabase.salvarUserLocal(nome1, id);

		await db.insert(
			'login',
			{
				'id': 1, // Sempre sobrescrevendo este registro
				'nome1': nome1,
				'nome2':'fake',
				'foto1': foto1.isNotEmpty ? foto1 : null,
			},
			conflictAlgorithm: ConflictAlgorithm.replace,
		);
  	}
	
	@override
	void initState() {
		super.initState();
		lerDados();
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
				  Row(
					crossAxisAlignment: CrossAxisAlignment.start,
				    children: [
						Image.asset(
							'assets/images/pulgo.png',
							height: 150,
						),
						Expanded(
							child: Align(
								alignment: Alignment.topLeft,
								child: CustomPaint(
									painter: BalloonPainter(),
									
									child: Container(
										padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
										margin: EdgeInsets.only(bottom: 5),
										child: Column(
											crossAxisAlignment: CrossAxisAlignment.start,
										children: [
											const Text(
												'Senti pena de você... então decidi fazer caridade emocional. Não se preocupe, não vou te deixar sozinho, Se livrar de mim não é fácil.',
												style: TextStyle(
													color: Colors.black,
													fontSize: 12,
													fontWeight: FontWeight.w200,
												),
											),
											Row(
												crossAxisAlignment: CrossAxisAlignment.center,
												children: [
													Expanded(child: Text(
													'Atenciosamente:',
													style: TextStyle(
														fontWeight: FontWeight.bold,
														fontSize: 12
													),
												)),
													Expanded(child: Text(
													'Pulgo',
													style: TextStyle(
														fontWeight: FontWeight.w200,
														fontSize: 12
													),
												)),
												],
											)
										],
										),
									),
								),
							),
						)
				    ],
				  ),
				  SizedBox(height: 10,),
                  if (nomeFinal != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Bem-vindo de volta, $nomeFinal!',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),

					CustomInputField(
						hintText: 'Digite o jogador 1 aqui',
						onNameChanged: (v) => setState(() => nome1 = v),
						onImageSelected: (p) => setState(() => foto1 = p),
						enabled: nomeFinal == null,
					),
					const SizedBox(height: 20),
					ElevatedButton(
						onPressed: (nome1.isNotEmpty || nomeFinal != null)
							? () async {
							try {
								await salvarNoBanco();
								if (!context.mounted) return;
								Navigator.pushReplacementNamed(context, Routes.loadingScreenUmJogador);
							} catch (e) {
								if (!context.mounted) return;
								ScaffoldMessenger.of(context).showSnackBar(
									SnackBar(content: Text('Erro ao salvar os dados: $e')),
								);
							}
						}
						: null,
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

class _CustomInputFieldState extends State<CustomInputField> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

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
		enabled: widget.enabled,
      onChanged: widget.onNameChanged,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: Image.asset('assets/images/user.png', scale: 2),
        suffixIcon: IconButton(
          icon: _selectedImage == null
              ? Image.asset('assets/images/add_foto.png', scale: 2)
              : CircleAvatar(
                  backgroundImage: FileImage(_selectedImage!),
                  radius: 16,
                ),
          onPressed: _pickImage,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}