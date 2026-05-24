// lib/screens/room_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/room_provider.dart';
import '../models/room_model.dart';
import '../theme/app_theme.dart';
import '../widgets/room_card.dart';

class RoomDetailScreen extends StatefulWidget {
  final String roomId;
  const RoomDetailScreen({super.key, required this.roomId});

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final roomProv = context.watch<RoomProvider>();
    final room = roomProv.getRoomById(widget.roomId);

    if (room == null) {
      return const Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(child: Text('Ruangan tidak ditemukan', style: TextStyle(color: AppColors.textPrimary))),
      );
    }

    final cfg = getStatusConfig(room.status);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Background glow
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [cfg.color.withOpacity(0.1), Colors.transparent],
                ),
              ),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 12, 20, 0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            'Detail Ruangan',
                            style: GoogleFonts.spaceGrotesk(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Room hero card
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppColors.bgCard,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: cfg.color.withOpacity(0.35)),
                                boxShadow: [
                                  BoxShadow(
                                    color: cfg.color.withOpacity(0.1),
                                    blurRadius: 24,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'RUANGAN',
                                            style: GoogleFonts.spaceGrotesk(
                                              color: AppColors.textMuted,
                                              fontSize: 11,
                                              letterSpacing: 1.5,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            room.id,
                                            style: GoogleFonts.spaceGrotesk(
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 48,
                                              height: 1.1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: cfg.bgColor,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Icon(cfg.icon, color: cfg.color, size: 32),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                                    decoration: BoxDecoration(
                                      color: cfg.bgColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: cfg.color.withOpacity(0.3)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 7,
                                          height: 7,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: cfg.color,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          room.statusLabel,
                                          style: GoogleFonts.spaceGrotesk(
                                            color: cfg.color,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Schedule info
                            if (room.schedule != null) ...[
                              _InfoSection(
                                title: 'Informasi Jadwal',
                                children: [
                                  _InfoRow(
                                    icon: Icons.person_rounded,
                                    label: 'Dosen',
                                    value: room.schedule!.lecturer.name,
                                    valueColor: AppColors.primary,
                                  ),
                                  _InfoRow(
                                    icon: Icons.badge_rounded,
                                    label: 'Kode',
                                    value: room.schedule!.lecturer.code,
                                  ),
                                  _InfoRow(
                                    icon: Icons.book_rounded,
                                    label: 'Mata Kuliah',
                                    value: room.schedule!.subject,
                                  ),
                                  _InfoRow(
                                    icon: Icons.access_time_rounded,
                                    label: 'Waktu',
                                    value: '${room.schedule!.timeStart} – ${room.schedule!.timeEnd} WIB',
                                  ),
                                  _InfoRow(
                                    icon: Icons.stairs_rounded,
                                    label: 'Lantai',
                                    value: 'Lantai ${room.floor}',
                                  ),
                                ],
                              ),
                            ] else
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.bgCard,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(Icons.event_busy_rounded, color: AppColors.textMuted, size: 36),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Tidak ada jadwal',
                                      style: GoogleFonts.spaceGrotesk(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Ruangan ini kosong pada slot waktu ini',
                                      style: GoogleFonts.spaceGrotesk(
                                        color: AppColors.textMuted,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // Last updated
                            if (room.lastUpdated != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.bgCard,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.history_rounded, color: AppColors.textMuted, size: 16),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Diperbarui oleh ${room.confirmedBy ?? "Relator"}',
                                      style: GoogleFonts.spaceGrotesk(
                                        color: AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Action buttons (Relator only)
          if (auth.isRelator && room.schedule != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        label: 'Dosen Masuk',
                        icon: Icons.check_circle_outline_rounded,
                        color: AppColors.statusGreen,
                        isActive: room.status == RoomStatus.dosenMasuk,
                        onTap: () => roomProv.updateRoomStatus(
                          room.id, RoomStatus.dosenMasuk, 'Relator Kelas'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionButton(
                        label: 'Tidak Masuk',
                        icon: Icons.cancel_outlined,
                        color: AppColors.statusRed,
                        isActive: room.status == RoomStatus.dosenTidakMasuk,
                        onTap: () => roomProv.updateRoomStatus(
                          room.id, RoomStatus.dosenTidakMasuk, 'Relator Kelas'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Toast
          _DetailToast(),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Text(
              title,
              style: GoogleFonts.spaceGrotesk(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const Divider(color: AppColors.border, height: 1),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textMuted, size: 16),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.spaceGrotesk(
                color: valueColor ?? AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(isActive ? 1 : 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? Colors.black : color, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                color: isActive ? Colors.black : color,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailToast extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rooms = context.watch<RoomProvider>();
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
      bottom: rooms.showToast ? 120 : -80,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.statusGreen.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: AppColors.statusGreen, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                rooms.toastMessage,
                style: GoogleFonts.spaceGrotesk(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
