//the Dog model
import 'package:flutter/material.dart';

class Dog{
  final int id;
  final String name;
  final int age;

  Dog({this.id, this.name, this.age});

  //insert a dog model into the database table
  //this involve two steps
  //1: Convert the Dog into map
  //2: Use the insert() method to store the map in the dogs table

  //convert a Dog into a Map. The keys must correspond to the name of the
  //columns in the database
  Map<String, dynamic> toMap(){
    return{
      'id': id,
      'name': name,
      'age': age
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}