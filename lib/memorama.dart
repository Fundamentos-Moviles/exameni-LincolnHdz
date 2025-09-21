import 'package:flutter/material.dart';
import 'dart:math';

class Memorama extends StatefulWidget {
  const Memorama({super.key});

  @override
  State<Memorama> createState() => _MemoramaState();
}

class _MemoramaState extends State<Memorama> {
  int filas = 4;
  int columnas = 5;

  late List<Color> coloresJuego;
  late List<bool> descubiertos;
  late List<bool> encontrados;
  late List<int> seleccionados;
  Color colorInactivo = Colors.grey;

  final filasController = TextEditingController(text: "4");
  final columnasController = TextEditingController(text: "5");

  @override
  void initState() {
    super.initState();
    iniciarJuego();
  }

  void iniciarJuego() {
    final random = Random();
    int numPares = (filas * columnas) ~/ 2;

    List<Color> coloresRandom = List.generate(numPares, (_) {
      return Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
    });

    coloresJuego = [...coloresRandom, ...coloresRandom]..shuffle(random);
    descubiertos = List.filled(filas * columnas, false);
    encontrados = List.filled(filas * columnas, false);
    seleccionados = [];
  }

  void seleccionar(int index) {
    if (descubiertos[index] || seleccionados.contains(index)) return;

    setState(() {
      seleccionados.add(index);
    });

    if (seleccionados.length == 2) {
      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          if (coloresJuego[seleccionados[0]] == coloresJuego[seleccionados[1]]) {
            descubiertos[seleccionados[0]] = true;
            descubiertos[seleccionados[1]] = true;
            encontrados[seleccionados[0]] = true;
            encontrados[seleccionados[1]] = true;
          }
          seleccionados.clear();

          if (descubiertos.every((d) => d)) {
            mostrarDialogoGanador();
          }
        });
      });
    }
  }

  void mostrarDialogoGanador() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("¡Felicidades!"),
        content: const Text("Has completado el memorama"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() => iniciarJuego());
            },
            child: const Text("Jugar de nuevo"),
          )
        ],
      ),
    );
  }

  void actualizarTamanio() {
    int? nuevasFilas = int.tryParse(filasController.text);
    int? nuevasColumnas = int.tryParse(columnasController.text);

    if (nuevasFilas != null && nuevasColumnas != null && (nuevasFilas * nuevasColumnas) % 2 == 0) {
      setState(() {
        filas = nuevasFilas;
        columnas = nuevasColumnas;
        iniciarJuego();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Debe ser un número válido y que el total de cuadros sea par")),
      );
    }
  }

  void reiniciarJuego() {
    setState(() {
      iniciarJuego();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Memorama, Hernandez Mendoza Lincoln Leonardo"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: 500,
                height: 500,
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columnas,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: filas * columnas,
                  itemBuilder: (context, index) {
                    bool visible = descubiertos[index] || seleccionados.contains(index);

                    return InkWell(
                      onTap: () => seleccionar(index),
                      child: AnimatedScale(
                        scale: encontrados[index] ? 0.8 : 1.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: Container(
                          decoration: BoxDecoration(
                            color: visible ? coloresJuego[index] : colorInactivo,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: filasController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Filas"),
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: columnasController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Columnas"),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: actualizarTamanio,
                  child: const Text("Actualizar"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: reiniciarJuego,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Reiniciar"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
