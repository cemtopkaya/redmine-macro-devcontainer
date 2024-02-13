# Değişiklik Günlüğü (Changelog)

Bu dosya, projenin değişiklik geçmişini kaydetmek için kullanılır. Projedeki yapılan değişiklikler, sürüm bilgileri ve tarihlerini burada tutabilirsiniz.

### [Gelecek] - Yayınlanmadı

jstoolbar özelleştirmesi ile button eklenecek ve makrolar şablonlar halinde bu düğmenin altındaki listede görüntülenecek.

## [1.1] - 2024-02-13

### Eklendi

- Visual Editor eklentisi geldi
- Visual Editor sekme olarak görüntülensin diye MySQL güncellemesi yapılıyor
- ornek_markdown_makro Eklentisi çalışır olacak şekilde eklendi

### Değişti

- PID 1 olarak puma server yerine supervisord başlatıldı böylece redmine 3000 portunda başlatılabilecek

## [1.0] - 2024-02-09

### Eklendi

- Rest API faal edilsin diye Mysql sorgusu kurulum betiğinde çalıştırılıyor
- Yeni Proje yaratılıyor
- MySQL sunucu çalıştırdığı SQL ifadeleri günlük dosyasına yazılacak şekilde ayaklandırılıyor
- Basit bir makro örneği eklentilerde çalışır şekilde Redmine başlatılıyor
- admin Kullanıcısının şifresi değiştirilmek zorunda kalınmasın diye SQL ifadesi postcreate betiğinde çalıştırıldı
