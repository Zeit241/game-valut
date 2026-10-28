import 'package:flutter/material.dart';
import 'package:game_shelf/ui/core/database/tables/library_games.dart';
import 'package:game_shelf/ui/core/widgets/snackbars.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lucide_icons_flutter/lucide_icons_200.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../data/models/game.dart';
import '../../../data/repositories/library_repository.dart';
import '../database/app_database.dart';
import '../theme/app_colors.dart';

Map<Status, String> statusOptions = {
  Status.paused: 'On Paused',
  Status.backlog: 'Want to play',
  Status.completed: 'Completed',
  Status.dropped: 'Dropped',
  Status.playing: 'Playing',
};

Map<Status, ({Color color, Color bgColor})> statusStyles = {
  Status.backlog: (
    color: AppColors.getColorFormHex('#B99AFF'),
    bgColor: AppColors.getColorFormHex('#251C3D'),
  ),
  Status.playing: (
    color: AppColors.getColorFormHex('#38BDF8'),
    bgColor: AppColors.getColorFormHex('#142B3A'),
  ),
  Status.completed: (
    color: AppColors.getColorFormHex('#34D399'),
    bgColor: AppColors.getColorFormHex('#143028'),
  ),
  Status.dropped: (
    color: AppColors.getColorFormHex('#9CA3AF'),
    bgColor: AppColors.getColorFormHex('#202532'),
  ),
};

class AddToLibrarySheetViewModel extends ChangeNotifier {
  final LibraryRepository _repository;

  AddToLibrarySheetViewModel(this._repository);

  Map<String, dynamic>? savedGame;

  Future<void> addGameToLibrary(
    Game game,
    Status status,
    String notes,
    int rating,
    int completion,
  ) {
    return _repository.addGame(
      game: game,
      status: status,
      notes: notes,
      rating: rating,
      completion: completion,
    );
  }

  void getGameFromLibrary(int id) async {
    final game = await _repository.getGameById(id);

    if (game == null) return;
    savedGame = {
      'status': game.status,
      'completion': game.completion,
      'rating': game.rating,
      'notes': game.notes,
      'added': game.addedAt,
    };
    notifyListeners();
  }

  Future<void> removeFormLib(int id) {
    return _repository.removeGame(id);
  }
}

class AddToLibrarySheet extends StatelessWidget {
  final Game game;
  Function? callback;

  AddToLibrarySheet({super.key, required this.game, this.callback});

  static Future<void> show(
    BuildContext context,
    Game game, {
    Function? callback,
  }) {

    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) => AddToLibrarySheet(game: game, callback: callback),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          AddToLibrarySheetViewModel(LibraryRepository(AppDatabase()))
            ..getGameFromLibrary(game.id),
      child: _SheetContent(game: game, callback: callback,),
    );
  }
}

class _SheetContent extends StatefulWidget {
  final Game game;
  final Function? callback;

  _SheetContent({required this.game, this.callback});

  @override
  State<_SheetContent> createState() => _SheetContentState();
}

class _SheetContentState extends State<_SheetContent> {
  final TextEditingController _controller = TextEditingController();
  AddToLibrarySheetViewModel? _viewModel;
  bool _appliedSavedGame = false;
  Map<String, dynamic>? savedGame;

  Status status = Status.backlog;
  double completion = 0;
  int rating = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewModel = context.read<AddToLibrarySheetViewModel>();
    if (_viewModel == viewModel) return;
    _viewModel?.removeListener(_applySavedGame);
    _viewModel = viewModel..addListener(_applySavedGame);
    _applySavedGame();
  }

  void _applySavedGame() {
    if (_appliedSavedGame || !mounted) return;
    final saved = _viewModel?.savedGame;

    if (saved == null) return;

    setState(() {
      savedGame = saved;
      status = saved['status'] as Status;
      completion = (saved['completion'] as num).toDouble();
      rating = saved['rating'] as int;
      _controller.text = saved['notes'] as String? ?? '';
    });
  }

  @override
  void dispose() {
    _viewModel?.removeListener(_applySavedGame);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AddToLibrarySheetViewModel>();

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  _viewModel?.savedGame != null
                      ? 'Added to library'
                      : 'Edit backlog entry',
                  style: .new(fontSize: 22),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(LucideIcons200.x),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: .start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 56,
                    height: 56 * (64 / 48),
                    child: Image.network(
                      widget.game.backgroundImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(widget.game.name, style: .new(fontSize: 18)),
                      Text(
                        '${widget.game.parseReleasedYear()}  ·  ${widget.game.developers.firstOrNull?.name}',
                        style: .new(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 72,
                  child: Text(
                    savedGame == null
                        ? 'Not in your library'
                        : 'Added ${DateFormat('MMM dd').format(savedGame?['added'] as DateTime)}',
                    textAlign: TextAlign.end,
                    style: .new(color: AppColors.textSecondary, fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              spacing: 8,
              crossAxisAlignment: .start,
              children: [
                Text(
                  'Status',
                  style: .new(
                    color: AppColors.textSecondary,
                    fontWeight: .w500,
                  ),
                ),
                DropdownButtonFormField<Status>(
                  key: ValueKey(status),
                  initialValue: status,
                  isDense: false,
                  isExpanded: true,
                  decoration: InputDecoration(
                    fillColor: AppColors.backgroundRaised,
                    contentPadding: .symmetric(vertical: 10, horizontal: 12),
                  ),
                  selectedItemBuilder: (context) => [
                    for (final status in statusOptions.keys)
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: StatusPill(status: status),
                      ),
                  ],
                  items: [
                    for (final status in statusOptions.keys)
                      DropdownMenuItem(
                        value: status,
                        child: StatusPill(status: status),
                      ),
                  ],
                  onChanged: (value) => setState(() => status = value!),
                  validator: (value) => value == null ? 'Choose status' : null,
                ),
              ],
            ),

            if (status != Status.backlog)
              Column(
                spacing: 12,
                crossAxisAlignment: .start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        'Completion',
                        style: .new(
                          color: AppColors.textSecondary,
                          fontWeight: .w500,
                        ),
                      ),
                      Text(
                        '${completion.round()}%',
                        style: .new(color: AppColors.accent, fontWeight: .w600),
                      ),
                    ],
                  ),

                  Slider(
                    padding: .zero,
                    value: completion,
                    min: 0,
                    max: 100,
                    onChanged: (value) => setState(() => completion = value),
                  ),
                ],
              ),

            if (status != Status.backlog)
              Column(
                spacing: 12,
                crossAxisAlignment: .start,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        'Your rating',
                        style: .new(
                          color: AppColors.textSecondary,
                          fontWeight: .w500,
                        ),
                      ),
                      Text(
                        'Optional',
                        style: .new(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          fontWeight: .w300,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 32,
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemCount: 5,
                      scrollDirection: .horizontal,
                      itemBuilder: (context, index) {
                        return InkWell(
                          radius: 100,
                          onTap: () {
                            setState(() {
                              rating = index + 1;
                            });
                          },
                          child: Icon(
                            LucideIcons200.star,
                            size: 26,
                            color: rating > index
                                ? AppColors.accent
                                : AppColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            Column(
              spacing: 12,
              crossAxisAlignment: .start,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(
                      'Notes',
                      style: .new(
                        color: AppColors.textSecondary,
                        fontWeight: .w500,
                      ),
                    ),
                    Text(
                      'Only you can see this',
                      style: .new(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: .w300,
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: _controller,
                  minLines: 2,
                  maxLines: 4,
                  decoration: InputDecoration(
                    fillColor: AppColors.backgroundRaised,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () async {
                      final callback = widget.callback;
                      await viewModel.addGameToLibrary(
                        widget.game,
                        status,
                        _controller.text,
                        rating,
                        completion.round(),
                      );
                      if (!context.mounted) return;
                      Snackbars.show(
                        context,
                        _viewModel?.savedGame == null
                            ? 'Added to your library'
                            : 'Saved changes',
                      );
                      Navigator.pop(context);
                      callback?.call();
                    },
                    label: Text(
                      _viewModel?.savedGame == null
                          ? 'Add to library'
                          : 'Save changes',
                    ),
                    icon: Icon(LucideIcons.plus),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      final callback = widget.callback;
                      if (_viewModel?.savedGame != null) {
                        await _viewModel?.removeFormLib(widget.game.id);
                        if (!context.mounted) return;
                        Snackbars.show(
                          context,
                          'Game removed from your library',
                        );
                      }
                      Navigator.pop(context);
                      callback?.call();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                    child: Text(
                      _viewModel?.savedGame == null
                          ? 'Close'
                          : 'Remove from library',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  final Status status;

  const StatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: statusStyles[status]?.bgColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        statusOptions[status]!,
        style: .new(
          color: statusStyles[status]?.color,
          fontSize: 12,
          height: 1,
          fontWeight: .w600,
        ),
      ),
    );
  }
}
