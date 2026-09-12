import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const AniketProAIApp());
}

class AniketProAIApp extends StatelessWidget {
  const AniketProAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ANIKET PRO AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF5E6C8), // Soft Gold
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212), // Dark BG
      ),
      home: const SplashScreen(),
    );
  }
}

// --- Splash Screen ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _requestPermissionsAndNavigate();
  }

  Future<void> _requestPermissionsAndNavigate() async {
    await [Permission.photos, Permission.storage].request();
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainWebViewScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5E6C8).withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF5E6C8), width: 2),
              ),
              child: const Text("ꫝ", style: TextStyle(fontSize: 60, color: Color(0xFFF5E6C8))),
            ),
            const SizedBox(height: 20),
            const Text("ANIKET PRO AI", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFF5E6C8), letterSpacing: 1.2)),
            const SizedBox(height: 10),
            const Text("Loading SMC Engine...", style: TextStyle(color: Colors.white54)),
            const SizedBox(height: 30),
            const CircularProgressIndicator(color: Color(0xFFF5E6C8)),
          ],
        ),
      ),
    );
  }
}

// --- Main WebView Screen ---
class MainWebViewScreen extends StatefulWidget {
  const MainWebViewScreen({super.key});
  @override
  State<MainWebViewScreen> createState() => _MainWebViewScreenState();
}

class _MainWebViewScreenState extends State<MainWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  
  // আপনার Netlify লিংক
  final String _netlifyUrl = "https://graceful-dieffenbachia-986a50.netlify.app";

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // চার্ট ও AI এর জন্য জরুরি
      ..setBackgroundColor(const Color(0xFF121212))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) => setState(() => _isLoading = true),
          onPageFinished: (String url) async {
            setState(() => _isLoading = false);
            // Netlify Badge Hide করার JavaScript Injection
            await _controller.runJavaScript('''
              (function() {
                var badges = document.querySelectorAll('a[href*="netlify"], div[id*="netlify"], .netlify-badge');
                badges.forEach(function(el) { el.remove(); });
                var allElements = document.querySelectorAll('*');
                for (var i = 0; i < allElements.length; i++) {
                  if (allElements[i].innerText && allElements[i].innerText.includes('Powered by Netlify')) {
                    allElements[i].style.display = 'none';
                  }
                }
              })();
            ''');
          },
        ),
      )
      ..loadRequest(Uri.parse(_netlifyUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: const Color(0xFF121212),
              child: const Center(child: CircularProgressIndicator(color: Color(0xFFF5E6C8))),
            ),
          // Settings Gear Icon (Top Right)
          Positioned(
            top: 40, right: 15,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showSettingsPopup(context),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                  child: const Icon(Icons.settings, color: Color(0xFFF5E6C8), size: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("⚙️ App Settings", style: TextStyle(color: Color(0xFFF5E6C8), fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SwitchListTile(title: const Text("Floating Bubble (ꫝ)", style: TextStyle(color: Colors.white)), value: false, activeColor: const Color(0xFFF5E6C8), onChanged: (val) {}),
            SwitchListTile(title: const Text("Gallery Auto-Delete", style: TextStyle(color: Colors.white)), value: false, activeColor: const Color(0xFFF5E6C8), onChanged: (val) {}),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.download), label: const Text("📥 Entry SS"), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF5E6C8), foregroundColor: Colors.black))),
                const SizedBox(width: 10),
                Expanded(child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.download), label: const Text("📥 HTF SS"), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF5E6C8), foregroundColor: Colors.black))),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
