// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/room_provider.dart';
import '../models/room_model.dart';
import '../theme/app_theme.dart';
import '../widgets/room_card.dart';
import 'room_detail_screen.dart';
import 'role_selection_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final rooms = context.watch<RoomProvider>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryDim,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                        ),
                        child: const Icon(Icons.domain_rounded, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FIKTI Room',
                              style: GoogleFonts.spaceGrotesk(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w800,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              auth.roleLabel,
                              style: GoogleFonts.spaceGrotesk(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout_rounded, color: AppColors.textSecondary, size: 20),
                        onPressed: () {
                          auth.logout();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Stats row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _StatChip(label: 'Aktif', count: rooms.countActive, color: AppColors.statusGreen),
                      const SizedBox(width: 10),
                      _StatChip(label: 'Menunggu', count: rooms.countWaiting, color: AppColors.statusYellow),
                      const SizedBox(width: 10),
                      _StatChip(label: 'Tidak Masuk', count: rooms.countAbsent, color: AppColors.statusRed),
                      const SizedBox(width: 10),
                      _StatChip(label: 'Kosong', count: rooms.countEmpty, color: AppColors.statusGrey),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Floor tabs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        _FloorTab(label: 'Lantai 6', floor: 6, activeFloor: rooms.activeFloor,
                          onTap: () => rooms.setActiveFloor(6)),
                        const SizedBox(width: 4),
                        _FloorTab(label: 'Lantai 7', floor: 7, activeFloor: rooms.activeFloor,
                          onTap: () => rooms.setActiveFloor(7)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // Floor subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        'Lantai ${rooms.activeFloor}',
                        style: GoogleFonts.spaceGrotesk(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryDim,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${rooms.activeFloorRooms.length} Ruangan',
                          style: GoogleFonts.spaceGrotesk(
                            color: AppColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Room grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.82,
                      ),
                      itemCount: rooms.activeFloorRooms.length,
                      itemBuilder: (context, index) {
                        final room = rooms.activeFloorRooms[index];
                        return AnimatedBuilder(
                          animation: _animController,
                          builder: (_, child) {
                            final delay = index * 0.1;
                            final start = delay.clamp(0.0, 0.8);
                            final end = (delay + 0.4).clamp(0.0, 1.0);
                            final curve = CurvedAnimation(
                              parent: _animController,
                              curve: Interval(start, end, curve: Curves.easeOut),
                            );
                            return Opacity(
                              opacity: curve.value,
                              child: Transform.translate(
                                offset: Offset(0, 20 * (1 - curve.value)),
                                child: child,
                              ),
                            );
                          },
                          child: RoomCard(
                            room: room,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RoomDetailScreen(roomId: room.id),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Toast overlay
          _ToastOverlay(),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatChip({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: GoogleFonts.spaceGrotesk(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                color: color.withOpacity(0.8),
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class _FloorTab extends StatelessWidget {
  final String label;
  final int floor;
  final int activeFloor;
  final VoidCallback onTap;

  const _FloorTab({
    required this.label,
    required this.floor,
    required this.activeFloor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = floor == activeFloor;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              color: isActive ? AppColors.bg : AppColors.textSecondary,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _ToastOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rooms = context.watch<RoomProvider>();
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
      bottom: rooms.showToast ? 32 : -80,
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
