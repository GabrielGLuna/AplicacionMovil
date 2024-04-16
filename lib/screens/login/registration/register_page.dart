import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:multigeo/screens/dispositivos.dart';
import 'package:multigeo/screens/login/login/login_page.dart';
import 'package:multigeo/services/push_notification.dart';
import 'package:multigeo/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:multigeo/provider/dispositivo.dart';
import 'package:intl/intl.dart';
import 'package:multigeo/provider/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multigeo/utils/showsnackbar.dart';
import 'package:multigeo/widgets/upload_image.dart';

class RegisterPage extends StatefulWidget { 

  const RegisterPage({Key? key}) : super(key: key); // Modifica el constructor

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  final TextEditingController _usernameControler = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthControler = TextEditingController();

  bool _isObscure = true;
  bool _isLoading = false;
  File? image;

  static String? token;

  @override
  void initState(){
    super.initState();
    token = PushNotificationService.token;
  }

  @override
  void dispose() {
    super.dispose();
    _usernameControler.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _birthControler.dispose();
  }

  //Registrar Usuario
  void submitRegister() async{
    final registerProvider = Provider.of<RegisterProvider>(context, listen: false);
    if(_registerFormKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      //verificar si el nombre de usuario ya existe
      final bool existUserName = await registerProvider.checkUserExist(_usernameControler.text);
      if(existUserName){
        setState(() {
          _isLoading = false;
        });
        showSnackbar(context,"El usuario ya existe");
        return;
      }

      //verificar si  el email ya existe
      final bool existEmail = await registerProvider.checkEmailExist(_emailController.text);
      if(existEmail){
        setState(() {
          _isLoading = false;
        });
        showSnackbar(context,"El usuario ya existe");
        return;
      }

      final now = DateTime.now();
      String formatedDate = DateFormat('dd/MM/yyyy').format(now);
      //obtener la fecha de nacimiento
      final birth = _birthControler.text;
      //calcular la edad
      DateTime dateBirth = DateFormat('dd/MM/yyyy').parse(birth);
      int age = now.year - dateBirth.year;
      if(now.month < dateBirth.month || 
          (now.month == dateBirth.month && now.day <dateBirth.day)){
        age--;
      }

      //registrar usuario
      try{
        await registerProvider.registroUser(
          username: _usernameControler.text, 
          email: _emailController.text, 
          password: _passwordController.text, 
          rol: "user", 
          birth: _birthControler.text, 
          age: age.toString(), 
          token: token!, 
          createAt: formatedDate, 
          image: image, 
          onError: (error){
            showSnackbar(context, error);
          }
        );
        //enviar correo de verificacion
        await FirebaseAuth.instance.currentUser!.sendEmailVerification();
        showSnackbar(context, "Confirme en su correo electronico");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => DispositivosScreen()),
          (Route<dynamic> route) => false,
        );
        setState(() {
          _isLoading = false;
        });
      }on FirebaseAuthException catch(e){
        showSnackbar(context, e.toString());
      }catch(e){
        showSnackbar(context, e.toString());
      }

    } else{
      setState(() {
        _isLoading = false;
      });
    }

  }

  // seleccionar una imagen
  void selectedImage() async {
    image = await pickImageUser(context);
    setState(() {});
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese una contraseña válida';
    }
    // Puedes agregar otras condiciones de validación aquí, como longitud mínima, caracteres especiales, etc.
    return null; // No hay errores
  }

  String? dateValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese una fecha de nacimiento válida';
    }

    // Ejemplo de validación de fecha futura

    // Si pasa todas las validaciones, retornar null indicando que no hay errores
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg-reg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        child: Center(
                     
              child: SingleChildScrollView(
                   child: Column(
                    children: [
                      
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Form(
                              key: _registerFormKey,
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(height: 20),
                                  InkWell(
                                    onTap: (){
                                      selectedImage();
                                    },
                                    child: 
                                    CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Colors.white,
                                      child: image != null
                                          ? CircleAvatar(
                                        radius: 60,
                                        backgroundImage: FileImage(image!),
                                      ): Container(
                                        child: const Icon(Icons.camera_alt_outlined, color: AppTheme.color1,),
                                      ),
                                    )),
                                  const SizedBox(height: 20),
                  
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "Nombre de Usuario", 
                                      labelText: "Ingrese su username",
                                      border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  
                                ),
                                      suffixIcon: IconButton(onPressed: () {
                                        // Lógica para borrar el contenido del campo de correo
                                        _usernameControler.clear();
                                      }, icon: const Icon(Icons.cancel, color: Colors.grey),
                                      ),
                                    ),            
                                    controller: _usernameControler ,
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, ingrese un usuario válido';
                                      }
                                      return null; // No hay errores
                                    },
                                  ),
                  
                                  const SizedBox(height: 20),
                  
                                  TextFormField(
                                    decoration: InputDecoration(
                                      hintText: "user@example.com", 
                                      labelText: "Ingrese su email",
                                      border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  
                                ),
                                      suffixIcon: IconButton(onPressed: () {
                                        // Lógica para borrar el contenido del campo de correo
                                        _emailController.clear();
                                      }, icon: const Icon(Icons.cancel, color: Colors.grey),
                                      ),
                                    ),            
                                    controller: _emailController ,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, ingrese un correo válido';
                                      }
                                      if (!value.contains('@')) {
                                        return 'Ingrese una dirección de correo válida';
                                      }
                                      return null; // No hay errores
                                    },
                                  ),
                  
                                  const SizedBox(height: 20),
                  
                                  TextFormField(
                                    decoration: InputDecoration(
                                        hintText: "******",
                                        labelText: "Ingrese su contraseña",
                                        border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  
                                ),
                                        suffixIcon: IconButton(
                                            icon:  Icon(
                                              _isObscure
                                                  ? Icons.visibility_off_outlined
                                                  : Icons.visibility_outlined,
                                            ),
                                            onPressed: (){
                                              setState(() {
                                                _isObscure = !_isObscure;
                                              });
                                            }
                                        )),
                                    controller: _passwordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: _isObscure,
                                    validator: _passwordValidator,
                                  ),
                                  const SizedBox( height: 30),
                  
                                  getBirth(context),
                  
                                  const SizedBox( height: 30),
                  
                                  _isLoading
                                      ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blueAccent
                                    ),
                                  )
                                      : ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(AppTheme.color3)
                                    ),
                                    onPressed: () => submitRegister(),
                                    child: const Text('Registrarse', style: TextStyle(color: Colors.white),),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("¿Ya tienes cuenta?"),
                                      TextButton(
                                          onPressed: (){
                                             Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                                          }, 
                                          child: const Text("Inicia Sesion", style: TextStyle(color: Colors.white),))
                                    ],
                                  )
                                ],
                              )
                          )
                        ),
                      ),
                    ],
                  ),
                ),
            ),
      ),
      
          
      );
  }

  Widget getBirth(BuildContext context){
    return TextFormField(
      decoration:  InputDecoration(
          hintText: "dd/mm/yyy",
          labelText: "Ingrese su fecha de nacimiento",
          suffixIcon: const Icon(Icons.calendar_today_outlined),
          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              
                            ),
      ),
      controller: _birthControler,
      validator: dateValidator,
      readOnly: true,
      onTap:() async {
        DateTime? pickedData = await showDatePicker(
          context: context, 
          initialDate: DateTime.now(),
          firstDate: DateTime(1900), 
          lastDate: DateTime.now(),
          builder:(context, child) {
            return Theme(
                data: ThemeData(
                    colorScheme: const ColorScheme.light().copyWith(
                        primary: Colors.black,
                        onPrimary: Colors.white,
                        surface: Colors.grey,
                        onSurface: Colors.black12
                    ),
                    dialogBackgroundColor: Colors.indigo,
                    
                    textButtonTheme: TextButtonThemeData(
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(Colors.black38)
                        )
                    )
                ),                 
                child: child!);
          },
        );
        if (pickedData != null){
          String formattedData = '${pickedData.day}/${pickedData.month}/${pickedData.year}';
          setState(() {
            _birthControler.text = formattedData;
          });
        }
      },
    );

  }
}
