# lib/markdown_macro.rb
require 'redmine'

module MarkdownMacro
  module Macros
    # MarkdownMacro: Redmine makrosu olarak Markdown içeriğini ekler
    Redmine::WikiFormatting::Macros.register do
      desc "Markdown içeriği ekler. Değişim talep formu ve yeni özellik isteği olarak farklı içerik döndürür."
      macro :custom_markdown do |obj, args, text|
        
        case args[0]
        when "change_request_form"
          markdown_text = <<~MARKDOWN.strip
            # Değişim Talep Formu
            Bu değişim talep formudur.
            Lütfen aşağıdaki bilgileri doldurun:
            - İsim:
            - E-posta:
            - Değişiklik Açıklaması:
          MARKDOWN
        when "yeni özellik isteği"
          markdown_text = <<~MARKDOWN.strip
            # Yeni Özellik İsteği
            Bu yeni özellik isteğidir.
            Lütfen aşağıdaki bilgileri belirtin:
            - Özellik Açıklaması:
            - Öncelik:
            - Zorluk:
          MARKDOWN
        else
          markdown_text = "Geçersiz makro parametresi: #{args[0]}"
        end
        
        return markdown_text
        # Markdown içeriğini HTML'e dönüştür
        html = Redmine::WikiFormatting.to_html(markdown_text, obj.project, :textile)
        return html.html_safe

        # html = Redmine::WikiFormatting::Markdown.new(markdown_text).to_html
        # return html.html_safe
      end
    end
  end
end
