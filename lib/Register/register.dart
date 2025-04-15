import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Daftar extends StatefulWidget {
  @override
  _DaftarState createState() => _DaftarState();
}

class _DaftarState extends State<Daftar> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedDate;
  bool _isObscure = true;
  bool _isConfirmObscure = true;
  bool _isPrivacyChecked = false;

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        // Format tanggal menjadi dd-MM-yyyy
        _dateController.text =
            "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
      });
    }
  }

  void _register() {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red, 
          content: Text(
            'Password dan konfirmasi tidak cocok!',
            style: TextStyle(color: Colors.white), 
          ),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(_emailController.text)) {
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

    if (!_isPrivacyChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Harap setujui Kebijakan Privasi!',
            style: GoogleFonts.montserrat(),
          ),
        ),
      );
      return;
    }

    if (_nameController.text.isEmpty ||
        _selectedGender == null ||
        _selectedDate == null ||
        _addressController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap lengkapi semua data!')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(         
      SnackBar(
        backgroundColor: Color(0xFF3D8D7A),
        content: Text(
          'Pendaftaran berhasil!',
          style: TextStyle(color: Colors.white), 
        ),
        duration: Duration(seconds: 3),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, '/menu');
    });

    print("Nama: ${_nameController.text}");
    print("Jenis Kelamin: $_selectedGender");
    print("Tanggal Lahir: $_selectedDate");
    print("Alamat: ${_addressController.text}");
    print("Nomor Telepon: ${_phoneController.text}");
    print("Email: ${_emailController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0, top: 12.0),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back, size: 28.0),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/maskot_with_circle.png', height: 150),
                      const SizedBox(height: 20),
                      Text(
                        'Buat Akun\nWasteWarriors!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3D8D7A),
                          ),
                        )
                      ),
                      const SizedBox(height: 22),
                      _buildTextField(controller: _nameController, hint: "Nama Lengkap"),
                      const SizedBox(height: 12),
                      _buildDropdownField(
                        hint: "Jenis Kelamin",
                        value: _selectedGender,
                        items: ["Laki-laki", "Perempuan"],
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildDateField(),
                      const SizedBox(height: 12),
                      _buildTextField(controller: _addressController, hint: "Alamat Lengkap"),
                      const SizedBox(height: 12),
                      _buildTextField(controller: _phoneController, hint: "Nomor Telepon"),
                      const SizedBox(height: 12),
                      _buildTextField(controller: _emailController, hint: "Email"),
                      const SizedBox(height: 12),
                      _buildPasswordField(
                        controller: _passwordController,
                        hint: "Password",
                        isObscure: _isObscure,
                        toggleObscure: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildPasswordField(
                        controller: _confirmPasswordController,
                        hint: "Konfirmasi Password",
                        isObscure: _isConfirmObscure,
                        toggleObscure: () {
                          setState(() {
                            _isConfirmObscure = !_isConfirmObscure;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Color(0xFF3D8D7A),
                            ),
                            child: Checkbox(
                              value: _isPrivacyChecked,
                              activeColor: Color(0xFF3D8D7A),
                              onChanged: (value) {
                                setState(() {
                                  _isPrivacyChecked = value!;
                                });
                              },
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text("Kebijakan Privasi",
                                style: GoogleFonts.montserrat(
                                  color: Color(0xFF2DCC70),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500
                                ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 80),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF3D8D7A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _register,
                          child: Text(
                            'Daftar',
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w600, 
                              color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint}) {
    return TextField(
      controller: controller,
      style: GoogleFonts.montserrat(),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.montserrat(color: Color(0xFFA1A4B2), fontSize: 14, fontWeight: FontWeight.w500),
        filled: true,
        fillColor: Color(0xFFF2F3F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required List<String> items,
    String? value,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Color(0xFFF2F3F7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: value,
        hint: Text(hint,
         style: GoogleFonts.montserrat(
          fontSize: 14,
          color: Color(0xFFA1A4B2),
          fontWeight: FontWeight.w500,
         )),
        underline: Container(),
        onChanged: onChanged,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.montserrat()))).toList(),
      ),
    );
  }

  Widget _buildDateField() {
    return TextField(
      controller: _dateController,
      readOnly: true,
      onTap: _pickDate,
      decoration: InputDecoration(
        hintText: "Tanggal Lahir",
        filled: true,
        fillColor: const Color(0xFFF2F3F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool isObscure,
    required Function toggleObscure,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.montserrat(color: Color(0xFFA1A4B2), fontWeight: FontWeight.w500, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF2F3F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () => toggleObscure(),
        ),
      ),
    );
  }
}
