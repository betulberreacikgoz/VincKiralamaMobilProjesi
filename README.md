# 🏗️ Vinç Kiralama Mobil Uygulaması

[![Tanıtım Videosu](https://img.shields.io/badge/YouTube-İzle-red?style=for-the-badge&logo=youtube)](https://youtu.be/paX0iAmHX-4)  
> 📺 **Video Linki:** [https://youtu.be/paX0iAmHX-4](https://youtu.be/paX0iAmHX-4)

Vinç Kiralama Projesi, vinç kiralama işlemlerini dijitalleştiren, firma ve müşterileri bir araya getiren modern bir mobil uygulamadır. Flutter ile geliştirilmiş, **Clean Architecture** prensiplerine uygun, güvenli ve kullanıcı dostu bir platformdur.

---

## 📸 Ekran Görüntüleri

| Karşılama Ekranı | Müşteri Kaydı | Firma Başvurusu |
|:---:|:---:|:---:|
| <img width="250" alt="Karşılama" src="https://github.com/user-attachments/assets/42302fd9-5d39-4332-b116-d65e0ac5cfee" /> | <img width="250" alt="Kayıt" src="https://github.com/user-attachments/assets/25ad177c-e86e-4272-9b34-1dab5f75fefd" /> | <img width="250" alt="Başvuru" src="https://github.com/user-attachments/assets/a8f75874-ff50-4e99-8366-096de782d1bb" /> |

| Firma Paneli | Admin Paneli | Admin Paneli |
|:---:|:---:|:---:|
| <img width="250" alt="Firma" src="https://github.com/user-attachments/assets/ab795dc0-5dca-494d-af90-ff247aa7289c" /> | <img width="250" alt="Admin" src="https://github.com/user-attachments/assets/272f358c-7dfe-4907-af77-898de8300dd7" /> | <img width="250" alt="İşler" src="https://github.com/user-attachments/assets/8a1696e7-24f5-4970-a162-569bde404d73" /> |

---

## 🚀 Özellikler

### 👤 Müşteri Modülü
- **Güvenli Erişim:** Kullanıcı kaydı ve JWT tabanlı giriş.
- **Talep Yönetimi:** Detaylı vinç kiralama talebi oluşturma.
- **İş Takibi:** Aktif ve tamamlanmış işleri anlık görüntüleme.
- **Teklif Karşılaştırma:** Firmalardan gelen teklifleri inceleme ve onaylama.
- **İletişim:** Firmalarla doğrudan irtibat kurma ve bildirim alma.

### 🏢 Firma Modülü
- **Onaylı Kayıt:** Admin denetimli firma kayıt sistemi.
- **Filo Yönetimi:** Vinç araçlarını ekleme, güncelleme ve silme.
- **Teklif Verme:** Müşteri taleplerine fiyat ve detay iletme.
- **Raporlama:** Geçmiş işlerin ve finansal verilerin takibi.

### 👨‍💼 Admin Paneli
- **Denetim:** Yeni firma başvurularını inceleme ve onaylama.
- **Yönetim:** Kullanıcı ve firma veritabanını görüntüleme.
- **İstatistik:** Platformun genel kullanım verilerini analiz etme.

---

## 🛠️ Mimari Yapı

Uygulama, **Clean Architecture** prensipleriyle 4 ana katman üzerine inşa edilmiştir:



```text
lib/
├── core/           # Router (GoRouter), Storage, Güvenlik ve Temalar
├── data/           # Remote & Local Datasources, Repository Impls
├── domain/         # Entities, Repository Interfaces, Use Cases
├── presentation/   # UI Screens, Widgets, Riverpod Providers
└── main.dart       # Uygulama başlangıç konfigürasyonu
