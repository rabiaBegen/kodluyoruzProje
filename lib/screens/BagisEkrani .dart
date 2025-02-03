import 'package:flutter/material.dart';

class BagisEkrani extends StatefulWidget {
  @override
  _BagisEkraniState createState() => _BagisEkraniState();
}

class _BagisEkraniState extends State<BagisEkrani> {
  final _formKey = GlobalKey<FormState>(); // Form anahtarı ekleyelim

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff61BE7B),
        title: Text('Bağış Yap',style: TextStyle(color: Colors.white),
      ),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Form anahtarını burada kullanıyoruz
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Kart Sahibinin Adı Soyadı',
                  border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
              ),
              focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff61BE7B), width: 2), // Odaklanınca kenar rengi
            ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen kart sahibinin adını girin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Kart Numarası',
                 border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
              ),
              focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff61BE7B), width: 2), // Odaklanınca kenar rengi
            ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen kart numarasını girin';
                  } else if (value.length != 16) {
                    return 'Kart numarası 16 haneli olmalıdır';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Kart Tarihi (AA/YY)',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff61BE7B), width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen kart tarihini girin';
                        } else if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                          return 'Geçerli bir tarih formatı girin (AA/YY)';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff61BE7B), width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen CVV kodunu girin';
                        } else if (value.length != 3) {
                          return 'CVV kodu 3 haneli olmalıdır';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Bağış Miktarı (TL)',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff61BE7B), width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bağış miktarını girin';
                  } else if (double.tryParse(value) == null) {
                    return 'Geçerli bir miktar girin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff61BE7B),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Bağış işlemini gerçekleştir
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Bağış başarılı!')),
                      );
                    } else {
                      // Formda hata varsa mesaj göster
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lütfen tüm alanları doğru doldurun')),
                      );
                    }
                  },
                  child: Text('Bağış Yap',style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
