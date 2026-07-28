import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_template_appwrite/config/app_config.dart';

/// A "Buy Me a Coffee" donate button shown in the sidebar footer when
/// [AppConfig.hasPremium] is `false` and [AppConfig.buyMeCoffeeUsername]
/// is non-empty.
///
/// Renders BMC's own brand assets instead of a hand-drawn approximation:
/// - Expanded: `assets/images/bmc-button.svg`, the official full badge
///   (cup + wordmark + its own filled, rounded-corner yellow background).
///   That background is deliberate on BMC's part — the dark wordmark is
///   only ever designed to sit on that yellow, not on arbitrary app
///   backgrounds, so the badge always carries its own backdrop rather than
///   trying to blend into this sidebar's dark navy.
/// - Collapsed: `assets/images/bmc-logo.svg`, BMC's standalone cup mark
///   (no wordmark, no background) — a real dedicated icon asset, not a
///   crop of the button badge. Sat on a subtle app-drawn light chip (not
///   part of the asset) so its near-black outline stays visible against
///   the sidebar's dark navy.
///
/// Neither SVG is edited, only scaled via layout, so the shipped artwork
/// always matches what BMC provides.
///
/// Tapping it opens `https://www.buymeacoffee.com/<username>` in the
/// system browser.
class DonateButton extends StatelessWidget {
  /// Creates a [DonateButton].
  const DonateButton({super.key, required this.isExpanded});

  /// Whether the sidebar is in expanded (full badge) or collapsed
  /// (cup-mark icon with tooltip) mode.
  final bool isExpanded;

  static const String _baseUrl = 'https://www.buymeacoffee.com/';

  static const String _buttonAsset = 'assets/images/bmc-button.svg';
  static const String _logoAsset = 'assets/images/bmc-logo.svg';

  // bmc-button.svg's viewBox aspect ratio (width / height).
  static const double _buttonAspectRatio = 545 / 153;

  // bmc-logo.svg's viewBox aspect ratio (width / height).
  static const double _logoAspectRatio = 884 / 1279;

  static const double _expandedBadgeHeight = 28;
  static const double _collapsedIconHeight = 20;
  static const double _collapsedBadgeSize = 32;

  Future<void> _openDonationPage(BuildContext context) async {
    final Uri uri = Uri.parse('$_baseUrl${AppConfig.buyMeCoffeeUsername}');
    final bool canOpen = await canLaunchUrl(uri);
    if (canOpen) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }

    if (!context.mounted) {
      return;
    }
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(content: Text('Unable to open the donation page.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget content =
        isExpanded ? _buildExpandedBadge() : _buildCollapsedIcon();

    final Widget button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await _openDonationPage(context);
        },
        borderRadius: BorderRadius.circular(10),
        hoverColor: Colors.white.withValues(alpha: 0.06),
        child: Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: isExpanded ? 12 : 0),
          alignment: isExpanded ? Alignment.centerLeft : Alignment.center,
          child: content,
        ),
      ),
    );

    if (!isExpanded) {
      return Tooltip(message: 'Buy Me a Coffee', child: button);
    }
    return button;
  }

  // The full official badge (icon + wordmark + its own yellow background).
  //
  // Wrapped in a left-aligned `FittedBox` so the sidebar's 200ms expand
  // animation — which grows the sidebar's width before this row necessarily
  // has room for the badge's natural width — shrinks the badge instead of
  // overflowing during those in-between frames; at the animation's rest
  // state the available width already fits the badge, so nothing visibly
  // scales down.
  Widget _buildExpandedBadge() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: SvgPicture.asset(
        _buttonAsset,
        height: _expandedBadgeHeight,
        width: _expandedBadgeHeight * _buttonAspectRatio,
      ),
    );
  }

  // BMC's standalone cup mark — a dedicated icon asset, not a crop of the
  // button badge. The mark's outline and steam wisps are near-black, which
  // all but disappears directly on this sidebar's dark navy, so a subtle
  // light chip sits behind it purely to lift that dark linework into view;
  // the artwork itself stays untouched.
  Widget _buildCollapsedIcon() {
    return Container(
      width: _collapsedBadgeSize,
      height: _collapsedBadgeSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SvgPicture.asset(
        _logoAsset,
        height: _collapsedIconHeight,
        width: _collapsedIconHeight * _logoAspectRatio,
      ),
    );
  }
}
