import 'dart:convert';
import 'dart:math';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:ecomerce_app_web/global_variable.dart';
import 'package:ecomerce_app_web/models/banner.dart';
import 'package:ecomerce_app_web/services/manage_http_response.dart';
import 'package:http/http.dart' as http;

class BannerController {
  uploadBanner({required dynamic pickedImage, required context}) async {
    try {
      final cloudinary = CloudinaryPublic("deotwffdz", "mcjdyao7");
      CloudinaryResponse imageResponses = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(pickedImage,
            identifier: 'pickedImage', folder: 'banners'),
      );
      String image = imageResponses.secureUrl;

      BannerModel bannerModel = BannerModel(id: '', image: image);

      http.Response response = await http.post(
        Uri.parse("$uri/api/banner"),
        body: bannerModel.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );
      manageHttpRespond(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Banner Uploaded');
          });
    } catch (e) {
      print(e);
    }
  }
  //fetch banners

  Future<List<BannerModel>> loadBanners() async {
    try {
      //send http get request to fetch banners
      http.Response response = await http.get(
        Uri.parse('$uri/api/banner'),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );
      print(response.body);
      if (response.statusCode == 200) //ok
      {
        List<dynamic> data = jsonDecode(response.body);

        List<BannerModel> banners =
            data.map((banner) => BannerModel.fromJson(banner)).toList();
        return banners;
      } else {
        //throw an exception if the server responded with an error status code
        throw Exception('Error loading Banners $e');
      }
    } catch (e) {
      throw Exception('Error loading Banners $e');
    }
  }
}
