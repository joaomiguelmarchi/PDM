import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/provider.dart';
import '../model/note.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProviderNotes(),
      child: Consumer<ProviderNotes>(builder: (_, state, __) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'NotePad',
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'NOTAS:',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  ListView.builder(
                    itemCount: state.notes.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final note = state.notes[index];
                      return _Note(
                        note: note,
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider.value(
                    value: state,
                    child: _ManipulateNote.create(),
                  ),
                ),
              );
            },
            child: const Icon(
              Icons.add,
              size: 40,
            ),
          ),
        );
      }),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({
    Key? key,
    required this.note,
  }) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ProviderNotes>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Colors.black,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text('NOME: '),
                        Expanded(
                          child: Text(
                            note.name ?? '',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text('NOTA: '),
                        Expanded(
                          child: Text(note.note ?? ''),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // state.updateNote(note);
                      // state.refresh();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider.value(
                            value: state,
                            child: _ManipulateNote.edit(nota: note),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      size: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      state.removeNote(note);
                      state.refresh();
                    },
                    icon: const Icon(
                      Icons.delete,
                      size: 20,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ManipulateNote extends StatelessWidget {
  _ManipulateNote.create({Key? key})
      : isEditing = false,
        super(key: key);

  _ManipulateNote.edit({Key? key, required this.nota})
      : isEditing = true,
        super(key: key);

  Note? nota;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ProviderNotes>(context);

    if (nota != null) {
      state.nameController.text = nota?.name ?? '';
      state.noteController.text = nota?.note ?? '';
    } else {
      state.nameController.clear();
      state.noteController.clear();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isEditing ? 'Editar nota' : 'Criar Nota',
        ),
      ),
      body: Center(
        child: Form(
          key: state.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 350,
                  child: TextFormField(
                    controller: state.nameController,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    maxLength: 35,
                    decoration: const InputDecoration(
                      label: Text('Nome'),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim() == '') {
                        return 'Nome vazio';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 350,
                  child: TextFormField(
                    controller: state.noteController,
                    keyboardType: TextInputType.text,
                    maxLines: 5,
                    decoration: const InputDecoration(
                        label: Text('Nota'),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                        )),
                    validator: (value) {
                      if (value == null || value.trim() == '') {
                        return 'Nota vazia';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (!state.formKey.currentState!.validate()) {
                    return;
                  }

                  final nome = state.nameController.text.trim();
                  final note = state.noteController.text.trim();

                  final newNota = Note(
                    id: nota?.id,
                    name: nome,
                    note: note,
                  );

                  if(isEditing){
                    state.updateNote(newNota);
                  }else{
                    state.addNote(newNota);
                  }
                  state.refresh();
                  Navigator.pop(context);
                  state.nameController.clear();
                  state.noteController.clear();
                },
                child: Text(
                  isEditing ? 'EDIT' : 'ADD',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
