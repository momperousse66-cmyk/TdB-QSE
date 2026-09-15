import 'package:flutter/material.dart';

import 'actions_screen.dart';
import 'controles_qualite_screen.dart';
import 'dashboard_screen.dart';
import 'echeances_screen.dart';
import 'parametres_screen.dart';
import 'plans_prevention_screen.dart';
import 'reclamations_screen.dart';
import 'suivi_mensuel_screen.dart';

/// Coquille de navigation : un tiroir latéral donne accès au tableau de bord
/// et aux six registres modifiables, plus les options (villes/objectifs).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  bool _railExpanded = true;

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
    (Icons.dashboard, 'Tableau de bord'),
    (Icons.checklist, 'Actions'),
    (Icons.shield_outlined, 'Plans de prévention'),
    (Icons.fact_check_outlined, 'Contrôles qualité'),
    (Icons.event_note, 'Échéances'),
    (Icons.support_agent, 'Réclamations'),
    (Icons.calendar_view_month, 'Suivi mensuel'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: _railExpanded ? 240 : 72,
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              child: Column(
                children: [
                  Align(
                    alignment: _railExpanded ? Alignment.centerRight : Alignment.center,
                    child: IconButton(
                      tooltip: _railExpanded ? 'Rétracter le menu' : 'Déployer le menu',
                      icon: Icon(_railExpanded ? Icons.chevron_left : Icons.chevron_right),
                      onPressed: () => setState(() => _railExpanded = !_railExpanded),
                    ),
                  ),
                  Expanded(
                    child: NavigationRail(
                      selectedIndex: _index < _items.length ? _index : null,
                      onDestinationSelected: (i) => setState(() => _index = i),
                      extended: _railExpanded,
                      labelType: _railExpanded ? null : NavigationRailLabelType.none,
                      backgroundColor: Colors.transparent,
                      destinations: [
                        for (final it in _items)
                          NavigationRailDestination(icon: Icon(it.$1), label: Text(it.$2)),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Tooltip(
                    message: 'Options',
                    child: ListTile(
                      selected: _index == _pages.length - 1,
                      leading: const Icon(Icons.tune),
                      title: _railExpanded ? const Text('Options') : null,
                      onTap: () => setState(() => _index = _pages.length - 1),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: _pages[_index]),
        ],
      ),
    );
  }
}
