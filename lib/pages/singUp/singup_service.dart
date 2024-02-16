import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:regradocorte_app/shared/constants/routes.dart';

class SignUpService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUpCustomer(String email, String password, String nameUser) async {
    try {
      // Cria o usuário com Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Obter o UID do usuário criado
      String uid = userCredential.user!.uid;

      // Referência para o documento do usuário
      DocumentReference userDocRef = _firestore.collection('users').doc(uid);

      // Gravar informações do usuário no Firestore
      await userDocRef.set({
        'uuid': uid,
        'name': nameUser,
        'email': email,
        'phone': '', // Adicione o telefone aqui se disponível
        'role': 'customer',
      });

    } on FirebaseAuthException catch (e) {
      print('Erro no Firebase Auth: $e');
    } catch (e) {
      print('Erro geral: $e');
    }
  }

  Future<void> signUpShalon(String email, String password, String nameUser, String shalonName) async {
    try {
      // Cria o usuário com Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Obter o UID do usuário criado
      String uid = userCredential.user!.uid;

      // Referência para o documento do usuário
      DocumentReference userDocRef = _firestore.collection('users').doc(uid);

      // Gravar informações do usuário no Firestore
      await userDocRef.set({
        'uuid': uid,
        'name': nameUser,
        'email': email,
        'phone': '', // Adicione o telefone aqui se disponível
        'role': 'shalonAdmin',
      });

      // Criar um documento na coleção "shalon"
      DocumentReference shalonRef = await _firestore.collection('shalon').add({
        'ownerId': uid, // ID do usuário que é dono do salão
        'name': shalonName, // Nome do salão
        'phone': '', // Telefone do salão
        'address': '', // Endereço do salão
        'bio': '', // Bio do salão
      });

      // Atualizar o documento do usuário com o ID do salão
      await userDocRef.update({'salonId': shalonRef.id});

      // Adicionar usuário na subcoleção "employees" do documento "shalon" como admin
      await shalonRef.collection('employees').doc(uid).set({
        'userId': uid, // ID do usuário
        'role': 'admin', // Função do usuário no salão como admin
      });

    } on FirebaseAuthException catch (e) {
      print('Erro no Firebase Auth: $e');
    } catch (e) {
      print('Erro geral: $e');
    }
  }
}
