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
    (Icons.tune, 'Options'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            labelType: NavigationRailLabelType.all,
            backgroundColor: const Color(0xFFF7FAFC),
            destinations: [
              for (final it in _items)
                NavigationRailDestination(icon: Icon(it.$1), label: Text(it.$2, textAlign: TextAlign.center)),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: _pages[_index]),
        ],
      ),
    );
  }
}
