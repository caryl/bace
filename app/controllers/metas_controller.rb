class MetasController < ApplicationController
  dynamic_searchable :index
  def index
    @klass = Klass.find(params[:klass_id])
    @metas = @klass.metas.find(:all, :include=>[:assoc_klass], :order=>'klass_id')

    respond_to do |format|
      format.html
      format.xml  { render :xml => @metas }
    end
  end

  def show
    @meta = Meta.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @meta }
    end
  end

  def new
    @klass = Klass.find(params[:klass_id])
    @meta = Meta.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @meta }
    end
  end

  def edit
    @meta = Meta.find(params[:id])
  end

  def create
    @meta = Meta.new(params[:meta])

    respond_to do |format|
      if @meta.save
        flash[:notice] = 'Meta was successfully created.'
        format.html { redirect_to(@meta) }
        format.xml  { render :xml => @meta, :status => :created, :location => @meta }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @meta.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @meta = Meta.find(params[:id])

    respond_to do |format|
      if @meta.update_attributes(params[:meta])
        flash[:notice] = 'Meta was successfully updated.'
        format.html { redirect_to(@meta) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @meta.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @meta = Meta.find(params[:id])
    @meta.destroy

    respond_to do |format|
      format.html { redirect_to(klass_metas_url(@meta.klass_id)) }
      format.xml  { head :ok }
    end
  end
end
