import 'package:coc/config/helpers/errors.dart';
import 'package:coc/config/helpers/player_tag.dart';
import 'package:coc/config/theme/app_fonts.dart';
import 'package:coc/l10n/locale_extensions.dart';
import 'package:coc/presentation/providers/players/player_provider.dart';
import 'package:coc/presentation/widgets/liquid_glass.dart';
import 'package:coc/presentation/widgets/categories_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemberProfileCategories extends ConsumerStatefulWidget {
  final String memberTag;

  const MemberProfileCategories({super.key, required this.memberTag});

  @override
  ConsumerState<MemberProfileCategories> createState() =>
      _MemberProfileCategoriesState();
}

class _MemberProfileCategoriesState extends ConsumerState<MemberProfileCategories> {
  late final String _tag;

  @override
  void initState() {
    super.initState();
    _tag = normalizePlayerTag(widget.memberTag);
    Future.microtask(
      () => ref.read(playerProvider.notifier).loadPlayer(_tag),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final playerAsync = ref.watch(
      playerProvider.select((session) => session.byTag[_tag]),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: _SectionTitle(title: l10n.troopsAndUnits),
        ),
        const SizedBox(height: 14),
        if (playerAsync == null || playerAsync.isLoading)
          const _LoadingCard()
        else if (playerAsync.hasError)
          _ErrorCard(
            message: localizedApiError(playerAsync.error!, l10n),
            onRetry: () =>
                ref.read(playerProvider.notifier).loadPlayer(_tag, force: true),
          )
        else if (playerAsync.hasValue)
          CategoriesList(player: playerAsync.value!),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontFamily: AppFonts.primary,
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            l10n.troopsLoadError,
            style: TextStyle(
              fontFamily: AppFonts.primary,
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.light,
              color: Colors.grey.shade600,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 12),
          GlassButton.compact(
            label: l10n.retry,
            onPressed: onRetry,
            style: GlassButtonStyle.primary,
          ),
        ],
      ),
    );
  }
}
