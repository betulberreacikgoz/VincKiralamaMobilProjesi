# 🏗️ Vinç Kiralama Mobil Uygulaması

Vinç Kiralama Projesi, vinç kiralama işlemlerini dijitalleştiren, firma ve müşterileri bir araya getiren modern bir mobil uygulamadır. Flutter ile geliştirilmiş, temiz mimari prensiplerine uygun, güvenli ve kullanıcı dostu bir platformdur.

## 📱 Özellikler

### 👤 Müşteri Özellikleri
- ✅ Güvenli kullanıcı kaydı ve girişi
- 🏗️ Vinç kiralama talebi oluşturma
- 📋 Aktif ve tamamlanmış işleri görüntüleme
- 💰 Firma tekliflerini karşılaştırma
- 📞 Firmalarla iletişim kurma
- 🔔 Bildirim sistemi

### 🏢 Firma Özellikleri
- 🔐 Firma kaydı ve onay sistemi
- 🚛 Vinç filosu yönetimi (ekleme, düzenleme, silme)
- 📨 Müşteri taleplerine teklif verme
- 📊 Aktif ve tamamlanmış işleri takip etme
- 💼 İş geçmişi ve raporlama
- 🔑 Güvenli firma anahtarı ile giriş

### 👨‍💼 Admin Özellikleri
- ✅ Firma başvurularını onaylama/reddetme
- 👥 Tüm kullanıcıları ve firmaları görüntüleme
- 📈 Sistem geneli istatistikler
- 🔧 Platform yönetimi

## 🏗️ Mimari Yapı

Proje **Clean Architecture** prensiplerine uygun olarak geliştirilmiştir:

```
lib/
├── core/                    # Çekirdek işlevler
│   ├── env.dart            # Ortam değişkenleri
│   ├── router/             # Navigasyon yönetimi (GoRouter)
│   └── storage/            # Güvenli veri saklama
│
├── data/                    # Veri katmanı
│   ├── datasources/        # API ve veri kaynakları
│   └── repositories/       # Repository implementasyonları
│
├── domain/                  # İş mantığı katmanı
│   └── entities/           # Domain modelleri
│
├── presentation/            # Sunum katmanı
│   ├── admin/              # Admin ekranları
│   ├── auth/               # Kimlik doğrulama ekranları
│   ├── customer/           # Müşteri ekranları
│   ├── firm/               # Firma ekranları
│   └── home/               # Ana sayfa ve karşılama ekranları
│
└── main.dart               # Uygulama giriş noktası
```

## 🛠️ Teknolojiler

### State Management & Routing
- **Flutter Riverpod** (^2.6.1) - Reaktif state management
- **GoRouter** (^17.0.1) - Deklaratif routing ve navigasyon

### Network & API
- **Dio** (^5.9.0) - HTTP client
- **MySQL1** (^0.20.0) - Veritabanı bağlantısı

### Storage & Security
- **Flutter Secure Storage** (^10.0.0) - Güvenli veri saklama (token, credentials)
- **Flutter Dotenv** (^6.0.0) - Ortam değişkenleri yönetimi

### UI & UX
- **Google Fonts** (^6.3.3) - Özel fontlar
- **Flutter Animate** (^4.5.2) - Animasyonlar
- **Material 3** - Modern UI tasarımı

### Code Generation
- **Freezed** (^3.2.3) - Immutable modeller
- **JSON Serializable** (^6.11.2) - JSON serileştirme

## 📋 Gereksinimler

- Flutter SDK: ^3.0.0
- Dart SDK: ^3.0.0
- Android Studio / VS Code
- Android SDK (Android geliştirme için)
- Xcode (iOS geliştirme için)

## 🚀 Kurulum

### 1. Projeyi Klonlayın
```bash
git clone https://github.com/kullaniciadi/VincKiralamaProjesi_Mobil.git
cd VincKiralamaProjesi_Mobil
```

### 2. Bağımlılıkları Yükleyin
```bash
flutter pub get
```

### 3. Ortam Değişkenlerini Ayarlayın
Proje kök dizininde `.env` dosyası oluşturun:

```env
API_BASE_URL=http://your-api-url.com/api
```

**Not:** `.env` dosyası `.gitignore`'da bulunur ve GitHub'a yüklenmez. Kendi API URL'nizi buraya eklemelisiniz.

### 4. Code Generation Çalıştırın
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Uygulamayı Çalıştırın
```bash
flutter run
```

## 🔧 Yapılandırma

### API Bağlantısı
Backend API'nizi yapılandırmak için:

1. `.env` dosyasında `API_BASE_URL` değerini güncelleyin
2. `lib/core/env.dart` dosyasını kontrol edin
3. `lib/data/datasources/` klasöründeki veri kaynaklarını inceleyin

### Platform Özel Ayarlar

#### Android
`android/app/src/main/AndroidManifest.xml` dosyasında internet izni eklenmiştir:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

#### iOS
`ios/Runner/Info.plist` dosyasında gerekli izinler yapılandırılmalıdır.

## 📱 Kullanım

### Müşteri Olarak Başlangıç
1. Uygulamayı açın
2. "Müşteri Girişi" seçeneğini seçin
3. Yeni hesap oluşturun veya mevcut hesabınızla giriş yapın
4. Vinç kiralama talebi oluşturun
5. Gelen teklifleri inceleyin ve seçim yapın

### Firma Olarak Başlangıç
1. Uygulamayı açın
2. "Firma Girişi" seçeneğini seçin
3. Firma kaydı oluşturun (Admin onayı gerekir)
4. Onay sonrası firma anahtarınızla giriş yapın
5. Vinç filosunuzu ekleyin
6. Müşteri taleplerine teklif verin

### Admin Olarak Başlangıç
1. Uygulamayı açın
2. "Admin Girişi" seçeneğini seçin
3. Admin kimlik bilgilerinizle giriş yapın
4. Firma başvurularını onaylayın
5. Sistemi yönetin

## 🔐 Güvenlik

- **JWT Token Authentication** - Güvenli kimlik doğrulama
- **Flutter Secure Storage** - Hassas verilerin şifreli saklanması
- **Role-Based Access Control** - Rol bazlı erişim kontrolü
- **Environment Variables** - API anahtarları ve hassas bilgilerin güvenli yönetimi

## 🧪 Test

```bash
# Unit testleri çalıştır
flutter test

# Widget testleri çalıştır
flutter test test/widget_test.dart

# Integration testleri çalıştır
flutter test integration_test/
```

## 📦 Build

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle (Google Play için)
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🎨 Ekran Görüntüleri

### Müşteri Ekranları
- Karşılama Ekranı
- Müşteri Kaydı (Sarı tema)
- Müşteri Girişi
- Talep Oluşturma
- Aktif İşler
- Teklif Görüntüleme

### Firma Ekranları
- Firma Kaydı
- Firma Girişi
- Vinç Yönetimi
- Teklif Verme
- İş Takibi

### Admin Ekranları
- Admin Dashboard
- Firma Onay Paneli
- Kullanıcı Yönetimi

## 🤝 Katkıda Bulunma

1. Bu repository'yi fork edin
2. Feature branch'i oluşturun (`git checkout -b feature/AmazingFeature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add some AmazingFeature'`)
4. Branch'inizi push edin (`git push origin feature/AmazingFeature`)
5. Pull Request oluşturun

## 📝 Lisans

Bu proje [MIT Lisansı](LICENSE) altında lisanslanmıştır.

## 👨‍💻 Geliştirici

**Proje Sahibi** - [GitHub Profiliniz](https://github.com/betulberreacikgoz)

## 📧 İletişim

Sorularınız için: acikgozbetulberre@gmail.com

## 🙏 Teşekkürler

- Flutter ekibine harika framework için
- Riverpod topluluğuna state management desteği için
- Tüm açık kaynak katkıda bulunanlara

---

⭐ Bu projeyi beğendiyseniz yıldız vermeyi unutmayın!
