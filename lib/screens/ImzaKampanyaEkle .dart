import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImzaKampanyaEkle extends StatefulWidget {
  @override
  State<ImzaKampanyaEkle> createState() => _ImzaKampanyaEkleState();
}

class _ImzaKampanyaEkleState extends State<ImzaKampanyaEkle> {
  final TextEditingController _kampanyaAdiController = TextEditingController();
  final TextEditingController _kampanyaAmaciController = TextEditingController();
  final TextEditingController _kampanyaDetaylariController = TextEditingController();

  String _selectedCategory = 'eğitim';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color(0xff61BE7B),
        title: Text(
          'İmza Kampanyası Ekle',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _kampanyaAdiController,
              decoration: InputDecoration(
                labelText: 'Kampanya Adı',
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff61BE7B), width: 2),
                ),
              ),
            ),
            SizedBox(height: 16),
    
            TextFormField(
              controller: _kampanyaAmaciController,
              decoration: InputDecoration(
                labelText: 'Kampanya Amacı',
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff61BE7B), width: 2),
                ),
              ),
            ),
            SizedBox(height: 16),
    
            TextFormField(
              controller: _kampanyaDetaylariController,
              decoration: InputDecoration(
                labelText: 'Kampanya Detayları',
                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff61BE7B), width: 2),
                ),
              ),
              maxLines: 5,
            ),
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
                  backgroundColor: Color(0xff61BE7B),
                ),
                onPressed: () {
                  _kampanyaEkle(context);
                },
                child: Text(
                  'Kampanyayı Ekle',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _kampanyaEkle(BuildContext context) async {
    String kampanyaAdi = _kampanyaAdiController.text;
    String kampanyaAmaci = _kampanyaAmaciController.text;
    String kampanyaDetaylari = _kampanyaDetaylariController.text;

    if (kampanyaAdi.isEmpty || kampanyaAmaci.isEmpty || kampanyaDetaylari.isEmpty) {
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
        'kategori': _selectedCategory,
        'tarih': FieldValue.serverTimestamp(),
        'type': 'imza',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kampanya başarıyla eklendi')),
      );

      _kampanyaAdiController.clear();
      _kampanyaAmaciController.clear();
      _kampanyaDetaylariController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: ${e.toString()}')),
      );
    }
  }
}