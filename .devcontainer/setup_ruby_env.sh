#!/bin/bash


# MySQL sunucusunun IP adresi ve portu
MYSQL_HOST=db
MYSQL_PORT=3306

# MySQL kullanıcı adı ve şifresi
MYSQL_USER=root
MYSQL_PASSWORD=admin

# MySQL sunucusuna bağlanma denemesi yapacak fonksiyon
check_mysql_connection() {
    mysqladmin ping -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PASSWORD &> /dev/null
    return $?
}

# MySQL sunucusuna bağlanma denemesi yap
while ! check_mysql_connection; do
    echo "MySQL sunucusuna bağlanılamadı, bekleniyor..."
    sleep 5
done


# -s parametresi, curl komutunun sessiz modda çalışmasını sağlar, yani çıktıya hiçbir şey yazdırmaz.
# -o /dev/null, curl çıktısını null aygıtına (yani, çıktıyı atar) yönlendirir.
# -w '%{http_code}', curl komutunun sadece HTTP durum kodunu (http_code) çıktı olarak yazmasını sağlar.
# ! işareti, curl komutunun çıktısının başarısız olduğunu (yani, HTTP durum kodunun başarısız olduğunu) kontrol eder.
# Bu döngü, HTTP isteğinin başarılı olana kadar bekler ve bir saniye aralıklarla tekrarlar (sleep 1).
while ! curl -s -o /dev/null -w '%{http_code}' http://localhost:3000; do 
    echo "Redmine için PUMA sunucusuna bağlanılamadı, 1sn bekleyip tekrar denenecek..."
    sleep 1; 
done;

# ------------------------------------------------------------------------------------------------------------

# REST Web servisini etkinleştirmek için veritabanında aşağıdaki komutla 
# settings tablosunda name alanı rest_api_enabled olan kaydın value alanı true olarak güncellenir

# Kullanıcı adı ve şifre değişkenleri
USERNAME="root"
PASSWORD="admin"

# Veritabanı adı
DATABASE="redmine"

# İlk kayıt için değişkenler
REST_API_NAME="rest_api_enabled"
REST_API_VALUE="1"

# İkinci kayıt için değişkenler
JSONP_NAME="jsonp_enabled"
JSONP_VALUE="1"
CURRENT_TIME=$(date +"%Y-%m-%d %H:%M:%S")

# İlk kayıtı kontrol etme ve ekleme veya güncelleme
rest_api_count=$(mysql -h db -u "${USERNAME}" -p"${PASSWORD}" "${DATABASE}" -sN -e "SELECT COUNT(*) FROM settings WHERE name='${REST_API_NAME}'")
if [[ rest_api_count -eq 0 ]]; then
    echo "Inserting new record for ${REST_API_NAME}"
    sql="INSERT INTO settings (name, value, updated_on) VALUES ('${REST_API_NAME}', '${REST_API_VALUE}', '${CURRENT_TIME}');"
    mysql -h db -u "${USERNAME}" -p"${PASSWORD}" "${DATABASE}" -e "${sql}"
fi

# İkinci kayıtı kontrol etme ve ekleme veya güncelleme
jsonp_count=$(mysql -h db -u "${USERNAME}" -p"${PASSWORD}" "${DATABASE}" -sN -e "SELECT COUNT(*) FROM settings WHERE name='${JSONP_NAME}'")
if [[ jsonp_count -eq 0 ]]; then
    echo "Inserting new record for ${JSONP_NAME}"
    mysql -h db -u "${USERNAME}" -p"${PASSWORD}" "${DATABASE}" -e "INSERT INTO settings (name, value, updated_on) VALUES ('${JSONP_NAME}', '${JSONP_VALUE}', '${CURRENT_TIME}');"
fi

mysql -h db -u "${USERNAME}" -p"${PASSWORD}" "${DATABASE}" -e "UPDATE settings SET value='${REST_API_VALUE}', updated_on='${CURRENT_TIME}' WHERE name='${REST_API_NAME}';"
mysql -h db -u "${USERNAME}" -p"${PASSWORD}" "${DATABASE}" -e "UPDATE settings SET value='${JSONP_VALUE}', updated_on='${CURRENT_TIME}' WHERE name='${JSONP_NAME}';"

# İlk kez giriş yaparken kullanıcı adı admin ve şifresi admin ancak ilk girişte şifreyi değiştirmem isteniyor
# bunun önüne geçmek için users tablosunda must_change_passwd alanı admin kullanıcısı için 0 yapılır:
mysql -h db -u root -padmin redmine -v -e "UPDATE users SET must_change_passwd=0 WHERE login='admin';"

# ------------------------------------------------------------------------------------------------------------

# Başlangıç projesini oluşturuyorum
# Kullanıcı adı ve şifre değişkenleri
REDMINE_ADMIN_USERNAME="admin"
REDMINE_ADMIN_PASSWORD="admin"

# Curl komutunu kullanarak POST isteği gönderme
curl -vvv \
    -H "Content-Type: application/json" \
    --user "${REDMINE_ADMIN_USERNAME}:${REDMINE_ADMIN_PASSWORD}" \
    -X POST \
    -d '{"project":{"name":"YENI_PROJE_ISMI","identifier":"yeni_proje","description":"Proje açıklaması"}}' \
    http://localhost:3000/projects.json

# ------------------------------------------------------------------------------------------------------------

# Redmine docker içinde aşağıdaki compose.yml ile çalışıyor ve içine VS Code ile debug için eklenti kuruyoruz.
gem install ruby-debug-ide --conservative

# Kod içinde gezinme, intellisense, yardım pencereleri sağlayacak alt yapı
gem install solargraph --conservative

# RUFO : RUby FOrmatter
gem install rufo --conservative  

# Ruby Formatter olarak rubocop da kullanılabilir
# gem install rubocop --conservative

# Aşağıdaki hata için çalıştırılacak:
# Missing `secret_key_base` for 'production' environment, set this string with `bin/rails credentials
# EDITOR="nano --wait" /usr/src/redmine/bin/rails credentials:edit

# ------------------------------------------------------------------------------------------------------------

# Kodu geliştireceğimiz dizin konteynere "/workspace" ismiyle bağlanacak.
# "/workspace" dizini içinde "./ornek_eklenti" ismindeki klasörü "/usr/src/redmine/plugins" dizininin altına soft link ile bağlıyoruz
# launch.json içinde `"program": "/usr/src/redmine/bin/rails",` ile kodumuzu başlatabiliyoruz.
# Farklı isimlerde eklentiler için docker-compose.yml içinde mount edilmi "/workspace/volume/redmine/redmine-plugins" dizini içinde yaratarak kodlayabilirsiniz
ln -s -v /workspace/ornek_eklenti /usr/src/redmine/plugins/ornek_eklenti  && echo "link created" || echo "link creation failed"

# ------------------------------------------------------------------------------------------------------------