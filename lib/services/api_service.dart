import 'dart:io';

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

    if (response.statusCode == 200) {
      // Parse the response data
      var responseData = response.data;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      return {
        'success': true,
        'message': 'Villa added successfully',
        'data': responseData,
      };
    } else {
      return {
        'success': false,
        'message': 'Failed to add villa: ${response.data}',
        'data': null,
      };
    }
  } catch (e) {
    print('Error adding villa: $e');
    return {
      'success': false,
      'message': 'An unexpected error occurred',
      'error': e.toString(),
      'data': null,
    };
  }
}


static Future<Map<String, dynamic>> uploadUnitImages({
  required String unitId,
  required List<String> imagePaths,
}) async {
  try {
    print('Uploading images for unit ID: $unitId');
    
    List<Map<String, dynamic>> results = [];
    
    for (String imagePath in imagePaths) {
      // Create form data with the correct key 'photos'
      final formData = FormData.fromMap({
        'photos': await _getMultipartFile(imagePath),  // Changed from 'file' to 'photos'
      });

      print('Sending image upload request for unit $unitId');
      
      final response = await _dio.post(
        '/api/$apiKey/AdminDashBoard/AddPhotoToUnit/$unitId',  // Correct endpoint
        data: formData,
        options: Options(
          headers: {
            'accept': '*/*',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      print('Upload response status: ${response.statusCode}');
      print('Upload response data: ${response.data}');

      if (response.statusCode == 200) {
        results.add({
          'success': true,
          'path': response.data?.toString() ?? '',
          'response': response.data,
        });
      } else {
        results.add({
          'success': false,
          'path': imagePath,
          'error': 'Upload failed with status ${response.statusCode}',
        });
      }
    }

    bool allSuccessful = results.every((result) => result['success']);
    
    return {
      'success': allSuccessful,
      'message': allSuccessful ? 'Images uploaded successfully' : 'Some images failed to upload',
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

// Update the _getMultipartFile method to ensure correct content type
static Future<MultipartFile> _getMultipartFile(String imagePath) async {
  try {
    if (kIsWeb) {
      if (imagePath.startsWith('data:image')) {
        String base64Image = imagePath.split(',').last;
        List<int> imageBytes = base64Decode(base64Image);
        return MultipartFile.fromBytes(
          imageBytes,
          filename: 'image_${DateTime.now().millisecondsSinceEpoch}.jpg',
          contentType: MediaType('image', 'jpeg'),
        );
      }
      throw Exception('Invalid image format for web');
    } else {
      File file = File(imagePath);
      String fileName = imagePath.split('/').last;
      return await MultipartFile.fromFile(
        file.path,
        filename: fileName,
        contentType: MediaType('image', 'jpeg'),
      );
    }
  } catch (e) {
    print('Error creating MultipartFile: $e');
    rethrow;
  }
}
}