import 'package:flutter/material.dart';
import 'package:aventura_matematica/data/database/progress_db.dart';
import 'package:aventura_matematica/presentation/screens/game/game_screen.dart';
import 'package:aventura_matematica/presentation/screens/home/realms_screen.dart';

class RealmStagesScreen extends StatefulWidget {
  final Realm realm;

  const RealmStagesScreen({super.key, required this.realm});

  @override
  State<RealmStagesScreen> createState() => _RealmStagesScreenState();
}

class _RealmStagesScreenState extends State<RealmStagesScreen>
    with SingleTickerProviderStateMixin {
  late Future<Map<String, bool>> _progress;
  late AnimationController _controller;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _progress = _loadProgress();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnim = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Map<String, bool>> _loadProgress() async {
    return {
      'Fácil': await ProgressDB.instance.isCompleted(
        widget.realm.name,
        'Fácil',
      ),
      'Médio': await ProgressDB.instance.isCompleted(
        widget.realm.name,
        'Médio',
      ),
      'Difícil': await ProgressDB.instance.isCompleted(
        widget.realm.name,
        'Difícil',
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final difficulties = ['Fácil', 'Médio', 'Difícil'];
    final difficultyColors = {
      'Fácil': Colors.greenAccent,
      'Médio': Colors.orangeAccent,
      'Difícil': Colors.redAccent,
    };

    return Scaffold(
      backgroundColor: const Color(0xFF311B92),
      appBar: AppBar(
        title: Text(
          widget.realm.name,
          style: const TextStyle(
            fontFamily: 'MedievalSharp',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4527A0),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 4,
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, bool>>(
        future: _progress,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          final progress = snapshot.data!;

          // Define o bloqueio das fases
          bool unlockedEasy = true;
          bool unlockedMedium = progress['Fácil'] ?? false;
          bool unlockedHard = progress['Médio'] ?? false;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: difficulties.length,
            itemBuilder: (context, index) {
              final diff = difficulties[index];
              final completed = progress[diff] ?? false;
              final isUnlocked =
                  (diff == 'Fácil') ||
                  (diff == 'Médio' && unlockedMedium) ||
                  (diff == 'Difícil' && unlockedHard);

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: AnimatedBuilder(
                  animation: _glowAnim,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isUnlocked
                            ? [
                                BoxShadow(
                                  color: difficultyColors[diff]!.withOpacity(
                                    _glowAnim.value * 0.6,
                                  ),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          if (!isUnlocked) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "⚠️ Complete a fase anterior para desbloquear '$diff'!",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.redAccent,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GameScreen(
                                realm: widget.realm,
                                difficulty: diff,
                              ),
                            ),
                          ).then((_) {
                            setState(() {
                              _progress = _loadProgress();
                            });
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: isUnlocked
                                  ? [
                                      widget.realm.color.withOpacity(0.8),
                                      Colors.black.withOpacity(0.4),
                                    ]
                                  : [Colors.grey.shade800, Colors.black87],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: Icon(
                              completed
                                  ? Icons.check_circle
                                  : (isUnlocked
                                        ? Icons.bolt_rounded
                                        : Icons.lock_outline),
                              color: completed
                                  ? Colors.amberAccent
                                  : isUnlocked
                                  ? Colors.white
                                  : Colors.grey,
                              size: 32,
                            ),
                            title: Text(
                              "Fase ${index + 1}: $diff",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'MedievalSharp',
                                color: isUnlocked
                                    ? Colors.white
                                    : Colors.white38,
                              ),
                            ),
                            subtitle: Text(
                              isUnlocked
                                  ? (completed
                                        ? "✔️ Concluída"
                                        : "Pronta para jogar")
                                  : "Bloqueada",
                              style: TextStyle(
                                color: isUnlocked
                                    ? Colors.white70
                                    : Colors.white30,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              color: isUnlocked
                                  ? Colors.white54
                                  : Colors.white24,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
