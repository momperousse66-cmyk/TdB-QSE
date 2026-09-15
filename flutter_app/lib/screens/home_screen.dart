import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import 'actions_screen.dart';
import 'controles_qualite_screen.dart';
import 'dashboard_screen.dart';
import 'echeances_screen.dart';
import 'parametres_screen.dart';
import 'plans_prevention_screen.dart';
import 'reclamations_screen.dart';
import 'suivi_mensuel_screen.dart';

/// Coquille de navigation : un panneau inférieur horizontal donne accès au
/// tableau de bord, aux registres modifiables et aux options.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  static const _pages = [
    DashboardScreen(),
    ActionsScreen(),
    PlansPreventionScreen(),
    ControlesQualiteScreen(),
    EcheancesScreen(),
    ReclamationsScreen(),
    SuiviMensuelScreen(),
    ParametresScreen(),
  ];

  static const _items = [
    _NavItem('dashboard', Icons.dashboard, 'Accueil', 0),
    _NavItem('actions', Icons.checklist, 'Actions', 1),
    _NavItem('pdp', Icons.shield_outlined, 'PdP', 2),
    _NavItem('qualite', Icons.fact_check_outlined, 'Qualité', 3),
    _NavItem('echeances', Icons.event_note, 'Échéances', 4),
    _NavItem('reclamations', Icons.support_agent, 'Réclam.', 5),
    _NavItem('suivi', Icons.calendar_view_month, 'Suivi', 6),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final favorites = [
      for (final id in state.parametres.favoriteCategories)
        ..._items.where((item) => item.id == id),
    ];
    final visibleFavorites = favorites.length >= 4 ? favorites.take(4).toList() : _items.take(4).toList();
    final hidden = _items.where((item) => !visibleFavorites.any((favorite) => favorite.id == item.id)).toList();

    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _pages[_index]),
          SafeArea(
            top: false,
            child: Container(
              height: 76,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          for (final item in visibleFavorites)
                            Expanded(
                              child: _BottomNavItem(
                                icon: item.icon,
                                label: item.label,
                                selected: _index == item.pageIndex,
                                onTap: () => setState(() => _index = item.pageIndex),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const VerticalDivider(width: 12, indent: 8, endIndent: 8),
                    PopupMenuButton<_NavItem>(
                      tooltip: 'Autres catégories',
                      icon: const Icon(Icons.more_horiz),
                      itemBuilder: (context) => [
                        for (final item in hidden)
                          PopupMenuItem(
                            value: item,
                            child: Row(children: [Icon(item.icon, size: 20), const SizedBox(width: 10), Text(item.label)]),
                          ),
                        const PopupMenuDivider(),
                        const PopupMenuItem<_NavItem>(
                          enabled: false,
                          child: Text('Gérer les favoris dans Options'),
                        ),
                      ],
                      onSelected: (item) => setState(() => _index = item.pageIndex),
                    ),
                    Expanded(
                      child: _BottomNavItem(
                        icon: Icons.tune,
                        label: 'Options',
                        selected: _index == _pages.length - 1,
                        onTap: () => setState(() => _index = _pages.length - 1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final String id;
  final IconData icon;
  final String label;
  final int pageIndex;

  const _NavItem(this.id, this.icon, this.label, this.pageIndex);
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BottomNavItem({required this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: SizedBox(
          height: 64,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 4),
              Text(label, overflow: TextOverflow.ellipsis, style: TextStyle(color: color, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
