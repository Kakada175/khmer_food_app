import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/province_model.dart';
import '../models/food_model.dart';
import '../models/review_model.dart';
import '../models/collection_model.dart';
import '../models/user_model.dart';

class LaravelApiService extends GetxService {
  static const String baseUrl = 'http://localhost:8000/api';

  Future<LaravelApiService> init() async {
    return this;
  }

  // Categories
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories'));
      if (response.statusCode == 200) {
        final List data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((e) => CategoryModel.fromJson(e)).toList();
      }
    } catch (e) {
      Get.printError(info: 'Error fetching categories: $e');
    }
    return [];
  }

  // Provinces
  Future<List<ProvinceModel>> getProvinces() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/provinces'));
      if (response.statusCode == 200) {
        final List data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((e) => ProvinceModel.fromJson(e)).toList();
      }
    } catch (e) {
      Get.printError(info: 'Error fetching provinces: $e');
    }
    return [];
  }

  // Foods / Recipes
  Future<List<FoodModel>> getFoods() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/foods'));
      if (response.statusCode == 200) {
        final List data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((e) => FoodModel.fromJson(e)).toList();
      }
    } catch (e) {
      Get.printError(info: 'Error fetching foods: $e');
    }
    return [];
  }

  Future<FoodModel?> addFood(FoodModel food) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/foods'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(food.toJson()),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return FoodModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      }
    } catch (e) {
      Get.printError(info: 'Error creating recipe: $e');
    }
    return null;
  }

  Future<bool> deleteFood(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/foods/$id'));
      return response.statusCode == 200;
    } catch (e) {
      Get.printError(info: 'Error deleting recipe: $e');
      return false;
    }
  }

  Future<ReviewModel?> addReview(String foodId, ReviewModel review) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/foods/$foodId/reviews'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(review.toJson()),
      );
      if (response.statusCode == 201) {
        return ReviewModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      }
    } catch (e) {
      Get.printError(info: 'Error adding review: $e');
    }
    return null;
  }

  // Auth
  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      }
    } catch (e) {
      Get.printError(info: 'Error logging in: $e');
    }
    return null;
  }

  Future<UserModel?> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      }
    } catch (e) {
      Get.printError(info: 'Error registering: $e');
    }
    return null;
  }

  Future<UserModel?> switchRole(String userId, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/switch-role'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId, 'role': role}),
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      }
    } catch (e) {
      Get.printError(info: 'Error switching role: $e');
    }
    return null;
  }

  Future<UserModel?> toggleFavorite(String userId, String foodId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/toggle-favorite'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId, 'foodId': foodId}),
      );
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      }
    } catch (e) {
      Get.printError(info: 'Error toggling favorite: $e');
    }
    return null;
  }

  // Collections
  Future<List<CollectionModel>> getCollections(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/collections?userId=$userId'));
      if (response.statusCode == 200) {
        final List data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((e) => CollectionModel.fromJson(e)).toList();
      }
    } catch (e) {
      Get.printError(info: 'Error fetching collections: $e');
    }
    return [];
  }

  Future<CollectionModel?> createCollection(CollectionModel collection, String userId) async {
    try {
      final Map<String, dynamic> body = collection.toJson();
      body['userId'] = userId;

      final response = await http.post(
        Uri.parse('$baseUrl/collections'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return CollectionModel.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      }
    } catch (e) {
      Get.printError(info: 'Error creating collection: $e');
    }
    return null;
  }

  // AI Chat
  Future<String> askAIChef(String query, List<Map<String, String>> history) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ai/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'query': query,
          'history': history,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['reply'] ?? '';
      }
    } catch (e) {
      Get.printError(info: 'Error asking AI: $e');
    }
    return 'Sorry, I am having trouble connecting to the AI Culinary Assistant right now.';
  }
}
