class MailMarkdown < Redcarpet::Render::HTML

  def paragraph(text)
    <<HTML 
<div class="p">#{text}</div>
HTML
  end

end
