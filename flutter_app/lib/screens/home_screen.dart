import 'package:flutter/material.dart';

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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    for (var i = 0; i < _items.length; i++)
                      _BottomNavItem(
                        icon: _items[i].$1,
                        label: _items[i].$2,
                        selected: _index == i,
                        onTap: () => setState(() => _index = i),
                      ),
                    const VerticalDivider(width: 24, indent: 8, endIndent: 8),
                    _BottomNavItem(
                      icon: Icons.tune,
                      label: 'Options',
                      selected: _index == _pages.length - 1,
                      onTap: () => setState(() => _index = _pages.length - 1),
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
          width: 108,
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
