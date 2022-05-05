import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'MyApp.dart';
import 'package:flutter/widgets.dart';
import 'package:offline_database/model/Dog.dart';
import 'dart:developer' as developer;
import 'package:offline_database/views/HomeScreen.dart';

void main() async{
  //Before reading and writing data to the database, open a connection to the database. This involves two steps:
  //Define the path to the database file using getDatabasesPath() from the sqflite package, combined with the join function from the path package.
  //Open the database with the openDatabase() function from sqflite.
  //Note: In order to use the keyword await, the code must be placed inside an async function.
  // You should place all the following table functions inside void main() async {}

  //Avoid errors caused by flutter u[grade
  //Importing 'import 'package:flutter/widgets.dart' is required
  WidgetsFlutterBinding.ensureInitialized();
  //open the database and store the reference
  final Future<Database> database = openDatabase(
    //set the path to the database. Note: Using the join function from the path
    //path package is best practice to ensure the path is correctly constructed for each platform
    join(await getDatabasesPath(), 'doggie_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version){
      //Run the CREATE TABLE statement on the database
      return db.execute("CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",);
    },
    version: 1,
  );
  print("printimg database ${await database}");
  //Define a function that inserts dogs into the database
  Future<void> insertDog(Dog dog) async {
    //Get a reference to database.
    final Database db = await database;
    //Insert the dog into the correct table. you might also specify the
    //conflictAlgorithm to use in case the same dog is inserted twice.
    //In this case, replace any previous data
    await db.insert(
      //the dogs is the table name
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  //Create a Dog and add it to the dogs table
  final germanShepherd = Dog(
      id: 0,
      name: 'German Shepherd',
      age: 35
  );

  //Now that a Dog is stored in the database,
  // query the database for a specific dog or a list of all dogs.
  // This involves two steps:
  //Run a query against the dogs table. This return a List<Map>.
  //Convert the List<Map> into a list List<Dog>.

  //A method that retrieves all the dogs from the dogs
  Future<List<Dog>> allDogs() async {
    //Get a reference to the database
    final Database db = await database;

    //query the table for all dogs
    final List<Map<String, dynamic>> maps = await db.query('dogs');
    //convert the List<Map<String, dynamic>> into a List<Dogs>
       return List.generate(maps.length, (index) {
       return Dog(id: maps[index]['id'], name: maps[index]['name'], age: maps[index]['age']);
    });
  }
  await insertDog(germanShepherd);

  print(await allDogs());

  //Update a Dog in the database
  //After inserting information into the database,
  // you might want to update that information at a later time.
  // You can do this by using the update() method from the sqflite library.
  //This involves two steps:
  //Convert the Dog into a Map.
  //Use a where clause to ensure you update the correct Dog

  Future<void> updateDog(Dog dog) async {
    //get a reference to the database
    final db = await database;

    //update the give dog
    await db.update(
      'dogs',
      dog.toMap(),
      //Ensure taht the dog has a matching id.
      where: "id = ?",
        //pass the Dog's id as a whereArg to prevent SQL injection
        // Warning: Always use whereArgs to pass arguments to a where statement.
        // This helps safeguard against SQL injection attacks.
        //Do not use string interpolation, such as where: "id = ${dog.id}"!
      whereArgs: [dog.id]
    );
  }

  //update German Shepherd age.
   await updateDog(Dog(
    id: 0,
    name: 'German shepherd',
    age: 55
  ));

  //print the updated results
  print(await allDogs());

  //delete a dog from the database
  //In this section, create a function that takes an id
  // and deletes the dog with a matching id from the database.
  // To make this work, you must provide a where clause to limit
  // the records being deleted.

  Future<void> deleteDog(int id) async{
    //get a reference to the database
    final db = await database;

    //remove the dog from the database
    await db.delete(
      'dogs',
      //Use a where clause to delete a specific dog
      where: "id = ?",
      //pass the Dog's id as a whereArg to prevent SQL injection
      whereArgs: [id]
    );
  }
  
  deleteDog(germanShepherd.id);
  print(await allDogs());
  developer.log('allDogs', name: 'Starrex');
  runApp(MyApp());
}