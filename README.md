# Vinç Kiralama Mobil Uygulaması

[![Tanıtım Videosu](https://img.shields.io/badge/YouTube-İzle-red?style=for-the-badge&logo=youtube)](https://youtu.be/paX0iAmHX-4)

Vinç Kiralama Projesi, vinç kiralama işlemlerini dijitalleştiren, firma ve müşterileri bir araya getiren modern bir mobil uygulamadır. Flutter ile geliştirilmiş, **Clean Architecture** prensiplerine uygun, güvenli ve kullanıcı dostu bir platformdur.

---

## 📸 Ekran Görüntüleri

| Karşılama Ekranı | Müşteri Kaydı | Firma Başvurusu |
|:---:|:---:|:---:|
| <img width="421" height="879" alt="Image" src="https://github.com/user-attachments/assets/42302fd9-5d39-4332-b116-d65e0ac5cfee" /> | <img width="421" height="879" alt="Image" src="https://github.com/user-attachments/assets/25ad177c-e86e-4272-9b34-1dab5f75fefd" /> | <img width="423" height="882" alt="Image" src="https://github.com/user-attachments/assets/a8f75874-ff50-4e99-8366-096de782d1bb" /> |

| Firma Paneli | Admin Paneli |
|:---:|:---:|
| <img width="419" height="877" alt="Image" src="https://github.com/user-attachments/assets/ab795dc0-5dca-494d-af90-ff247aa7289c" /> | <img width="423" height="881" alt="Image" src="https://github.com/user-attachments/assets/272f358c-7dfe-4907-af77-898de8300dd7" /> |

---

## Özellikler

### Müşteri Modülü
- Güvenli kullanıcı kaydı ve girişi
- Vinç kiralama talebi oluşturma
- Aktif ve tamamlanmış işleri görüntüleme
- Firma tekliflerini karşılaştırma ve seçim yapma
- Firmalarla doğrudan iletişim
- Anlık bildirim sistemi

### Firma Modülü
- Firma kaydı ve admin onay sistemi
- Vinç filosunu yönetme (Ekleme, Düzenleme, Silme)
- Müşteri taleplerine teklif verme
- İş geçmişi takibi ve raporlama
- Güvenli firma anahtarı ile giriş

### Admin Paneli
- Firma başvurularını onaylama/reddetme
- Kullanıcı ve firma yönetimi
- Sistem geneli istatistik takibi
- Platform genel yapılandırması

---

## Mimari Yapı

Proje, sürdürülebilirlik ve test edilebilirlik için katmanlı mimari ile yapılandırılmıştır:


```text
lib/
├── core/           # Çekirdek işlevler (Router, Storage, Env)
├── data/           # Veri katmanı (Datasources, Repositories)
├── domain/         # İş mantığı katmanı (Entities, Use Cases)
├── presentation/   # Sunum katmanı (UI, Riverpod Providers)
└── main.dart       # Giriş noktası
