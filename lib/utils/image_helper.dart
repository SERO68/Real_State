
class ImageHelper {
  static String getImageUrl(String path) {
    if (path.startsWith('http') || path.startsWith('https')) {
      return path;
    }
    
    // Add your base URL here
    const baseUrl = 'http://your-api-base-url.com/';
    return baseUrl + path;
  }

  static bool isValidImageUrl(String url) {
    return url.isNotEmpty && (url.startsWith('http') || url.startsWith('https'));
  }

  static String getPlaceholderImage() {
    return 'images/placeholder.jpg';
  }
}