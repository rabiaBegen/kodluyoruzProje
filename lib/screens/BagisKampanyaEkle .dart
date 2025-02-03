import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore ekleme

class BagisKampanyaEkle extends StatefulWidget {
  @override
  State<BagisKampanyaEkle> createState() => _BagisKampanyaEkleState();
}

class _BagisKampanyaEkleState extends State<BagisKampanyaEkle> {
  final TextEditingController _kampanyaAdiController = TextEditingController();
  final TextEditingController _kampanyaAmaciController = TextEditingController();
  final TextEditingController _kampanyaDetaylariController = TextEditingController();
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _kullaniciAdSoyadController = TextEditingController();

  String _selectedCategory = 'eğitim'; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff61BE7B),
        title: Text(
          'Bağış Kampanyası Ekle',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView( // Kaydırma ekleme
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_kampanyaAdiController, 'Kampanya Adı'),
              SizedBox(height: 16),
              _buildTextField(_kampanyaAmaciController, 'Kampanya Amacı'),
              SizedBox(height: 16),
              _buildTextField(_kampanyaDetaylariController, 'Kampanya Detayları', maxLines: 5),
              SizedBox(height: 16),
              _buildTextField(_ibanController, 'İban'),
              SizedBox(height: 16),
              _buildTextField(_kullaniciAdSoyadController, 'Ad Soyad'),
             SizedBox(height: 12),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff61BE7B), width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
                      });
                    },
                    items: <String>['eğitim', 'sağlık', 'kadın', 'çocuk', 'hayvan', 'insan']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff61BE7B), // Buton rengi
                  ),
                  onPressed: () {
                    _kampanyaEkle(context);
                  },
                  child: Text('Kampanyayı Ekle',style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff61BE7B), width: 2),
        ),
      ),
      maxLines: maxLines,
    );
  }

  void _kampanyaEkle(BuildContext context) async {
    String kampanyaAdi = _kampanyaAdiController.text;
    String kampanyaAmaci = _kampanyaAmaciController.text;
    String kampanyaDetaylari = _kampanyaDetaylariController.text;
    String iban = _ibanController.text;
    String kullaniciAdSoyad = _kullaniciAdSoyadController.text;

    if (kampanyaAdi.isEmpty || kampanyaAmaci.isEmpty || kampanyaDetaylari.isEmpty || iban.isEmpty || kullaniciAdSoyad.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen tüm alanları doldurunuz')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('campaigns').add({
        'kampanyaAdi': kampanyaAdi,
        'kampanyaAmaci': kampanyaAmaci,
        'kampanyaDetaylari': kampanyaDetaylari,
        'iban': iban,
        'kullaniciAdSoyad': kullaniciAdSoyad,
        'kategori': _selectedCategory,  // Kategori burada saklanıyor
        'tarih': FieldValue.serverTimestamp(),
        'type': 'bagis', // Kampanya türü
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kampanya başarıyla eklendi')),
      );

      _kampanyaAdiController.clear();
      _kampanyaAmaciController.clear();
      _kampanyaDetaylariController.clear();
      _ibanController.clear();
      _kullaniciAdSoyadController.clear();
      setState(() {
        _selectedCategory = 'eğitim'; // Varsayılan kategoriye sıfırlama
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: ${e.toString()}')),
      );
    }
  }
}
