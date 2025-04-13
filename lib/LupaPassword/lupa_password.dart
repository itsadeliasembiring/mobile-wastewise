import 'package:flutter/material.dart';

class LupaPassword extends StatefulWidget {
  @override
  _LupaPasswordState createState() => _LupaPasswordState();
}

class _LupaPasswordState extends State<LupaPassword> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  void _resetPassword() {
    String email = _emailController.text;

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red, 
          content: Text(
            'Email harus diisi!',
            style: TextStyle(color: Colors.white), 
          ),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    
    // Validasi format email
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red, 
          content: Text(
            'Format email tidak valid!',
            style: TextStyle(color: Colors.white), 
          ),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green, 
          content: Text(
            'Link reset password telah dikirim ke email Anda!',
            style: TextStyle(color: Colors.white), 
          ),
          duration: Duration(seconds: 3),
        ),
      );
    });
  }

  void _backToLogin() {
    Navigator.pushReplacementNamed(context, '/form-login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
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
                    const Text(
                      'Lupa Password?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3D8D7A),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    
                    // Deskripsi
                    const Text(
                      'Masukkan alamat email yang terdaftar untuk mendapatkan link reset password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFA1A4B2),
                      ),
                    ),
                    const SizedBox(height: 30.0),

                    // Input Email
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      autofillHints: [AutofillHints.email],
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: const TextStyle(color: Color(0xFFA1A4B2)),
                        filled: true,
                        fillColor: const Color(0xFFF2F3F7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),

                    // Tombol Reset Password
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
                        onPressed: _isLoading ? null : _resetPassword,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Kirim Link Reset',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    // Kembali ke Halaman Login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Ingat password?',
                          style: TextStyle(color: Color(0xFFA1A4B2)),
                        ),
                        TextButton(
                          onPressed: _backToLogin,
                          child: const Text(
                            'Kembali ke Login',
                            style: TextStyle(color: Color(0xFF2DCC70)),
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