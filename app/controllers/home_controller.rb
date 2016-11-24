class HomeController < ApplicationController
  def index
    @excellent_topics = Topic.excellent.recent.fields_for_list.limit(20).to_a
    @latest_topics = Topic.recent.without_hide_nodes.with_replies_or_likes.fields_for_list.limit(10).to_a
    fresh_when([@excellent_topics, @latest_topics, Setting.index_html])
  end

  def uploads
    return render_404 if Rails.env.production?

    # This is a temporary solution for help generate image thumb
    # that when you use :file upload_provider and you have no Nginx image_filter configurations.
    # DO NOT use this in production environment.
    format, version = params[:format].split("!")
    filename = [params[:path], format].join(".")
    pragma = request.headers['Pragma'] == 'no-cache'
    thumb = Homeland::ImageThumb.new(filename, version, pragma: pragma)
    if thumb.exists?
      send_file thumb.outpath, type: 'image/jpeg', disposition: 'inline'
    else
      render plain: 'File not found', status: 404
    end
  end

  def api
    redirect_to "/api-doc/"
  end

  def error_404
    render_404
  end

  def markdown
  end
end
