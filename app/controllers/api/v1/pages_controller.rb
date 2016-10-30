class Api::V1::PagesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def create
    begin
      url = page_params[:url]
      agent = Mechanize.new
      page_to_track = agent.get(url)
      page = Page.new(url: url )
      PageContent::COMPONENTS_TO_TRACK.each do |component_to_track|
        page_to_track.search(component_to_track).each do |component|
          page.page_contents << PageContent.new(content_type: component_to_track, content: component)
        end
      end
      if page.save
        render json: page.to_json(:methods => [:page_contents]), status: :created
      else
        render json: page.errors, status: :unprocessable_entity
      end
    rescue Exception => e
      render json: e.message, status: :unprocessable_entity
    end
  end

  def index
    @pages = Page.paginate :per_page => 10, :page => params[:page]
    render json: @pages.to_json(:methods => [:page_contents])
  end

  def show
    @page = Page.find(params[:id])
    render json: @page.to_json(:methods => [:page_contents])
  end

  def destroy
    @page = Page.find(params[:id])
    @page.destroy
    head :no_content
  end

  private
  def page_params
    params.require(:page).permit(:url)
  end

  def record_not_found(error)
    render :json => {:error => error.message}, :status => :not_found
  end

end
