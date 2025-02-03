import 'package:flutter/material.dart';
class NewCampaignPage extends StatefulWidget {
  @override
  _NewCampaignPageState createState() => _NewCampaignPageState();
}

class _NewCampaignPageState extends State<NewCampaignPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  String _selectedCategory = 'eğitim'; // Varsayılan kategori

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Kampanya Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration:
                    const InputDecoration(labelText: 'Kampanya Başlığı'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Başlık boş olamaz!';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _detailController,
                decoration: const InputDecoration(labelText: 'Kampanya Detayı'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Detay boş olamaz!';
                  }
                  return null;
                },
              ),
              DropdownButton<String>(
                value: _selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: <String>[
                  'eğitim',
                  'sağlık',
                  'kadın',
                  'çocuk',
                  'hayvan',
                  'insan'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Kampanyayı ekleyin ve geri dönün
                    // Burada kampanyayı listeye ekleyebilirsiniz veya başka bir işlem yapabilirsiniz.
                    Navigator.pop(context);
                  }
                },
                child: const Text('Kampanya Ekle'),
              ),
            ],
          ),
        ),
      ),
    );
  }}