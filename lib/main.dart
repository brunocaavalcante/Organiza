import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:organiza2/app/app_module.dart';
import 'package:organiza2/app/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  
  // Configurar Firestore com settings otimizadas para melhor conectividade
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true, // Cache local
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}

