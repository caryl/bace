class DynamicSearchesController < ApplicationController
  # GET /dynamic_searches
  # GET /dynamic_searches.xml
  def index
    @dynamic_searches = DynamicSearch.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dynamic_searches }
    end
  end

  # GET /dynamic_searches/1
  # GET /dynamic_searches/1.xml
  def show
    @dynamic_search = DynamicSearch.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dynamic_search }
    end
  end

  # GET /dynamic_searches/new
  # GET /dynamic_searches/new.xml
  def new
    @dynamic_search = DynamicSearch.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dynamic_search }
    end
  end

  # GET /dynamic_searches/1/edit
  def edit
    @dynamic_search = DynamicSearch.find(params[:id])
  end

  # POST /dynamic_searches
  # POST /dynamic_searches.xml
  def create
    @dynamic_search = DynamicSearch.new(params[:dynamic_search])

    respond_to do |format|
      if @dynamic_search.save
        flash[:notice] = 'DynamicSearch was successfully created.'
        format.html { redirect_to(@dynamic_search) }
        format.xml  { render :xml => @dynamic_search, :status => :created, :location => @dynamic_search }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dynamic_search.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dynamic_searches/1
  # PUT /dynamic_searches/1.xml
  def update
    @dynamic_search = DynamicSearch.find(params[:id])

    respond_to do |format|
      if @dynamic_search.update_attributes(params[:dynamic_search])
        flash[:notice] = 'DynamicSearch was successfully updated.'
        format.html { redirect_to(@dynamic_search) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dynamic_search.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dynamic_searches/1
  # DELETE /dynamic_searches/1.xml
  def destroy
    @dynamic_search = DynamicSearch.find(params[:id])
    @dynamic_search.destroy

    respond_to do |format|
      format.html { redirect_to(dynamic_searches_url) }
      format.xml  { head :ok }
    end
  end
end
