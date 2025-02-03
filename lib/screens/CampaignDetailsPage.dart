import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CampaignTypeSelectionScreen .dart';
import 'DetailPage.dart';

class CampaignDetailsPage extends StatefulWidget {
  final String title;
  final String type; // "tümü" olabilir veya belirli bir tür (örn: "eğitim", "sağlık")

  const CampaignDetailsPage({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  State<CampaignDetailsPage> createState() => _CampaignDetailsPageState();
}

class _CampaignDetailsPageState extends State<CampaignDetailsPage> {
  late Future<List<Map<String, dynamic>>> campaignList;

  // Firebase'den kampanya verilerini çekme
  Future<List<Map<String, dynamic>>> fetchCampaigns() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('campaigns') // Firebase koleksiyon adı
        .where('kategori', isEqualTo: widget.type) // Kategoriye göre filtreleme
        .get();

    // Veriyi List'e dönüştürme
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    campaignList = fetchCampaigns(); // Sayfa açıldığında kampanyaları çek
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          child: AppBar(
            backgroundColor: const Color(0xff61BE7B),
            title: Center(
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('campaigns')
              .where('kategori', isEqualTo: widget.type) // Type'a göre filtreleme
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No campaigns found'));
            }

            // Verileri listeye dönüştürme
            var campaigns = snapshot.data!.docs.map((doc) {
              return {
  'kampanyaAdi': doc['kampanyaAdi'] ?? 'Kampanya Adı Bulunamadı',
  'kampanyaAmaci': doc['kampanyaAmaci'] ?? 'Açıklama bulunamadı',
  'kategori': doc['kategori'] ?? 'Kategori yok',
};

            }).toList();
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                return _buildDetailCard(
  context,
  doc['kampanyaAdi'] ?? 'Kampanya Adı Bulunamadı',
  doc['kampanyaAmaci'] ?? 'Açıklama bulunamadı',
  doc.id,
  doc['kategori'] ?? 'Kategori yok',
);

              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CampaignTypeSelectionScreen()),
          );
        },
        backgroundColor: const Color(0xff61BE7B),
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }

  Widget _buildDetailCard(
      BuildContext context, String detail, String progress, String detailId, String campaignType) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(detail: detail, detailType: detailId),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              detail,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              progress,
              style: const TextStyle(fontSize: 14, color: Color(0xff61BE7B)),
            ),
            const SizedBox(height: 4),
            Text(
              "Tür: $campaignType",  // Kampanya türünü göster
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
