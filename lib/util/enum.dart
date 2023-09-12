class SessionKey {
  static const String lang = "Lang";
  static const String user = "user";
  static const String userLocalAuth = "userLocalAuth";
  static const String userByBio = "loginByBio";
}

class Prefkey {
  static const String userId = "UserId";
}

class NotifKey {
  static const String newChat = "NewChat";
  static const String sendChat = "SendChat";
  static const String readChat = "ReadChat";
}

class DirKey {
  static const String collection = "collection";
  static const String inbox = "inbox";
  static const String process = "process";
  static const String upload = "upload";
  static const String images = "images";
}

class FileKey {
  static const String collection = "collection.json";
}

enum HeroSourceMode {
  base64,
  file,
  network,
}
