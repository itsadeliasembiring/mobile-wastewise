import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UbahProfil extends StatefulWidget {
  @override
  _UbahProfil createState() => _UbahProfil();
}

class _UbahProfil extends State<UbahProfil> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  String? _selectedGender;
  DateTime? _selectedDate;

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

  void _saveChanges() {
    // Simulasi simpan data
    print("Nama: ${_nameController.text}");
    print("Jenis Kelamin: $_selectedGender");
    print("Tanggal Lahir: $_selectedDate");
    print("Alamat: ${_addressController.text}");
    print("Email: ${_emailController.text}");
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Perubahan berhasil disimpan!', style: GoogleFonts.montserrat()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubah Profil",
         style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Color(0xFF3D8D7A))),
        centerTitle: true,
        backgroundColor: Colors.white70,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),

              Center(
                child: Column(
                  children: [
                    // Foto Profil
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/adudu_icon.png'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              print("Ubah foto profil diklik!");
                            },
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.green,
                              child: Icon(Icons.camera_alt_outlined, color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Abdul Dudul",
                        style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text("abduldudul20@gmail.com", style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              // Nama
              _buildTextField(controller: _nameController, hint: "Nama"),
              SizedBox(height: 12),

              // Tanggal Lahir
              _buildDateField(),
              SizedBox(height: 12),

              // Jenis Kelamin
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
              SizedBox(height: 12),

              _buildTextField(controller: _addressController, hint: "Alamat Lengkap"),
              SizedBox(height: 12),

              _buildTextField(controller: _emailController, hint: "Email"),
              SizedBox(height: 30),

              // Tombol Simpan Perubahan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3D8D7A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: _saveChanges,
                  child: Text("Simpan Perubahan",
                   style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 16, 
                    fontWeight: FontWeight.w600)),
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
        hintStyle: GoogleFonts.montserrat(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdownField({required String hint, required List<String> items, String? value, required Function(String?) onChanged}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: value,
        hint: Text(hint, style: GoogleFonts.montserrat(fontSize: 14, color: Colors.grey)),
        underline: Container(),
        onChanged: onChanged,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.montserrat()))).toList(),
      ),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: _pickDate,
      child: TextField(
        controller: TextEditingController(
          text: _selectedDate == null ? "Tanggal Lahir" : _selectedDate.toString().split(' ')[0],
        ),
        enabled: false,
        style: GoogleFonts.montserrat(),
        decoration: InputDecoration(
          hintText: "Tanggal Lahir",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),
        ),
      ),
    );
  }

}
