import 'package:flutter/material.dart';

/// Membungkus seluruh app (semua screen, termasuk bottom navigation bar
/// dan route yang di-push seperti AddActivityScreen) di dalam satu frame
/// responsif.
///
/// - width <= [mobileBreakpoint]  -> tampil fullscreen 100% seperti biasa.
/// - width >  [mobileBreakpoint]  -> konten dibatasi ke [maxContentWidth]
///   dan diletakkan di tengah layar dengan bayangan halus, sehingga
///   terlihat seperti aplikasi mobile yang rapi saat dibuka di desktop.
///
/// Dipasang lewat `MaterialApp(builder: ...)` supaya tidak perlu mengubah
/// setiap screen satu-satu — cukup satu tempat untuk mengatur semuanya.
class ResponsiveAppFrame extends StatelessWidget {
  const ResponsiveAppFrame({super.key, required this.child});

  final Widget child;

  /// Di bawah nilai ini dianggap perangkat mobile -> fullscreen natural.
  static const double mobileBreakpoint = 600;

  /// Lebar maksimum "kartu" aplikasi saat ditampilkan di desktop/tablet.
  static const double maxContentWidth = 460;

  /// Jarak vertikal dari tepi layar browser ke frame, biar tidak
  /// menempel penuh dari atas ke bawah.
  static const double verticalMargin = 28;

  static const _frameRadius = 32.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > mobileBreakpoint;

        // Mobile: biarkan apa adanya, fullscreen 100%.
        if (!isDesktop) {
          return child;
        }

        // Desktop/tablet: batasi lebar & tinggi, taruh di tengah.
        final frameHeight =
            (constraints.maxHeight - verticalMargin * 2).clamp(
          0.0,
          double.infinity,
        );

        return Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          color: theme.brightness == Brightness.dark
              ? const Color(0xFF0B0920)
              : const Color(0xFFE7E8F3),
          child: SizedBox(
            width: maxContentWidth,
            height: frameHeight,
            child: DecoratedBox(
              // Shadow diletakkan di container TERPISAH dari ClipRRect,
              // supaya tidak ikut terpotong oleh clip.
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_frameRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.28),
                    blurRadius: 48,
                    spreadRadius: -6,
                    offset: const Offset(0, 22),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_frameRadius),
                child: Container(
                  color: theme.scaffoldBackgroundColor,
                  // MediaQuery di-override supaya widget di dalamnya
                  // (mis. yang pakai MediaQuery.of(context).size di masa
                  // depan) menganggap lebar layarnya = maxContentWidth,
                  // bukan lebar penuh browser.
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      size: Size(maxContentWidth, frameHeight),
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
