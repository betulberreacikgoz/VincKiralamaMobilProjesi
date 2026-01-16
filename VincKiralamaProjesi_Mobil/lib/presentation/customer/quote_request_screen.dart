import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vinc_kiralama/presentation/customer/matched_cranes_screen.dart';

class QuoteRequestScreen extends ConsumerStatefulWidget {
  const QuoteRequestScreen({super.key});

  @override
  ConsumerState<QuoteRequestScreen> createState() => _QuoteRequestScreenState();
}

class _QuoteRequestScreenState extends ConsumerState<QuoteRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form Alanları
  String? _selectedCity;
  String? _selectedDistrict;
  String? _selectedJobType;
  String? _selectedSiteType;
  String? _selectedAccessType;
  String? _selectedDuration;
  
  final _heightController = TextEditingController();
  final _loadWeightController = TextEditingController();
  final _jobDescriptionController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();

  // Türkiye'nin 81 İli (Alfabetik)
  final List<String> _cities = [
    'Adana', 'Adıyaman', 'Afyonkarahisar', 'Ağrı', 'Aksaray', 'Amasya', 'Ankara', 'Antalya',
    'Ardahan', 'Artvin', 'Aydın', 'Balıkesir', 'Bartın', 'Batman', 'Bayburt', 'Bilecik',
    'Bingöl', 'Bitlis', 'Bolu', 'Burdur', 'Bursa', 'Çanakkale', 'Çankırı', 'Çorum',
    'Denizli', 'Diyarbakır', 'Düzce', 'Edirne', 'Elazığ', 'Erzincan', 'Erzurum', 'Eskişehir',
    'Gaziantep', 'Giresun', 'Gümüşhane', 'Hakkari', 'Hatay', 'Iğdır', 'Isparta', 'İstanbul',
    'İzmir', 'Kahramanmaraş', 'Karabük', 'Karaman', 'Kars', 'Kastamonu', 'Kayseri', 'Kilis',
    'Kırıkkale', 'Kırklareli', 'Kırşehir', 'Kocaeli', 'Konya', 'Kütahya', 'Malatya', 'Manisa',
    'Mardin', 'Mersin', 'Muğla', 'Muş', 'Nevşehir', 'Niğde', 'Ordu', 'Osmaniye',
    'Rize', 'Sakarya', 'Samsun', 'Şanlıurfa', 'Siirt', 'Sinop', 'Şırnak', 'Sivas',
    'Tekirdağ', 'Tokat', 'Trabzon', 'Tunceli', 'Uşak', 'Van', 'Yalova', 'Yozgat', 'Zonguldak'
  ];

  // İş Türleri (Web ile aynı)
  final List<String> _jobTypes = [
    'Cam silme / dış cephe',
    'Eşya / makine taşıma',
    'Çatı / klima montajı',
    'İnşaat kalıp / beton',
    'Reklam tabelası montajı',
    'Ağaç kesimi / peyzaj',
    'Diğer'
  ];

  // İş Alanı Türü (Web ile aynı)
  final List<String> _siteTypes = [
    'Dar sokak',
    'Cadde üstü',
    'Şantiye alanı',
    'Fabrika / depo içi'
  ];

  // Araç Yaklaşma Durumu (Web ile aynı)
  final List<String> _accessTypes = [
    'Bina dibine kadar yaklaşabilir',
    '5-10 metre mesafede durabilir',
    'Daha uzak, sadece sepet uzanacak'
  ];

  // İş Süresi (Web ile aynı)
  final List<String> _durations = [
    '1 gün',
    '2-3 gün',
    '1 hafta',
    '1 haftadan uzun'
  ];

  // Basit ilçe listesi (Gerçek uygulamada şehre göre dinamik olmalı)
  List<String> get _districts {
    // Şimdilik basit bir liste, ileride şehre göre API'den çekilebilir
    return ['Merkez', 'Diğer İlçeler'];
  }

  @override
  void dispose() {
    _heightController.dispose();
    _loadWeightController.dispose();
    _jobDescriptionController.dispose();
    _customerNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _companyNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _searchMatchingCranes() {
    if (_formKey.currentState!.validate()) {
      final criteria = {
        'city': _selectedCity,
        'district': _selectedDistrict,
        'jobType': _selectedJobType,
        'jobDescription': _jobDescriptionController.text,
        'siteType': _selectedSiteType,
        'accessType': _selectedAccessType,
        'heightMeters': _heightController.text.isNotEmpty ? int.tryParse(_heightController.text) : null,
        'loadWeightKg': _loadWeightController.text.isNotEmpty ? int.tryParse(_loadWeightController.text) : null,
        'duration': _selectedDuration,
        'jobStartDate': _selectedDate,
        'customerName': _customerNameController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'companyName': _companyNameController.text,
        'notes': _notesController.text,
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MatchedCranesScreen(criteria: criteria),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teklif Al', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFFFAB00),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Lütfen aşağıdaki formu doldurun, size en uygun vinç için teklif iletelim.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // A) İŞ TÜRÜ
            const Text('A) İş Türü', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Ne tür bir iş yapılacak? *',
                border: OutlineInputBorder(),
              ),
              value: _selectedJobType,
              items: _jobTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
              onChanged: (value) => setState(() => _selectedJobType = value),
              validator: (value) => value == null ? 'İş türü seçiniz' : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _jobDescriptionController,
              decoration: const InputDecoration(
                labelText: 'İş açıklaması (opsiyonel)',
                border: OutlineInputBorder(),
                hintText: 'Örn: 5. kat cam değişimi, bina önü dar sokak...',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            // B) KONUM
            const Text('B) Konum', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Şehir *',
                border: OutlineInputBorder(),
              ),
              value: _selectedCity,
              items: _cities.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
              onChanged: (value) => setState(() {
                _selectedCity = value;
                _selectedDistrict = null; // Şehir değişince ilçeyi sıfırla
              }),
              validator: (value) => value == null ? 'Şehir seçiniz' : null,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'İlçe',
                border: OutlineInputBorder(),
              ),
              value: _selectedDistrict,
              items: _districts.map((district) => DropdownMenuItem(value: district, child: Text(district))).toList(),
              onChanged: (value) => setState(() => _selectedDistrict = value),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'İş alanı türü *',
                border: OutlineInputBorder(),
              ),
              value: _selectedSiteType,
              items: _siteTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
              onChanged: (value) => setState(() => _selectedSiteType = value),
              validator: (value) => value == null ? 'İş alanı türü seçiniz' : null,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Araç yaklaşma durumu *',
                border: OutlineInputBorder(),
              ),
              value: _selectedAccessType,
              items: _accessTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
              onChanged: (value) => setState(() => _selectedAccessType = value),
              validator: (value) => value == null ? 'Araç yaklaşma durumu seçiniz' : null,
            ),
            const SizedBox(height: 24),

            // C) TEKNİK İHTİYAÇ
            const Text('C) Teknik İhtiyaç', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _heightController,
                    decoration: const InputDecoration(
                      labelText: 'Çalışma yüksekliği (m)',
                      border: OutlineInputBorder(),
                      suffixText: 'm',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _loadWeightController,
                    decoration: const InputDecoration(
                      labelText: 'Yük ağırlığı (kg)',
                      border: OutlineInputBorder(),
                      suffixText: 'kg',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'İş süresi *',
                border: OutlineInputBorder(),
              ),
              value: _selectedDuration,
              items: _durations.map((dur) => DropdownMenuItem(value: dur, child: Text(dur))).toList(),
              onChanged: (value) => setState(() => _selectedDuration = value),
              validator: (value) => value == null ? 'İş süresi seçiniz' : null,
            ),
            const SizedBox(height: 16),

            ListTile(
              title: const Text('İşin Yapılacağı Tarih *'),
              subtitle: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),

            // D) MÜŞTERİ BİLGİLERİ
            const Text('D) Müşteri Bilgileri', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            TextFormField(
              controller: _customerNameController,
              decoration: const InputDecoration(
                labelText: 'Ad Soyad *',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Ad soyad giriniz' : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Telefon *',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) => value == null || value.isEmpty ? 'Telefon giriniz' : null,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-posta (opsiyonel)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _companyNameController,
              decoration: const InputDecoration(
                labelText: 'Firma adı (opsiyonel)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Ek notlar',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            // UYGUN VİNÇLERİ BUL BUTONU
            ElevatedButton.icon(
              onPressed: _searchMatchingCranes,
              icon: const Icon(Icons.search, size: 24),
              label: const Text('UYGUN VİNÇLERİ BUL', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFAB00),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
