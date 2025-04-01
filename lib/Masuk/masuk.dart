import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Masuk extends StatefulWidget {
  @override
  _MasukState createState() => _MasukState();
}

class _MasukState extends State<Masuk> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email dan Password harus diisi!')),
      );
      return;
    }

    // TODO: Implementasi autentikasi login
    print('Email: $email');
    print('Password: $password');

    // Contoh navigasi setelah login berhasil
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _forgotPassword() {
    print('Aksi lupa password');
    // TODO: Navigasi atau logika lupa password
  }

  void _register() {
    print('Navigasi ke halaman daftar');
    // TODO: Navigasi ke halaman registrasi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            // Tombol Kembali
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 10.0),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, size: 29.0),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Gambar Logo
                    Image.asset('assets/maskot_with_circle.png', height: 220),
                    const SizedBox(height: 20),

                    // Judul
                    Text(
                      'Halo,\nWasteWarriors!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3D8D7A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),

                    // Input Email
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      autofillHints: [AutofillHints.email],
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 15,
                          color: Color(0xFFA1A4B2)
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF2F3F7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),

                    // Input Password
                    TextField(
                      controller: _passwordController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: 15,
                          color: Color(0xFFA1A4B2)
                          ),
                        filled: true,
                        fillColor: const Color(0xFFF2F3F7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    // Tombol Masuk
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3D8D7A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: _login,
                        child: Text(
                          'Masuk',
                          style: GoogleFonts.montserrat(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18.0),

                    // Lupa Password
                    TextButton(
                      onPressed: _forgotPassword,
                      child: Text(
                        'Lupa password?',
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFA1A4B2)
                          ),
                      ),
                    ),
                    const SizedBox(height: 60.0),

                    // Daftar Sekarang
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum memiliki akun?',
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            color: Color(0xFFA1A4B2)
                          ),
                        ),
                        TextButton(
                          onPressed: _register,
                          child: Text(
                            'Daftar Sekarang',
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2DCC70)
                            ),
                          ),
                        ),
                      ],
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