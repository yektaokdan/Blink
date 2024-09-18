# Blink
![Blink Mockup](https://github.com/yektaokdan/Blink/blob/main/image_for_readme/mockup.png?raw=true)

## Özet

**Blink**, kullanıcılara çeşitli RSS kaynaklarından en son haberleri sunan bir iOS uygulamasıdır. Kullanıcılar farklı haber kategorilerine göz atabilir, favori haberlerini kaydedebilir ve son dakika bildirimleri alabilirler.

## Özellikler

- **RSS Entegrasyonu**: RSS kaynaklarından haberleri çeker ve uygulamada listeler.
- **Kategori Bazlı Gezinme**: Kullanıcılar ilgilendikleri haber kategorilerini seçebilir ve bu kategorilerle ilgili haberleri görüntüleyebilir.
- **Favorilere Ekleme**: Haberleri uzun basarak favorilere ekleyebilir ve daha sonra kolayca erişebilirler.
- **Anlık Bildirimler**: Son dakika haberleri ve önemli gelişmeler için kullanıcılara bildirim gönderir.

## Kurulum

1. **Repoyu klonla**:
    ```sh
    git clone https://github.com/yektaokdan/Blink.git
    ```
2. **Projeyi Xcode'da aç**:
    ```sh
    cd Blink
    open Blink.xcodeproj
    ```
3. **Bağımlılıkları yükle** (CocoaPods kullanıyorsan):
    ```sh
    pod install
    ```
4. **Uygulamayı simülatörde ya da cihazda çalıştır**.

## Kullanım

1. **Haberleri Gözden Geçir**:
   - Uygulama açıldığında en son haberler listelenecektir.
   - Kategoriler arasında gezinebilir ve ilgili haberleri görüntüleyebilirsin.

2. **Favorilere Haber Ekle**:
   - Bir haberin üzerine uzun basarak, "Favorilere Ekle" seçeneğiyle favorilerine kaydedebilirsin.

3. **Favorileri Görüntüle**:
   - Favoriler sekmesine geçerek kaydettiğin haberleri görebilir ve tekrar okuyabilirsin.

## Kod Yapısı

- **HomeVC**: Ana ekranı ve haberlerin listelenmesini yönetir.
- **CategoryDetailVC**: Seçilen kategoriye göre ilgili haberleri gösterir.
- **FavoriteVC**: Favorilere eklenen haberleri listeleyen ekran.
- **RSSService**: RSS verilerini çeker ve işler.
- **NewsViewModel**: Haberlerin alınması ve güncellenmesiyle ilgili tüm mantığı yönetir.
- **FavoriteManager**: Favorilere eklenen haberleri yönetir.

## Bildirimler

- **didUpdateNews**: Yeni haberler alındığında tetiklenir.
- **didSaveFavorite**: Bir haber favorilere eklendiğinde tetiklenir.

