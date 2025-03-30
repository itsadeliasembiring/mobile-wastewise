import 'package:flutter/material.dart';

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
      });
    }
  }

  void _register() {
    if (!_isPrivacyChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap setujui Kebijakan Privasi!')),
      );
      return;
    }

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
              // Tombol Kembali
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0, top: 12.0),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, size: 28.0),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Gambar Maskot
                      Image.asset('assets/maskot_with_circle.png', height: 150),
                      const SizedBox(height: 20),

                      // Judul
                      const Text(
                        'Buat Akun\nWasteWarriors!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3D8D7A),
                        ),
                      ),
                      const SizedBox(height: 22),

                      // Input Nama Lengkap
                      _buildTextField(controller: _nameController, hint: "Nama Lengkap"),
                      const SizedBox(height: 12),

                      // Dropdown Jenis Kelamin
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

                      // Picker Tanggal Lahir
                      _buildDateField(),
                      const SizedBox(height: 12),

                      // Input Alamat
                      _buildTextField(controller: _addressController, hint: "Alamat Lengkap"),
                      const SizedBox(height: 12),

                      // Input Nomor Telepon
                      _buildTextField(controller: _phoneController, hint: "Nomor Telepon"),
                      const SizedBox(height: 12),

                      // Input Email
                      _buildTextField(controller: _emailController, hint: "Email"),
                      const SizedBox(height: 12),

                      // Input Password
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

                      // Input Konfirmasi Password
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

                      // Checkbox Kebijakan Privasi
                      Row(
                        children: [
                          Checkbox(
                            value: _isPrivacyChecked,
                            onChanged: (value) {
                              setState(() {
                                _isPrivacyChecked = value!;
                              });
                            },
                          ),
                          const Text("Saya telah membaca"),
                          TextButton(
                            onPressed: () {},
                            child: const Text("Kebijakan Privasi",
                                style: TextStyle(color: Colors.green)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 80),

                      // Tombol Daftar
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3D8D7A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: _register,
                          child: const Text(
                            'Daftar',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
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
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF2F3F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdownField({required String hint, required List<String> items, String? value, required Function(String?) onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3F7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: value,
        hint: Text(hint),
        underline: Container(),
        onChanged: onChanged,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      ),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: _pickDate,
      child: _buildTextField(
        controller: TextEditingController(text: _selectedDate == null ? "Tanggal Lahir" : _selectedDate.toString().split(' ')[0]),
        hint: "Tanggal Lahir",
      ),
    );
  }

  Widget _buildPasswordField({required TextEditingController controller, required String hint, required bool isObscure, required Function toggleObscure}) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF2F3F7),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        suffixIcon: IconButton(icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility), onPressed: () => toggleObscure()),
      ),
    );
  }
}
