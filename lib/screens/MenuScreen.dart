import 'package:flutter/material.dart';
import 'CampaignDetailsPage.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 20).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Üst Kısım: Logo
            _buildTopSection(),
            const SizedBox(height: 8),
            // Uygulama Adı
            _buildAppName(),
            const SizedBox(height: 24),
            // Kampanya Listesi
            _buildCampaignGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      width: MediaQuery.of(context).size.width, // Ekran genişliği kadar genişlik
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animation.value),
                child: child,
              );
            },
            child: Image.asset(
              'assets/kus.png',
              fit: BoxFit.cover, // Görseli ekran genişliğine sığacak şekilde ayarla
              width: MediaQuery.of(context).size.width, // Ekran genişliği kadar genişlik
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAppName() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Text(
        "SES VER",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xff61BE7B),
        ),
      ),
    );
  }

  Widget _buildCampaignGrid() {
    return GridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true, // GridView'un içeriğe göre boyutlanmasını sağlar
      children: _buildCampaignCards(),
    );
  }

  List<Widget> _buildCampaignCards() {
    return [
      _buildCampaignCard("Eğitim Kampanyası", "Okula Gitmeyen Çocuk Kalmasın!", "assets/eğitim.jpg", "eğitim"),
      _buildCampaignCard("Sağlık Kampanyası", "Ücretsiz Eğitim Materyalleri Sağlansın!", "assets/sağlık.jpg", "sağlık"),
      _buildCampaignCard("Kadın Hakları Kampanyası", "Kadın Hakları İçin Mücadele Ediyoruz!", "assets/kadin_haklari.jpg", "kadın"),
      _buildCampaignCard("Çocuk Hakları Kampanyası", "Çocukların Geleceği İçin Adım Atıyoruz!", "assets/çocuk_haklari.jpg", "çocuk"),
      _buildCampaignCard("Hayvan Hakları Kampanyası", "Hayvanların Hakları İçin Mücadele Ediyoruz!", "assets/hayvan_hakları.jpg", "hayvan"),
      _buildCampaignCard("İnsan Hakları Kampanyası", "Herkes İçin Eşit Haklar!", "assets/insanhaklari.jpg", "insan"),
    ];
  }

  Widget _buildCampaignCard(String title, String detail, String imagePath, String type) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CampaignDetailsPage(
              title: title,
              type: type,
            ),
          ),
        );
      },
      child: Container(
  height: 250, // Sabit yükseklik
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 6,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: ListView(
    padding: EdgeInsets.zero, // Padding'i sıfırla
    children: [
      // Resim Kısmı
      ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Image.asset(
          imagePath,
          height: 120, // Resmin yüksekliği sabit
          width: double.infinity, // Container genişliği kadar
          fit: BoxFit.cover, // Resmi container'a sığdır
        ),
      ),
      Text(title,style: TextStyle(color: Color(0xff61BE7B)),)
    ],
  ),
)
    );
  }
}
