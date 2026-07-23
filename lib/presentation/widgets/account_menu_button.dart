import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/providers/auth/auth_provider.dart';
import 'package:coc/presentation/widgets/liquid_glass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Account actions: unlink Clash player and/or sign out of Firebase.
class AccountMenuButton extends ConsumerWidget {
  /// When true, shows "Unlink player" (linked home). Guests only see sign out.
  final bool canUnlinkPlayer;

  const AccountMenuButton({
    super.key,
    this.canUnlinkPlayer = false,
  });

  Future<void> _unlink(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.unlinkPlayerTitle),
        content: Text(l10n.unlinkPlayerMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.unlinkPlayerButton),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    await ref.read(linkedPlayerTagProvider.notifier).clear();
    await ref.read(linkDeferredProvider.notifier).clear();
    if (!context.mounted) return;
    context.go('/link-player');
  }

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.signOutButton),
        content: Text(l10n.signOutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.signOutButton),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    await ref.read(authServiceProvider).signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuButton<_AccountAction>(
      tooltip: l10n.accountMenuTooltip,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onSelected: (action) {
        switch (action) {
          case _AccountAction.unlink:
            _unlink(context, ref);
          case _AccountAction.signOut:
            _signOut(context, ref);
        }
      },
      itemBuilder: (context) => [
        if (canUnlinkPlayer)
          PopupMenuItem(
            value: _AccountAction.unlink,
            child: Text(l10n.unlinkPlayerButton),
          ),
        PopupMenuItem(
          value: _AccountAction.signOut,
          child: Text(l10n.signOutButton),
        ),
      ],
      child: SizedBox(
        width: 36,
        height: 36,
        child: LiquidGlassSurface(
          circular: true,
          tintColor: Colors.white,
          tintStrength: 0.22,
          child: Icon(
            Icons.manage_accounts_rounded,
            size: 18,
            color: colorScheme.onPrimary.withValues(alpha: 0.9),
          ),
        ),
      ),
    );
  }
}

enum _AccountAction { unlink, signOut }
