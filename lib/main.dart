import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const BriefingApp());
}

class BriefingApp extends StatelessWidget {
  const BriefingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Briefing Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String selectedDay = 'Senin';
  final List<String> days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
  final List<String> monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
  ];

  // Data Umum Laporan
  final TextEditingController tanggalCtrl = TextEditingController();
  final TextEditingController salesKemarinCtrl = TextEditingController();
  
  // KPI (ATU & ATV)
  bool isKpiAllGood = false;
  final TextEditingController atuCtrl = TextEditingController();
  final TextEditingController atvCtrl = TextEditingController();

  final TextEditingController wtdCtrl = TextEditingController();
  final TextEditingController mtdCtrl = TextEditingController();
  final TextEditingController todayFokusCtrl = TextEditingController();

  // Dept Minus & Info Tambahan (Multi-line)
  final TextEditingController deptMinusCtrl = TextEditingController();
  final TextEditingController infoTambahanCtrl = TextEditingController();

  // Input Per Staff (Sales / Target)
  final TextEditingController arlyCtrl = TextEditingController();
  final TextEditingController achmadCtrl = TextEditingController();
  final TextEditingController amandaCtrl = TextEditingController();
  final TextEditingController titaniaCtrl = TextEditingController();
  final TextEditingController fujiCtrl = TextEditingController();
  final TextEditingController poppyCtrl = TextEditingController();
  final TextEditingController glendyCtrl = TextEditingController();

  // Input House Brand (HB) Per Staff
  final TextEditingController arlyHbCtrl = TextEditingController();
  final TextEditingController achmadHbCtrl = TextEditingController();
  final TextEditingController amandaHbCtrl = TextEditingController();
  final TextEditingController titaniaHbCtrl = TextEditingController();
  final TextEditingController fujiHbCtrl = TextEditingController();
  final TextEditingController poppyHbCtrl = TextEditingController();
  final TextEditingController glendyHbCtrl = TextEditingController();

  // Catatan & Fokus
  final TextEditingController fokusCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setToday();
  }

  void _updateDateAndDay(DateTime dt) {
    setState(() {
      selectedDay = days[dt.weekday - 1];
      tanggalCtrl.text = "${dt.day} ${monthNames[dt.month - 1]} ${dt.year}";
    });
  }

  void _setToday() {
    _updateDateAndDay(DateTime.now());
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      _updateDateAndDay(picked);
    }
  }

  String generateText() {
    StringBuffer sb = StringBuffer();
    sb.writeln('$selectedDay ${tanggalCtrl.text}');
    
    if (salesKemarinCtrl.text.isNotEmpty) sb.writeln('Sales kemarin ${salesKemarinCtrl.text}');

    // Format KPI (All Good / Standard)
    bool hasKpiData = atuCtrl.text.isNotEmpty || atvCtrl.text.isNotEmpty || isKpiAllGood;
    if (hasKpiData) {
      if (isKpiAllGood) {
        sb.writeln('KPI all good');
      } else {
        sb.writeln('KPI');
      }
      if (atvCtrl.text.isNotEmpty) sb.writeln('- ATV ${atvCtrl.text}');
      if (atuCtrl.text.isNotEmpty) sb.writeln('- ATU ${atuCtrl.text}');
    }

    if (wtdCtrl.text.isNotEmpty) sb.writeln('WTD ${wtdCtrl.text}');
    if (mtdCtrl.text.isNotEmpty) sb.writeln('MTD ${mtdCtrl.text}');
    if (todayFokusCtrl.text.isNotEmpty) sb.writeln('Today fokus di ${todayFokusCtrl.text}');

    // Format Dept Minus
    if (deptMinusCtrl.text.isNotEmpty) {
      sb.writeln('\nDept minus:');
      sb.writeln(deptMinusCtrl.text);
    }
    
    // Format Informasi Tambahan
    if (infoTambahanCtrl.text.isNotEmpty) {
      sb.writeln('\nInformasi Tambahan:');
      sb.writeln(infoTambahanCtrl.text);
    }

    // Format Pencapaian Staff
    sb.writeln('\nPencapaian / Target Staff:');
    if (arlyCtrl.text.isNotEmpty) sb.writeln('Arly ${arlyCtrl.text}${arlyHbCtrl.text.isNotEmpty ? " . ${arlyHbCtrl.text}HB" : ""}');
    if (achmadCtrl.text.isNotEmpty) sb.writeln('Achmad ${achmadCtrl.text}${achmadHbCtrl.text.isNotEmpty ? " . ${achmadHbCtrl.text}HB" : ""}');
    if (amandaCtrl.text.isNotEmpty) sb.writeln('Amanda ${amandaCtrl.text}${amandaHbCtrl.text.isNotEmpty ? " . ${amandaHbCtrl.text}HB" : ""}');
    if (titaniaCtrl.text.isNotEmpty) sb.writeln('Titania ${titaniaCtrl.text}${titaniaHbCtrl.text.isNotEmpty ? " . ${titaniaHbCtrl.text}HB" : ""}');
    if (fujiCtrl.text.isNotEmpty) sb.writeln('Fuji ${fujiCtrl.text}${fujiHbCtrl.text.isNotEmpty ? " . ${fujiHbCtrl.text}HB" : ""}');
    if (poppyCtrl.text.isNotEmpty) sb.writeln('Poppy ${poppyCtrl.text}${poppyHbCtrl.text.isNotEmpty ? " . ${poppyHbCtrl.text}HB" : ""}');
    if (glendyCtrl.text.isNotEmpty) sb.writeln('Glendy ${glendyCtrl.text}${glendyHbCtrl.text.isNotEmpty ? " . ${glendyHbCtrl.text}HB" : ""}');

    // Catatan
    if (fokusCtrl.text.isNotEmpty) {
      sb.writeln('\nFokus Sales / Catatan:');
      sb.writeln(fokusCtrl.text);
    }

    return sb.toString();
  }

  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: generateText())).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Format WA berhasil disalin!'),
          backgroundColor: Colors.teal,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Listenable> listenables = [
      tanggalCtrl, salesKemarinCtrl, atuCtrl, atvCtrl, wtdCtrl, mtdCtrl,
      todayFokusCtrl, deptMinusCtrl, infoTambahanCtrl, arlyCtrl, achmadCtrl,
      amandaCtrl, titaniaCtrl, fujiCtrl, poppyCtrl, glendyCtrl,
      arlyHbCtrl, achmadHbCtrl, amandaHbCtrl, titaniaHbCtrl,
      fujiHbCtrl, poppyHbCtrl, glendyHbCtrl, fokusCtrl
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Briefing Generator | Developed by GlendyAnakBaik'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Row(
        children: [
          // PANEL KIRI: FORM INPUT
          Expanded(
            flex: 3,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // SECTION 1: TANGGAL & HARI
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: DropdownButtonFormField<String>(
                            value: selectedDay,
                            decoration: const InputDecoration(labelText: 'Hari', border: OutlineInputBorder()),
                            items: days.map((day) => DropdownMenuItem(value: day, child: Text(day))).toList(),
                            onChanged: (val) => setState(() => selectedDay = val!),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: tanggalCtrl,
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            decoration: InputDecoration(
                              labelText: 'Tanggal',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_month, color: Colors.teal),
                                onPressed: () => _selectDate(context),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: _setToday,
                          icon: const Icon(Icons.today, size: 18),
                          label: const Text('Hari Ini'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                            backgroundColor: Colors.teal.shade100,
                            foregroundColor: Colors.teal.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // SECTION 2: RINGKASAN TOKO & KPI
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Ringkasan Performa Toko', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal)),
                        const SizedBox(height: 12),
                        TextField(
                          controller: salesKemarinCtrl,
                          decoration: const InputDecoration(labelText: 'Sales Kemarin', hintText: 'ex: 26Mio . 113%', border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 12),
                        
                        // CONTAINER KPI
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.teal.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('KPI Status:', style: TextStyle(fontWeight: FontWeight.bold)),
                                  const Spacer(),
                                  FilterChip(
                                    label: const Text('Checkpoint All Good'),
                                    selected: isKpiAllGood,
                                    selectedColor: Colors.teal.shade200,
                                    onSelected: (val) {
                                      setState(() {
                                        isKpiAllGood = val;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: atvCtrl,
                                      decoration: const InputDecoration(labelText: 'ATV', hintText: 'ex: 4.11 / minus 3.42', border: OutlineInputBorder(), isDense: true),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: atuCtrl,
                                      decoration: const InputDecoration(labelText: 'ATU', hintText: 'ex: 6.22', border: OutlineInputBorder(), isDense: true),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(child: TextField(controller: wtdCtrl, decoration: const InputDecoration(labelText: 'WTD', border: OutlineInputBorder(), isDense: true, hintText: 'ex: 8% perday 39mio'))),
                            const SizedBox(width: 8),
                            Expanded(child: TextField(controller: mtdCtrl, decoration: const InputDecoration(labelText: 'MTD', border: OutlineInputBorder(), isDense: true, hintText: 'ex: 12% perday 50mio'))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(controller: todayFokusCtrl, decoration: const InputDecoration(labelText: 'Today Fokus Di', border: OutlineInputBorder(), isDense: true, hintText: 'ex: 50mio')),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // SECTION 3: DEPARTEMEN MINUS
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Departemen Minus', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: deptMinusCtrl,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Rincian Dept Minus',
                            border: OutlineInputBorder(),
                            hintText: 'ex:\nNF minus 18Mio\nToys minus 5Mio',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // SECTION 4: INFORMASI TAMBAHAN
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Informasi Tambahan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: infoTambahanCtrl,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Detail Informasi',
                            border: OutlineInputBorder(),
                            hintText: 'ex:\nPerstaff 1jam wajib 1mio\nTarget minggu ini 10 hari 381mio\nperday sampai akhir bulan 40mio',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // SECTION 5: ANGKA PER STAFF & HB
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Angka Per Staff & HB', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal)),
                        const SizedBox(height: 8),
                        _buildStaffRow('Arly', arlyCtrl, arlyHbCtrl),
                        _buildStaffRow('Achmad', achmadCtrl, achmadHbCtrl),
                        _buildStaffRow('Amanda', amandaCtrl, amandaHbCtrl),
                        _buildStaffRow('Titania', titaniaCtrl, titaniaHbCtrl),
                        _buildStaffRow('Fuji', fujiCtrl, fujiHbCtrl),
                        _buildStaffRow('Poppy', poppyCtrl, poppyHbCtrl),
                        _buildStaffRow('Glendy', glendyCtrl, glendyHbCtrl),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // SECTION 6: CATATAN & FOKUS
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Kata kata hari ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: fokusCtrl,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Catatan',
                            border: OutlineInputBorder(),
                            hintText: 'ex:\nJual NF sebanyak banyaknya\nPush Hb\nsounding promo\nFokus Running tapi tetap fokus cust',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const VerticalDivider(width: 1),

          // PANEL KANAN: PREVIEW TERFORMAT & TOMBOL COPY
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade50,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: copyToClipboard,
                    icon: const Icon(Icons.copy),
                    label: const Text('Salin Format WA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Preview Hasil Teks WA:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: SingleChildScrollView(
                        child: AnimatedBuilder(
                          animation: Listenable.merge(listenables),
                          builder: (context, child) {
                            return Text(
                              generateText(),
                              style: const TextStyle(fontSize: 14, fontFamily: 'monospace', height: 1.4),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaffRow(String name, TextEditingController mainCtrl, TextEditingController? hbCtrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(width: 70, child: Text(name, style: const TextStyle(fontWeight: FontWeight.w500))),
          Expanded(
            child: TextField(
              controller: mainCtrl,
              decoration: const InputDecoration(hintText: 'Nilai/Perday', isDense: true, border: OutlineInputBorder()),
            ),
          ),
          if (hbCtrl != null) ...[
            const SizedBox(width: 8),
            SizedBox(
              width: 75,
              child: TextField(
                controller: hbCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'HB', isDense: true, border: OutlineInputBorder()),
              ),
            ),
          ],
        ],
      ),
    );
  }
}