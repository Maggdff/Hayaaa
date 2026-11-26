import 'dart:io';

import 'package:http/http.dart' as http;

class SupabaseHelper {
  static const String supabaseUrl =
      'https://hmnzovknjzzuyudpyrnu.supabase.co';

  // Supply the public publishable key at build time. Never place a service_role key
  // in a mobile application: APK contents can be extracted by anyone.
  static const String supabaseKey =
      String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

  static const String bucketName = 'images';

  static void _ensureConfigured() {
    if (supabaseKey.isEmpty) {
      throw StateError(
        'Supabase is not configured. Set the SUPABASE_PUBLISHABLE_KEY build secret.',
      );
    }
  }

  static Future<String> uploadImage(File imageFile) async {
    _ensureConfigured();

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final path = '$bucketName/$fileName';
    final uri = Uri.parse('$supabaseUrl/storage/v1/object/$path');

    final response = await http.post(
      uri,
      headers: {
        'apikey': supabaseKey,
        'Content-Type': 'image/jpeg',
        'x-upsert': 'false',
      },
      body: await imageFile.readAsBytes(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return '$supabaseUrl/storage/v1/object/public/$path';
    }

    throw HttpException(
      'Supabase image upload failed (${response.statusCode}): ${response.body}',
      uri: uri,
    );
  }

  /// Deletes an image using its public URL.
  /// This operation requires a Storage policy that permits the caller to delete
  /// only objects they are authorized to manage.
  static Future<void> deleteImage(String imageUrl) async {
    _ensureConfigured();

    const marker = '/storage/v1/object/public/';
    final uri = Uri.tryParse(imageUrl);
    if (uri == null ||
        uri.host != Uri.parse(supabaseUrl).host ||
        !uri.path.contains(marker)) {
      return;
    }

    final path = uri.path.split(marker).last;
    if (path.isEmpty || !path.startsWith('$bucketName/')) return;

    final deleteUri =
        Uri.parse('$supabaseUrl/storage/v1/object/$path');

    final response = await http.delete(
      deleteUri,
      headers: {
        'apikey': supabaseKey,
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw HttpException(
        'Supabase image deletion failed (${response.statusCode}): ${response.body}',
        uri: deleteUri,
      );
    }
  }
}
