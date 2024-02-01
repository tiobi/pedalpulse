import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Utils {
  String timeAgo(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return 'Just Now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} h';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} d';
    } else {
      return formatDate(createdAt);
    }
  }

  String getDateString(DateTime date) {
    // dd/MMM/yyyy
    return "${date.day}/${date.month}/${date.year}";
  }

  String formatDate(DateTime date) {
    // Define the desired date format
    final formatter = DateFormat('dd/MMM/yyyy');

    // Format the DateTime object
    return formatter.format(date);
  }

  String getLikes(int likes) {
    if (likes < 1000) {
      return likes.toString();
    } else if (likes < 1000000) {
      return "${(likes ~/ 1000).toString()}K";
    } else {
      return "${(likes ~/ 1000000).toString()}M";
    }
  }

  Future<XFile> getImageXFileByUrl(String url) async {
    var file = await DefaultCacheManager().getSingleFile(url);
    XFile result = XFile(file.path);
    return result;
  }
}
