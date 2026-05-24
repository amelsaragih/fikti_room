// lib/providers/room_provider.dart
import 'package:flutter/foundation.dart';
import '../models/room_model.dart';

const List<Lecturer> _lecturers = [
  Lecturer(name: 'Dosen A', code: 'DSN-A'),
  Lecturer(name: 'Dosen B', code: 'DSN-B'),
  Lecturer(name: 'Dosen C', code: 'DSN-C'),
  Lecturer(name: 'Dosen D', code: 'DSN-D'),
];

const List<String> _subjects = [
  'Pemrograman Mobile',
  'Basis Data',
  'Struktur Data',
  'Jaringan Komputer',
  'Kecerdasan Buatan',
  'Pemrograman Web',
];

List<Room> _buildInitialRooms() {
  return [
    // Lantai 6
    Room(
      id: '601', floor: 6, status: RoomStatus.menunggu,
      schedule: Schedule(lecturer: _lecturers[0], subject: 'Pemrograman Mobile', timeStart: '08:00', timeEnd: '09:40'),
    ),
    Room(
      id: '602', floor: 6, status: RoomStatus.kosong,
      schedule: null,
    ),
    Room(
      id: '603', floor: 6, status: RoomStatus.menunggu,
      schedule: Schedule(lecturer: _lecturers[2], subject: 'Struktur Data', timeStart: '10:00', timeEnd: '11:40'),
    ),
    Room(
      id: '604', floor: 6, status: RoomStatus.dosenMasuk,
      schedule: Schedule(lecturer: _lecturers[1], subject: 'Basis Data', timeStart: '08:00', timeEnd: '09:40'),
    ),

    // Lantai 7
    Room(
      id: '701', floor: 7, status: RoomStatus.dosenMasuk,
      schedule: Schedule(lecturer: _lecturers[3], subject: 'Jaringan Komputer', timeStart: '07:30', timeEnd: '09:10'),
    ),
    Room(
      id: '702', floor: 7, status: RoomStatus.menunggu,
      schedule: Schedule(lecturer: _lecturers[0], subject: 'Kecerdasan Buatan', timeStart: '10:00', timeEnd: '11:40'),
    ),
    Room(
      id: '703', floor: 7, status: RoomStatus.kosong,
      schedule: null,
    ),
    Room(
      id: '704', floor: 7, status: RoomStatus.dosenTidakMasuk,
      schedule: Schedule(lecturer: _lecturers[2], subject: 'Pemrograman Web', timeStart: '08:00', timeEnd: '09:40'),
    ),
    Room(
      id: '705', floor: 7, status: RoomStatus.menunggu,
      schedule: Schedule(lecturer: _lecturers[1], subject: 'Basis Data', timeStart: '13:00', timeEnd: '14:40'),
    ),
    Room(
      id: '706', floor: 7, status: RoomStatus.kosong,
      schedule: null,
    ),
    Room(
      id: '707', floor: 7, status: RoomStatus.dosenMasuk,
      schedule: Schedule(lecturer: _lecturers[3], subject: 'Struktur Data', timeStart: '09:50', timeEnd: '11:30'),
    ),
    Room(
      id: '708', floor: 7, status: RoomStatus.kosong,
      schedule: null,
    ),
  ];
}

class RoomProvider extends ChangeNotifier {
  List<Room> _rooms = _buildInitialRooms();
  String _toastMessage = '';
  bool _showToast = false;
  int _activeFloor = 6;

  List<Room> get rooms => _rooms;
  List<Room> get floor6Rooms => _rooms.where((r) => r.floor == 6).toList();
  List<Room> get floor7Rooms => _rooms.where((r) => r.floor == 7).toList();
  List<Room> get activeFloorRooms => _activeFloor == 6 ? floor6Rooms : floor7Rooms;
  int get activeFloor => _activeFloor;
  String get toastMessage => _toastMessage;
  bool get showToast => _showToast;

  int get countActive => _rooms.where((r) => r.status == RoomStatus.dosenMasuk).length;
  int get countWaiting => _rooms.where((r) => r.status == RoomStatus.menunggu).length;
  int get countEmpty => _rooms.where((r) => r.status == RoomStatus.kosong).length;
  int get countAbsent => _rooms.where((r) => r.status == RoomStatus.dosenTidakMasuk).length;

  Room? getRoomById(String id) {
    try {
      return _rooms.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  void setActiveFloor(int floor) {
    _activeFloor = floor;
    notifyListeners();
  }

  void updateRoomStatus(String roomId, RoomStatus newStatus, String confirmedBy) {
    final index = _rooms.indexWhere((r) => r.id == roomId);
    if (index != -1) {
      _rooms[index] = Room(
        id: _rooms[index].id,
        floor: _rooms[index].floor,
        status: newStatus,
        schedule: _rooms[index].schedule,
        lastUpdated: DateTime.now(),
        confirmedBy: confirmedBy,
      );

      final statusLabel = _rooms[index].statusLabel;
      _showToastMessage('Status Ruangan ${_rooms[index].id} diperbarui: $statusLabel');
      notifyListeners();
    }
  }

  void _showToastMessage(String message) {
    _toastMessage = message;
    _showToast = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 3), () {
      _showToast = false;
      notifyListeners();
    });
  }
}
