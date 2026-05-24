// lib/providers/app_provider.dart

import 'package:flutter/material.dart';
import '../models/room_model.dart';

enum UserRole { relator, mahasiswa }

class AppProvider extends ChangeNotifier {
  UserRole? _currentRole;
  List<RoomModel> _rooms = [];

  UserRole? get currentRole => _currentRole;
  List<RoomModel> get rooms => _rooms;

  List<RoomModel> get floor6Rooms =>
      _rooms.where((r) => r.floor == 6).toList();
  List<RoomModel> get floor7Rooms =>
      _rooms.where((r) => r.floor == 7).toList();

  int get activeCount =>
      _rooms.where((r) => r.status == RoomStatus.dosenMasuk).length;
  int get waitingCount =>
      _rooms.where((r) => r.status == RoomStatus.menunggu).length;
  int get emptyCount =>
      _rooms.where((r) => r.status == RoomStatus.kosong || r.status == RoomStatus.dosenTidakMasuk).length;

  AppProvider() {
    _initRooms();
  }

  void _initRooms() {
    // Data dosen
    final dosenA = LecturerModel(id: 'a', name: 'Dosen A', code: 'DSN-A');
    final dosenB = LecturerModel(id: 'b', name: 'Dosen B', code: 'DSN-B');
    final dosenC = LecturerModel(id: 'c', name: 'Dosen C', code: 'DSN-C');
    final dosenD = LecturerModel(id: 'd', name: 'Dosen D', code: 'DSN-D');

    _rooms = [
      // Lantai 6 — 4 ruangan
      RoomModel(
        id: '601',
        roomNumber: '601',
        floor: 6,
        status: RoomStatus.menunggu,
        schedule: ScheduleModel(
          lecturer: dosenA,
          courseName: 'Pemrograman Mobile',
          startTime: '08:00',
          endTime: '09:40',
        ),
      ),
      RoomModel(
        id: '602',
        roomNumber: '602',
        floor: 6,
        status: RoomStatus.dosenMasuk,
        schedule: ScheduleModel(
          lecturer: dosenB,
          courseName: 'Basis Data',
          startTime: '10:00',
          endTime: '11:40',
        ),
      ),
      RoomModel(
        id: '603',
        roomNumber: '603',
        floor: 6,
        status: RoomStatus.kosong,
        schedule: null,
      ),
      RoomModel(
        id: '604',
        roomNumber: '604',
        floor: 6,
        status: RoomStatus.dosenTidakMasuk,
        schedule: ScheduleModel(
          lecturer: dosenC,
          courseName: 'Jaringan Komputer',
          startTime: '13:00',
          endTime: '14:40',
        ),
      ),

      // Lantai 7 — 8 ruangan
      RoomModel(
        id: '701',
        roomNumber: '701',
        floor: 7,
        status: RoomStatus.menunggu,
        schedule: ScheduleModel(
          lecturer: dosenD,
          courseName: 'Kecerdasan Buatan',
          startTime: '08:00',
          endTime: '09:40',
        ),
      ),
      RoomModel(
        id: '702',
        roomNumber: '702',
        floor: 7,
        status: RoomStatus.dosenMasuk,
        schedule: ScheduleModel(
          lecturer: dosenA,
          courseName: 'Algoritma & Pemrograman',
          startTime: '10:00',
          endTime: '11:40',
        ),
      ),
      RoomModel(
        id: '703',
        roomNumber: '703',
        floor: 7,
        status: RoomStatus.kosong,
        schedule: null,
      ),
      RoomModel(
        id: '704',
        roomNumber: '704',
        floor: 7,
        status: RoomStatus.menunggu,
        schedule: ScheduleModel(
          lecturer: dosenB,
          courseName: 'Sistem Operasi',
          startTime: '13:00',
          endTime: '14:40',
        ),
      ),
      RoomModel(
        id: '705',
        roomNumber: '705',
        floor: 7,
        status: RoomStatus.kosong,
        schedule: null,
      ),
      RoomModel(
        id: '706',
        roomNumber: '706',
        floor: 7,
        status: RoomStatus.dosenMasuk,
        schedule: ScheduleModel(
          lecturer: dosenC,
          courseName: 'Rekayasa Perangkat Lunak',
          startTime: '08:00',
          endTime: '09:40',
        ),
      ),
      RoomModel(
        id: '707',
        roomNumber: '707',
        floor: 7,
        status: RoomStatus.dosenTidakMasuk,
        schedule: ScheduleModel(
          lecturer: dosenD,
          courseName: 'Matematika Diskrit',
          startTime: '10:00',
          endTime: '11:40',
        ),
      ),
      RoomModel(
        id: '708',
        roomNumber: '708',
        floor: 7,
        status: RoomStatus.kosong,
        schedule: null,
      ),
    ];
  }

  void setRole(UserRole role) {
    _currentRole = role;
    notifyListeners();
  }

  void updateRoomStatus(String roomId, RoomStatus newStatus) {
    final index = _rooms.indexWhere((r) => r.id == roomId);
    if (index != -1) {
      _rooms[index] = _rooms[index].copyWith(status: newStatus);
      notifyListeners();
    }
  }

  void logout() {
    _currentRole = null;
    notifyListeners();
  }
}
