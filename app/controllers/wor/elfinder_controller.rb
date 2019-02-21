class Wor::ElfinderController < ApplicationController
  layout 'elfinder'

  def index
  end

  def elfinder
    h, r = ElFinder::Connector.new(
      :root => File.join(Rails.public_path, 'wor', 'uploads'),
      :url => '/wor/uploads',
      :perms => {
        'forbidden' => {:read => false, :write => false, :rm => false},
        /README/ => {:write => false},
        /pjkh\.png$/ => {:write => false, :rm => false},
      },
      :extractors => {
        'application/zip' => ['unzip', '-qq', '-o'],
        'application/x-gzip' => ['tar', '-xzf'],
      },
      :archivers => {
        'application/zip' => ['.zip', 'zip', '-qr9'],
        'application/x-gzip' => ['.tgz', 'tar', '-czf'],
      },
      :thumbs => true,
      :debug => true
    ).run(params)

    headers.merge!(h)
    render plain: r.to_json

    # render (r.empty? ? {:nothing => true} : {:text => r.to_json}), :layout => false
  end
end
