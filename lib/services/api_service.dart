import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

class ApiService {
  static const String baseUrl = 'http://realstateapi.runasp.net';
  static const String apiKey = '6001a3da-d018-4c56-8745-31beafa5b096';

static final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    responseType: ResponseType.json, // Add this line
    validateStatus: (status) => true,
));

  static Future<Map<String, dynamic>> addCompound({
    required String compoundName,
    required String compoundLocation,
    required String imagePath,
  }) async {
    try {
      // Create form data
      final formData = FormData.fromMap({
        'Compound_Name': compoundName,
        'Compoubd_Location': compoundLocation,
        'file': await _getMultipartFile(imagePath),
      });

      // Make the API call
      final response = await _dio.post(
        '/api/$apiKey/AdminDashBoard/AddCompoud',
        data: formData,
      );

      // Handle response
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Compound added successfully',
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}',
          'data': response.data,
        };
      }
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      return {
        'success': false,
        'message': _getErrorMessage(e),
        'error': e.toString(),
      };
    } catch (e) {
      print('General error: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred',
        'error': e.toString(),
      };
    }
  }

  static Future<MultipartFile> _getMultipartFile(String imagePath) async {
    if (kIsWeb) {
      // Handle web file
      String base64Image = imagePath.split(',').last;
      List<int> imageBytes = base64Decode(base64Image);
      return MultipartFile.fromBytes(
        imageBytes,
        filename: 'compound_image.jpg',
        contentType: MediaType('image', 'jpeg'),
      );
    } else {
      // Handle mobile/desktop file
      return await MultipartFile.fromFile(
        imagePath,
        filename: 'compound_image.jpg',
        contentType: MediaType('image', 'jpeg'),
      );
    }
  }

  static String _getErrorMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Send timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout. Please try again.';
      case DioExceptionType.badResponse:
        return 'Server error (${e.response?.statusCode}). Please try again.';
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      default:
        return 'Network error occurred. Please check your connection and try again.';
    }
  }
   static Future<Map<String, dynamic>> updatePlaceImage({
    required String placeId,
    required String imagePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'place_id': placeId,
        'file': await _getMultipartFile(imagePath),
      });

      final response = await _dio.post(
        '/api/$apiKey/AdminDashBoard/UpdatePlaceImage',
        data: formData,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Image updated successfully',
          'imageUrl': response.data['imageUrl'],
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to update image',
        };
      }
    } catch (e) {
      print('Error updating image: $e');
      return {
        'success': false,
        'message': 'An error occurred while updating the image',
      };
    }
  }
static Future<Map<String, dynamic>> getAllPlaces() async {
  try {
    final response = await _dio.get('/api/Compound/GetAllPrimaryData');



    if (response.statusCode == 200) {
      // If the response is a string, parse it
      List<dynamic> placesData;
      if (response.data is String) {
        placesData = jsonDecode(response.data);
      } else {
        placesData = response.data;
      }


      return {
        'success': true,
        'message': 'Places fetched successfully',
        'data': placesData,
      };
    } else {
      return {
        'success': false,
        'message': 'Server error: ${response.statusCode}',
        'data': [],
      };
    }
  } catch (e) {
    print('Error in getAllPlaces: $e');
    return {
      'success': false,
      'message': 'An unexpected error occurred',
      'error': e.toString(),
      'data': [],
    };
  }
}static Future<Map<String, dynamic>> getCompoundUnits(String compoundId) async {
  try {

    
    print('Fetching compound units for ID: $compoundId');

    final response = await _dio.get(
      '/api/Compound/GetOne/$compoundId',
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');

    if (response.statusCode == 200) {
      final data = response.data;
      return {
        'success': true,
        'message': 'Units fetched successfully',
        'data': {
          'compound_name': data['compound_Name'],
          'units': data['units'] ?? [],
          'unit_types': data['unitTypes'] ?? [],
        },
      };
    } else {
      return {
        'success': false,
        'message': 'Failed to fetch units: ${response.statusCode}',
        'data': null,
      };
    }
  } on DioException catch (e) {
    print('Dio error fetching compound units: $e');
    return {
      'success': false,
      'message': _getErrorMessage(e),
      'data': null,
    };
  } catch (e) {
    print('Error fetching compound units: $e');
    return {
      'success': false,
      'message': 'An error occurred while fetching units',
      'data': null,
    };
  }
}

static Future<Map<String, dynamic>> addVilla({
  required String compoundId,
  required Map<String, dynamic> villaData,
}) async {
  try {
    final requestBody = {
      "unitName": villaData['unitName'],
      "unitMainFeature": villaData['unitMainFeature'],
      "typeName": villaData['typeName'],
      "overviews": villaData['overviews'],
      "room": villaData['room'],
      "price": villaData['price']
    };

    print('Sending request with body: ${jsonEncode(requestBody)}');

    final response = await _dio.post(
      '/api/$apiKey/AdminDashBoard/AddUnitForCompund/$compoundId',
      data: requestBody,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    print('Response status: ${response.statusCode}');
    print('Response data: ${response.data}');

    if (response.statusCode == 200) {
      // Get the latest unit data
      final getUnitResponse = await _dio.get(
        '/api/Compound/GetOne/$compoundId',
      );

      if (getUnitResponse.statusCode == 200 && 
          getUnitResponse.data['units'] != null &&
          getUnitResponse.data['units'].isNotEmpty) {
        // Get the last added unit
        final lastUnit = getUnitResponse.data['units'].last;
        return {
          'success': true,
          'message': 'Villa added successfully',
          'data': lastUnit,
        };
      }

      return {
        'success': true,
        'message': 'Villa added successfully',
        'data': response.data,
      };
    } else {
      return {
        'success': false,
        'message': 'Failed to add villa: ${response.data}',
        'data': response.data,
      };
    }
  } catch (e) {
    print('Error adding villa: $e');
    return {
      'success': false,
      'message': 'An unexpected error occurred',
      'error': e.toString(),
    };
  }
}

static Future<Map<String, dynamic>> uploadUnitImages({
  required String unitId,
  required List<String> imagePaths,
}) async {
  try {
    print('Starting image upload for unit ID: $unitId');
    print('Number of images to upload: ${imagePaths.length}');

    List<Map<String, dynamic>> results = [];
    
    for (String imagePath in imagePaths) {
      print('Uploading image: $imagePath');
      
      final formData = FormData.fromMap({
        'file': await _getMultipartFile(imagePath),
      });

      print('Sending request to: /api/$apiKey/AdminDashBoard/AddPhotoToUnit/$unitId');
      
      final response = await _dio.post(
        '/api/$apiKey/AdminDashBoard/AddPhotoToUnit/$unitId',
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
          followRedirects: false,
          validateStatus: (status) => true,
        ),
      );

      print('Image upload response status: ${response.statusCode}');
      print('Image upload response data: ${response.data}');

      results.add({
        'success': response.statusCode == 200,
        'path': imagePath,
        'response': response.data,
      });
    }

    bool allSuccessful = results.every((result) => result['success']);
    
    print('All uploads completed. Success: $allSuccessful');
    print('Upload results: $results');

    return {
      'success': allSuccessful,
      'message': allSuccessful ? 'All images uploaded successfully' : 'Some images failed to upload',
      'results': results,
    };
  } catch (e) {
    print('Error uploading images: $e');
    return {
      'success': false,
      'message': 'Failed to upload images: ${e.toString()}',
      'error': e.toString(),
    };
  }
}
}