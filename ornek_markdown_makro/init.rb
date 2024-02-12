require "redmine"

$NAME_ORNEK_MAKRO = :ornek_markdown_makro
$MACRO_NAME_ORNEK_MAKRO = "plugin_#{$NAME_ORNEK_MAKRO}".to_sym

Redmine::Plugin.register $NAME_ORNEK_MAKRO do
  name "Benim Ornek Eklentim"
  author "Cem Topkaya"
  description "Basit bir Redmine eklentisi"
  version "0.1.0"
  url "https://eklentinin-sayfasi.com"
  author_url "https://gelistiricinin-sayfasi.com"

  MACRO_ROOT_ORNEK_MAKRO = Pathname.new(__FILE__).join("..").realpath.to_s
  # yaml_settings = YAML::load(File.open(File.join(MACRO_ROOT_ORNEK_MAKRO + "/config", "settings.yml")))

  # settings :default => {
  #   "change_request_form" => yaml_settings["default"]["plugin_redmine_markdown_macro"]["change_request_form"],
  #   "feature_request" => yaml_settings["default"]["plugin_redmine_markdown_macro"]["feature_request"],
  # }
  settings = YAML.load_file("#{MACRO_ROOT_ORNEK_MAKRO}/config/settings.yml")
  if settings
    # Setting.change_request_form = settings["default"]["plugin_redmine_markdown_macro"]["change_request_form"]
  end
end

# Gerekli dosyaları otomatik olarak yükle
# require_dependency "markdown_macro"
# require_dependency File.join(__dir__, 'lib', 'markdown_macro')
