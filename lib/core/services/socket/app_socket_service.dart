/// Abstraksi koneksi socket generik.
///
/// Kontrak ini sengaja dibuat sesederhana mungkin (connect/send/disconnect +
/// 2 stream) supaya nanti bisa diganti implementasi WebSocket sungguhan
/// (misal pakai package `web_socket_channel`) tanpa mengubah kode
/// datasource/bloc yang memakainya — cukup ganti binding di DI.
library;

/// Status koneksi socket, dipakai UI untuk menampilkan indikator LIVE /
/// connecting / reconnecting.
enum SocketConnectionStatus {
  disconnected,
  connecting,
  connected,
  reconnecting,
}

abstract class AppSocketService {
  /// Status koneksi saat ini.
  SocketConnectionStatus get status;

  /// Stream perubahan status koneksi.
  Stream<SocketConnectionStatus> get connectionStatus;

  /// Stream pesan mentah (sudah didecode jadi Map) dari "server".
  Stream<Map<String, dynamic>> get messages;

  /// Membuka koneksi ke sebuah channel/room, mis. `live-auction:15`.
  Future<void> connect(String channel);

  /// Mengirim payload ke "server".
  void send(Map<String, dynamic> payload);

  /// Menutup koneksi.
  Future<void> disconnect();
}
