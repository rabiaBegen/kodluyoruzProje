import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'BagisEkrani .dart';

class DetailPage extends StatefulWidget {
  final String detail;
  final String detailType;
  

  const DetailPage({super.key, required this.detail, required this.detailType});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  

  @override
  Widget build(BuildContext context) {
    var id = widget.detailType;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff61BE7B),
        title: const Text("Kampanya Detayı", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('campaigns')
              .doc(widget.detailType) // Veritabanındaki id'ye göre kampanya çek
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
  return const Center(child: Text('Kampanya bulunamadı'));
}

var campaignData = snapshot.data!.data() as Map<String, dynamic>? ?? {}; // Null durumuna karşı boş bir harita döndürüyoruz



            // Kampanya türüne göre işlem yap
            if (campaignData['type'] == 'bagis') {
              return _buildBagisPage(campaignData); // Bağış sayfası
            } else if (campaignData['type'] == 'imza') {
              return _buildImzaPage(campaignData, widget.detailType); // İmza sayfası
            } else {
              return Center(child: Text('Geçersiz kampanya türü'));
            }
          },
        ),
      ),
    );
  }

  // Bağış kampanyası sayfası
  Widget _buildBagisPage(Map<String, dynamic> campaignData) {
    return ListView(
      children: [
        _buildHeader(campaignData['kampanyaAdi'] ?? 'Kampanya Adı Bulunamadı'),
        const SizedBox(height: 20),
        _buildCampaignDetails(campaignData),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Bağış yapma sayfasına yönlendirme
            _navigateToDonationPage(context, campaignData);
          },
          child: Text('Bağış Yap',style: TextStyle(fontSize: 25,color:Color(0xff61BE7B) ),),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // İmza kampanyası sayfası
  Widget _buildImzaPage(Map<String, dynamic> campaignData, String campaignId) {
    return ListView(
      children: [
        _buildHeader(campaignData['kampanyaAdi']),
        const SizedBox(height: 20),
        _buildCampaignDetails(campaignData),
        const SizedBox(height: 20),
        _buildSignatureCount(campaignId), // İmza sayısını göster
       FloatingActionButton(
  onPressed: () => _signCampaign(context, campaignId), 
  backgroundColor: Color(0xff61BE7B),
  child: const Icon(Icons.edit, color: Colors.white),
)

      ],
    );
  }

  Widget _buildHeader(String detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          detail,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xff61BE7B),
          ),
        ),
        const SizedBox(height: 10),
        Divider(
          color: Color(0xff61BE7B),
          thickness: 1,
        ),
      ],
    );
  }

  Widget _buildCampaignDetails(Map<String, dynamic> campaignData) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildTextContent(
        "Kampanya Adı: ${campaignData['kampanyaAdi'] ?? 'Kampanya Adı Bulunamadı'}", // Burada fallback (yedek) metni kullanıyoruz
        campaignData['kampanyaAmaci'] ?? "Açıklama bulunamadı", // Null değerler için fallback
        Icons.star,
      ),
      const SizedBox(height: 20),
      _buildTextContent(
        "Kategori: ${campaignData['kategori'] ?? 'Kategori bilgisi bulunamadı'}", // Null için fallback
        campaignData['kategori'] ?? "Kategori bilgisi bulunamadı", // Null için fallback
        Icons.category,
      ),
      const SizedBox(height: 20),
      if (campaignData['kampanyaDetaylari'] != null)
        _buildTextContent(
          "Detaylar:",
          campaignData['kampanyaDetaylari'] ?? "Detaylar bulunamadı", // Null için fallback
          Icons.info,
        ),
    ],
  );
}

  Widget _buildTextContent(String title, String description, IconData icon) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: Color(0xff61BE7B)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff61BE7B)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // İmza sayısını gösteren widget
  Widget _buildSignatureCount(String campaignId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('signatures')
          .where('campaignId', isEqualTo: campaignId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        int signatureCount = snapshot.data?.docs.length ?? 0;
        return Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Toplam İmza Sayısı: $signatureCount",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff61BE7B),
              ),
            ),
          ),
        );
      },
    );
  }

  // Bağış sayfasına yönlendirme
  void _navigateToDonationPage(BuildContext context, Map<String, dynamic> campaignData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BagisEkrani(),
      ),
    );
  }
  // İmza atma işlemi
Future<void> _signCampaign(BuildContext context, String campaignId) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('İmza atmak için giriş yapmalısınız')),
    );
    return;
  }

  final userId = user.uid;

  // Kullanıcının daha önce imza atıp atmadığını kontrol et
  final signatureQuery = await FirebaseFirestore.instance
      .collection('signatures')
      .where('campaignId', isEqualTo: campaignId)
      .where('userId', isEqualTo: userId)
      .get();

  if (signatureQuery.docs.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Zaten bu kampanyaya imza attınız')),
    );
    return;
  }

  // Yeni imza ekle
  await FirebaseFirestore.instance.collection('signatures').add({
    'campaignId': campaignId,
    'userId': userId,
    'timestamp': FieldValue.serverTimestamp(),
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('İmzanız başarıyla eklendi')),
  );
}
}
