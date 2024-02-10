# Redmine Konteynerlerinin Yapısı

Mysql günlükleri toplansın diye `/workspace/volume/mysql/mysqld.cnf` dosyasında aşağıdaki ayarları yaptım:

```text
general_log_file = /var/log/mysql/mysql-query.log
general_log      = 1
```

Günlük dosyasına yazılan tüm MYSQL komutlarını görebilip hem Redmine işleyişi hem eklenti/makro geliştirmeleri Mysql tarafında ayrıntılı olarak görülebilir

```shell
docker exec -it -w /var/log/mysql/ test-plugin-redmine_mysql tail -f mysql-query.log
```

# Redmine Eklentisi Geliştirmek

Eklentiyi `/usr/src/redmine/plugins` dizininde, `git clone https://<eklentinin kod havuzu>.git` komutu ile çekebilir, `bundle exec rake redmine:plugins:migrate NAME=my_plugin RAILS_ENV=production` komutuyla veritabanı değişimlerini oluşturabilirsiniz.

![Alt text](image.png)

Redmine docker içinde aşağıdaki `docker-compose.yml` ile çalışıyor ve içine VS Code ile debug için bir paket `gem install ruby-debug-ide` ve eklenti kuruyoruz. Bunu yapması için `.devcontainer/devcontainer.json` içinde aşağıdaki satır kullanılıyor:

```json
"postCreateCommand": "/workspace/.devcontainer/setup_ruby_env.sh",
```

`setup_ruby_env.sh` Dosyasında hata ayıklama için gerekli `ruby-debug-ide` paketinin kurulumu ve sadece örnek eklentinin bulunması için soft link oluşturuluyor ve ornek_eklenti dizininden devam etmek isterseniz bir giriş noktası veriliyor:

```bash
# Kodu geliştireceğimiz dizin konteynere "/workspace" ismiyle bağlanacak.
# "/workspace" dizini içinde "./ornek_eklenti" ismindeki klasörü "/usr/src/redmine/plugins" dizininin altına soft link ile bağlıyoruz
# launch.json içinde `"program": "/usr/src/redmine/bin/rails",` ile kodumuzu başlatabiliyoruz.
# Farklı isimlerde eklentiler için docker-compose.yml içinde mount edilmi "/workspace/volume/redmine/redmine-plugins" dizini içinde yaratarak kodlayabilirsiniz
ln -s /workspace/ornek_eklenti /usr/src/redmine/plugins/ornek_eklenti

# Redmine docker içinde aşağıdaki compose.yml ile çalışıyor ve içine VS Code ile debug için eklenti kuruyoruz.
gem install ruby-debug-ide
```

Örnek bir eklenti nasıl geliştirilir diye [bu adresteki](https://github.com/cemtopkaya/ulak_test/blob/main/Redmine-Eklenti-Gelistirmek.md) yardımdan faydalanabilirsiniz.
