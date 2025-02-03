// kampanya seçme sayfası
import 'package:flutter/material.dart';

import 'BagisKampanyaEkle .dart';
import 'ImzaKampanyaEkle .dart';

class CampaignTypeSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar:PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: ClipRRect(
           borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50), // Sol alt köşe oval
              bottomRight: Radius.circular(50), // Sağ alt köşe oval
            ),
          child: AppBar(
            backgroundColor: Color(0xff61BE7B),
            title: Align(
  alignment: Alignment.center,
  child: Text(
    'Kampanya Türü',
    style: TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontWeight: FontWeight.w500,
    ),
    textAlign: TextAlign.center, // Metni ortalamak için
  ),
),

          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context)=>ImzaKampanyaEkle()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff61BE7B),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
                child: Text(
                  'İmza Kampanyası Oluştur',
                  style: TextStyle(fontSize: 18,color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context)=>BagisKampanyaEkle()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff61BE7B),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
                child: Text(
                  'Bağış Kampanyası Oluştur',
                  style: TextStyle(fontSize: 18,color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}