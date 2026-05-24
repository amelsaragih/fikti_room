// lib/widgets/room_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/room_model.dart';
import '../theme/app_theme.dart';

class StatusConfig {
  final Color color;
  final Color bgColor;
  final IconData icon;
  const StatusConfig({required this.color, required this.bgColor, required this.icon});
}

StatusConfig getStatusConfig(RoomStatus status) {
  switch (status) {
    case RoomStatus.dosenMasuk:
      return const StatusConfig(color: AppColors.statusGreen, bgColor: AppColors.statusGreenBg, icon: Icons.check_circle_rounded);
    case RoomStatus.menunggu:
      return const StatusConfig(color: AppColors.statusYellow, bgColor: AppColors.statusYellowBg, icon: Icons.schedule_rounded);
    case RoomStatus.dosenTidakMasuk:
      return const StatusConfig(color: AppColors.statusRed, bgColor: AppColors.statusRedBg, icon: Icons.cancel_rounded);
    case RoomStatus.kosong:
      return const StatusConfig(color: AppColors.statusGrey, bgColor: AppColors.statusGreyBg, icon: Icons.meeting_room_rounded);
  }
}

class RoomCard extends StatelessWidget {
  final Room room;
  final VoidCallback onTap;

  const RoomCard({super.key, required this.room, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cfg = getStatusConfig(room.status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: room.status == RoomStatus.dosenMasuk
                ? cfg.color.withOpacity(0.4)
                : AppColors.border,
            width: 1,
          ),
          boxShadow: room.status == RoomStatus.dosenMasuk
              ? [BoxShadow(color: cfg.color.withOpacity(0.08), blurRadius: 12, spreadRadius: 1)]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top: status bar
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: cfg.color,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        room.id,
                        style: GoogleFonts.spaceGrotesk(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: cfg.bgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(cfg.icon, color: cfg.color, size: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  if (room.schedule != null) ...[
                    Text(
                      room.schedule!.lecturer.name,
                      style: GoogleFonts.spaceGrotesk(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      room.schedule!.subject,
                      style: GoogleFonts.spaceGrotesk(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded, size: 10, color: AppColors.textMuted),
                        const SizedBox(width: 3),
                        Text(
                          '${room.schedule!.timeStart}–${room.schedule!.timeEnd}',
                          style: GoogleFonts.spaceGrotesk(
                            color: AppColors.textMuted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    const SizedBox(height: 4),
                    Text(
                      'Tidak ada\njadwal',
                      style: GoogleFonts.spaceGrotesk(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: cfg.bgColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      room.statusLabel,
                      style: GoogleFonts.spaceGrotesk(
                        color: cfg.color,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
