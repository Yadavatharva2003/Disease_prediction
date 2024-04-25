import 'package:flutter/material.dart';

class DiagnosticReportPage extends StatefulWidget {
  const DiagnosticReportPage({Key? key}) : super(key: key);

  @override
  State<DiagnosticReportPage> createState() => _DiagnosticReportPageState();
}

class _DiagnosticReportPageState extends State<DiagnosticReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diagnostic Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Add animated cards here
          ],
        ),
      ),
    );
  }
}
class AnimatedDiagnosticCard extends StatefulWidget {
  final String title;
  final String description;

  const AnimatedDiagnosticCard({
    required this.title,
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  _AnimatedDiagnosticCardState createState() => _AnimatedDiagnosticCardState();
}

class _AnimatedDiagnosticCardState extends State<AnimatedDiagnosticCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Card(
        elevation: 4.0,
        child: ListTile(
          title: Text(widget.title),
          subtitle: Text(widget.description),
        ),
      ),
    );
  }
}
