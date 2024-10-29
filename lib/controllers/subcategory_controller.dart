import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:ecomerce_app_web/global_variable.dart';
import 'package:ecomerce_app_web/models/subcategory.dart';
import 'package:ecomerce_app_web/services/manage_http_response.dart';
import 'package:http/http.dart' as http;

class SubcategoryController {
  uploadSubcategory(
      {required String categoryId,
      required String categoryName,
      required dynamic pickedImage,
      required String subCategoryName,
      required context}) async {
    try {
      final cloudinary = CloudinaryPublic("deotwffdz", "mcjdyao7");
      //upload the image
      CloudinaryResponse imageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(pickedImage,
            identifier: 'pickedImage', folder: 'categoryImages'),
      );
      String image = imageResponse.secureUrl;
      Subcategory subcategory = Subcategory(
          id: '',
          categoryId: categoryId,
          categoryName: categoryName,
          image: image,
          subCategoryName: subCategoryName);

      http.Response response = await http.post(
        Uri.parse("$uri/api/subcategories"),
        body: subcategory.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );
      manageHttpRespond(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'SubCategory Uploaded');
          });
    } catch (e) {
      print(e);
    }
  }

  Future<List<Subcategory>> loadSubcategories() async {
    try {
      //send an http get request to load the categories
      http.Response response = await http.get(
        Uri.parse('$uri/api/categories'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<Subcategory> subcategories = data
            .map((subcategory) => Subcategory.fromJson(subcategory))
            .toList();
        return subcategories;
      } else {
        throw Exception('Fail to load Subcategories');
      }
    } catch (e) {
      throw Exception('Error loading SubCategory: $e');
    }
  }
}
