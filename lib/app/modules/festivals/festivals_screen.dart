import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../controllers/home_controller.dart';
import '../home/home_screen.dart';

class FestivalsScreen extends StatelessWidget {
  const FestivalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeCtrl = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Khmer Festival Food Heritage'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Festival Banners
            _buildFestivalCard(
              '🎏 Khmer New Year (Chaul Chnam Thmey)',
              'Celebrated with Num Ansom Chek, Num Kom, and traditional coconut treats offered at pagodas.',
              'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=800&q=80',
            ),
            const SizedBox(height: 16),
            _buildFestivalCard(
              '🌾 Pchum Ben (Ancestors\' Day)',
              'Sacred 15-day festival featuring sticky rice cakes (Bay Ben) and aromatic curries.',
              'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&w=800&q=80',
            ),
            const SizedBox(height: 16),
            _buildFestivalCard(
              '🚣 Water Festival (Bon Om Touk)',
              'Tonle Sap boat racing celebration famous for Ambok (pounded new rice) with coconut & banana.',
              'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=800&q=80',
            ),

            const SizedBox(height: 24),

            const Text(
              'Traditional Festival Recipes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            const SizedBox(height: 12),

            Obx(
              () => Column(
                children: homeCtrl.festivalFoods.map((f) => FoodCardHorizontal(food: f)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFestivalCard(String title, String desc, String imgUrl) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(imgUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              desc,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
