import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../controllers/province_controller.dart';
import '../../controllers/localization_controller.dart';
import '../../data/models/province_model.dart';
import '../home/home_screen.dart';

class ProvinceExplorerScreen extends StatelessWidget {
  const ProvinceExplorerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provCtrl = Get.find<ProvinceController>();
    final locCtrl = Get.find<LocalizationController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('provinces'.tr),
      ),
      body: Column(
        children: [
          // Visual Map Selector Banner
          Obx(() {
            final activeProvince = provCtrl.selectedProvince.value;
            final bannerGradient = activeProvince != null
                ? activeProvince.themeGradient
                : AppColors.emeraldGradient;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: bannerGradient,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🗺️', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 10),
                      Text(
                        activeProvince != null
                            ? '${locCtrl.isKhmer ? activeProvince.nameKhmer : activeProvince.nameEnglish} Food Heritage'
                            : 'Interactive Cambodia Food Map',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    locCtrl.isKhmer
                        ? 'ជ្រើសរើសខេត្ត ដើម្បីស្វែងយល់ពីម្ហូបប្រចាំតំបន់ និងគ្រឿងផ្សំពិសេស'
                        : 'Select any province to explore authentic regional dishes & local ingredients.',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            );
          }),

          // Province Horizontal Picker Chips with Instant Solid Gold Color Swap
          Container(
            height: 58,
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: context.surfaceBg,
            child: Obx(() {
              final selectedId = provCtrl.selectedProvince.value?.id;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: provCtrl.provinces.length,
                itemBuilder: (context, index) {
                  final p = provCtrl.provinces[index];
                  final isSelected = selectedId == p.id;

                  return _ProvinceChip(
                    key: ValueKey('${p.id}_$isSelected'),
                    province: p,
                    isSelected: isSelected,
                    onTap: () {
                      provCtrl.selectProvince(p);
                    },
                  );
                },
              );
            }),
          ),

          // Selected Province Details Header & Food List
          Expanded(
            child: Obx(() {
              final p = provCtrl.selectedProvince.value;
              if (p == null) {
                return const Center(child: Text('Select a province to explore'));
              }

              final activeColor = p.themeColor;

              return ListView(
                key: ValueKey(p.id),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
                children: [
                  // Province Hero Card
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      image: DecorationImage(
                        image: p.imageUrl.startsWith('assets/')
                            ? AssetImage(p.imageUrl) as ImageProvider
                            : NetworkImage(p.imageUrl),
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.35),
                            Colors.black.withValues(alpha: 0.9),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            locCtrl.isKhmer ? p.nameKhmer : p.nameEnglish,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            locCtrl.isKhmer ? p.descriptionKhmer : p.descriptionEnglish,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white70, fontSize: 13.5, height: 1.3),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Local Specialty Badges
                  Text(
                    'Local Specialties & Ingredients',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: activeColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...p.localIngredients.map((ing) => Chip(
                            avatar: Icon(Icons.eco, size: 16, color: activeColor),
                            label: Text(ing, style: TextStyle(fontSize: 12, color: context.textPrimary)),
                            backgroundColor: context.cardBg,
                            side: BorderSide(color: context.borderColor),
                          )),
                      ...p.famousDesserts.map((d) => Chip(
                            avatar: const Icon(Icons.cake, size: 16, color: AppColors.accent),
                            label: Text(d, style: TextStyle(fontSize: 12, color: context.textPrimary)),
                            backgroundColor: context.cardBg,
                            side: BorderSide(color: context.borderColor),
                          )),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Famous Foods from ${p.nameEnglish}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (provCtrl.provinceFoods.isEmpty)
                    Text('No recipe entries found for this province yet.', style: TextStyle(color: context.textSecondary))
                  else
                    ...provCtrl.provinceFoods.map((food) => FoodCardHorizontal(food: food)),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _ProvinceChip extends StatefulWidget {
  final ProvinceModel province;
  final bool isSelected;
  final VoidCallback onTap;

  const _ProvinceChip({
    super.key,
    required this.province,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ProvinceChip> createState() => _ProvinceChipState();
}

class _ProvinceChipState extends State<_ProvinceChip> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final locCtrl = Get.find<LocalizationController>();
    final p = widget.province;
    final isSelected = widget.isSelected;
    const activeColor = AppColors.primary; // Royal Gold (#D4AF37)

    final bgColor = isSelected
        ? activeColor
        : (isHovered ? activeColor.withValues(alpha: 0.18) : context.cardBg);

    final textColor = isSelected
        ? Colors.white
        : (isHovered ? activeColor : context.textPrimary);

    final borderColor = isSelected
        ? activeColor
        : (isHovered ? activeColor : context.borderColor);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: borderColor,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : (isHovered
                    ? [
                        BoxShadow(
                          color: activeColor.withValues(alpha: 0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : []),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected) ...[
                const Icon(Icons.check_circle, size: 16, color: Colors.white),
                const SizedBox(width: 6),
              ],
              Text(
                locCtrl.isKhmer ? p.nameKhmer : p.nameEnglish,
                style: TextStyle(
                  color: textColor,
                  fontWeight: isSelected || isHovered ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
