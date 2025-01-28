import 'package:bot_toast/bot_toast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkHandler {
  static void shareLink(String url) async {
    try {
      BotToast.showLoading();
      await Share.share(url, subject: "Project Proposal Template");
      BotToast.closeAllLoading();
    } catch (e) {
      BotToast.showText(text: "Error Unable to share the link: $e");
    }
  }
}
