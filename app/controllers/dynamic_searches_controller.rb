class DynamicSearchesController < ApplicationController
  # GET /dynamic_searches
  # GET /dynamic_searches.xml
  def index
    @klass = Klass.find params[:klass_id]
    @resource = Resource.find params[:resource_id]
    @dynamic_searches = DynamicSearch.all(:conditions => {:target_klass_id => @klass.id, :resource_id => @resource.id})
    @target_metas = @klass.metas.all
    @value_metas = @target_metas + Klass.context.metas.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dynamic_searches }
    end
  end

  # POST /dynamic_searches
  # POST /dynamic_searches.xml
  def create
    @dynamic_search = DynamicSearch.new(params[:dynamic_search])

    respond_to do |format|
      if @dynamic_search.save
        flash[:notice] = 'DynamicSearch was successfully created.'
        format.html { redirect_to(:back) }
        format.xml  { render :xml => @dynamic_search, :status => :created, :location => @dynamic_search }
      else
        format.html { render :action => "index" }
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
        format.html { redirect_to(:back) }
        format.xml  { head :ok }
      else
        format.html { render :action => "index" }
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
      format.html { redirect_to(:back) }
      format.xml  { head :ok }
    end
  end
end
