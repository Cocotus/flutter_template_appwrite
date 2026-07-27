import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_template_appwrite/config/app_config.dart';

/// A "Buy Me a Coffee" donate button shown in the sidebar footer when
/// [AppConfig.hasPremium] is `false` and [AppConfig.buyMeCoffeeUsername]
/// is non-empty.
///
/// Tapping it opens `https://www.buymeacoffee.com/<username>` in the
/// system browser.
class DonateButton extends StatelessWidget {
  /// Creates a [DonateButton].
  const DonateButton({super.key, required this.isExpanded});

  /// Whether the sidebar is in expanded (label + icon) or collapsed
  /// (icon-only with tooltip) mode.
  final bool isExpanded;

  static const String _baseUrl = 'https://www.buymeacoffee.com/';

  Future<void> _openDonationPage(BuildContext context) async {
    final Uri uri = Uri.parse('$_baseUrl${AppConfig.buyMeCoffeeUsername}');
    final bool canOpen = await canLaunchUrl(uri);
    if (canOpen) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }

    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(content: Text('Unable to open the donation page.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The coffee-cup icon colour: BMC brand yellow (#FFDD00), slightly
    // desaturated so it reads well on the dark sidebar background.
    const Color coffeeYellow = Color(0xFFFFD600);
    final TextStyle labelStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: coffeeYellow,
          fontWeight: FontWeight.w500,
        ) ??
        const TextStyle(
          color: Color(0xFFFFD600),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        );

    final List<Widget> rowChildren = <Widget>[
      const Icon(Icons.coffee, color: coffeeYellow, size: 20),
    ];
    if (isExpanded) {
      rowChildren.add(const SizedBox(width: 12));
      rowChildren.add(
        Expanded(
          child: Text(
            'Buy Me a Coffee',
            overflow: TextOverflow.ellipsis,
            style: labelStyle,
          ),
        ),
      );
    }

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
          child: Row(
            mainAxisAlignment: isExpanded
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: rowChildren,
          ),
        ),
      ),
    );

    if (!isExpanded) {
      return Tooltip(
        message: 'Buy Me a Coffee',
        child: button,
      );
    }
    return button;
  }
}
