// lib/models/room_model.dart

enum RoomStatus { dosenMasuk, menunggu, dosenTidakMasuk, kosong }

class Lecturer {
  final String name;
  final String code;

  const Lecturer({required this.name, required this.code});
}

class Schedule {
  final Lecturer lecturer;
  final String subject;
  final String timeStart;
  final String timeEnd;

  const Schedule({
    required this.lecturer,
    required this.subject,
    required this.timeStart,
    required this.timeEnd,
  });
}

class Room {
  final String id;
  final int floor;
  RoomStatus status;
  final Schedule? schedule;
  DateTime? lastUpdated;
  String? confirmedBy;

  Room({
    required this.id,
    required this.floor,
    this.status = RoomStatus.kosong,
    this.schedule,
    this.lastUpdated,
    this.confirmedBy,
  });

  String get statusLabel {
    switch (status) {
      case RoomStatus.dosenMasuk:
        return 'Dosen Masuk';
      case RoomStatus.menunggu:
        return 'Menunggu';
      case RoomStatus.dosenTidakMasuk:
        return 'Tidak Masuk';
      case RoomStatus.kosong:
        return 'Kosong';
    }
  }

  Room copyWith({
    RoomStatus? status,
    DateTime? lastUpdated,
    String? confirmedBy,
  }) {
    return Room(
      id: id,
      floor: floor,
      status: status ?? this.status,
      schedule: schedule,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      confirmedBy: confirmedBy ?? this.confirmedBy,
    );
  }
}
