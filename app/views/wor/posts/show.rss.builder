#encoding: UTF-8

xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0",
        "xmlns:content"=>"http://purl.org/rss/1.0/modules/content/",
        "xmlns:wfw"=>"http://wellformedweb.org/CommentAPI/",
        "xmlns:dc"=>"http://purl.org/dc/elements/1.1/",
        "xmlns:atom"=>"http://www.w3.org/2005/Atom",
        "xmlns:sy"=>"http://purl.org/rss/1.0/modules/syndication/",
        "xmlns:slash"=>"http://purl.org/rss/1.0/modules/slash/",
        "xmlns:media"=>"http://search.yahoo.com/mrss/" do
  xml.channel do
    xml.title @post.title
    xml.link "#{request.protocol}#{request.host}#{post_path(@post)}"
    xml.atom :link, href: "#{request.protocol}#{request.host}#{post_path(@post)}", rel: "self", type: "application/rss+xml"

    xml.lastBuildDate @post.date.strftime('%a, %d %b %Y %H:%M:%S %z')
    xml.language "es-ES"
    xml.description do
      xml.cdata!(convert_to_absolute_paths(intro_text(@post)))
    end

    xml.item do
      xml.title @post.title
      xml.pubDate @post.date.strftime('%a, %d %b %Y %H:%M:%S %z')
      xml.link "#{request.protocol}#{request.host}#{post_path(@post)}"
      xml.guid "#{request.protocol}#{request.host}#{post_path(@post)}"

      xml.dc :creator do
        xml.cdata!(@post.user.username)
      end

      xml.description do
        xml.cdata!(convert_to_absolute_paths(intro_text(@post)))
      end

      xml.content :encoded do
        xml.cdata!("<img src=\"#{request.protocol}#{request.host}/#{@post.cover_image_path('1140x600')}?timestamp=#{@post.updated_at.to_i}\"/>#{convert_to_absolute_paths(@post.content)}")
      end
    end
  end
end
