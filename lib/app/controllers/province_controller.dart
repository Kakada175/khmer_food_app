import 'package:get/get.dart';
import '../data/models/province_model.dart';
import '../data/models/food_model.dart';
import '../data/repositories/food_repository.dart';

class ProvinceController extends GetxController {
  final FoodRepository foodRepository;
  ProvinceController(this.foodRepository);

  final RxList<ProvinceModel> provinces = <ProvinceModel>[].obs;
  final Rxn<ProvinceModel> selectedProvince = Rxn<ProvinceModel>();
  final RxList<FoodModel> provinceFoods = <FoodModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    provinces.value = foodRepository.getProvinces();
    if (provinces.isNotEmpty) {
      selectProvince(provinces.first);
    }
  }

  void selectProvince(ProvinceModel province) {
    selectedProvince.value = province;
    provinceFoods.value = foodRepository.searchFoods(provinceId: province.id);
  }

  void selectProvinceById(String provinceId) {
    final found = provinces.firstWhereOrNull((p) => p.id == provinceId);
    if (found != null) {
      selectProvince(found);
    }
  }
}
