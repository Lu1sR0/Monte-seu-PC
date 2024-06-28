import 'package:dreampcbuilder/splachscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BuildState()),
              
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Monte seu PC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins', // Define a fonte padrão como Poppins
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}


//aqui óoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
class BuildState with ChangeNotifier {
  List<BuildItem> _buildItems = [];
  BuildComponent? _selectedCpu;
  BuildComponent? _selectedGpu;
  BuildComponent? _selectedMemory;
  BuildComponent? _selectedCase;
  BuildComponent? _selectedStorage;
  BuildComponent? _selectedCooler;
  BuildComponent? _selectedFonte;

  List<BuildItem> get buildItems => _buildItems;
  BuildComponent? get selectedCpu => _selectedCpu;
  BuildComponent? get selectedGpu => _selectedGpu;
  BuildComponent? get selectedMemory => _selectedMemory;
  BuildComponent? get selectedCase => _selectedCase;
  BuildComponent? get selectedStorage => _selectedStorage;
  BuildComponent? get selectedCooler => _selectedCooler;
  BuildComponent? get selectedFonte => _selectedFonte;

  Future<void> saveConfiguration(BuildContext context, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final buildItem = BuildItem(
      name: name,
      selectedCpu: selectedCpu,
      selectedGpu: selectedGpu,
      selectedMemory: selectedMemory,
      selectedStorage: selectedStorage,
      selectedCooler: selectedCooler,
      selectedFonte: selectedFonte,
      selectedCase: selectedCase,
      totalCost: getTotalCost(),
      totalTdp: getTotalTdp(),
    );
    prefs.setString('buildItem', json.encode(buildItem.toJson()));
    addBuildItem(buildItem);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MyBuildPage()),
    );
  }

  // Método para carregar a configuração salva
  Future<void> loadSavedConfiguration() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? buildItemString = prefs.getString('buildItem');
    if (buildItemString != null) {
      Map<String, dynamic> buildItemMap = json.decode(buildItemString);
      BuildItem buildItem = BuildItem.fromJson(buildItemMap);
      addBuildItem(buildItem);
    }
  }

  void addBuildItem(BuildItem buildItem) {
    _buildItems.add(buildItem);
    notifyListeners();
  }

  void clearBuildItems() {
    _buildItems.clear();
    notifyListeners();
  }

  void updateBuildItem(int index, BuildItem buildItem) {
    _buildItems[index] = buildItem;
    notifyListeners();
  }

  void removeBuildItem(int index) {
    _buildItems.removeAt(index);
    notifyListeners();
  }

  void selectCpu(BuildComponent cpu) {
    _selectedCpu = cpu;
    notifyListeners();
  }

  void selectGpu(BuildComponent gpu) {
    _selectedGpu = gpu;
    notifyListeners();
  }

  void selectMemory(BuildComponent memory) {
    _selectedMemory = memory;
    notifyListeners();
  }

  void selectCase(BuildComponent caseComponent) {
    _selectedCase = caseComponent;
    notifyListeners();
  }

  void selectStorage(BuildComponent storage) {
    _selectedStorage = storage;
    notifyListeners();
  }

  void selectCooler(BuildComponent cooler) {
    _selectedCooler = cooler;
    notifyListeners();
  }

  void selectFonte(BuildComponent fonte) {
    _selectedFonte = fonte;
    notifyListeners();
  }

  void clearSelections() {
    _selectedCpu = null;
    _selectedGpu = null;
    _selectedMemory = null;
    _selectedCase = null;
    _selectedStorage = null;
    _selectedCooler = null;
    _selectedFonte = null;
    notifyListeners();
  }

  double getTotalCost() {
    double total = 0;
    if (_selectedCpu != null) total += _selectedCpu!.cost;
    if (_selectedGpu != null) total += _selectedGpu!.cost;
    if (_selectedMemory != null) total += _selectedMemory!.cost;
    if (_selectedCase != null) total += _selectedCase!.cost;
    if (_selectedStorage != null) total += _selectedStorage!.cost;
    if (_selectedCooler != null) total += _selectedCooler!.cost;
    if (_selectedFonte != null) total += _selectedFonte!.cost;
    return total;
  }

  int getTotalTdp() {
    int total = 0;
    if (_selectedCpu != null) total += _selectedCpu!.tdp;
    if (_selectedGpu != null) total += _selectedGpu!.tdp;
    if (_selectedMemory != null) total += _selectedMemory!.tdp;
    if (_selectedCooler != null) total += _selectedCooler!.tdp;
    return total;
  }

  void clearBuildItem(int index) {
    _buildItems[index] = BuildItem(
      name: _buildItems[index].name,
      selectedCpu: null,
      selectedGpu: null,
      selectedMemory: null,
      selectedStorage: null,
      selectedCooler: null,
      selectedFonte: null,
      selectedCase: null,
      totalCost: 0.0,
      totalTdp: 0,
    );
    notifyListeners();
  }
}

class BuildComponent {
  final String name;
  final double cost;
  final int tdp;

  BuildComponent({required this.name, required this.cost, required this.tdp});
}

class BuildItem {
  String name;
  BuildComponent? selectedCpu;
  BuildComponent? selectedGpu;
  BuildComponent? selectedMemory;
  BuildComponent? selectedCase;
  BuildComponent? selectedStorage;
  BuildComponent? selectedFonte;
  BuildComponent? selectedCooler;
  double totalCost;
  int totalTdp;

  BuildItem({
    required this.name,
    this.selectedCpu,
    this.selectedGpu,
    this.selectedMemory,
    this.selectedCase,
    this.selectedStorage,
    this.selectedFonte,
    this.selectedCooler,
    required this.totalCost,
    required this.totalTdp,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'selectedCpu': selectedCpu?.name,
      'selectedGpu': selectedGpu?.name,
      'selectedMemory': selectedMemory?.name,
      'selectedCase': selectedCase?.name,
      'selectedStorage': selectedStorage?.name,
      'selectedFonte': selectedFonte?.name,
      'selectedCooler': selectedCooler?.name,
      'totalCost': totalCost,
      'totalTdp': totalTdp,
    };
  }

  factory BuildItem.fromJson(Map<String, dynamic> json) {
    return BuildItem(
      name: json['name'],
      totalCost: json['totalCost'],
      totalTdp: json['totalTdp'],
    );
  }
}
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Cor de fundo cinza escuro
      appBar: AppBar(
        title: Text(
          'Bem Vindo(a)',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins', // Define a fonte Poppins no título
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.transparent, // Fundo da AppBar transparente
        elevation: 0, // Remove a sombra da AppBar
        centerTitle: true, // Centraliza o título
        automaticallyImplyLeading: false, // Remove o botão de voltar automaticamente
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyBuildPage()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/montarpc.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5), // Opacidade para escurecer a imagem
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyBuildPage()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue, Color.fromARGB(110, 1, 89, 241)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.7),
                            blurRadius: 10.0,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                      child: Text(
                        'Minhas montagens',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins', // Define a fonte Poppins no texto
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  final String content;

  PlaceholderPage({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Dark gray background color
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          content,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }
}



  Widget buildSettingsItem(BuildContext context, String title, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

class MyBuildPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<BuildState>(context, listen: false).loadSavedConfiguration();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Dark gray background color
      appBar: AppBar(
        title: Text(
          'Minhas Montagens',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins', // Define a fonte Poppins no título
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.transparent, // Fundo da AppBar transparente
        elevation: 0, // Remove a sombra da AppBar
        centerTitle: true,
        automaticallyImplyLeading: false, // Centraliza o título e remove o botão de voltar
      ),
      body: Consumer<BuildState>(
        builder: (context, buildState, child) {
          return buildState.buildItems.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), // Adiciona padding para afastar o texto das bordas
                    child: Text(
                      'Nenhum PC encontrado :( \n não se esqueça de salvar sua configuração como um PDF antes de sair do app',
                      textAlign: TextAlign.center, // Centraliza o texto
                      style: TextStyle(fontSize: 19, color: Colors.white, fontFamily: 'Poppins'),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: buildState.buildItems.length,
                  itemBuilder: (context, index) {
                    final buildItem = buildState.buildItems[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BuildDetailPage(
                              buildItem: buildItem,
                              buildIndex: index,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[850],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.7),
                              blurRadius: 5.0,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  buildItem.name,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        buildState.removeBuildItem(index);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            //arrumar aqui 
                            Text(
                              'Processador: ${buildItem.selectedCpu?.name ?? "N/A"}',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Placa de vídeo: ${buildItem.selectedGpu?.name ?? "N/A"}',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Memória RAM: ${buildItem.selectedMemory?.name ?? "N/A"}',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Armazenamento: ${buildItem.selectedStorage?.name ?? "N/A"}',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Cooler: ${buildItem.selectedCooler?.name ?? "N/A"}',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Fonte: ${buildItem.selectedFonte?.name ?? "N/A"}',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Gabinete: ${buildItem.selectedCase?.name ?? "N/A"}',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Valor total: R\$${buildItem.totalCost.toStringAsFixed(2)}',
                              style: TextStyle(color: Colors.green),
                            ),
                            Text(
                              'Minímo de Watts necessário: ${buildState.getTotalTdp()} W',
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           Provider.of<BuildState>(context, listen: false).clearSelections();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CustomBuildPage()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}



//daqui pra cima ta certo

// Build Detail Page
class BuildDetailPage extends StatelessWidget {
  final BuildItem buildItem;
  final int buildIndex;

  BuildDetailPage({required this.buildItem, required this.buildIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
          title: Text(
          buildItem.name,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent, // Fundo da AppBar transparente
          elevation: 0, // Remove a sombra da AppBar
          centerTitle: true, // Centraliza o título
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white), // Ícone de voltar branco
            onPressed: () {
              Navigator.of(context).pop(); // Volta para a página anterior
            },
            tooltip: 'Voltar', // Texto que aparece ao passar o mouse sobre o ícone
          ),
        
        
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () async {
              final doc = pw.Document();
              doc.addPage(
                pw.Page(
                  build: (pw.Context context) {
                    return pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Nome do PC: ${buildItem.name}',
                          style: pw.TextStyle(
                              fontSize: 24, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 16),
                        pw.Text(
                          'Processador: ${buildItem.selectedCpu?.name ?? "N/A"}',
                          style: pw.TextStyle(fontSize: 18),
                        ),
                        pw.Text(
                          'Placa de vídeo: ${buildItem.selectedGpu?.name ?? "N/A"}',
                          style: pw.TextStyle(fontSize: 18),
                        ),
                        pw.Text(
                          'Memória RAM: ${buildItem.selectedMemory?.name ?? "N/A"}',
                          style: pw.TextStyle(fontSize: 18),
                        ),
                        pw.Text(
                          'Armazenamento: ${buildItem.selectedStorage?.name ?? "N/A"}',
                          style: pw.TextStyle(fontSize: 18),
                        ),
                        pw.Text(
                          'Cooler: ${buildItem.selectedCooler?.name ?? "N/A"}',
                          style: pw.TextStyle(fontSize: 18),
                        ),
                        pw.Text(
                          'Fonte: ${buildItem.selectedFonte?.name ?? "N/A"}',
                          style: pw.TextStyle(fontSize: 18),
                        ),
                        pw.Text(
                          'Gabinete: ${buildItem.selectedCase?.name ?? "N/A"}',
                          style: pw.TextStyle(fontSize: 18),
                        ),
                        pw.SizedBox(height: 16),
                        pw.Text(
                          'Valor total: R\$${buildItem.totalCost.toStringAsFixed(2)}',
                          style: pw.TextStyle(fontSize: 18),
                        ),
                      ],
                    );
                  },
                ),
              );

              await Printing.layoutPdf(
                  onLayout: (PdfPageFormat format) async => doc.save());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildDetailItem('Processador', buildItem.selectedCpu?.name),
            buildDetailItem('Placa de vídeo', buildItem.selectedGpu?.name),
            buildDetailItem('Memória RAM', buildItem.selectedMemory?.name),
            buildDetailItem('Armazenamento', buildItem.selectedStorage?.name),
            buildDetailItem('Cooler', buildItem.selectedCooler?.name),
            buildDetailItem('Fonte', buildItem.selectedFonte?.name),
            buildDetailItem('Gabinete', buildItem.selectedCase?.name),
            SizedBox(height: 20),
            Text(
              'Valor total: R\$${buildItem.totalCost.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailItem(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        '$title: ${value ?? "N/A"}',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}


// Edit Build Page tem que mudar aqui,triar o pop up e er se tem como arrumar 
class EditBuildPage extends StatelessWidget {
  final BuildItem buildItem;
  final int buildIndex;

  EditBuildPage({required this.buildItem, required this.buildIndex});

  @override
  Widget build(BuildContext context) {
    final buildState = Provider.of<BuildState>(context);
    // Inicialize os campos do estado com os valores atuais do BuildItem
    buildState._selectedCpu = buildItem.selectedCpu;
    buildState._selectedGpu = buildItem.selectedGpu;
    buildState._selectedMemory = buildItem.selectedMemory;
    buildState._selectedCase = buildItem.selectedCase;
    buildState._selectedStorage = buildItem.selectedStorage;
    buildState._selectedCooler = buildItem.selectedCooler;
    buildState._selectedFonte = buildItem.selectedFonte;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Editar Pc',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildEditableComponent(
                context,
                'Processador',
                buildState.selectedCpu,
                Icons.memory,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectCPUPage(editIndex: buildIndex),
                    ),
                  ).then((_) {
                    buildState.updateBuildItem(buildIndex, BuildItem(
                      name: buildItem.name,
                      selectedCpu: buildState.selectedCpu,
                      selectedGpu: buildState.selectedGpu,
                      selectedMemory: buildState.selectedMemory,
                      selectedStorage: buildState.selectedStorage,
                      selectedCooler: buildState.selectedCooler,
                      selectedFonte: buildState.selectedFonte,
                      selectedCase: buildState.selectedCase,
                      totalCost: buildState.getTotalCost(),
                      totalTdp: buildState.getTotalTdp(),
                    ));
                  });
                },
              ),
              SizedBox(height: 10),
              buildEditableComponent(
                context,
                'Placa de vídeo',
                buildState.selectedGpu,
                Icons.tv,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectGPUPage(editIndex: buildIndex),
                    ),
                  ).then((_) {
                    buildState.updateBuildItem(buildIndex, BuildItem(
                      name: buildItem.name,
                      selectedCpu: buildState.selectedCpu,
                      selectedGpu: buildState.selectedGpu,
                      selectedMemory: buildState.selectedMemory,
                      selectedStorage: buildState.selectedStorage,
                      selectedCooler: buildState.selectedCooler,
                      selectedFonte: buildState.selectedFonte,
                      selectedCase: buildState.selectedCase,
                      totalCost: buildState.getTotalCost(),
                      totalTdp: buildState.getTotalTdp(),
                    ));
                  });
                },
              ),
              SizedBox(height: 10),
              buildEditableComponent(
                context,
                'Memoria Ram',
                buildState.selectedMemory,
                Icons.sd_card,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectMemoryPage(editIndex: buildIndex),
                    ),
                  ).then((_) {
                    buildState.updateBuildItem(buildIndex, BuildItem(
                      name: buildItem.name,
                      selectedCpu: buildState.selectedCpu,
                      selectedGpu: buildState.selectedGpu,
                      selectedMemory: buildState.selectedMemory,
                      selectedStorage: buildState.selectedStorage,
                      selectedCooler: buildState.selectedCooler,
                      selectedFonte: buildState.selectedFonte,
                      selectedCase: buildState.selectedCase,
                      totalCost: buildState.getTotalCost(),
                      totalTdp: buildState.getTotalTdp(),
                    ));
                  });
                },
              ),
              SizedBox(height: 10),
              buildEditableComponent(
                context,
                'Armazenamento',
                buildState.selectedStorage,
                Icons.storage_rounded,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectStoragePage(editIndex: buildIndex),
                    ),
                  ).then((_) {
                    buildState.updateBuildItem(buildIndex, BuildItem(
                      name: buildItem.name,
                      selectedCpu: buildState.selectedCpu,
                      selectedGpu: buildState.selectedGpu,
                      selectedMemory: buildState.selectedMemory,
                      selectedStorage: buildState.selectedStorage,
                      selectedCooler: buildState.selectedCooler,
                      selectedFonte: buildState.selectedFonte,
                      selectedCase: buildState.selectedCase,
                      totalCost: buildState.getTotalCost(),
                      totalTdp: buildState.getTotalTdp(),
                    ));
                  });
                },
              ),
              SizedBox(height: 10),
              buildEditableComponent(
                context,
                'Cooler',
                buildState.selectedCooler,
                Icons.wind_power_rounded,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectCoolerPage(editIndex: buildIndex),
                    ),
                  ).then((_) {
                    buildState.updateBuildItem(buildIndex, BuildItem(
                      name: buildItem.name,
                      selectedCpu: buildState.selectedCpu,
                      selectedGpu: buildState.selectedGpu,
                      selectedMemory: buildState.selectedMemory,
                      selectedStorage: buildState.selectedStorage,
                      selectedCooler: buildState.selectedCooler,
                      selectedFonte: buildState.selectedFonte,
                      selectedCase: buildState.selectedCase,
                      totalCost: buildState.getTotalCost(),
                      totalTdp: buildState.getTotalTdp(),
                    ));
                  });
                },
              ),
              SizedBox(height: 10),
              buildEditableComponent(
                context,
                'Fonte',
                buildState.selectedFonte,
                Icons.energy_savings_leaf_rounded,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectPSUPage(editIndex: buildIndex),
                    ),
                  ).then((_) {
                    buildState.updateBuildItem(buildIndex, BuildItem(
                      name: buildItem.name,
                      selectedCpu: buildState.selectedCpu,
                      selectedGpu: buildState.selectedGpu,
                      selectedMemory: buildState.selectedMemory,
                      selectedStorage: buildState.selectedStorage,
                      selectedCooler: buildState.selectedCooler,
                      selectedFonte: buildState.selectedFonte,
                      selectedCase: buildState.selectedCase,
                      totalCost: buildState.getTotalCost(),
                      totalTdp: buildState.getTotalTdp(),
                    ));
                  });
                },
              ),
              SizedBox(height: 10),
              buildEditableComponent(
                context,
                'Gabinete',
                buildState.selectedCase,
                Icons.business,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectCasePage(editIndex: buildIndex),
                    ),
                  ).then((_) {
                    buildState.updateBuildItem(buildIndex, BuildItem(
                      name: buildItem.name,
                      selectedCpu: buildState.selectedCpu,
                      selectedGpu: buildState.selectedGpu,
                      selectedMemory: buildState.selectedMemory,
                      selectedStorage: buildState.selectedStorage,
                      selectedCooler: buildState.selectedCooler,
                      selectedFonte: buildState.selectedFonte,
                      selectedCase: buildState.selectedCase,
                      totalCost: buildState.getTotalCost(),
                      totalTdp: buildState.getTotalTdp(),
                    ));
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Captura os valores atualizados de custo total e TDP
                  double totalCost = buildState.getTotalCost();
                  int totalTdp = buildState.getTotalTdp();

                  // Armazena as seleções atuais
                  BuildComponent? selectedCpu = buildState.selectedCpu;
                  BuildComponent? selectedGpu = buildState.selectedGpu;
                  BuildComponent? selectedMemory = buildState.selectedMemory;
                  BuildComponent? selectedStorage = buildState.selectedStorage;
                  BuildComponent? selectedCooler = buildState.selectedCooler;
                  BuildComponent? selectedFonte = buildState.selectedFonte;
                  BuildComponent? selectedCase = buildState.selectedCase;

                  // Limpa as seleções no estado
                  Provider.of<BuildState>(context, listen: false).clearSelections();

                  // Atualiza o item de construção com as seleções armazenadas e valores atualizados
                  buildState.updateBuildItem(
                    buildIndex,
                    BuildItem(
                      name: buildItem.name,
                      selectedCpu: selectedCpu,
                      selectedGpu: selectedGpu,
                      selectedMemory: selectedMemory,
                      selectedStorage: selectedStorage,
                      selectedCooler: selectedCooler,
                      selectedFonte: selectedFonte,
                      selectedCase: selectedCase,
                      totalCost: totalCost,
                      totalTdp: totalTdp,
                    ),
                  );

                  // Fecha a página de edição e retorna à MyBuildPage com dados atualizados
                  Navigator.of(context).pop(); // Volta para a página anterior
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Salvar mudanças',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEditableComponent(BuildContext context, String title, BuildComponent? component,
      IconData icon, VoidCallback onTap) {
    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 30),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          component != null ? component.name : 'Nenhum selecionado',
          style: TextStyle(
            color: Colors.white70,
            fontFamily: 'Poppins',
            fontSize: 16,
          ),
        ),
        trailing: Icon(Icons.edit, color: Colors.white, size: 20),
        onTap: onTap,
      ),
    );
  }
}




// Custom Build Page
class CustomBuildPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<BuildState>(context, listen: false).clearSelections();
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF000000), // Dark background color
        appBar: AppBar(
          title: Text(
            'Montagem 🔧',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
            tooltip: 'Voltar',
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.cleaning_services, color: Colors.white),
              onPressed: () {
                Provider.of<BuildState>(context, listen: false).clearSelections();
              },
              tooltip: 'Limpar Seleções',
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  'Especificações',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                _buildComponents(context),
                SizedBox(height: 20),
                _buildSummary(context),
                SizedBox(height: 20),
                _buildActions(context),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComponents(BuildContext context) {
    return Consumer<BuildState>(
      builder: (context, buildState, child) {
        return Column(
          children: [
            _buildComponent(
              context,
              buildState.selectedCpu,
              'CPU',
              Icons.memory,
              'Adicionar Processador',
              SelectCPUPage(),
            ),
            _buildComponent(
              context,
              buildState.selectedGpu,
              'GPU',
              Icons.tv,
              'Adicionar Placa de vídeo',
              SelectGPUPage(),
            ),
            _buildComponent(
              context,
              buildState.selectedMemory,
              'Memoria ram',
              Icons.sd_card,
              'Adicionar Memoria ram',
              SelectMemoryPage(),
            ),
            _buildComponent(
              context,
              buildState.selectedStorage,
              'Armazenamento',
              Icons.storage_rounded,
              'Adicionar Armazenamento',
              SelectStoragePage(),
            ),
            _buildComponent(
              context,
              buildState.selectedCooler,
              'Cooler',
              Icons.wind_power_rounded,
              'Adicionar Cooler',
              SelectCoolerPage(),
            ),
            _buildComponent(
              context,
              buildState.selectedFonte,
              'Fonte',
              Icons.energy_savings_leaf_rounded,
              'Adicionar Fonte',
              SelectPSUPage(),
            ),
            _buildComponent(
              context,
              buildState.selectedCase,
              'Gabinete',
              Icons.business,
              'Adicionar Gabinete',
              SelectCasePage(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildComponent(
    BuildContext context,
    BuildComponent? component,
    String label,
    IconData icon,
    String buttonText,
    Widget page,
  ) {
    return component != null
        ? buildSelectedComponent(context, component, label)
        : buildCustomButton(icon, buttonText, context, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          });
  }

  Widget _buildSummary(BuildContext context) {
    return Consumer<BuildState>(
      builder: (context, buildState, child) {
        return Column(
          children: [
            Text(
              'Watts: ${buildState.getTotalTdp()} W',
              style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Poppins'),
            ),
            SizedBox(height: 10),
            Text(
              'Valor Total: R\$${buildState.getTotalCost().toStringAsFixed(2)}',
              style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Poppins'),
            ),
          ],
        );
      },
    );
  }

 bool _allComponentsSelected(BuildState buildState) {
  return buildState.selectedCpu != null &&
         buildState.selectedGpu != null &&
         buildState.selectedMemory != null &&
         buildState.selectedStorage != null &&
         buildState.selectedCooler != null &&
         buildState.selectedFonte != null &&
         buildState.selectedCase != null;
}

void _showIncompleteSelectionMessage(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Você esqueceu de escolher alguma peça')),
  );
}

ButtonStyle _blueButtonStyle() {
  return ElevatedButton.styleFrom(
    foregroundColor: Colors.white, backgroundColor: Colors.blue, // Cor do texto e ícone
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20), // Bordas arredondadas
    ),
    elevation: 5, // Sombra
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget buildBottomButton(IconData icon, String label, BuildContext context, VoidCallback onPressed) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    icon: Icon(icon),
    label: Text(label),
    style: _blueButtonStyle(),
  );
}

Widget _buildActions(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      buildBottomButton(Icons.print, 'Ver em PDF', context, () async {
        final buildState = Provider.of<BuildState>(context, listen: false);

        if (!_allComponentsSelected(buildState)) {
          _showIncompleteSelectionMessage(context);
          return;
        }

        final doc = pw.Document();
        doc.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Montagem Personalizada',
                      style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 16),
                  _buildPdfText('Processador', buildState.selectedCpu?.name),
                  _buildPdfText('Placa de vídeo', buildState.selectedGpu?.name),
                  _buildPdfText('Memoria ram', buildState.selectedMemory?.name),
                  _buildPdfText('Armazenamento', buildState.selectedStorage?.name),
                  _buildPdfText('Cooler', buildState.selectedCooler?.name),
                  _buildPdfText('Fonte', buildState.selectedFonte?.name),
                  _buildPdfText('Gabinete', buildState.selectedCase?.name),
                  pw.SizedBox(height: 16),
                  pw.Text('Valor total: R\$${buildState.getTotalCost().toStringAsFixed(2)}',
                      style: pw.TextStyle(fontSize: 18)),
                  pw.Text('Minímo de Watts necessário: ${buildState.getTotalTdp()} W',
                      style: pw.TextStyle(fontSize: 18)),
                ],
              );
            },
          ),
        );
        await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
      }),
      buildBottomButton(Icons.save, 'Salvar', context, () {
        final buildState = Provider.of<BuildState>(context, listen: false);

        if (!_allComponentsSelected(buildState)) {
          _showIncompleteSelectionMessage(context);
          return;
        }

        showDialog(
          context: context,
          builder: (context) {
            TextEditingController _controller = TextEditingController();
            return AlertDialog(
              title: Text('Salvar Configuração'),
              content: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Coloque um nome para sua configuração',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    if (_controller.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Nome inválido')),
                      );
                    } else {
                      final buildItem = BuildItem(
                        name: _controller.text,
                        selectedCpu: buildState.selectedCpu,
                        selectedGpu: buildState.selectedGpu,
                        selectedMemory: buildState.selectedMemory,
                        selectedStorage: buildState.selectedStorage,
                        selectedCooler: buildState.selectedCooler,
                        selectedFonte: buildState.selectedFonte,
                        selectedCase: buildState.selectedCase,
                        totalCost: buildState.getTotalCost(),
                        totalTdp: buildState.getTotalTdp(),
                      );

                      buildState.addBuildItem(buildItem);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => MyBuildPage()),
                      );
                    }
                  },
                  child: Text('Salvar'),
                ),
              ],
            );
          },
        );
      }),
    ],
  );
}



  pw.Widget _buildPdfText(String label, String? value) {
    return pw.Text(
      '$label: ${value ?? "N/A"}',
      style: pw.TextStyle(fontSize: 18),
    );
  }
}



  Widget buildSelectedComponent(
      BuildContext context, BuildComponent component, String type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              Icon(Icons.check, color: const Color.fromARGB(255, 59, 160, 255), size: 40),
              SizedBox(height: 10),
              Text(
                '$type: ${component.name}',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCustomButton(IconData icon, String text, BuildContext context,
      VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                Icon(icon, color: const Color.fromARGB(255, 255, 255, 255), size: 40),
                SizedBox(height: 10),
                Text(
                  text,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBottomButton(IconData icon, String text,
      [BuildContext? context, VoidCallback? onPressed]) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 30),
          SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }




//Peças 

class SelectCPUPage extends StatelessWidget {
  final int? editIndex;

  SelectCPUPage({this.editIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white), // Ícone de voltar branco
          onPressed: () {
            Navigator.of(context).pop(); // Volta para a página anterior
          },
          tooltip: 'Voltar', // Texto que aparece ao passar o mouse sobre o ícone
        ),
        backgroundColor: Colors.black,
        title: Text(
          'Escolha um Processador',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins', // Define a fonte Poppins no título
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              buildCpuCard(
                context,
                'AMD Ryzen 9 7950X',
                4700,
                170,
                'assets/amd.jpg',
                'Contagem de núcleos: 16\nClock do núcleo: 4,5 GHz\nClock de boost: 5,7 GHz\nSoquete: AM5\nTDP: 170 W\nGráficos integrados: Radeon',
              ),
              buildCpuCard(
                context,
                'AMD Ryzen 7 7800X3D 4.2 GHz 8-Core Processor',
                3350,
                120,
                'assets/amd1.jpg',
                'Contagem de núcleos: 8\nClock do núcleo: 4,2 GHz\nClock de boost: 5 GHz\nSoquete: AM5\nTDP: 120 W\nGráficos integrados: Radeon',
              ),
              buildCpuCard(
                context,
                'AMD Ryzen 5 5600X',
                2200,
                65,
                'assets/amd2.jpg',
                'Contagem de núcleos: 6\nClock do núcleo: 3,7 GHz\nClock de boost: 4,6 GHz\nSoquete: AM4\nTDP: 65 W\nGráficos integrados: None',
              ),
              buildCpuCard(
                context,
                'Intel Core i9-14900K',
                8500,
                125,
                'assets/intel.jpg',
                'Contagem de núcleos: 24\nClock do núcleo: 3,2 GHz\nClock de boost: 6 GHz\nSoquete: LGA1700\nTDP: 125 W\nGráficos integrados: Intel UHD',
              ),
              buildCpuCard(
                context,
                'Intel Core i7-13700K',
                4500,
                125,
                'assets/intel1.jpg',
                'Contagem de núcleos: 16\nClock do núcleo: 3,4 GHz\nClock de boost: 5,4 GHz\nSoquete: LGA1700\nTDP: 125 W\nGráficos integrados: Intel UHD',
              ),
              buildCpuCard(
                context,
                'Intel Core i5-12600K',
                2750,
                125,
                'assets/intel3.jpg',
                'Contagem de núcleos: 10\nClock do núcleo: 3,7 GHz\nClock de boost: 4,9 GHz\nSoquete: LGA1700\nTDP: 125 W\nGráficos integrados: Intel UHD',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCpuCard(BuildContext context, String title, double price, int tdp,
      String imagePath, String specs) {
    final component = BuildComponent(name: title, cost: price, tdp: tdp);
    return buildCard(context, title, price, imagePath, specs, component);
  }

  Widget buildCard(BuildContext context, String title, double price, String imagePath,
      String specs, BuildComponent component) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  imagePath,
                  width: 80,
                  height: 80,
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        specs,
                        style: TextStyle(color: Colors.white70, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'R\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<BuildState>(context, listen: false).selectCpu(component);
                    if (editIndex != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBuildPage(
                            buildItem: Provider.of<BuildState>(context, listen: false)
                                .buildItems[editIndex!],
                            buildIndex: editIndex!,
                          ),
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    'Adicionar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class SelectGPUPage extends StatelessWidget {
  final int? editIndex;

  SelectGPUPage({this.editIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
          tooltip: 'Voltar',
        ),
        backgroundColor: Colors.black,
        title: Text(
          'Escolha uma Placa de vídeo',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              buildGpuCard(
                context,
                'NVIDIA GeForce RTX 3080 Ti',
                3500,
                320,
                'assets/gpu.jpg',
                'Arquitetura: Ampere\nNúcleos CUDA: 10240\nClock do núcleo: 1365 MHz\nBoost Clock: 1665 MHz\nVRAM: 12GB GDDR6X\nTDP: 320W',
              ),
              buildGpuCard(
                context,
                'NVIDIA GeForce RTX 3060 Ti',
                2800,
                300,
                'assets/gpu1.jpg',
                'Arquitetura: RDNA 2\nNúcleos de computação: 4608\nClock do núcleo: 1825 MHz\nBoost Clock: 2250 MHz\nVRAM: 16GB GDDR6\nTDP: 300W',
              ),
              buildGpuCard(
                context,
                'NVIDIA GeForce RTX 3070 Ti',
                2200,
                290,
                'assets/gpu2.jpg',
                'Arquitetura: Ampere\nNúcleos CUDA: 6144\nClock do núcleo: 1575 MHz\nBoost Clock: 1770 MHz\nVRAM: 8GB GDDR6X\nTDP: 290W',
              ),
              buildGpuCard(
                context,
                'AMD Radeon RX 6700 XT',
                1500,
                230,
                'assets/gpu3.jpg',
                'Arquitetura: RDNA 2\nNúcleos de computação: 2560\nClock do núcleo: 2424 MHz\nBoost Clock: 2581 MHz\nVRAM: 12GB GDDR6\nTDP: 230W',
              ),
              buildGpuCard(
                context,
                'AMD Radeon RX 6800 XT',
                1200,
                200,
                'assets/gpu4.jpg',
                'Arquitetura: Ampere\nNúcleos CUDA: 4864\nClock do núcleo: 1410 MHz\nBoost Clock: 1665 MHz\nVRAM: 8GB GDDR6\nTDP: 200W',
              ),
              buildGpuCard(
                context,
                'AMD Radeon RX 6600 XT',
                700,
                160,
                'assets/gpu5.jpg',
                'Arquitetura: RDNA 2\nNúcleos de computação: 2048\nClock do núcleo: 1968 MHz\nBoost Clock: 2581 MHz\nVRAM: 8GB GDDR6\nTDP: 160W',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGpuCard(BuildContext context, String title, double price, int tdp,
      String imagePath, String specs) {
    final component = BuildComponent(name: title, cost: price, tdp: tdp);
    return buildCard(context, title, price, imagePath, specs, component);
  }

  Widget buildCard(BuildContext context, String title, double price, String imagePath,
      String specs, BuildComponent component) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  imagePath,
                  width: 80,
                  height: 80,
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        specs,
                        style: TextStyle(color: Colors.white70, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'R\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<BuildState>(context, listen: false).selectGpu(component);
                    if (editIndex != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBuildPage(
                            buildItem: Provider.of<BuildState>(context, listen: false)
                                .buildItems[editIndex!],
                            buildIndex: editIndex!,
                          ),
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    'Adicionar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class SelectCoolerPage extends StatelessWidget {
  final int? editIndex;

  SelectCoolerPage({this.editIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
          tooltip: 'Voltar',
        ),
        backgroundColor: Colors.black,
        title: Text(
          'Escolha um Cooler',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              buildCoolerCard(
                context,
                'Cooler Master Hyper 212',
                199,
                40,
                'assets/cooler.jpg',
                'Tipo: Air Cooler\nCompatibilidade de Soquete: AM4, LGA1200\nFluxo de Ar: 42 CFM\nTDP: 180 W\nNível de Ruído: 36 dB(A)',
                'Cooler Master',
              ),
              buildCoolerCard(
                context,
                'Noctua NH-D15',
                800,
                90,
                'assets/cooler1.jpg',
                'Tipo: Air Cooler\nCompatibilidade de Soquete: AM4, LGA1200\nFluxo de Ar: 82.5 CFM\nTDP: 250 W\nNível de Ruído: 24.6 dB(A)',
                'Noctua',
              ),
              buildCoolerCard(
                context,
                'NZXT Kraken X63',
                1040,
                150,
                'assets/cooler2.jpg',
                'Tipo: Water Cooler\nCompatibilidade de Soquete: AM4, LGA1200\nFluxo de Ar: 98.17 CFM\nTDP: 280 W\nNível de Ruído: 21 dB(A)',
                'NZXT',
              ),
              buildCoolerCard(
                context,
                'Corsair H100i RGB Platinum',
                600,
                160,
                'assets/cooler3.jpg',
                'Tipo: Water Cooler\nCompatibilidade de Soquete: AM4, LGA1200\nFluxo de Ar: 63 CFM\nTDP: 240 W\nNível de Ruído: 37 dB(A)',
                'Corsair',
              ),
              buildCoolerCard(
                context,
                'Be Quiet! Dark Rock Pro 4',
                1000,
                80,
                'assets/cooler4.jpg',
                'Tipo: Air Cooler\nCompatibilidade de Soquete: AM4, LGA1200\nFluxo de Ar: 75.16 CFM\nTDP: 250 W\nNível de Ruído: 24.3 dB(A)',
                'Be Quiet!',
              ),
              buildCoolerCard(
                context,
                'Deepcool Castle 360EX',
                1100,
                170,
                'assets/cooler5.jpg',
                'Tipo: Water Cooler\nCompatibilidade de Soquete: AM4, LGA1200\nFluxo de Ar: 70.28 CFM\nTDP: 300 W\nNível de Ruído: 35.6 dB(A)',
                'Deepcool',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCoolerCard(
    BuildContext context,
    String title,
    double price,
    int tdp,
    String imagePath,
    String specs,
    String brand,
  ) {
    final component = BuildComponent(name: title, cost: price, tdp: tdp);
    return buildCard(context, title, price, imagePath, specs, component, brand);
  }

  Widget buildCard(
    BuildContext context,
    String title,
    double price,
    String imagePath,
    String specs,
    BuildComponent component,
    String brand,
  ) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Marca: $brand',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        specs,
                        style: TextStyle(
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'R\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<BuildState>(context, listen: false)
                        .selectCooler(component);
                    if (editIndex != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBuildPage(
                            buildItem: Provider.of<BuildState>(context, listen: false)
                                .buildItems[editIndex!],
                            buildIndex: editIndex!,
                          ),
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    'Adicionar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



class SelectMemoryPage extends StatelessWidget {
  final int? editIndex;

  SelectMemoryPage({this.editIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
          tooltip: 'Voltar',
        ),
        backgroundColor: Colors.black,
        title: Text(
          'Escolha uma Memoria RAM',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildMemoryCard(
                context,
                'Corsair Vengeance LPX 16GB (2 x 8GB) DDR4-3200',
                320,
                10,
                'assets/ram.jpg',
                'Capacidade: 16GB (2 x 8GB)\nVelocidade: 3200MHz\nTipo: DDR4\nLatência: CL16',
              ),
              buildMemoryCard(
                context,
                'G.Skill Trident Z RGB 32GB (2 x 16GB) DDR4-3600',
                840,
                12,
                'assets/ram1.jpg',
                'Capacidade: 32GB (2 x 16GB)\nVelocidade: 3600MHz\nTipo: DDR4\nLatência: CL18',
              ),
              buildMemoryCard(
                context,
                'Kingston HyperX Fury 16GB (2 x 8GB) DDR4-2666',
                737,
                10,
                'assets/ram2.jpg',
                'Capacidade: 16GB (2 x 8GB)\nVelocidade: 2666MHz\nTipo: DDR4\nLatência: CL15',
              ),
              buildMemoryCard(
                context,
                'Corsair Dominator Platinum 32GB (2 x 16GB) DDR4-3200',
                810,
                14,
                'assets/ram3.jpg',
                'Capacidade: 32GB (2 x 16GB)\nVelocidade: 3200MHz\nTipo: DDR4\nLatência: CL16',
              ),
              buildMemoryCard(
                context,
                'G.Skill Ripjaws V 16GB (2 x 8GB) DDR4-3000',
                750,
                11,
                'assets/ram4.jpg',
                'Capacidade: 16GB (2 x 8GB)\nVelocidade: 3000MHz\nTipo: DDR4\nLatência: CL15',
              ),
              buildMemoryCard(
                context,
                'Corsair Vengeance RGB Pro 32GB (2 x 16GB) DDR4-3200',
                650,
                13,
                'assets/ram5.jpg',
                'Capacidade: 32GB (2 x 16GB)\nVelocidade: 3200MHz\nTipo: DDR4\nLatência: CL16',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMemoryCard(BuildContext context, String title, double price, int tdp,
      String imagePath, String specs) {
    final component = BuildComponent(name: title, cost: price, tdp: tdp);
    return buildCard(context, title, price, imagePath, specs, component);
  }

  Widget buildCard(BuildContext context, String title, double price, String imagePath,
      String specs, BuildComponent component) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  imagePath,
                  width: 80,
                  height: 80,
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        specs,
                        style: TextStyle(color: Colors.white70, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'R\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<BuildState>(context, listen: false)
                        .selectMemory(component);
                    if (editIndex != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBuildPage(
                            buildItem: Provider.of<BuildState>(context,
                                    listen: false)
                                .buildItems[editIndex!],
                            buildIndex: editIndex!,
                          ),
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    'Adicionar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SelectStoragePage extends StatelessWidget {
  final int? editIndex;

  SelectStoragePage({this.editIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
          tooltip: 'Voltar',
        ),
        backgroundColor: Colors.black,
        title: Text(
          'Escolha um Armazenamento',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildStorageCard(
                context,
                'Samsung 970 EVO Plus 1TB',
                850,
                'M.2 NVMe',
                'assets/espaco.jpg',
                'Leitura Sequencial: 3500 MB/s\nGravação Sequencial: 3300 MB/s\nInterface: PCIe 3.0 x4\nTipo de NAND: V-NAND 3-bit MLC',
              ),
              buildStorageCard(
                context,
                'Crucial MX500 2TB',
                770,
                '2.5"',
                'assets/espaco1.jpg',
                'Leitura Sequencial: 560 MB/s\nGravação Sequencial: 510 MB/s\nInterface: SATA III\nTipo de NAND: 3D NAND',
              ),
              buildStorageCard(
                context,
                'WD Blue SN550 500GB',
                370,
                'M.2 NVMe',
                'assets/espaco2.jpg',
                'Leitura Sequencial: 2400 MB/s\nGravação Sequencial: 1950 MB/s\nInterface: PCIe 3.0 x4\nTipo de NAND: 3D NAND',
              ),
              buildStorageCard(
                context,
                'Seagate Barracuda 2TB',
                255,
                '2.5"',
                'assets/espaco3.jpg',
                'Leitura Sequencial: 220 MB/s\nGravação Sequencial: 185 MB/s\nInterface: SATA III\nTipo de NAND: N/A',
              ),
              buildStorageCard(
                context,
                'Samsung 870 QVO 4TB',
                2500,
                '2.5"',
                'assets/espaco4.jpg',
                'Leitura Sequencial: 560 MB/s\nGravação Sequencial: 530 MB/s\nInterface: SATA III\nTipo de NAND: QLC',
              ),
              buildStorageCard(
                context,
                'Sabrent Rocket Q 2TB',
                1880,
                'M.2 NVMe',
                'assets/espaco5.jpg',
                'Leitura Sequencial: 3200 MB/s\nGravação Sequencial: 2900 MB/s\nInterface: PCIe 3.0 x4\nTipo de NAND: QLC',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStorageCard(
    BuildContext context,
    String title,
    double price,
    String type,
    String imagePath,
    String specs,
  ) {
    final component = BuildComponent(name: title, cost: price, tdp: 0);
    return buildCard(context, title, price, imagePath, specs, component, type);
  }

  Widget buildCard(
    BuildContext context,
    String title,
    double price,
    String imagePath,
    String specs,
    BuildComponent component,
    String type,
  ) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  imagePath,
                  width: 80,
                  height: 80,
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Tipo: $type',
                        style: TextStyle(
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        specs,
                        style: TextStyle(color: Colors.white70, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'R\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<BuildState>(context, listen: false)
                        .selectStorage(component);
                    if (editIndex != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBuildPage(
                            buildItem: Provider.of<BuildState>(context,
                                    listen: false)
                                .buildItems[editIndex!],
                            buildIndex: editIndex!,
                          ),
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    'Adicionar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class SelectPSUPage extends StatelessWidget {
  final int? editIndex;

  SelectPSUPage({this.editIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
          tooltip: 'Voltar',
        ),
        backgroundColor: Colors.black,
        title: Text(
          'Escolha uma Fonte',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildPsuCard(
                context,
                'Corsair RM750x 750W 80+ Gold',
                691,
                'Corsair',
                'assets/fonte.jpg',
                'Potência: 750W\nCertificação: 80+ Gold\nModular: Totalmente\nConectores: ATX, EPS, PCIe, SATA',
                0,
              ),
              buildPsuCard(
                context,
                'EVGA SuperNOVA 650 G5 80+ Gold',
                980,
                'EVGA',
                'assets/fonte1.jpg',
                'Potência: 650W\nCertificação: 80+ Gold\nModular: Totalmente\nConectores: ATX, EPS, PCIe, SATA',
                0,
              ),
              buildPsuCard(
                context,
                'Cooler Master MWE Gold 650W 80+ Gold',
                1241,
                'Cooler Master',
                'assets/fonte2.jpg',
                'Potência: 650W\nCertificação: 80+ Gold\nModular: Parcial\nConectores: ATX, EPS, PCIe, SATA',
                0,
              ),
              buildPsuCard(
                context,
                'Seasonic FOCUS GX-550 550W 80+ Gold',
                270,
                'Seasonic',
                'assets/fonte3.jpg',
                'Potência: 550W\nCertificação: 80+ Gold\nModular: Totalmente\nConectores: ATX, EPS, PCIe, SATA',
                0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPsuCard(
    BuildContext context,
    String title,
    double price,
    String brand,
    String imagePath,
    String specs,
    int tdp,
  ) {
    final component = BuildComponent(name: title, cost: price, tdp: tdp);
    return buildCard(context, title, price, imagePath, specs, component);
  }

  Widget buildCard(
    BuildContext context,
    String title,
    double price,
    String imagePath,
    String specs,
    BuildComponent component,
  ) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  imagePath,
                  width: 80,
                  height: 80,
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        specs,
                        style: TextStyle(color: Colors.white70, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'R\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<BuildState>(context, listen: false)
                        .selectFonte(component);
                    if (editIndex != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBuildPage(
                            buildItem: Provider.of<BuildState>(context,
                                    listen: false)
                                .buildItems[editIndex!],
                            buildIndex: editIndex!,
                          ),
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    'Adicionar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SelectCasePage extends StatelessWidget {
  final int? editIndex;

  SelectCasePage({this.editIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
          tooltip: 'Voltar',
        ),
        backgroundColor: Colors.black,
        title: Text(
          'Escolha um Gabinete',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              buildCaseCard(
                context,
                'NZXT H510',
                585,
                'NZXT',
                'assets/case.jpg',
                'Formato: Mid Tower\nSuporte GPU: até 381mm\nSuporte Radiador: Até 280mm\nBaias: 2x 3.5" + 2x 2.5"',
              ),
              buildCaseCard(
                context,
                'Corsair iCUE 4000X RGB',
                1175,
                'Corsair',
                'assets/case1.jpg',
                'Formato: Mid Tower\nSuporte GPU: até 360mm\nSuporte Radiador: Até 360mm\nBaias: 2x 3.5" + 2x 2.5"',
              ),
              buildCaseCard(
                context,
                'Cooler Master MasterBox Q300L',
                1151,
                'Cooler Master',
                'assets/case2.jpg',
                'Formato: Micro ATX\nSuporte GPU: até 360mm\nSuporte Radiador: Até 240mm\nBaias: 1x 3.5" + 2x 2.5"',
              ),
              buildCaseCard(
                context,
                'Fractal Design Meshify C',
                974,
                'Fractal Design',
                'assets/case3.jpg',
                'Formato: Mid Tower\nSuporte GPU: até 315mm\nSuporte Radiador: Até 360mm\nBaias: 2x 3.5" + 3x 2.5"',
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget buildCaseCard(BuildContext context, String title, double price, String brand, String imagePath, String specs) {
    final component = BuildComponent(name: title, cost: price, tdp: 0);
    return buildCard(context, title, price, imagePath, specs, component, brand);
  }

  Widget buildCard(BuildContext context, String title, double price, String imagePath, String specs, BuildComponent component, String brand) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Marca: $brand',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        specs,
                        style: TextStyle(color: Colors.white70, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'R\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<BuildState>(context, listen: false)
                        .selectCase(component);
                    if (editIndex != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBuildPage(
                            buildItem: Provider.of<BuildState>(context, listen: false)
                                .buildItems[editIndex!],
                            buildIndex: editIndex!,
                          ),
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    'Adicionar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}